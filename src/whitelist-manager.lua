local M = {}

-- Define the module as a function that takes dependencies
local function WhitelistManager(deps)
    deps = deps or {}
    -- Use provided dependencies or defaults
    local constants = deps.constants or require("src.constants.token_constants")

    -- Create a local table to hold module functions
    local self = {}

    -- Public methods
    function self._isWhitelisted(address)
        return constants.WHITELIST_ADDRESSES[address] or false
    end

    function self.validateWhitelist(msg)
        local sender = msg.Tags["Sender"]
        if not sender then
            return false, "No sender address provided"
        end

        if not self._isWhitelisted(sender) then
            return false, "Address not whitelisted: " .. sender
        end

        return true
    end

    return self
end

-- For testing: create new instance with dependencies
M.new = WhitelistManager

-- For production: singleton instance
local instance = nil
function M.getInstance(deps)
    if not instance then
        instance = WhitelistManager(deps)
    end
    return instance
end

-- Return the module interface
return M
