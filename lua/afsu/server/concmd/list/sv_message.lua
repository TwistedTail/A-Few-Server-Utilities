
local SendMessage = AFSU.SendMessage
local Messages = AFSU.ServerMessages

AFSU.NewListCommand("server_message", function(Player)
	local Type = "Info"
	local Message = "No server messages have been registered!"

	if next(Messages) then
		Type = "Normal"
		Message = "Listing " .. #Messages .. " server messages:"

		for _, V in ipairs(Messages) do
			Message = Message .. "\n » " .. V
		end
	end

	SendMessage(Player, Type, Message)
end, 1, true)
