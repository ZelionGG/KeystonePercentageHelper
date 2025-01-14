local AddOnName, KeystonePercentageHelper = ...

KeystonePercentageHelper.changelog = {
    {
        version = "1.0.0",
        date = "2025-01-13",
        changes = {
            "Initial release",
            "Added support for The War Within dungeons",
            "Added percentage tracking for all supported dungeons",
            "Added customizable display frame",
            "Added advanced options for dungeon percentages"
        }
    }
}

function KeystonePercentageHelper:GetChangelogString()
    local text = ""
    for _, entry in ipairs(self.changelog) do
        text = text .. "|cffffd100Version " .. entry.version .. "|r - " .. entry.date .. "\n"
        for _, change in ipairs(entry.changes) do
            text = text .. "• " .. change .. "\n"
        end
        text = text .. "\n"
    end
    return text
end
