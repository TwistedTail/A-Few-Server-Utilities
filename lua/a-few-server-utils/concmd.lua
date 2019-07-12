-- Console Command definition file

local concommand = concommand
local hook = hook
local math = math

local FreezeEnts = true

local function FreezeEntity(Ent)
	if not IsValid(Ent) then return end
	if Ent:GetUnFreezable() then return end

	local Phys = Ent:GetPhysicsObject()

	if IsValid(Phys) then
		Phys:EnableMotion(false)
	end
end

local function SpawnedProp(_, _, Ent)
	FreezeEntity(Ent)
end

local function SpawnedSENT(_, Ent)
	FreezeEntity(Ent)
end

local function SpawnedRagdoll(_, _, Ent)
	if not IsValid(Ent) then return end
	if Ent:GetUnFreezable() then return end

	local Count = Ent:GetPhysicsObjectCount()

	if Count > 0 then
		for i = 0, Count - 1 do
			local Phys = Ent:GetPhysicsObjectNum(i)

			if IsValid(Phys) then
				Phys:EnableMotion(false)
			end
		end
	end
end

local function PrintActionMessage(Ply, Message, NoTitle)
	if not Message then return end

	if not NoTitle then
		Message = "[Server Utils] " .. Message
	end

	if IsValid(Ply) then
		Ply:ChatPrint(Message)
	else
		print(Message)
	end
end

local Commands = {
	toggle_freeze = function(Ply)
		if FreezeEnts then
			FreezeEnts = false

			hook.Remove("PlayerSpawnedProp", "AFSU Freeze Props")
			hook.Remove("PlayerSpawnedSENT", "AFSU Freeze SENTs")
			hook.Remove("PlayerSpawnedVehicle", "AFSU Freeze Vehicles")
			hook.Remove("PlayerSpawnedRagdoll", "AFSU Freeze Ragdolls")
		else
			FreezeEnts = true

			hook.Add("PlayerSpawnedProp", "AFSU Freeze Props", SpawnedProp)
			hook.Add("PlayerSpawnedSENT", "AFSU Freeze SENTs", SpawnedSENT)
			hook.Add("PlayerSpawnedVehicle", "AFSU Freeze Vehicles", SpawnedSENT)
			hook.Add("PlayerSpawnedRagdoll", "AFSU Freeze Ragdolls", SpawnedRagdoll)
		end

		PrintActionMessage(Ply, "Toggled entity freezing " .. (FreezeEnts and "ON" or "OFF"))
	end,
	add_servername = function(Ply, Args)
		if not Args[2] then
			PrintActionMessage(Ply, "Remember to write the new server name you want to add.")
			return
		end

		local Count = #AFSU.ServerNames + 1
		local NewName = tostring(Args[2])

		AFSU.ServerNames[Count] = NewName

		PrintActionMessage(Ply, "New server name " .. NewName .. " added.")
		AFSU.SaveTableToFile(AFSU.NamesFile, "ServerNames")
	end,
	add_servermessage = function(Ply, Args)
		if not Args[2] then
			PrintActionMessage(Ply, "Remember to write the new server message you want to add.")
			return
		end

		local Count = #AFSU.ServerMessages + 1
		local NewMessage = tostring(Args[2])

		AFSU.ServerMessages[Count] = NewMessage

		PrintActionMessage(Ply, "New server message " .. NewMessage .. " added.")
		AFSU.SaveTableToFile(AFSU.MessagesFile, "ServerMessages")
	end,
	list_servernames = function(Ply)
		local Left = #AFSU.ServerNames
		local Parts = 0

		PrintActionMessage(Ply, "Registered server names:")

		repeat
			local Message = ""
			local Amount = math.min(5, Left)

			for j = 1, Amount do
				local Index = (5 * Parts) + j
				local Current = AFSU.ServerNames[Index]

				Message = Message .. "\n\t" .. Index .. ".-\t " .. Current
			end

			Left = Left - Amount
			Parts = Parts + 1

			PrintActionMessage(Ply, Message, true)
		until Left <= 0
	end,
	list_servermessages = function(Ply)
		local Left = #AFSU.ServerMessages
		local Parts = 0

		PrintActionMessage(Ply, "Registered server messages:")

		repeat
			local Message = ""
			local Amount = math.min(5, Left)

			for j = 1, Amount do
				local Index = (5 * Parts) + j
				local Current = AFSU.ServerMessages[Index]

				Message = Message .. "\n\t" .. Index .. ".-\t " .. Current
			end

			Left = Left - Amount
			Parts = Parts + 1

			PrintActionMessage(Ply, Message, true)
		until Left <= 0
	end,

}

concommand.Add("afsu", function(Ply, _, Args)
	if IsValid(Ply) and not Ply:IsSuperAdmin() then
		Ply:ChatPrint("[Server Utils] Access denied.")
	end

	local Command = Args[1]

	if not Command or #Command < 1 then return
		PrintActionMessage(Ply, "Please input a valid command.")
	end

	if not Commands[Command] then return
		PrintActionMessage(Ply, "Command " .. Command .. " doesn't exist.")
	end

	Commands[Command](Ply, Args)
end)

hook.Add("PlayerSpawnedProp", "AFSU Freeze Props", SpawnedProp)
hook.Add("PlayerSpawnedSENT", "AFSU Freeze SENTs", SpawnedSENT)
hook.Add("PlayerSpawnedVehicle", "AFSU Freeze Vehicles", SpawnedSENT)
hook.Add("PlayerSpawnedRagdoll", "AFSU Freeze Ragdolls", SpawnedRagdoll)

print("[Server Utils] Loaded Console Commands successfully.")