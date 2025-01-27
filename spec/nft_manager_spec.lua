local NFTManagerModule = require("src.nft-manager")

describe("NFT Manager", function()
    local nft_manager
    local mock_constants
    local mock_ao_utils
    local mock_token_utils
    local valid_process_id = "valid-process-id"

    -- Set up test environment before each test
    before_each(function()
        -- Mock dependencies
        mock_constants = {
            NFT_PROCESS_IDS = {
                [valid_process_id] = true
            }
        }

        mock_ao_utils = {
            reply = function(count) return count end
        }

        mock_token_utils = {
            returnTokens = function() end
        }

        -- Create NFT manager with mocked dependencies
        nft_manager = NFTManagerModule.new({
            constants = mock_constants,
            AOUtils = mock_ao_utils,
            tokenUtils = mock_token_utils
        })
    end)

    describe("initialization", function()
        it("should create an NFT manager instance", function()
            assert.is_not_nil(nft_manager)
            assert.is_not_nil(nft_manager.handleNFTCreditNotice)
            assert.is_not_nil(nft_manager.isNFT)
            assert.is_not_nil(nft_manager.getStoredNFTCount)
        end)

        it("should maintain singleton instance", function()
            local first_instance = NFTManagerModule.getInstance()
            local second_instance = NFTManagerModule.getInstance()
            assert.are.equal(first_instance, second_instance)
        end)

        it("should allow multiple test instances", function()
            local instance1 = NFTManagerModule.new({
                constants = mock_constants,
                AOUtils = mock_ao_utils,
                tokenUtils = mock_token_utils
            })
            local instance2 = NFTManagerModule.new({
                constants = mock_constants,
                AOUtils = mock_ao_utils,
                tokenUtils = mock_token_utils
            })
            assert.are_not.equal(instance1, instance2)
        end)
    end)

    describe("isNFT", function()
        it("should return true for valid NFT process ID", function()
            assert.is_true(nft_manager.isNFT(valid_process_id))
        end)

        it("should return false for invalid NFT process ID", function()
            assert.is_false(nft_manager.isNFT("invalid-process-id"))
        end)
    end)

    describe("handleNFTCreditNotice", function()
        it("should return false for invalid NFT process ID", function()
            local msg = {
                Tags = {
                    ["From-Process"] = "invalid-process-id"
                }
            }
            assert.is_false(nft_manager.handleNFTCreditNotice(msg))
            assert.are.equal(0, nft_manager.getStoredNFTCount())
        end)

        it("should store valid NFT and return true", function()
            local msg = {
                Tags = {
                    ["From-Process"] = valid_process_id
                }
            }
            assert.is_true(nft_manager.handleNFTCreditNotice(msg))
            assert.are.equal(1, nft_manager.getStoredNFTCount())
        end)

        it("should maintain correct count after multiple operations", function()
            local valid_msg = {
                Tags = {
                    ["From-Process"] = valid_process_id
                }
            }
            local invalid_msg = {
                Tags = {
                    ["From-Process"] = "invalid-process-id"
                }
            }

            -- Try invalid first
            nft_manager.handleNFTCreditNotice(invalid_msg)
            assert.are.equal(0, nft_manager.getStoredNFTCount())

            -- Then valid
            nft_manager.handleNFTCreditNotice(valid_msg)
            assert.are.equal(1, nft_manager.getStoredNFTCount())

            -- Another invalid shouldn't change count
            nft_manager.handleNFTCreditNotice(invalid_msg)
            assert.are.equal(1, nft_manager.getStoredNFTCount())
        end)
    end)

    -- TODO: Add tests for sendNFT when implemented
    describe("sendNFT", function()
        it("should be implemented", function()
            pending("Implement sendNFT functionality and tests")
        end)
    end)
end)
