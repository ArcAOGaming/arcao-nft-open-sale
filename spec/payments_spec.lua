local PaymentManagerModule = require("src.payments")

describe("Payment Manager", function()
    local payment_manager
    local mock_constants
    local mock_token_utils
    local mock_nft_manager
    local valid_process_id = "valid-payment-token"
    local correct_amount = "1000000"
    local return_tokens_called = false
    local send_nft_called = false

    -- Set up test environment before each test
    before_each(function()
        return_tokens_called = false
        send_nft_called = false

        -- Mock dependencies
        mock_constants = {
            PAYMENT_TOKEN_ID = valid_process_id,
            NFT_PRICE = correct_amount
        }

        mock_token_utils = {
            returnTokens = function() return_tokens_called = true end
        }

        mock_nft_manager = {
            sendNFT = function() send_nft_called = true end
        }

        -- Create payment manager with mocked dependencies
        payment_manager = PaymentManagerModule.new({
            constants = mock_constants,
            tokenUtils = mock_token_utils,
            nftManager = mock_nft_manager
        })
    end)

    describe("initialization", function()
        it("should create a payment manager instance", function()
            assert.is_not_nil(payment_manager)
            assert.is_not_nil(payment_manager.handlePaymentCreditNotice)
            assert.is_not_nil(payment_manager.isPaymentToken)
            assert.is_not_nil(payment_manager.isCorrectAmount)
        end)

        it("should maintain singleton instance", function()
            local first_instance = PaymentManagerModule.getInstance()
            local second_instance = PaymentManagerModule.getInstance()
            assert.are.equal(first_instance, second_instance)
        end)

        it("should allow multiple test instances", function()
            local instance1 = PaymentManagerModule.new({
                constants = mock_constants,
                tokenUtils = mock_token_utils,
                nftManager = mock_nft_manager
            })
            local instance2 = PaymentManagerModule.new({
                constants = mock_constants,
                tokenUtils = mock_token_utils,
                nftManager = mock_nft_manager
            })
            assert.are_not.equal(instance1, instance2)
        end)
    end)

    describe("isPaymentToken", function()
        it("should return true for valid payment token", function()
            assert.is_true(payment_manager.isPaymentToken(valid_process_id))
        end)

        it("should return false for invalid payment token", function()
            assert.is_false(payment_manager.isPaymentToken("invalid-token"))
        end)
    end)

    describe("isCorrectAmount", function()
        it("should return true for exact amount", function()
            assert.is_true(payment_manager.isCorrectAmount(correct_amount))
        end)

        it("should return false for lower amount", function()
            assert.is_false(payment_manager.isCorrectAmount("999999"))
        end)

        it("should return false for higher amount", function()
            assert.is_false(payment_manager.isCorrectAmount("1000001"))
        end)
    end)

    describe("handlePaymentCreditNotice", function()
        it("should return false and call returnTokens for invalid token", function()
            local msg = {
                Tags = {
                    ["From-Process"] = "invalid-token",
                    ["Quantity"] = correct_amount,
                    ["Sender"] = "sender-id"
                }
            }
            assert.is_false(payment_manager.handlePaymentCreditNotice(msg))
            assert.is_true(return_tokens_called)
            assert.is_false(send_nft_called)
        end)

        it("should return false and call returnTokens for incorrect amount", function()
            local msg = {
                Tags = {
                    ["From-Process"] = valid_process_id,
                    ["Quantity"] = "999999",
                    ["Sender"] = "sender-id"
                }
            }
            assert.is_false(payment_manager.handlePaymentCreditNotice(msg))
            assert.is_true(return_tokens_called)
            assert.is_false(send_nft_called)
        end)

        it("should return true and call sendNFT for valid payment", function()
            local msg = {
                Tags = {
                    ["From-Process"] = valid_process_id,
                    ["Quantity"] = correct_amount,
                    ["Sender"] = "sender-id"
                }
            }
            assert.is_true(payment_manager.handlePaymentCreditNotice(msg))
            assert.is_false(return_tokens_called)
            assert.is_true(send_nft_called)
        end)
    end)
end)
