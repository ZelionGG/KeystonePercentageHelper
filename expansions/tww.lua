local AddOnName, KeystonePercentageHelper = ...

KeystonePercentageHelper.TWW_DUNGEONS = {
    -- {bossID, neededPercent, shouldInfom, haveInformed}
    [503] = {{1, 32.78, false, false}, {2, 78.76,  false, false}, {3, 100,   true,  false}}, -- [AKCE] Ara-Kara, City of Echoes
    [502] = {{1, 31.54, false, false}, {2, 56.60,  false, false}, {3, 87.60, false, false},  {4, 100,   true, false}}, -- [CoT] City of Threads
    [501] = {{1, 26.79, false, false}, {2, 54.40,  false, false}, {3, 75.66, false, false},  {4, 100, true, false}}, -- [TSV] The Stonevault
    [505] = {{1, 29.78, false, false}, {2, 93.48,  false, false}, {3, 100,   true,  false}}, -- [TDB] The Dawnbreaker
}

KeystonePercentageHelper.TWW_DEFAULTS = {
    AKCE = { BossOne = 32.78, BossOneInform = false, BossTwo = 78.76, BossTwoInform = false, BossThree = 100, BossThreeInform = true },
    CoT = { BossOne = 31.54, BossOneInform = false, BossTwo = 56.60, BossTwoInform = false, BossThree = 87.60, BossThreeInform = false, BossFour = 100, BossFourInform = true },
    TSV = { BossOne = 26.79, BossOneInform = false, BossTwo = 54.40, BossTwoInform = false, BossThree = 75.66, BossThreeInform = false, BossFour = 100, BossFourInform = true },
    TDB = { BossOne = 29.78, BossOneInform = false, BossTwo = 93.48, BossTwoInform = false, BossThree = 100, BossThreeInform = true }
}

KeystonePercentageHelper.TWW_DUNGEON_IDS = {
    AKCE = 503,
    CoT = 502,
    TSV = 501,
    TDB = 505
}
