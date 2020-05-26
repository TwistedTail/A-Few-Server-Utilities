
local SaveTableToFile = AFSU.SaveTableToFile
local SendMessage = AFSU.SendMessage
local Screens = AFSU.LoadingScreens

AFSU.NewAddCommand("loading_screen", function(Player, URL)
	if not URL then
		SendMessage(Player, "Error", "No loading screen URL was entered!")
		return
	end

	Screens[#Screens + 1] = URL

	SendMessage(Player, "Info", "New loading screen URL '" .. URL .. "' added.")
	SaveTableToFile(AFSU.LoadingScreenFile, "LoadingScreens")
end, 2, true)
