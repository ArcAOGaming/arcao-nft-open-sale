local M = {}

-- Define the module as a function that takes dependencies
local function TokenHandler(deps)
    deps = deps or {}
    -- Use provided dependencies or defaults
    local paymentManager = deps.paymentManager or require("src.payments").getInstance()
    local nftManager = deps.nftManager or require("src.nft-manager").getInstance()
    local tokenUtils = deps.tokenUtils or require("src.utils.token_utils")

    -- Create a local table to hold module functions
    local self = {}

    -- Public methods
    function self.handleCreditNotice(msg)
        local fromProcess = msg.Tags["From-Process"]

        -- Try to handle as payment
        if paymentManager.isPaymentToken(fromProcess) then
            if paymentManager.handlePaymentCreditNotice(msg) then
                return true
            end
            return false
        end

        -- Try to handle as NFT
        if nftManager.isNFT(fromProcess) then
            if nftManager.handleNFTCreditNotice(msg) then
                return true
            end
            return false
        end

        -- Neither payment nor NFT
        tokenUtils.returnTokens(msg, "Unrecognized token type from: " .. fromProcess)
        return false
    end

    return self
end

-- For testing: create new instance with dependencies
M.new = TokenHandler

-- For production: singleton instance
local instance = nil
function M.getInstance(deps)
    if not instance then
        instance = TokenHandler(deps)
    end
    return instance
end

-- Return the module interface
return M
