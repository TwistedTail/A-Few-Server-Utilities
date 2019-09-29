
local SaveTableToFile = AFSU.SaveTableToFile
local SendMessage = AFSU.SendMessage

AFSU.NewAddCommand("loading_screen", function(Player, URL)
	if not URL then
		SendMessage(Player, "Error", "No URL was entered!")
		return
	end

	local Screens = AFSU.LoadingScreens

	Screens[#Screens + 1] = URL

	SendMessage(Player, "Info", "New loading screen URL '" .. URL .. "' added.")
	SaveTableToFile(AFSU.LoadingScreenFile, "LoadingScreens")
end)
