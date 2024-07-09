local AFSU       = AFSU
local ConsoleVar = CreateConVar("afsu_allow_family_share", "1", FCVAR_ARCHIVE)
local Allowed    = ConsoleVar:GetBool()

local function PlayerAuthed(Player)
    if Player:OwnerSteamID64() == Player:SteamID64() then return end

    Player:Kick("Family Shared accounts are not allowed, please rejoin with the account that owns the game")
end

local function Initialize()
    if not Allowed then
        hook.Add("PlayerAuthed", "AFSU Family Share", PlayerAuthed)
    end

    hook.Remove("Initialize", "AFSU Family Share")
end

AFSU.NewToggleCommand("allow_family_share", function(Player)
    local Toggled = not Allowed

    ConsoleVar:SetBool(Toggled)

    AFSU.SendMessage(Player, "Info", "Family Share protection toggled ", Toggled and "ON" or "OFF", ".")
end)

cvars.AddChangeCallback("afsu_allow_family_share", function(_, _, New)
    Allowed = tobool(New)

    if Allowed then
        hook.Remove("PlayerAuthed", "AFSU Family Share")
    else
        hook.Add("PlayerAuthed", "AFSU Family Share", PlayerAuthed)
    end
end)

hook.Add("Initialize", "AFSU Family Share", Initialize)
