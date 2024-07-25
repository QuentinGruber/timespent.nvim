local eq = assert.are.same
local testModule
describe("list", function()
    before_each(function()
        testModule = require("timespent")
    end)
    it("decode", function()
        testModule.setup()
        eq(true, true)
    end)
end)
