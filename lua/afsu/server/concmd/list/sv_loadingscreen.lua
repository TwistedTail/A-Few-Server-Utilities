
local SendMessage = AFSU.SendMessage
local Screens = AFSU.LoadingScreens

AFSU.NewListCommand("loading_screen", function(Player)
	local Type = "Info"
	local Message = "No loading screens have been registered!"

	if next(Screens) then
		Type = "Normal"
		Message = "Listing " .. #Screens .. " loading screens:"

		for _, V in ipairs(Screens) do
			Message = Message .. "\n » " .. V
		end
	end

	SendMessage(Player, Type, Message)
end, 1, true)
