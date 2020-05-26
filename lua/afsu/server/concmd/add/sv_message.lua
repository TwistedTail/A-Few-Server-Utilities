
local SaveTableToFile = AFSU.SaveTableToFile
local SendMessage = AFSU.SendMessage
local Messages = AFSU.ServerMessages

AFSU.NewAddCommand("server_message", function(Player, Name)
	if not Name then
		SendMessage(Player, "Error", "No server message was entered!")
		return
	end

	Messages[#Messages + 1] = Name

	SendMessage(Player, "Info", "New server message '" .. Name .. "' added.")
	SaveTableToFile(AFSU.MessagesFile, "ServerMessages")
end, 2, true)
