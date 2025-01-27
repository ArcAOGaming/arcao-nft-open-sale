--- Handlers module
-- This module defines various handlers for processing messages.

local math_helper = require('src.utils.math_helper')

--- Example handler that adds two big integers using hasMatchingTag.
Handlers.add("add_numbers",
    Handlers.utils.hasMatchingTag("Action", "AddNumbers"),
    function(msg)
        -- Convert inputs to bint objects and add
        local result = math_helper.add(msg.Data.num1, msg.Data.num2)
        print("Result:", tostring(result))
        return tostring(result)
    end
)
