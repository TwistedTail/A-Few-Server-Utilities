
local SendMessage = AFSU.SendMessage

AFSU.NewListCommand("server_name", function(Player)
	local Type, Message
	local Names = AFSU.ServerNames

	if not next(Names) then
		Type = "Info"
		Message = "No registered server names!"
	else
		Type = "Normal"
		Message = "Listing " .. #Names .. " registered server names:"

		for _, V in ipairs(Names) do
			Message = Message .. "\n » " .. V
		end
	end

	SendMessage(Player, Type, Message)
end)
