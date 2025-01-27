---
-- This module is responsible for adding additional Scheduler Units(SUs)
-- which have the authority to schedule this process. It reads a list
-- of trusted authorities from the configuration file and inserts
-- each one into the `ao.authorities` table.
--
-- Usage:
-- Simply require this module to automatically populate the
-- `ao.authorities` table with the configured authorities.
--
-- Example:
-- local trustedAuthorities = require("src.utils.trusted_authorities")
--
-- Note:
-- Ensure that the `config.lua` file contains the correct list of
-- trusted authorities.
--

-- Load the configuration file
local config = require("src.utils.trusted_authorities.config")

-- Loop through the list and insert each string into the authorities table
for _, authority in ipairs(config) do
    table.insert(ao.authorities, authority)
end

return