local AddOnName, KeystonePercentageHelper = ...

-- Define which dungeons are in the current season
KeystonePercentageHelper.TWW_1_DUNGEONS = {
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