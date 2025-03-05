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
            {1, 22.59, false},
            {2, 76.81, true},
            {3, 100, true},
            {4, 100, true},
            {5, 100, true}
        }
    }
}
