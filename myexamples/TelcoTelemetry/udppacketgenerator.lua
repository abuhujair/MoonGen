local mg     	= require "moongen"
local memory 	= require "memory"
local device 	= require "device"
local stats  	= require "stats"
local arp    	= require "proto.arp"
local log    	= require "log"
local ffi	 	= require "ffi"
local packets	= require "5GPackets"

-- set addresses here
local DST_MAC		= nil -- resolved via ARP on GW_IP or DST_IP, can be overriden with a string here
local SRC_IP_BASE	= "172.16.10.2" -- actual address will be SRC_IP_BASE + random(0, flows)
local DST_IP		= "172.16.10.1"
local SRC_PORT		= 1234
local DST_PORT		= 5000

-- used to resolve DST_MAC
local GW_IP		= DST_IP
-- used as source IP to resolve GW_IP to DST_MAC
local ARP_IP	= SRC_IP_BASE
local MAX_PACKET_SIZE = 250

function configure(parser)
	parser:description("Generates UDP traffic and measure latencies. Edit the source to modify constants like IPs.")
	parser:argument("txDev", "Device to transmit from."):convert(tonumber)
	parser:option("-r --rate", "Transmit rate in Mbit/s."):default(10000):convert(tonumber)
	parser:option("-f --flows", "Number of flows (randomized source IP)."):default(1):convert(tonumber)
	parser:option("-s --size", "Packet size."):default(500):convert(tonumber)
	parser:option("-t --time", "Run Time in s."):default(1):convert(tonumber)
end

function master(args)
	txDev = device.config{port = args.txDev, rxQueues = 3, txQueues = 3}
	device.waitForLinks()
	-- max 1kpps timestamping traffic timestamping
	-- rate will be somewhat off for high-latency links at low rates
	if args.rate > 0 then
		txDev:getTxQueue(0):setRate(args.rate - (args.size + 4) * 8 / 1000)
	end
	mg.startTask("loadSlave", txDev:getTxQueue(0), args.flows, args.time)
	arp.startArpTask{
		-- we need an IP address to do ARP requests on this interface
		{ rxQueue = txDev:getRxQueue(2), txQueue = txDev:getTxQueue(2), ips = ARP_IP }
	}
	mg.waitForTasks()
end

local function fillUdpPacket(buf, payload)
	buf:getUdpPacket():fill{
		ethSrc = queue,
		ethDst = DST_MAC,
		ip4Src = SRC_IP_BASE,
		ip4Dst = DST_IP,
		udpSrc = SRC_PORT,
		udpDst = DST_PORT,
		pktLength = 42+#payload,
	}
	local pkt = buf:getUdpPacket()
	ffi.copy(pkt.payload, payload, #payload)
	MAX_PACKET_SIZE = math.max(MAX_PACKET_SIZE, #payload+42)
end

local function doArp()
	if not DST_MAC then
		log:info("Performing ARP lookup on %s", GW_IP)
		DST_MAC = arp.blockingLookup(GW_IP, 5)
		if not DST_MAC then
			log:info("ARP lookup failed, using default destination mac address")
			return
		end
	end
	log:info("Destination mac: %s", DST_MAC)
end

function loadSlave(queue, flows, time)
	doArp()
	local mempool = memory.createMemPool(function (buf)
        local payload = GetRandomMessage()
		fillUdpPacket(buf, payload)
	end
	)

	local bufs = mempool:bufArray(1023)
	local txCtr = stats:newDevTxCounter(queue, "plain")
	-- local counter = 0
	-- local baseIP = parseIPAddress(SRC_IP_BASE)

	local loopcounter = 0
	mg.setRuntime(time)
	while mg.running() do
		bufs:alloc(MAX_PACKET_SIZE)
		loopcounter = loopcounter + 1
		-- for i, buf in ipairs(bufs) do			
			-- pkt.ip4.src:set(baseIP + counter)			
			-- counter = incAndWrap(counter, flows)
		-- end

		-- UDP checksums are optional, so using just IPv4 checksums would be sufficient here
		bufs:offloadUdpChecksums()
		queue:send(bufs)
		txCtr:update()
	end

	for index, value in ipairs(DistributionResult) do
		print(index, value,loopcounter)
	end

	txCtr:finalize()
end
