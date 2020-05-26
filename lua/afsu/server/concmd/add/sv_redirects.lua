
local Message = "New server '%s' (%s) has been added"
local SaveTableToFile = AFSU.SaveTableToFile
local UpdateLookup = AFSU.GetLookupTable
local SendMessage = AFSU.SendMessage
local Hosts = AFSU.Hostnames

AFSU.NewAddCommand("server_redirect", function(Player, Name, IP)
	if not Name then
		SendMessage(Player, "Error", "No server name was entered!")
		SendMessage(Player, "Info", "Usage: afsu add server_redirect <Name> <IP>")
		return
	end

	if not IP then
		SendMessage(Player, "Error", "No server IP was entered!")
		SendMessage(Player, "Info", "Usage: afsu add server_redirect <Name> <IP>")
		return
	end

	Hosts[#Hosts + 1] = {
		Name = Name:lower(),
		Address = IP,
	}

	SendMessage(Player, "Info", Message:format(Name, IP))
	SaveTableToFile(AFSU.HostnamesFile, "Hostnames")
	UpdateLookup("Hostnames", "Name", true)
end, 2, true)
