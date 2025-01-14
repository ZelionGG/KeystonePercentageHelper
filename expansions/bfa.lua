local AddOnName, KeystonePercentageHelper = ...

KeystonePercentageHelper.BFA_DUNGEONS = {
    -- {bossID, neededPercent, shouldInfom, haveInformed}
    [370] = {{1, 39.68, false, false}, {2, 45.83,  false, false}, {3, 81.26, true,  false},  {4, 100,   true, false}}, -- [OMGW] Operation: Mechagon - Workshop
    [353] = {{1, 37.04, false, false}, {2, 54.66,  false, false}, {3, 100,   true,  false},  {4, 100,   true, false}}, -- [SoB] Siege of Boralus
    [247] = {{1, 39.68, false, false}, {2, 45.83,  false, false}, {3, 81.26, true,  false},  {4, 100,   true, false}}, -- [TML] -- The MOTHERLODE!!
}

KeystonePercentageHelper.BFA_DEFAULTS = {
    OMGW = { BossOne = 39.68, BossOneInform = false, BossTwo = 45.83, BossTwoInform = false, BossThree = 81.26, BossThreeInform = true, BossFour = 100, BossFourInform = true },
    SoB = { BossOne = 37.04, BossOneInform = false, BossTwo = 54.66, BossTwoInform = false, BossThree = 100, BossThreeInform = true, BossFour = 100, BossFourInform = true },
    TML = { BossOne = 39.68, BossOneInform = false, BossTwo = 45.83, BossTwoInform = false, BossThree = 81.26, BossThreeInform = true, BossFour = 100, BossFourInform = true }
}

KeystonePercentageHelper.BFA_DUNGEON_IDS = {
    OMGW = 370, -- Operation: Mechagon - Workshop
    SoB = 353, -- Siege of Boralus
    TML = 247  -- The MOTHERLODE!!
}
