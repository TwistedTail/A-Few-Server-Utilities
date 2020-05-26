
local SaveTableToFile = AFSU.SaveTableToFile
local SendMessage = AFSU.SendMessage
local Names = AFSU.ServerNames

AFSU.NewAddCommand("server_name", function(Player, Name)
	if not Name then
		SendMessage(Player, "Error", "No server name was entered!")
		return
	end

	Names[#Names + 1] = Name

	SendMessage(Player, "Info", "New server name '" .. Name .. "' added.")
	SaveTableToFile(AFSU.NamesFile, "ServerNames")
end, 2, true)
