
local SendMessage = AFSU.SendMessage
local Names = AFSU.ServerNames

AFSU.NewListCommand("server_name", function(Player)
	local Type = "Info"
	local Message = "No server names have been registered!"

	if next(Names) then
		Type = "Normal"
		Message = "Listing " .. #Names .. " server names:"

		for _, V in ipairs(Names) do
			Message = Message .. "\n » " .. V
		end
	end

	SendMessage(Player, Type, Message)
end, 1, true)
