
local ChangeConVar = CreateConVar("afsu_change_loading_screen", "1", FCVAR_ARCHIVE)
local ChangeScreen = ChangeConVar:GetBool()
local LoadFileToTable = AFSU.LoadFileToTable
local SendMessage = AFSU.SendMessage

local function ChangeLoadingScreen()
	if AFSU.LoadScreenDelay > 0 and next(AFSU.LoadingScreens) then
		local Index = math.random(1, #AFSU.LoadingScreens)
		local LoadingURL = AFSU.LoadingScreens[Index]

		RunConsoleCommand("sv_loadingurl", LoadingURL)
	end
end

local function Initialize()
	LoadFileToTable(AFSU.LoadingScreenFile, "LoadingScreens")

	if ChangeScreen then
		timer.Create("AFSU Loading Screen", AFSU.LoadScreenDelay, 0, ChangeLoadingScreen)
	end

	hook.Remove("Initialize", "AFSU Init Loading Screen Change")
end

AFSU.NewToggleCommand("change_loading_screen", function(Player)
	ChangeConVar:SetBool(not ChangeScreen)

	SendMessage(Player, "Info", "Loading screen change toggled ", ChangeScreen and "ON" or "OFF", ".")
end)

cvars.AddChangeCallback("afsu_change_loading_screen", function()
	ChangeScreen = not ChangeScreen

	if ChangeScreen then
		timer.Create("AFSU Loading Screen", AFSU.LoadScreenDelay, 0, ChangeLoadingScreen)
		ChangeLoadingScreen()
	else
		timer.Remove("AFSU Loading Screen")
		RunConsoleCommand("sv_loadingurl", " ")
	end
end)

hook.Add("Initialize", "AFSU Init Loading Screen Change", Initialize)
