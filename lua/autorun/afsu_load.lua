-- A Few Server Utilities load

MsgN("\n» Loading A Few Server Utils")

local Root = "afsu"

if not AFSU then AFSU = {} end

if SERVER then

	-- Taken from Stooberton's PSA loader
	local function Load(Path)
		local Files, Directories = file.Find(Path .. "/*", "LUA")

		for _, File in ipairs(Files) do
			local Sub = string.sub(File, 1, 3)

			File = Path .. "/" .. File

			if Sub == "cl_" then
				MsgN(" » " .. File)
				AddCSLuaFile(File)
			elseif Sub == "sv_" then
				MsgN(" » " .. File)
				include(File)
			else
				MsgN(" » " .. File)
				include(File)
				AddCSLuaFile(File)
			end
		end

		for _, Directory in ipairs(Directories) do
			Load(Path .. "/" .. Directory)
		end
	end

	Load(Root)

elseif CLIENT then

	-- Taken from Stooberton's PSA loader
	local function Load(Path)
		local Files, Directories = file.Find(Path .. "/*", "LUA")

		for _, File in ipairs(Files) do
			File = Path .. "/" .. File
			MsgN(" » " .. File)
			include(File)
		end

		for _, Directory in ipairs(Directories) do
			Load(Path .. "/" .. Directory)
		end
	end

	Load(Root)

end

MsgN("» Loaded!\n")
