local AddOnName, KeystonePercentageHelper = ...

KeystonePercentageHelper.SL_DUNGEONS = {
    -- {bossID, neededPercent, shouldInfom, haveInformed}
    [375] = {{1, 33.10, false, false}, {2, 63.45,  false, false}, {3, 100,   true,  false}}, -- [MoTS] Mists of Tirna Scithe
    [376] = {{1, 22.59, false, false}, {2, 76.81,  true, false},  {3, 100,   true,  false},  {4, 100,   true, false}}, -- [NW] The Necrotic Wake
}

KeystonePercentageHelper.SL_DEFAULTS = {
    MoTS = { BossOne = 33.10, BossOneInform = false, BossTwo = 63.45, BossTwoInform = false, BossThree = 100, BossThreeInform = true },
    NW = { BossOne = 22.59, BossOneInform = false, BossTwo = 76.81, BossTwoInform = true, BossThree = 100, BossThreeInform = true, BossFour = 100, BossFourInform = true }
}

KeystonePercentageHelper.SL_DUNGEON_IDS = {
    MoTS = 375,
    NW = 376
}
