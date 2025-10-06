local AddOnName, KeystonePolaris = ...

-- Define a single source of truth for dungeon data
KeystonePolaris.BFA_DUNGEON_DATA = {
    -- Format: [shortName] = {id = dungeonID, bosses = {{bossID, percent, shouldInform}, ...}}
    OMGW = {
        id = 370,
        mapID = 2773,
        teleportID = 373274,
        bosses = {
            {1, 22.46, false},
            {2, 47.59, true},
            {3, 71.66, true},
            {4, 100,   true}
        }
    },
    SoB = {
        id = 353,
        mapID = 1822,
        teleportID = 464256,
        bosses = {
            {1, 37.04, false},
            {2, 54.66, false},
            {3, 100, true},
            {4, 100, true}
        }
    },
    TML = {
        id = 247,
        mapID = 1594,
        teleportID = {467555, 467553},
        bosses = {
            {1, 26.91, false},
            {2, 59.30, false},
            {3, 75.93, false},
            {4, 100, true}
        }
    }
}
