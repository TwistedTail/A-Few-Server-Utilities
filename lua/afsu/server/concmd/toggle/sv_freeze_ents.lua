
local FreezeConVar = CreateConVar("afsu_freeze_ents", "1", FCVAR_ARCHIVE)
local FreezeEnts = FreezeConVar:GetBool()
local SendMessage = AFSU.SendMessage

local function FreezeEntity(Ent)
	if not IsValid(Ent) then return end
	if Ent:GetUnFreezable() then return end

	local Phys = Ent:GetPhysicsObject()

	if IsValid(Phys) then
		Phys:EnableMotion(false)
	end
end

local function SpawnedProp(_, _, Ent) FreezeEntity(Ent) end

local function SpawnedSENT(_, Ent) FreezeEntity(Ent) end

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

if FreezeEnts then
	hook.Add("PlayerSpawnedProp", "AFSU Freeze Props", SpawnedProp)
	hook.Add("PlayerSpawnedSENT", "AFSU Freeze SENTs", SpawnedSENT)
	hook.Add("PlayerSpawnedVehicle", "AFSU Freeze Vehicles", SpawnedSENT)
	hook.Add("PlayerSpawnedRagdoll", "AFSU Freeze Ragdolls", SpawnedRagdoll)
end

AFSU.NewToggleCommand("freeze_ents", function(Player)
	FreezeConVar:SetBool(not FreezeEnts)

	SendMessage(Player, "Info", "Entity freezing toggled ", FreezeEnts and "ON" or "OFF", ".")
end)

cvars.AddChangeCallback("afsu_freeze_ents", function()
	FreezeEnts = not FreezeEnts

	if FreezeEnts then
		hook.Add("PlayerSpawnedProp", "AFSU Freeze Props", SpawnedProp)
		hook.Add("PlayerSpawnedSENT", "AFSU Freeze SENTs", SpawnedSENT)
		hook.Add("PlayerSpawnedVehicle", "AFSU Freeze Vehicles", SpawnedSENT)
		hook.Add("PlayerSpawnedRagdoll", "AFSU Freeze Ragdolls", SpawnedRagdoll)
	else
		hook.Remove("PlayerSpawnedProp", "AFSU Freeze Props")
		hook.Remove("PlayerSpawnedSENT", "AFSU Freeze SENTs")
		hook.Remove("PlayerSpawnedVehicle", "AFSU Freeze Vehicles")
		hook.Remove("PlayerSpawnedRagdoll", "AFSU Freeze Ragdolls")
	end
end)
