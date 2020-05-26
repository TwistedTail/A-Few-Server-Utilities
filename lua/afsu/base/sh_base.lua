
AFSU.MsgTypes = {
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

do -- Console printing
	local Types = AFSU.MsgTypes

	function AFSU.PrintToConsole(Type, ...)
		if not ... then return end

		local Data = Types[Type or "Normal"] or Types.Normal
		local Prefix = "[AFSU" .. Data.Prefix .. "] "
		local Message = istable(...) and ... or { ... }

		Message[#Message + 1] = "\n"

		MsgC(Data.Color, Prefix, color_white, unpack(Message))
	end
end

do -- Data table conversion
	local ToJSON, ToTable = util.TableToJSON, util.JSONToTable

	function AFSU.ToJSON(Table)
		if not istable(Table) then return end

		return ToJSON(Table)
	end

	function AFSU.ToTable(String)
		if not isstring(String) then return end

		return ToTable(String)
	end
end

do -- Lookup table creation
	AFSU.Lookup = AFSU.Lookup or {}

	local Lookup = AFSU.Lookup

	function AFSU.GetLookupTable(Name, NameKey, ForceUpdate)
		if ForceUpdate or not Lookup[Name] then
			local Table = Lookup[Name] or {}

			if next(Table) then
				for K in pairs(Table) do Table[K] = nil end
			end

			for Index, Data in pairs(AFSU[Name]) do
				local Key = Data[NameKey]

				Table[Key] = Data

				Data.Index = Index
			end

			Lookup[Name] = Table
		end

		return Lookup[Name]
	end
end
