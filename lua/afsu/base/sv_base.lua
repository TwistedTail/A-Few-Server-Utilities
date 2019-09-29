
local sub = string.sub
local upper = string.upper
local Commands = {
	add = {},
	remove = {},
	list = {},
	toggle = {}
}

local function UpperFirst(Word)
	return upper(sub(Word, 1, 1)) .. sub(Word, 2)
end

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

local function CheckFile(File)
	if not File then return false end

	if not file.Exists(AFSU.DataPath, "DATA") then
		file.CreateDir(AFSU.DataPath)

		return false
	end

	return file.Exists(File, "DATA")
end

util.AddNetworkString("AFSU_ChatMessage")

local function SendMessage(Player, Type, ...)
	if not ... then return end

	Type = Type or "Normal"

	local Message = istable(...) and ... or { ... }

	if IsValid(Player) then
		net.Start("AFSU_ChatMessage")
			net.WriteString(Type)
			net.WriteTable(Message)
		net.Send(Player)
	else
		AFSU.PrintToChat(Type, Message)
	end
end

AFSU.SendMessage = SendMessage

for K in pairs(Commands) do
	AFSU["New" .. UpperFirst(K) .. "Command"] = function(Name, Action)
		if not Name then return end
		if not Action then return end

		Commands[K][Name] = Action
	end
end

concommand.Add("afsu", function(Player, _, Args)
	if IsValid(Player) and not Player:IsSuperAdmin() then
		SendMessage(Player, "Error", "Acess denied!")
		return
	end

	local Action, Command = unpack(Args)

	if not Action or not Commands[Action] then
		SendMessage(Player, "Error", "The action '", Action or "" , "' is not valid!\n", ListActions())
		return
	end

	if not Command or not Commands[Action][Command] then
		SendMessage(Player, "Error", "The command '", Command or "", "' is not valid!\n", ListCommands(Action))
		return
	end

	Commands[Action][Command](Player, unpack(Args, 3))
end)

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
