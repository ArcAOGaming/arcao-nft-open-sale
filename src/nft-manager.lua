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
    function self.returnNFTs(msg)
        if not AOUtils.verifyProcessOwner(msg) then
            return false
        end

        -- Get recipient from tag or default to owner
        local recipient = msg.Tags["Recipient"]
        local sent_count = 0

        -- Iterate backwards through stored_nfts to safely remove while iterating
        for i = #stored_nfts, 1, -1 do
            if self.sendNFT(stored_nfts[i], recipient) then
                table.remove(stored_nfts, i)
                sent_count = sent_count + 1
            end
        end

        return AOUtils.reply(msg, string.format("%d NFTs have been sent to %s", sent_count, recipient))
    end

    function self.handleNFTCount(msg)
        local count = #stored_nfts
        return AOUtils.reply(msg, count)
    end

    function self.getStoredNFTCount()
        return #stored_nfts
    end

    function self.isNFT(processId)
        return constants.NFT_PROCESS_IDS[processId] or false
    end

    function self.sendNextNFT(recipient)
        local index = #stored_nfts
        self.sendNFT(stored_nfts[index], recipient)
        table.remove(stored_nfts, index)
    end

    function self.sendNFT(processId, recipient)
        -- TODO: Implement NFT sending logic
        AOUtils.sendTransfer(processId, recipient, "1")
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
