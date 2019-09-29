
local SendMessage = AFSU.SendMessage

AFSU.NewListCommand("loading_screen", function(Player)
	local Type, Message
	local Screens = AFSU.LoadingScreens

	if not next(Screens) then
		Type = "Info"
		Message = "No registered loading screen URLs!"
	else
		Type = "Normal"
		Message = "Listing " .. #Screens .. " registered loading screen URLs:"

		for _, V in ipairs(Screens) do
			Message = Message .. "\n » " .. V
		end
	end

	SendMessage(Player, Type, Message)
end)
