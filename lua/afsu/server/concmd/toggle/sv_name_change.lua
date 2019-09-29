
local ChangeConVar = CreateConVar("afsu_change_hostname", "1", FCVAR_ARCHIVE)
local ChangeName = ChangeConVar:GetBool()
local LoadFileToTable = AFSU.LoadFileToTable
local SendMessage = AFSU.SendMessage

local function ChangeHostName()
	if AFSU.HostNameDelay > 0 then
		local HostName, Message

		if not AFSU.HostName then
			AFSU.HostName = GetHostName()
		end

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

local function Initialize()
	LoadFileToTable(AFSU.NamesFile, "ServerNames")
	LoadFileToTable(AFSU.MessagesFile, "ServerMessages")

	if ChangeName then
		timer.Create("AFSU Server Name", AFSU.HostNameDelay, 0, ChangeHostName)
	end

	hook.Remove("Initialize", "AFSU Init Hostname Change")
end

AFSU.NewToggleCommand("change_hostname", function(Player)
	ChangeConVar:SetBool(not ChangeName)

	SendMessage(Player, "Info", "Hostname change toggled ", ChangeName and "ON" or "OFF", ".")
end)

cvars.AddChangeCallback("afsu_change_hostname", function()
	ChangeName = not ChangeName

	if ChangeName then
		timer.Create("AFSU Server Name", AFSU.HostNameDelay, 0, ChangeHostName)
		ChangeHostName()
	else
		timer.Remove("AFSU Server Name")
		RunConsoleCommand("hostname", AFSU.HostName)
	end
end)

hook.Add("Initialize", "AFSU Init Hostname Change", Initialize)
