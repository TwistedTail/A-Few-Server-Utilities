
local RestartConVar = CreateConVar("afsu_server_restart", "1", FCVAR_ARCHIVE)
local Restart = RestartConVar:GetBool()
local SendMessage = AFSU.SendMessage

local function RestartServer()
	SendMessage(nil, "Info", "Restarting the server!")
	RunConsoleCommand("_restart")
end

local function CancelRestart()
	if timer.Exists("AFSU Server Restart") then
		timer.Remove("AFSU Server Restart")
	end
end

local function BeginRestart(Delay)
	local Forced = isnumber(Delay)

	Delay = Forced and Delay or AFSU.RestartDelay

	timer.Simple(1, function()
		if Forced or not next(player.GetHumans()) then
			timer.Create("AFSU Server Restart", Delay, 1, RestartServer)
		end
	end)
end

local function Initialize()
	if Restart then
		BeginRestart(AFSU.FirstRestartDelay)

		hook.Add("PlayerInitialSpawn", "AFSU Player Connect", CancelRestart)
		hook.Add("PlayerDisconnected", "AFSU Player Disconnect", BeginRestart)
	end

	hook.Remove("Initialize", "AFSU Init Restart Server")
end

AFSU.NewToggleCommand("restart_server", function(Player)
	RestartConVar:SetBool(not Restart)

	SendMessage(Player, "Info", "Server restart toggled ", Restart and "ON" or "OFF", ".")
end)

cvars.AddChangeCallback("afsu_server_restart", function()
	Restart = not Restart

	if Restart then
		BeginRestart()

		hook.Add("PlayerInitialSpawn", "AFSU Player Connect", CancelRestart)
		hook.Add("PlayerDisconnected", "AFSU Player Disconnect", BeginRestart)
	else
		timer.Remove("AFSU Server Restart")

		hook.Remove("PlayerInitialSpawn", "AFSU Player Connect")
		hook.Remove("PlayerDisconnected", "AFSU Player Disconnect")
	end
end)

hook.Add("Initialize", "AFSU Init Restart Server", Initialize)
