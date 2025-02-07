local M = {}

-- Define the module as a function that takes dependencies
local function NFTManager(deps)
    deps = deps or {}
    -- Use provided dependencies or defaults
    local constants = deps.constants or require("src.constants.token_constants")
    local AOUtils = deps.AOUtils or require("src.utils.ao-utils")
    local tokenUtils = deps.tokenUtils or require("src.utils.token_utils")
    -- Create a local table to hold module functions
    local self = {}

    -- Private state
    local stored_nfts = {}

    -- Public methods
    function self.handleNFTCount(msg)
        local count = #stored_nfts
        return AOUtils.reply(count)
    end

    function self.getStoredNFTCount()
        return #stored_nfts
    end

    function self.isNFT(processId)
        return constants.NFT_PROCESS_IDS[processId] or false
    end

    function self.sendNFT(recipient)
        -- TODO: Implement NFT sending logic
        print("Sending NFT to " .. recipient)
        return true
    end

    function self.handleNFTCreditNotice(msg)
        local processId = msg.Tags["From-Process"]

        if not self.isNFT(processId) then
            tokenUtils.returnTokens(msg, "Not an NFT from: " .. processId)
            return false
        end

        table.insert(stored_nfts, processId)
        return true
    end

    return self
end

-- For testing: create new instance with dependencies
M.new = NFTManager

-- For production: singleton instance
local instance = nil
function M.getInstance(deps)
    if not instance then
        instance = NFTManager(deps)
    end
    return instance
end

-- Return the module interface
return M
