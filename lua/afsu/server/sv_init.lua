-- Serverside Initialization file

local function Initialize()
	RunConsoleCommand("sv_hibernate_think", "1")
end

hook.Add("Initialize", "AFSU Initialize", Initialize)
