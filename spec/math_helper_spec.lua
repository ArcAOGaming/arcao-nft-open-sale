local math_helper = require("src.utils.math_helper")
local bint = require 'bint'(256)  -- use 256 bits integers

-- Add lib to package path if not already present
package.path = "./lib/share/lua/5.4/?.lua;./lib/share/lua/5.4/?/init.lua;" .. package.path
package.cpath = "./lib/lib/lua/5.4/?.so;" .. package.cpath

describe("Math Helper", function()
    describe("add", function()
        it("should add two positive numbers correctly", function()
            local result = math_helper.add("2", "3")
            assert.are.equal("5", tostring(result))
        end)

        it("should handle negative numbers", function()
            local result = math_helper.add("2", "-3")
            assert.are.equal("-1", tostring(result))
        end)

        it("should handle zero", function()
            local result = math_helper.add("2", "0")
            assert.are.equal("2", tostring(result))
        end)

        it("should handle very large numbers", function()
            local result = math_helper.add("123456789123456789123456789", "1")
            assert.are.equal("123456789123456789123456790", tostring(result))
        end)

        it("should handle very large negative numbers", function()
            local result = math_helper.add("-123456789123456789123456789", "-1")
            assert.are.equal("-123456789123456789123456790", tostring(result))
        end)

        it("should handle bint objects directly", function()
            local a = bint("12345678901234567890")
            local b = bint("98765432109876543210")
            local result = math_helper.add(a, b)
            assert.are.equal("111111111011111111100", tostring(result))
        end)

        it("should handle bit shifts", function()
            local x = bint(1)
            x = x << 128
            assert.are.equal("340282366920938463463374607431768211456", tostring(x))
        end)
    end)
end)
