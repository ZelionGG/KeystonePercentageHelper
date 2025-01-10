local AddOnName, KeystonePercentageHelper = ...

-- Define which dungeons are in the current season
KeystonePercentageHelper.CURRENT_SEASON_DUNGEONS = {
    -- War Within dungeons
    [503] = true, -- AKCE
    [502] = true, -- CoT
    [505] = true, -- TDB
    [501] = true, -- TSV
    -- Shadowlands dungeons
    [375] = true, -- MoTS
    [376] = true, -- NW
    -- BFA dungeons
    [353] = true, -- SoB
    -- Cataclysm dungeons
    [507] = true, -- GB
}

-- Function to check if a dungeon is in the current season
function KeystonePercentageHelper:IsCurrentSeasonDungeon(dungeonId)
    return self.CURRENT_SEASON_DUNGEONS[dungeonId] or false
end
