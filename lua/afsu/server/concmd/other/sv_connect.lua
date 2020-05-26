
local LoadFileToTable = AFSU.LoadFileToTable
local UpdateLookup = AFSU.GetLookupTable
local GetLookup = AFSU.GetLookupTable
local SendMessage = AFSU.SendMessage
local Response = AFSU.SendResponse

AFSU.RegisterSingleCommand("connect", function(Player, Name)
	if not IsValid(Player) then
		SendMessage(Player, "Error", "This command can't be used via console!")
		return
	end

	if not Name then
		SendMessage(Player, "Error", "No server name was entered!")
		Response(Player, "ConCommand", { "afsu", "list", "server_redirect" })
		return
	end

	local Hosts = GetLookup("Hostnames", "Name")
	local Data = Hosts[Name]

	if not Data then
		SendMessage(Player, "Error", "The server '" .. Name .. "' is not registered!")
		Response(Player, "ConCommand", { "afsu", "list", "server_redirect" })
		return
	end

	SendMessage(Player, "Info", "Redirecting you to " .. Data.Address .. "...")

	timer.Simple(1, function() Response(Player, "Connect", { IP = Data.Address }) end)
end, 0)

hook.Add("Initialize", "AFSU Redirect Init", function()
	LoadFileToTable(AFSU.HostnamesFile, "Hostnames")
	UpdateLookup("Hostnames", "Name", true)

	hook.Remove("Initialize", "AFSU Redirect Init")
end)
