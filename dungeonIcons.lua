local AddonName, KeystonePercentageHelper, Engine = ...

-- Add the dungeon icons after KeystonePercentageHelper is initialized
local function OnLoad()
    KeystonePercentageHelper.dungeonIcons = {
        -- The War Within
        AKCE = "|T5899326:16:16:0:0|t",
        CoT = "|T5899328:16:16:0:0|t",
        CBM = "|T5899327:16:16:0:0|t",
        DFC = "|T5899329:16:16:0:0|t",
        OFG = "|T6392629:16:16:0:0|t",
        PotSF = "|T5899331:16:16:0:0|t",
        TDB = "|T5899330:16:16:0:0|t",
        TR = "|T5899332:16:16:0:0|t",
        TSV = "|T5899333:16:16:0:0|t",

        -- Shadowlands
        MoTS = "|T3601531:16:16:0:0|t",
        NW = "|T3601560:16:16:0:0|t",
        ToP = "|T3601550:16:16:0:0|t",

        -- Battle for Azeroth
        OMGW = "|T3024540:16:16:0:0|t",
        SoB = "|T2011139:16:16:0:0|t",
        TML = "|T2011121:16:16:0:0|t",

        -- Legion

        -- Cataclysm
        GB = "|T409596:16:16:0:0|t",
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