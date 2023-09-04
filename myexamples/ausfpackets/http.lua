local log    = require "log"

local amfInstanceId = { "2f9a6c8b-1e5d-03f7-240c-7f091d478e06", 
                        "d7b53a91-86e4-c20f-3561-9d8c0a7b9e2d",
                        -- "4ec5f0a1-7d89-b62a-3f71-c98e05d376b8",
                        -- "a23b6f84-7d19-e0c5-6fcb-081de97a4f35",
                        -- "5d0a91e7-2f8c-634b-6bce-df14a7b50398",
                        -- "f8e49d0a-37c2-15b6-ac67-09e158b3d724",
                        -- "1b3d8f2c-4a9e-6075-d6c7-a08f9e0512f8",
                        -- "90873e56-b2d1-4ac0-f9e3-c865a7fbc6d2",
                        -- "3c7a5b98-1e6f-42d7-a0f1-9e8c65d7b831",
                        -- "e5d6b28c-4a0f-9e71-c39a-7f865d214fbc"
                    }

local supiSuci = {  "404000470184978",
                    "404000488525971",
                    "404000621205854",
                    "404000617502994",
                    "404000003990207",
                    -- "404000129701200",
                    -- "404000543325967",
                    -- "404000784243957",
                    -- "404000338867165",
                    -- "404000813376371",
                    -- "404000952363796",
                    -- "404000080166421",
                    -- "404000025878658",
                    -- "404000516768273",
                    -- "404000221840008",
                    -- "404000823249789",
                    -- "404000361055612",
                    -- "404000555047640",
                    -- "404000673350809",
                    -- "404000037824947",
                    -- "404000590253667",
                    -- "404000730066719",
                    -- "404000788214855",
                    -- "404000844854843",
                    -- "404000908771563"
                }

local function getRandomValue(table)
    local idx = math.random(1, #table)
    return table[idx]
end

function createAUSFueauthRequest()
    local header = "POST /nausf-auth/v1/ue-authentications HTTP/1.1\r\nHost: 127.0.0.1:3333\r\nContent-Length:143\r\nContent-Type:application/json\r\nUser-Agent:cpprestsdk/2.10.15\r\nConnection: Keep-Alive\r\n\r\n"
    local body = string.format("{\"amfInstanceId\":\"%s\",\"servingNetworkName\":\"5G:mnc000.mcc404.3gppnetwork.org\",\"supiOrSuci\":\"%s\"}", getRandomValue(amfInstanceId), getRandomValue(supiSuci))
    return header..body
end

-- Function to create a random HTTP response payload with a specific size
function createAUSFHTTPRequest()
    return createAUSFueauthRequest()
end
