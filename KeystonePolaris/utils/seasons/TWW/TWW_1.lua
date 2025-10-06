local AddOnName, KeystonePolaris = ...

-- Define which dungeons are in the current season
KeystonePolaris.TWW_1_DUNGEONS = {
    -- War Within dungeons
    [503] = true, -- AKCE (Ara-Kara, City of Echoes)
    [502] = true, -- CoT (City of Threads)
    [505] = true, -- TDB (The Dawnbreaker)
    [501] = true, -- TSV (The Stonevault)
    -- Shadowlands dungeons
    [375] = true, -- MoTS (Mists of Tirna Scithe)
    [376] = true, -- NW (Necrotic Wake)
    -- BFA dungeons
    [353] = true, -- SoB (Siege of Boralus)
    -- Cataclysm dungeons
    [507] = true, -- GB (Grim Batol)
}