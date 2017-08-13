local function _update_delay_one(self)
	self.updatePacket = self._update_packet
	self._update_packet = nil
end

local function _update_packet(pkt, dv)
	local var = pkt[dv.pkt][dv.var]
	if type(var) == "cdata" then
		var:set(dv.func())
	else
		pkt[dv.pkt][dv.var] = dv.func()
	end
end

local _valid_modes = {
	none = true, -- setting this makes validation easier (see option.test)
	single = function(self, pkt)
		local index = self._update_index or 0
		_update_packet(pkt, self.packet.dynvars[index + 1])
		-- luacheck: globals incAndWrap
		self._update_index = incAndWrap(index, #self.packet.dynvars)
	end,
	all = function(self, pkt)
		for i = 1, #self.packet.dynvars do
			_update_packet(pkt, self.packet.dynvars[i])
		end
	end,
	random = function(self, pkt)
		local index = math.random(#self.packet.dynvars)
		_update_packet(pkt, self.packet.dynvars[index])
	end,
	randommulti = function(self, pkt)
		local num = #self.packet.dynvars
		local count = math.random(num)

		-- array of 1 .. n
		local indices = {}
		for i = 1, num do indices[i] = i end

		-- remove (n - count) random indices
		for i = num, count + 1, -1 do
			local r = math.random(i) -- to be removed
			indices[r] = indices[i] -- keep last index
			-- indices[i] = nil -- can be ignored by using count below
		end

		for i = 1, count do
			_update_packet(pkt, self.packet.dynvars[indices[i]])
		end
	end
}

local _modelist = {}
for i in pairs(_valid_modes) do
	table.insert(_modelist, i)
end

local option = {}

option.formatString = {}
for _,v in ipairs(_modelist) do
	table.insert(option.formatString, v)
end
option.formatString = "<" .. table.concat(option.formatString, "|") .. ">"
option.helpString = "Change how dynamic fields are updated. (default = single)"
-- TODO add value documentation

function option.parse(self, mode)
	if #self.packet.dynvars == 0  or mode == "none" then
		return -- packets will not change
	end

	-- Don't change the first packet
	self.updatePacket = _update_delay_one

	mode = type(mode) == "string" and _valid_modes[string.lower(mode)]
	self._update_packet = mode or _valid_modes.single
end

function option.validate() end

function option.test(self, error, mode)
	local t = type(mode)
	if t == "string" then
		error:assert(#self.packet.dynvars > 0, 4, "Option 'mode': Value set, but no dynvars in associated packet.")

		if not _valid_modes[string.lower(mode)] then
			error(4, "Option 'mode': Invalid value %q. Can be one of %s.",
				mode, table.concat(_modelist, ", "))
			return false
		end
	else
		error(4, "Option 'mode': Invalid argument. String expected, got %s.", t)
		return false
	end

	return true
end

return option
