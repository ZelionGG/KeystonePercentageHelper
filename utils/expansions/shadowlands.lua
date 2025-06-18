local AddOnName, KeystonePercentageHelper = ...

-- Define a single source of truth for dungeon data
KeystonePercentageHelper.SL_DUNGEON_DATA = {
    -- Format: [shortName] = {id = dungeonID, bosses = {{bossID, percent, shouldInform}, ...}}
    MoTS = {
        id = 375,
        bosses = {
            {1, 33.10, false},
            {2, 63.45, false},
            {3, 100, true}
        }
    },
    NW = {
        id = 376,
        bosses = {
            {1, 22.59, false},
            {2, 76.81, true},
            {3, 100, true},
            {4, 100, true}
        }
    },
    ToP = {
        id = 382,
        bosses = {
            {1, 7.01, false},
            {2, 37.27, false},
            {3, 71.59, false},
            {4, 100, false},
            {5, 100, true}
        }
    },
    TSoW = {
        id = 391,
        bosses = {
            {1, 7.01, false},
            {2, 37.27, false},
            {3, 71.59, false},
            {4, 100, false},
            {5, 100, true}
        }
    },
    TSLG = {
        id = 392,
        bosses = {
            {1, 7.01, false},
            {2, 37.27, false},
            {3, 71.59, false},
        }
    },
    HoA = {
        id = 378,
        bosses = {
            {1, 7.01, false},
            {2, 37.27, false},
            {3, 71.59, false},
            {4, 100, false},
        }
    }
}
