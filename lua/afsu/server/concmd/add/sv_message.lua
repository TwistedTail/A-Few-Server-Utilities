
local SaveTableToFile = AFSU.SaveTableToFile
local SendMessage = AFSU.SendMessage

AFSU.NewAddCommand("server_message", function(Player, Name)
	if not Name then
		SendMessage(Player, "Error", "No name was entered!")
		return
	end

	local Messages = AFSU.ServerMessages

	Messages[#Messages + 1] = Name

	SendMessage(Player, "Info", "New server message '" .. Name .. "' added.")
	SaveTableToFile(AFSU.MessagesFile, "ServerMessages")
end)
