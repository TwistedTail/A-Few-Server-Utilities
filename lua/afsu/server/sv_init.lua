-- Serverside Initialization file

local file = file
local hook = hook
local math = math
local player = player
local timer = timer
local util = util

local function CheckFile(File)
	if not file.Exists(AFSU.DataPath, "DATA") then
		file.CreateDir(AFSU.DataPath)

		return false
	end

	return file.Exists(File, "DATA")
end

local function LoadFileToTable(File, Name)
	if not CheckFile(File) then return end
	if not AFSU[Name] then return end

	AFSU[Name] = util.JSONToTable(file.Read(File))
end

local function SaveTableToFile(File, Name)
	if not AFSU[Name] then return end
	if not next(AFSU[Name]) then return end

	file.Write(File, util.TableToJSON(AFSU[Name], true))
end

local function ChangeHostName()
	if AFSU.HostNameDelay > 0 then
		if not AFSU.HostName then
			AFSU.HostName = GetHostName()
		end

		local HostName
		local Message

		if next(AFSU.ServerNames) then
			local Index = math.random(1, #AFSU.ServerNames)

			HostName = AFSU.ServerNames[Index]
		end

		if next(AFSU.ServerMessages) then
			local Index = math.random(1, #AFSU.ServerMessages)

			Message = " - " .. AFSU.ServerMessages[Index]
		end

		if HostName or Message then
			RunConsoleCommand("hostname", (HostName or AFSU.HostName) .. (Message or ""))
		end
	end
end

local function ChangeLoadingScreen()
	if AFSU.LoadScreenDelay > 0 and next(AFSU.LoadingScreens) then
		local Index = math.random(1, #AFSU.LoadingScreens)
		local LoadingURL = AFSU.LoadingScreens[Index]

		RunConsoleCommand("sv_loadingurl", LoadingURL)
	end
end

local function RestartServer()
	print("[Server Utils] Restarting the server.")
	RunConsoleCommand("_restart")
end

local function PlayerConnect()
	if timer.Exists("AFSU Server Restart") then
		timer.Remove("AFSU Server Restart")
	end
end

local function PlayerDisconnect()
	timer.Simple(1, function()
		if not next(player.GetHumans()) then
			timer.Create("AFSU Server Restart", AFSU.RestartDelay, 1, RestartServer)
		end
	end)
end

local function InitServerFiles()
	LoadFileToTable(AFSU.NamesFile, "ServerNames")
	LoadFileToTable(AFSU.MessagesFile, "ServerMessages")
	LoadFileToTable(AFSU.LoadingScreenFile, "LoadingScreens")

	RunConsoleCommand("sv_hibernate_think", "1")

	timer.Create("AFSU Server Name", AFSU.HostNameDelay, 0, ChangeHostName)
	timer.Create("AFSU Loading Screen", AFSU.LoadScreenDelay, 0, ChangeLoadingScreen)

	hook.Remove("Initialize", "AFSU Initialize")
end

hook.Add("Initialize", "AFSU Initialize", InitServerFiles)
hook.Add("PlayerInitialSpawn", "AFSU Player Connect", PlayerConnect)
hook.Add("PlayerDisconnected", "AFSU Player Disconnect", PlayerDisconnect)

AFSU.SaveTableToFile = SaveTableToFile
