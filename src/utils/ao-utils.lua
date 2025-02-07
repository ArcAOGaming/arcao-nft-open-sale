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
function AOUtils.reply(data)
    if type(data) == "string" or type(data) == "table" then
        Handlers.utils.reply(data)
    elseif type(data) == "number" then
        Handlers.utils.reply(tostring(data))
    elseif type(data) == "boolean" then
        Handlers.utils.reply(tostring(data))
    elseif data == nil then
        Handlers.utils.reply("")
    else
        error("Invalid data type for reply: " .. type(data))
    end
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

return AOUtils
