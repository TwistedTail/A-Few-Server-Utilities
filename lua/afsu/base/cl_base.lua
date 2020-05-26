
do -- Chat messages
	function AFSU.PrintToChat(Type, ...)
		if not ... then return end

		local Types = AFSU.MsgTypes
		local Data = Types[Type or "Normal"] or Types.Normal
		local Prefix = "[AFSU" .. Data.Prefix .. "] "
		local Message = istable(...) and ... or { ... }

		chat.AddText(Data.Color, Prefix, color_white, unpack(Message))
	end

	local PrintToChat = AFSU.PrintToChat

	net.Receive("AFSU_ChatMessage", function()
		local Type = net.ReadString()
		local Message = net.ReadTable()

		PrintToChat(Type, Message)
	end)
end

do -- Responses
	if not AFSU.Responses then AFSU.Responses = {} end

	local Responses = AFSU.Responses

	function AFSU.AddResponse(Name, Action)
		if not isstring(Name) then return end
		if not isfunction(Action) then return end

		Responses[Name] = Action
	end

	net.Receive("AFSU_SendResponse", function()
		local Name = net.ReadString()
		local Data = net.ReadString()
		local Action = Responses[Name]

		if Action then
			Action(AFSU.ToTable(Data))
		end
	end)
end