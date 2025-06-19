local AddOnName, KeystonePercentageHelper = ...

-- Define which dungeons are in the current season
KeystonePercentageHelper.TWW_3_DUNGEONS = {
    -- War Within dungeons
    [503] = true, -- AKCE
    [499] = true, -- PotSF
    [505] = true, -- TDB
    [525] = true, -- OFG (Operation: Floodgate)
    --[542] = true, -- EDAD (Eco-dome Al'dani) (Coming in 11.1.2)
    -- Shadowlands dungeons
    [391] = true, -- Tazavesh: Streets of Wonder
    [392] = true, -- Tazavesh: So'leah's Gambit
    [378] = true, -- Halls of Atonement
}