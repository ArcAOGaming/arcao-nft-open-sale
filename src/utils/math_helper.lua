---
-- Math helper module for big integer operations.
-- @module math_helper

local bint = require 'bint'(256)  -- use 256 bits integers
local M = {}

--- Adds two big integers.
-- @param a The first number (string or number).
-- @param b The second number (string or number).
-- @return The sum of a and b as a bint.
function M.add(a, b)
    -- Convert inputs to bint objects
    local result = bint(a)
    result:_add(bint(b))
    return result
end

return M
