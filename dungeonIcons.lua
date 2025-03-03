local AddonName, KeystonePercentageHelper, Engine = ...

-- Add the dungeon icons after KeystonePercentageHelper is initialized
local function OnLoad()
    KeystonePercentageHelper.dungeonIcons = {
        -- Placeholder Keystone T525134

        -- The War Within
        AKCE = "5899326",
        CoT = "5899328",
        CBM = "5899327",
        DFC = "5899329",
        OFG = "6392629",
        PotSF = "5899331",
        TDB = "5899330",
        TR = "5899332",
        TSV = "5899333",

        -- Shadowlands
        MoTS = "3601531",
        NW = "3601560",
        ToP = "3601550",

        -- Battle for Azeroth
        OMGW = "3024540",
        SoB = "2011139",
        TML = "2011121",

        -- Legion

        -- Cataclysm
        GB = "409596",
    }
end

-- Register for ADDON_LOADED event
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
    if addon == AddonName then
        OnLoad()
        self:UnregisterEvent("ADDON_LOADED")
    end
end)