local AddOnName, KeystonePercentageHelper = ...

KeystonePercentageHelper.BFA_DUNGEONS = {
    -- {bossID, neededPercent, shouldInfom, haveInformed}
    [353] = {{1, 37.04, false, false}, {2, 54.66,  false, false}, {3, 100,   true,  false},  {4, 100,   true, false}}, -- [SoB] Siege of Boralus
}

KeystonePercentageHelper.BFA_DEFAULTS = {
    SoB = { BossOne = 37.04, BossOneInform = false, BossTwo = 54.66, BossTwoInform = false, BossThree = 100, BossThreeInform = true, BossFour = 100, BossFourInform = true }
}

KeystonePercentageHelper.BFA_DUNGEON_IDS = {
    SoB = 353
}
