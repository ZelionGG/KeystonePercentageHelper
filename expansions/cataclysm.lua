local AddOnName, KeystonePercentageHelper = ...

KeystonePercentageHelper.CATACLYSM_DUNGEONS = {
    -- {bossID, neededPercent, shouldInfom, haveInformed}
    [507] = {{1, 39.68, false, false}, {2, 45.83,  false, false}, {3, 81.26, true,  false},  {4, 100,   true, false}}, -- [GB] Grim Batol
}

KeystonePercentageHelper.CATACLYSM_DEFAULTS = {
    GB = { BossOne = 39.68, BossOneInform = false, BossTwo = 45.83, BossTwoInform = false, BossThree = 81.26, BossThreeInform = true, BossFour = 100, BossFourInform = true }
}

KeystonePercentageHelper.CATACLYSM_DUNGEON_IDS = {
    GB = 507
}
