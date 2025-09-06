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
            {1, 31.67, false},
            {2, 57.22, false},
            {3, 91.67, true},
            {4, 77.22, false},
            {5, 100, true}
        }
    },
    TSLG = {
        id = 392,
        bosses = {
            {1, 51.45, false},
            {2, 75.43, false},
            {3, 100, true}
        }
    },
    HoA = {
        id = 378,
        bosses = {
            {1, 55.79, false},
            {2, 81.66, false},
            {3, 93.24, true},
            {4, 100, true}
        }
    }
}
