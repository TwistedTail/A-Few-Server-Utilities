
local SendMessage = AFSU.SendMessage

AFSU.NewListCommand("server_message", function(Player)
	local Type, Message
	local Messages = AFSU.ServerMessages

	if not next(Messages) then
		Type = "Info"
		Message = "No registered server messages!"
	else
		Type = "Normal"
		Message = "Listing " .. #Messages .. " registered server messages:"

		for _, V in ipairs(Messages) do
			Message = Message .. "\n » " .. V
		end
	end

	SendMessage(Player, Type, Message)
end)
