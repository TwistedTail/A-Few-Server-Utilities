
if not AFSU.Commands then
	AFSU.Commands = {
		add = {},
		remove = {},
		list = {},
		toggle = {}
	}
end

do -- Message networking
	util.AddNetworkString("AFSU_ChatMessage")

	function AFSU.SendMessage(Player, Type, ...)
		if not ... then return end

		Type = Type or "Normal"

		local Message = istable(...) and ... or { ... }

		if IsValid(Player) then
			net.Start("AFSU_ChatMessage")
				net.WriteString(Type)
				net.WriteTable(Message)
			net.Send(Player)
		else
			AFSU.PrintToConsole(Type, Message)
		end
	end
end

do -- Response networking
	util.AddNetworkString("AFSU_SendResponse")

	function AFSU.SendResponse(Player, Action, Data)
		if not IsValid(Player) then return end
		if not isstring(Action) then return end
		if not istable(Data) then return end

		net.Start("AFSU_SendResponse")
			net.WriteString(Action)
			net.WriteString(AFSU.ToJSON(Data))
		net.Send(Player)
	end
end

do -- Command registration
	local sub = string.sub
	local upper = string.upper
	local Commands = AFSU.Commands
	local NoChild = {}
	local Default = {
		add = true,
		remove = true,
		list = true,
		toggle = true
	}

	local function UpperFirst(Word)
		return upper(sub(Word, 1, 1)) .. sub(Word, 2)
	end

	for K in pairs(Default) do
		AFSU["New" .. UpperFirst(K) .. "Command"] = function(Name, Action, PermsMode, HideChat)
			if not isstring(Name) then return end
			if not isfunction(Action) then return end

			Name = Name:lower()

			Commands[K][Name] = {
				Action = Action,
				Mode = PermsMode or 2,
				HideChat = HideChat or false,
			}
		end
	end

	function AFSU.RegisterSingleCommand(Name, Action, PermsMode, HideChat)
		if not isstring(Name) then return end
		if not isfunction(Action) then return end

		Name = Name:lower()

		if Default[Name] then return end

		NoChild[Name] = true
		Commands[Name] = {
			Action = Action,
			Mode = PermsMode or 2,
			HideChat = HideChat or false,
			NoChild = true,
		}
	end

	function AFSU.RegisterCommand(Command, Name, Action, PermsMode, HideChat)
		if not isstring(Command) then return end
		if not isstring(Name) then return end
		if not isfunction(Action) then return end

		Command = Command:lower()
		Name = Name:lower()

		if NoChild[Command] then return end

		Commands[Name] = {
			Action = Action,
			Mode = PermsMode or 2,
			HideChat = HideChat or false,
		}
	end
end

do -- Command calling
	local Explode = string.Explode
	local Commands = AFSU.Commands
	local SendMessage = AFSU.SendMessage

	local function ListActions()
		local Result = "Available actions:"

		for K, V in pairs(Commands) do
			if next(V) then
				Result = Result .. "\n » " .. K
			end
		end

		return Result
	end

	local function ListCommands(Action)
		local Data = Commands[Action]
		local Result

		if not next(Data) then
			Result = "This action has no available commands!"
		else
			Result = "Available commands:"

			for K in pairs(Data) do
				Result = Result .. "\n » " .. K
			end
		end

		return Result
	end

	local function HasAccess(Player, Mode)
		if not IsValid(Player) then return true end -- Console
		if Mode >= 2 and Player:IsSuperAdmin() then return true end
		if Mode == 1 and Player:IsAdmin() then return true end

		return Mode <= 0
	end

	local function GetCommandData(Player, Action, Command)
		local Data = Action and Commands[Action]
		local Single = true

		if not Data then
			SendMessage(Player, "Error", "The action '", Action or "" , "' is not valid!\n", ListActions())
			return
		end

		if not Data.NoChild then
			Data = Command and Commands[Action][Command]
			Single = false

			if not Data then
				SendMessage(Player, "Error", "The command '", Command or "", "' is not valid!\n", ListCommands(Action))
				return
			end
		end

		if not HasAccess(Player, Data.Mode) then
			SendMessage(Player, "Error", "Acess denied!")
			return
		end

		return Data, Single
	end

	concommand.Add("afsu", function(Player, _, Args)
		local Action, Command = unpack(Args)
		local Data, Single = GetCommandData(Player, Action, Command)

		if not Data then return end

		Data.Action(Player, unpack(Args, Single and 2 or 3))
	end)

	hook.Add("PlayerSay", "AFSU Chat Commands", function(Player, Text)
		local Message = Explode(" ", Text)
		local Prefix, Action, Command = unpack(Message, 1, 3)

		if Prefix:lower() ~= "!afsu" then return end -- Not a command for us

		local Data, Single = GetCommandData(Player, Action, Command)

		if not Data then return end

		Data.Action(Player, unpack(Message, Single and 3 or 4))

		if Data.HideChat then return "" end
	end)
end

do -- File saving and loading
	local function CheckFile(File)
		if not File then return false end

		if not file.Exists(AFSU.DataPath, "DATA") then
			file.CreateDir(AFSU.DataPath)

			return false
		end

		return file.Exists(File, "DATA")
	end

	function AFSU.LoadFileToTable(File, Name)
		if not CheckFile(File) then return end
		if not AFSU[Name] then return end

		AFSU[Name] = util.JSONToTable(file.Read(File))
	end

	function AFSU.SaveTableToFile(File, Name)
		if not File then return end
		if not AFSU[Name] then return end
		if not next(AFSU[Name]) then return end

		file.Write(File, util.TableToJSON(AFSU[Name], true))
	end
end
