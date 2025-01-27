local TokenHandlerModule = require("src.token_handler")

describe("Token Handler", function()
    local token_handler
    local mock_payment_manager
    local mock_nft_manager
    local mock_token_utils
    local return_tokens_called = false
    local payment_credit_notice_called = false
    local nft_credit_notice_called = false

    -- Set up test environment before each test
    before_each(function()
        return_tokens_called = false
        payment_credit_notice_called = false
        nft_credit_notice_called = false

        -- Mock dependencies
        mock_payment_manager = {
            isPaymentToken = function() return false end,
            handlePaymentCreditNotice = function()
                payment_credit_notice_called = true
                return false
            end
        }

        mock_nft_manager = {
            isNFT = function() return false end,
            handleNFTCreditNotice = function()
                nft_credit_notice_called = true
                return false
            end
        }

        mock_token_utils = {
            returnTokens = function() return_tokens_called = true end
        }

        -- Create token handler with mocked dependencies
        token_handler = TokenHandlerModule.new({
            paymentManager = mock_payment_manager,
            nftManager = mock_nft_manager,
            tokenUtils = mock_token_utils
        })
    end)

    describe("initialization", function()
        it("should create a token handler instance", function()
            assert.is_not_nil(token_handler)
            assert.is_not_nil(token_handler.handleCreditNotice)
        end)

        it("should maintain singleton instance", function()
            local first_instance = TokenHandlerModule.getInstance()
            local second_instance = TokenHandlerModule.getInstance()
            assert.are.equal(first_instance, second_instance)
        end)

        it("should allow multiple test instances", function()
            local instance1 = TokenHandlerModule.new({
                paymentManager = mock_payment_manager,
                nftManager = mock_nft_manager,
                tokenUtils = mock_token_utils
            })
            local instance2 = TokenHandlerModule.new({
                paymentManager = mock_payment_manager,
                nftManager = mock_nft_manager,
                tokenUtils = mock_token_utils
            })
            assert.are_not.equal(instance1, instance2)
        end)
    end)

    describe("handleCreditNotice", function()
        it("should call handlePaymentCreditNotice when isPaymentToken returns true", function()
            mock_payment_manager.isPaymentToken = function() return true end
            local msg = { Tags = { ["From-Process"] = "payment-id" } }
            token_handler.handleCreditNotice(msg)
            assert.is_true(payment_credit_notice_called)
            assert.is_false(nft_credit_notice_called)
        end)

        it("should call handleNFTCreditNotice when isNFT returns true", function()
            mock_nft_manager.isNFT = function() return true end
            local msg = { Tags = { ["From-Process"] = "nft-id" } }
            token_handler.handleCreditNotice(msg)
            assert.is_false(payment_credit_notice_called)
            assert.is_true(nft_credit_notice_called)
        end)

        it("should call returnTokens when neither payment nor NFT", function()
            local msg = { Tags = { ["From-Process"] = "unknown-id" } }
            token_handler.handleCreditNotice(msg)
            assert.is_false(payment_credit_notice_called)
            assert.is_false(nft_credit_notice_called)
            assert.is_true(return_tokens_called)
        end)
    end)
end)
