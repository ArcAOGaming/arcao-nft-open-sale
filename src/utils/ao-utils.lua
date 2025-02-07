local json = require("json")

local AOUtils = {}
AOUtils.__index = AOUtils

-- Private functions
local function _createResponse(target, action, data)
    return {
        Target = target,
        Action = action,
        Data = json.encode(data)
    }
end

local function _getErrorTarget(msg)
    return msg.Sender or msg.From
end

local function _handleError(msg)
    local target = _getErrorTarget(msg)
    ao.send(_createResponse(target, "Error", {
        message = "An unexpected error occurred. Please try again later.",
        log = msg
    }))
end

-- Public methods
function AOUtils.reply(msg, data)
    local formattedData
    if type(data) == "string" then
        formattedData = data
    elseif type(data) == "table" then
        formattedData = json.encode(data)
    elseif type(data) == "number" then
        formattedData = tostring(data)
    elseif type(data) == "boolean" then
        formattedData = tostring(data)
    elseif data == nil then
        formattedData = ""
    else
        error("Invalid data type for reply: " .. type(data))
    end

    msg.reply({
        Action = "reply",
        Data = formattedData
    })
end

function AOUtils.sendError(target, message)
    ao.send(_createResponse(target, "Error", {
        message = message
    }))
end

function AOUtils.wrapHandler(handlerFn)
    return function(msg)
        xpcall(function() return handlerFn(msg) end, _handleError)
    end
end

function AOUtils.verifyProcessOwner(msg)
    if msg.From ~= ao.env.Process.Owner then
        error("Unauthorized: Only the process owner can perform this action")
        return false
    end
    return true
end

function AOUtils.sendTransfer(target, recipient, quantity)
    assert(type(target) == 'string', 'Target is required!')
    assert(type(recipient) == 'string', 'Recipient is required!')
    assert(type(quantity) == 'string', 'Quantity must be a string!')

    ao.send({
        Target = target,
        Action = "Transfer",
        Tags = {
            Recipient = recipient,
            Quantity = quantity
        }
    })
end

return AOUtils
