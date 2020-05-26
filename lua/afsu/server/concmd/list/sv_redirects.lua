
local SendMessage = AFSU.SendMessage
local Hosts = AFSU.Hostnames

AFSU.NewListCommand("server_redirect", function(Player)
	local Type = "Info"
	local Message = "No redirect servers have been registered!"

	if next(Hosts) then
		Type = "Normal"
		Message = "Listing " .. #Hosts .. " redirect servers:"

		for _, V in ipairs(Hosts) do
			Message = Message .. "\n » " .. V.Name .. " = " .. V.Address
		end
	end

	SendMessage(Player, Type, Message)
end, 0, true)
