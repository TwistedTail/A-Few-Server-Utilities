
local Types = {
	Normal = {
		Prefix = "",
		Color = Color(80, 255, 80)
	},
	Info = {
		Prefix = " - Info",
		Color = Color(0, 233, 255)
	},
	Warning = {
		Prefix = " - Warning",
		Color = Color(255, 160, 0)
	},
	Error = {
		Prefix = " - Error",
		Color = Color(255, 80, 80)
	}
}

function AFSU.PrintToChat(Type, ...)
	if not ... then return end

	local Data = Types[Type or "Normal"] or Types.Normal
	local Prefix = "[AFSU" .. Data.Prefix .. "] "
	local Message = istable(...) and ... or { ... }

	MsgC(Data.Color, Prefix, color_white, unpack(Message))
	Msg("\n")
end
