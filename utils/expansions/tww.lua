local AddOnName, KeystonePolaris = ...

-- Define a single source of truth for dungeon data
KeystonePolaris.TWW_DUNGEON_DATA = {
    -- Format: [shortName] = {id = dungeonID, bosses = {{bossID, percent, shouldInform}, ...}}
    AKCE = { -- Ara-Kara, City of Echoes
        id = 503,
        mapID = 2660,
        teleportID = 445417,
        bosses = {
            {1, 37.75, false},
            {2, 73.50, false},
            {3, 100, true}
        }
    },
    CoT = { -- City of Threads
        id = 502,
        mapID = 2669,
        teleportID = 445416,
        bosses = {
            {1, 31.54, false},
            {2, 56.60, false},
            {3, 87.60, false},
            {4, 100, true}
        }
    },
    CBM = { -- Cinderbrew Meadery
        id = 506,
        mapID = 2661,
        teleportID = 445440,
        bosses = {
            {1, 24.87, false},
            {2, 61.33, false},
            {3, 97.96, true},
            {4, 100, true}
        }
    },
    DFC = { -- Darkflame Cleft
        id = 504,
        mapID = 2651,
        teleportID = 445441,
        bosses = {
            {1, 28.24, false},
            {2, 65.02, true},
            {3, 80.05, true},
            {4, 100, true}
        }
    },
    OFG = { -- Operation: Floodgate
        id = 525,
        mapID = 2773,
        teleportID = 1216786,
        bosses = {
            {1, 36.81, false},
            {2, 67.86, false},
            {3, 57.87, true},
            {4, 100, true}
        }
    },
    PotSF = { -- Priory of the Sacred Flame
        id = 499,
        mapID = 2649,
        teleportID = 445444,
        bosses = {
            {1, 46.98, false},
            {2, 69.48, false},
            {3, 100, true}
        }
    },
    TDB = { -- The Dawnbreaker
        id = 505,
        mapID = 2662,
        teleportID = 445414,
        bosses = {
            {1, 29.78, false},
            {2, 93.48, false},
            {3, 100, true}
        }
    },
    TR = { -- The Rookery
        id = 500,
        mapID = 2648,
        teleportID = 445443,
        bosses = {
            {1, 41.13, false},
            {2, 66.73, false},
            {3, 100, true}
        }
    },
    TSV = { -- The Stonevault
        id = 501,
        mapID = 2652,
        teleportID = 445269,
        bosses = {
            {1, 26.79, false},
            {2, 54.40, false},
            {3, 75.66, false},
            {4, 100, true}
        }
    },
    EDAD = { -- Eco-Dome Al'dani
        id = 542,
        mapID = 2830,
        teleportID = 1237215,
        bosses = {
            {1, 18.92, false},
            {2, 57.12, false},
            {3, 100, true}
        }
    }
}
