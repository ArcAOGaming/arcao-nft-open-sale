local M = {}

-- Define the module as a function that takes dependencies
local function PaymentManager(deps)
    deps = deps or {}
    -- Use provided dependencies or defaults
    local constants = deps.constants or require("src.constants.token_constants")
    local tokenUtils = deps.tokenUtils or require("src.utils.token_utils")
    local nftManager = deps.nftManager or require("src.nft-manager").getInstance()
    local whitelistManager = deps.whitelistManager or require("src.whitelist-manager").getInstance()

    -- Create a local table to hold module functions
    local self = {}

    -- Private functions
    local function _validatePayment(quantity, expectedPrice)
        return quantity == expectedPrice
    end

    -- Public methods
    function self.isPaymentToken(processId)
        return processId == constants.PAYMENT_TOKEN_ID
    end

    function self.isCorrectAmount(quantity)
        return _validatePayment(quantity, constants.NFT_PRICE)
    end

    function self.handlePaymentCreditNotice(msg)
        local processId = msg.Tags["From-Process"]
        local quantity = msg.Tags["Quantity"]
        local sender = msg.Tags["Sender"]

        -- Check whitelist first
        local isWhitelisted, whitelistError = whitelistManager.validateWhitelist(msg)
        if not isWhitelisted then
            tokenUtils.returnTokens(msg, whitelistError)
            return false
        end

        if not self.isPaymentToken(processId) then
            tokenUtils.returnTokens(msg, "Not a payment token from: " .. processId)
            return false
        end

        if not self.isCorrectAmount(quantity) then
            tokenUtils.returnTokens(msg, "Incorrect payment amount. Expected: " .. constants.NFT_PRICE)
            return false
        end

        nftManager.sendNextNFT(sender)
        tokenUtils.sendTokensToOwner(constants.PAYMENT_TOKEN_ID, constants.NFT_PRICE, nil)
        return true
    end

    return self
end

-- For testing: create new instance with dependencies
M.new = PaymentManager

-- For production: singleton instance
local instance = nil
function M.getInstance(deps)
    if not instance then
        instance = PaymentManager(deps)
    end
    return instance
end

-- Return the module interface
return M
