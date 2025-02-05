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
        message = "An unexpected error occurred. Please try again later."
    }))
end

-- Public methods
function AOUtils.reply(data)
    return Handlers.utils.reply(data)
end

function AOUtils.sendError(target, message)
    ao.send(_createResponse(target, "Error", {
        message = message
    }))
end

function AOUtils.wrapHandler(handlerFn)
    return function(msg)
        local success = xpcall(function() return handlerFn(msg) end, errorHandler)
        if not success then
           if msg.Sender == nil then
              ao.send(sendResponse(msg.From, "Error", { message = "An unexpected error occurred. Please try again later." }))
           else
              ao.send(sendResponse(msg.Sender, "Error", { message = "An unexpected error occurred. Please try again later." }))
           end
        end
     end
end

return AOUtils
