local testModule
describe("useless tests", function()
    before_each(function()
        testModule = require("timespent")
    end)
    it("setup", function()
        testModule.setup()
    end)
    it("registerProgress", function()
        testModule.registerProgress()
    end)
    --TODO: tests
end)
