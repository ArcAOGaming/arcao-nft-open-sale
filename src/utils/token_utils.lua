local TokenUtils = {}
TokenUtils.__index = TokenUtils

-- Constructor
function TokenUtils.new()
    local self = setmetatable({}, TokenUtils)
    return self
end

-- Private functions
local function _createTransferMessage(token, recipient, quantity, note)
    return {
        Target     = token,
        Action     = "Transfer",
        Recipient  = recipient,
        Quantity   = quantity,
        ["X-Note"] = note or "Sending tokens from Random Process"
    }
end

-- Public methods
function TokenUtils.sendTokens(token, recipient, quantity, note)
    ao.send(_createTransferMessage(token, recipient, quantity, note))
end

function TokenUtils.returnTokens(msg, errMessage)
    TokenUtils.sendTokens(msg.From, msg.Sender, msg.Quantity, errMessage)
end

-- Create and return singleton instance
local tokenUtils = TokenUtils.new()
return tokenUtils
