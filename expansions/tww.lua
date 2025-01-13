local AddOnName, KeystonePercentageHelper = ...

KeystonePercentageHelper.TWW_DUNGEONS = {
    -- {bossID, neededPercent, shouldInfom, haveInformed}
    [503] = {{1, 32.78, false, false}, {2, 78.76,  false, false}, {3, 100,   true,  false}}, -- [AKCE] Ara-Kara, City of Echoes
    [502] = {{1, 31.54, false, false}, {2, 56.60,  false, false}, {3, 87.60, false, false},  {4, 100,   true, false}}, -- [CoT] City of Threads
    [506] = {{1, 29.78, false, false}, {2, 93.48,  false, false}, {3, 100,   true,  false},  {4, 100,   true, false}}, -- [CBM] Cinderbrew Meadery
    [504] = {{1, 32.78, false, false}, {2, 78.76,  false, false}, {3, 100,   true,  false},  {4, 100,   true, false}}, -- [DFC] Darkflame Cleft
    [525] = {{1, 31.54, false, false}, {2, 56.60,  false, false}, {3, 100, false, false},  {4, 100,   true, false}}, -- [OFG] Operation: Floodgate
    [499] = {{1, 32.78, false, false}, {2, 78.76,  false, false}, {3, 100,   true,  false}}, -- [PotSF] Priory of the Sacred Flame 
    [505] = {{1, 29.78, false, false}, {2, 93.48,  false, false}, {3, 100,   true,  false}}, -- [TDB] The Dawnbreaker
    [500] = {{1, 31.54, false, false}, {2, 56.60,  false, false}, {3, 100, false, false}}, -- [TR] The Rookery
    [501] = {{1, 26.79, false, false}, {2, 54.40,  false, false}, {3, 75.66, false, false},  {4, 100, true, false}}, -- [TSV] The Stonevault
}

KeystonePercentageHelper.TWW_DEFAULTS = {
    AKCE = { BossOne = 32.78, BossOneInform = false, BossTwo = 78.76, BossTwoInform = false, BossThree = 100, BossThreeInform = true },
    CoT = { BossOne = 31.54, BossOneInform = false, BossTwo = 56.60, BossTwoInform = false, BossThree = 87.60, BossThreeInform = false, BossFour = 100, BossFourInform = true },
    CBM = { BossOne = 29.78, BossOneInform = false, BossTwo = 93.48, BossTwoInform = false, BossThree = 100, BossThreeInform = true, BossFour = 100, BossFourInform = true },
    DFC = { BossOne = 32.78, BossOneInform = false, BossTwo = 78.76, BossTwoInform = false, BossThree = 100, BossThreeInform = true, BossFour = 100, BossFourInform = true },
    OFG = { BossOne = 31.54, BossOneInform = false, BossTwo = 56.60, BossTwoInform = false, BossThree = 100, BossThreeInform = true, BossFour = 100, BossFourInform = true },
    PotSF = { BossOne = 32.78, BossOneInform = false, BossTwo = 78.76, BossTwoInform = false, BossThree = 100, BossThreeInform = true },
    TDB = { BossOne = 29.78, BossOneInform = false, BossTwo = 93.48, BossTwoInform = false, BossThree = 100, BossThreeInform = true },
    TR = { BossOne = 31.54, BossOneInform = false, BossTwo = 56.60, BossTwoInform = false, BossThree = 100, BossThreeInform = true },
    TSV = { BossOne = 26.79, BossOneInform = false, BossTwo = 54.40, BossTwoInform = false, BossThree = 75.66, BossThreeInform = false, BossFour = 100, BossFourInform = true },
}

KeystonePercentageHelper.TWW_DUNGEON_IDS = {
    AKCE = 503,
    CoT = 502,
    CBM = 506,
    DFC = 504,
    OFG = 525,
    PotSF = 499,
    TDB = 505,
    TR = 500,
    TSV = 501
}
