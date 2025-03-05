local AddOnName, KeystonePercentageHelper = ...

-- Define a single source of truth for dungeon data
KeystonePercentageHelper.CATACLYSM_DUNGEON_DATA = {
    -- Format: [shortName] = {id = dungeonID, bosses = {{bossID, percent, shouldInform}, ...}}
    GB = {
        id = 507,
        bosses = {
            {1, 39.68, false},
            {2, 45.83, false},
            {3, 81.26, true},
            {4, 100, true}
        }
    }
}
