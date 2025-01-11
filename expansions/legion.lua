local AddOnName, KeystonePercentageHelper = ...

KeystonePercentageHelper.LEGION_DUNGEONS = {
    -- {bossID, neededPercent, shouldInfom, haveInformed}
    [247] = {{1, 39.68, false, false}, {2, 45.83,  false, false}, {3, 81.26, true,  false},  {4, 100,   true, false}}, -- [TML] -- The MOTHERLODE!!
}

KeystonePercentageHelper.LEGION_DEFAULTS = {
    TML = { BossOne = 39.68, BossOneInform = false, BossTwo = 45.83, BossTwoInform = false, BossThree = 81.26, BossThreeInform = true, BossFour = 100, BossFourInform = true },
}

KeystonePercentageHelper.LEGION_DUNGEON_IDS = {
    TML = 247,  -- The MOTHERLODE!!
}
