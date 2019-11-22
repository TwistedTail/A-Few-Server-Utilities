
local RestartConVar = CreateConVar("afsu_server_restart", "1", FCVAR_ARCHIVE)
local Restart = RestartConVar:GetBool()
local SendMessage = AFSU.SendMessage
local Humans = player.GetHumans

local function RestartServer()
	SendMessage(nil, "Info", "Restarting the server!")
	RunConsoleCommand("_restart")
end

local function RoutinaryRestart()
	if next(Humans()) then return end

	local UptimeDiff = AFSU.FirstRestartDelay - CurTime()
	local Delay = UptimeDiff > 0 and UptimeDiff or AFSU.RestartDelay

	timer.Create("AFSU Server Restart", Delay, 1, RestartServer)
end

local function PlayerRestart()
	timer.Simple(1, function()
		if next(Humans()) then return end

		timer.Create("AFSU Server Restart", AFSU.RestartDelay, 1, RestartServer)
	end)
end

local function StopRestart()
	timer.Remove("AFSU Server Restart")
end

local function Initialize()
	if Restart then
		RoutinaryRestart()

		hook.Add("PlayerInitialSpawn", "AFSU Player Connect", StopRestart)
		hook.Add("PlayerDisconnected", "AFSU Player Disconnect", PlayerRestart)
	end

	hook.Remove("Initialize", "AFSU Init Restart Server")
end

AFSU.NewToggleCommand("restart_server", function(Player)
	RestartConVar:SetBool(not Restart)

	SendMessage(Player, "Info", "Server restart toggled ", Restart and "ON" or "OFF", ".")
end)

cvars.AddChangeCallback("afsu_server_restart", function(_, _, New)
	Restart = tobool(New)

	if Restart then
		RoutinaryRestart()

		hook.Add("PlayerInitialSpawn", "AFSU Player Connect", StopRestart)
		hook.Add("PlayerDisconnected", "AFSU Player Disconnect", PlayerRestart)
	else
		StopRestart()

		hook.Remove("PlayerInitialSpawn", "AFSU Player Connect")
		hook.Remove("PlayerDisconnected", "AFSU Player Disconnect")
	end
end)

hook.Add("Initialize", "AFSU Init Restart Server", Initialize)
