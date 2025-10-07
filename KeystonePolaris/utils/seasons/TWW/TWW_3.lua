local AddOnName, KeystonePolaris = ...

-- Define which dungeons are in the current season
KeystonePolaris.TWW_3_DUNGEONS = {
    -- War Within dungeons
    [503] = true, -- AKCE (Ara-Kara, City of Echoes)
    [499] = true, -- PotSF (Priory of the Sacred Flame)
    [505] = true, -- TDB (The Dawnbreaker)
    [525] = true, -- OFG (Operation: Floodgate)
    [542] = true, -- EDAD (Eco-dome Al'dani) (Coming in 11.2)
    -- Shadowlands dungeons
    [391] = true, -- TSoW (Tazavesh: Streets of Wonder)
    [392] = true, -- TSLG (Tazavesh: So'leah's Gambit)
    [378] = true, -- HoA (Halls of Atonement)
}