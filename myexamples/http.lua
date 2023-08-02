local log    = require "log"

local httpMethods = {"GET", "POST", "PUT", "DELETE"}
local httpURIs = {"/api/data", "/users", "/posts", "/login"}
local httpVersions = {"1.0"} --{, "1.1"}
local httpDataTypes = {"text/plain"} --{"application/json"}--, 
local httpData = {
    '{"key": "value"}',
    '{"name": "John Doe", "age": 30}',
    -- Add more data values as needed
}

local function getRandomValue(table)
    local idx = math.random(1, #table)
    return table[idx]
end

-- Function to create a random JSON data string with a specific size
local function createRandomJsonData(size)
    local jsonData = getRandomValue(httpData)
    if not jsonData then
        return nil
    end

    local dataSize = size - #jsonData
    if dataSize > 0 then
        local extraData = string.rep("x", dataSize)
        jsonData = jsonData:gsub("}$", ',"extra": "' .. extraData .. '"}')
    end

    return jsonData
end

-- Function to create a random HTTP request payload with a specific size
function createRandomHttpRequest(size)
    local method = getRandomValue(httpMethods)
    local uri = getRandomValue(httpURIs)
    local version = getRandomValue(httpVersions)
    local dataType = getRandomValue(httpDataTypes)

    local payload = string.format("%s %s HTTP/%s\r\n", method, uri, version)
    payload = payload .. string.format("Content-Type: %s\r\n", dataType)
    local data = createRandomJsonData(size-#payload-25-4)

    if data then
        payload = payload .. string.format("Content-Length: %d\r\n", #data)
        payload = payload .. "\r\n" .. data
    else
        payload = payload .. "\r\n"
    end

    return payload
end

-- Function to create a random HTTP response payload with a specific size
function createRandomHttpResponse(size)
    local payload = "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: 1392\r\n\r\n111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"
    return payload
--     local version = "1.1" --getRandomValue(httpVersions)
--     local statusCode = 200 --math.random(200, 500) -- Randomly select a status code between 200 and 500
--     local dataType = getRandomValue(httpDataTypes)
    
--     local statusText = "OK" -- Default status text for a 200 status code
--     if statusCode == 404 then
--         statusText = "Not Found"
--     elseif statusCode == 500 then
--         statusText = "Internal Server Error"
--         -- Add more status codes and their respective status text as needed
--     end
    
--     local payload = string.format("HTTP/%s %d %s\r\n", version, statusCode, statusText)
--     payload = payload .. string.format("Content-Type: %s\r\n", dataType)
--     local data = createRandomJsonData(size-#payload-25-4)
    
--     if data then
--         payload = payload .. string.format("Content-Length: %d\r\n", #data)
--         payload = payload .. "\r\n" .. data
--     else
--         payload = payload .. "\r\n"
--     end

--     return payload
end
