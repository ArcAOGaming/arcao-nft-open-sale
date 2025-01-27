--- Handlers module
-- This module defines various handlers for processing messages.
local ao_utils = require('src.utils.ao-utils')
local nft_manager = require('src.nft-manager')
local token = require('src.token')

-- Credit Notice Handler
Handlers.add('creditNotice',
    Handlers.utils.hasMatchingTag('Action', 'Credit-Notice'),
    ao_utils.wrapHandler(token.handleCreditNotice)
)

-- Query NFT Count Handler
Handlers.add('queryNFTCount',
    Handlers.utils.hasMatchingTag('Action', 'Query-NFT-Count'),
    ao_utils.wrapHandler(nft_manager.handleNFTCount)
)
