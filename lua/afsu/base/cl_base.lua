
net.Receive("AFSU_ChatMessage", function()
	local Type = net.ReadString()
	local Message = net.ReadTable()

	AFSU.PrintToChat(Type, Message)
end)
