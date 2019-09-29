
local SaveTableToFile = AFSU.SaveTableToFile
local SendMessage = AFSU.SendMessage

AFSU.NewAddCommand("server_name", function(Player, Name)
	if not Name then
		SendMessage(Player, "Error", "No name was entered!")
		return
	end

	local Names = AFSU.ServerNames

	Names[#Names + 1] = Name

	SendMessage(Player, "Info", "New server name '" .. Name .. "' added.")
	SaveTableToFile(AFSU.NamesFile, "ServerNames")
end)
