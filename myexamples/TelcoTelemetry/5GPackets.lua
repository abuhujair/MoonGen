DistributionResult = {}

local cumulativeCalculated = false
local ProbabilityDistribution = {
    3.0
    -- 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0
}

local Messages = {
    -- "POST /nausf-auth/v1/ue-authentications/2285807 HTTP/1.1\r\n\r\n{\"supiOrSuci\":\"404000000000000\",\"servingNetworkName\":\"5iMFuwAyLPbKWhtZ1rW0FUQ3NHOqFnEZ\",\"amfInstanceId\":\"BiYupttk7pzxBnTLE6B9jorCKEeTk49xk49x\"}",
    -- "POST /nausf-auth/v1/ue-authentications/7277776 HTTP/1.1\r\n\r\n{\"supiOrSuci\":\"404000000000001\",\"servingNetworkName\":\"5iMFuwAyLPbKWhtZ1rW0FUQ3NHOqFnEZ\",\"amfInstanceId\":\"BiYupttk7pzxBnTLE6B9jorCKEeTk49xk49x\"}",
    -- "POST /nausf-auth/v1/ue-authentications/4830684 HTTP/1.1\r\n\r\n{\"supiOrSuci\":\"404000000000002\",\"servingNetworkName\":\"5iMFuwAyLPbKWhtZ1rW0FUQ3NHOqFnEZ\",\"amfInstanceId\":\"BiYupttk7pzxBnTLE6B9jorCKEeTk49xk49x\"}",
    "POST /nausf-auth/v1/ue-authentications/9076382 HTTP/1.1\r\n\r\n{\"supiOrSuci\":\"404000000000003\",\"servingNetworkName\":\"5iMFuwAyLPbKWhtZ1rW0FUQ3NHOqFnEZ\",\"amfInstanceId\":\"BiYupttk7pzxBnTLE6B9jorCKEeTk49xk49x\"}",
    -- "POST /nausf-auth/v1/ue-authentications/0236869 HTTP/1.1\r\n\r\n{\"supiOrSuci\":\"404000000000004\",\"servingNetworkName\":\"5iMFuwAyLPbKWhtZ1rW0FUQ3NHOqFnEZ\",\"amfInstanceId\":\"BiYupttk7pzxBnTLE6B9jorCKEeTk49xk49x\"}",
    -- "POST /nausf-auth/v1/ue-authentications/5472888 HTTP/1.1\r\n\r\n{\"supiOrSuci\":\"404000000000005\",\"servingNetworkName\":\"5iMFuwAyLPbKWhtZ1rW0FUQ3NHOqFnEZ\",\"amfInstanceId\":\"BiYupttk7pzxBnTLE6B9jorCKEeTk49xk49x\"}",
    -- "POST /nausf-auth/v1/ue-authentications/4546512 HTTP/1.1\r\n\r\n{\"supiOrSuci\":\"404000000000006\",\"servingNetworkName\":\"5iMFuwAyLPbKWhtZ1rW0FUQ3NHOqFnEZ\",\"amfInstanceId\":\"BiYupttk7pzxBnTLE6B9jorCKEeTk49xk49x\"}",
    -- "POST /nausf-auth/v1/ue-authentications/4522260 HTTP/1.1\r\n\r\n{\"supiOrSuci\":\"404000000000007\",\"servingNetworkName\":\"5iMFuwAyLPbKWhtZ1rW0FUQ3NHOqFnEZ\",\"amfInstanceId\":\"BiYupttk7pzxBnTLE6B9jorCKEeTk49xk49x\"}",
    -- "POST /nausf-auth/v1/ue-authentications/3582277 HTTP/1.1\r\n\r\n{\"supiOrSuci\":\"404000000000008\",\"servingNetworkName\":\"5iMFuwAyLPbKWhtZ1rW0FUQ3NHOqFnEZ\",\"amfInstanceId\":\"BiYupttk7pzxBnTLE6B9jorCKEeTk49xk49x\"}",
    -- "POST /nausf-auth/v1/ue-authentications/4990873 HTTP/1.1\r\n\r\n{\"supiOrSuci\":\"404000000000009\",\"servingNetworkName\":\"5iMFuwAyLPbKWhtZ1rW0FUQ3NHOqFnEZ\",\"amfInstanceId\":\"BiYupttk7pzxBnTLE6B9jorCKEeTk49xk49x\"}",
}

local function createDistribution()

    local sum = 0
    -- Create cumulative distribution
    for i, prob in ipairs(ProbabilityDistribution) do
        sum = sum + prob
        ProbabilityDistribution[i] = sum
    end
    -- Normalize
    for i, prob in ipairs(ProbabilityDistribution) do
        ProbabilityDistribution[i] = prob/sum
        DistributionResult[i] = 0
    end
end

function GetRandomMessage()
    if not cumulativeCalculated then
        createDistribution()
        cumulativeCalculated = true
    end

    local rand_index = math.random()

    for index, prob in ipairs(ProbabilityDistribution) do
        if rand_index < prob then
            DistributionResult[index] = DistributionResult[index]+1
            return Messages[index]
        end
    end    
end
