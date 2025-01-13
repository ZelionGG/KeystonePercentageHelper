local AddOnName, KeystonePercentageHelper = ...

-- Define which dungeons are in the next season
KeystonePercentageHelper.NEXT_SEASON_DUNGEONS = {
    -- War Within dungeons
    [506] = true, -- CBM (Cinderbrew Meadery)
    [504] = true, -- DFC (Darkflame Cleft)
    [525] = true, -- OFG (Operation: Floodgate)
    [499] = true, -- PotSF (Priory of the Sacred Flame)
    [500] = true, -- TR (The Rookery)
    -- Shadowlands
    [382] = true, -- ToP (Theater of Pain)
    -- Battle for Azeroth dungeons
    [370] = true, -- OMGW (Operation: Mechagon - Workshop)
    [247] = true, -- TML (The MOTHERLODE!!)
}

-- Function to check if a dungeon is in the next season
function KeystonePercentageHelper:IsNextSeasonDungeon(dungeonId)
    return self.NEXT_SEASON_DUNGEONS[dungeonId] or false
end
