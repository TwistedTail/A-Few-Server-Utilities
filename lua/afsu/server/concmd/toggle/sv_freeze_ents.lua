
local FreezeConVar = CreateConVar("afsu_freeze_ents", "1", FCVAR_ARCHIVE)
local FreezeEnts = FreezeConVar:GetBool()
local SendMessage = AFSU.SendMessage

local function RagdollMotion(Ent, Enabled)
	if not IsValid(Ent) then return end
	if not Enabled and Ent:GetUnFreezable() then return end

	local Count = Ent:GetPhysicsObjectCount()

	if Count > 0 then
		for i = 0, Count - 1 do
			local Phys = Ent:GetPhysicsObjectNum(i)

			if IsValid(Phys) then
				Phys:EnableMotion(Enabled)
			end
		end
	end
end

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

local function SpawnedRagdoll(_, _, Ent) RagdollMotion(Ent, false) end

local PhysgunEnts = {}
local function PhysgunPickup(Player, Ent)
	if Ent:GetClass() == "prop_ragdoll" then
		PhysgunEnts[Player] = Ent
	end
end

local function PhysgunDrop(Player)
	if PhysgunEnts[Player] then
		PhysgunEnts[Player] = nil
	end
end

local function PhysgunReload(_, Player)
	if PhysgunEnts[Player] then
		RagdollMotion(PhysgunEnts[Player], true)
	end
end

local function AddHooks()
	hook.Add("PlayerSpawnedProp", "AFSU Freeze Props", SpawnedProp)
	hook.Add("PlayerSpawnedSENT", "AFSU Freeze SENTs", SpawnedSENT)
	hook.Add("PlayerSpawnedVehicle", "AFSU Freeze Vehicles", SpawnedSENT)
	hook.Add("PlayerSpawnedRagdoll", "AFSU Freeze Ragdolls", SpawnedRagdoll)
	hook.Add("OnPhysgunPickup", "AFSU Physgun Pickup", PhysgunPickup)
	hook.Add("PhysgunDrop", "AFSU Physgun Drop", PhysgunDrop)
	hook.Add("OnPhysgunReload", "AFSU PhysgunReload", PhysgunReload)
end

local function RemoveHooks()
	hook.Remove("PlayerSpawnedProp", "AFSU Freeze Props")
	hook.Remove("PlayerSpawnedSENT", "AFSU Freeze SENTs")
	hook.Remove("PlayerSpawnedVehicle", "AFSU Freeze Vehicles")
	hook.Remove("PlayerSpawnedRagdoll", "AFSU Freeze Ragdolls")
	hook.Remove("OnPhysgunPickup", "AFSU Physgun Pickup")
	hook.Remove("PhysgunDrop", "AFSU Physgun Drop")
	hook.Remove("OnPhysgunReload", "AFSU PhysgunReload")
end

local function Initialize()
	if FreezeEnts then
		AddHooks()
	end

	hook.Remove("Initialize", "AFSU Init Freeze Ents")
end

AFSU.NewToggleCommand("freeze_ents", function(Player)
	FreezeConVar:SetBool(not FreezeEnts)

	SendMessage(Player, "Info", "Entity freezing toggled ", FreezeEnts and "ON" or "OFF", ".")
end)

cvars.AddChangeCallback("afsu_freeze_ents", function(_, _, New)
	FreezeEnts = tobool(New)

	if FreezeEnts then
		AddHooks()
	else
		RemoveHooks()
	end
end)

hook.Add("Initialize", "AFSU Init Freeze Ents", Initialize)
