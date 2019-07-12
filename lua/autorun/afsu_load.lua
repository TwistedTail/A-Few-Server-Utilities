-- A Few Server Utilities load

if SERVER then
	AFSU = AFSU or {}
	AFSU.ChangeDelay = 15	-- Interval in seconds between each server name change
	AFSU.RestartDelay = 300	-- Delay in seconds after the last player disconnected to restart the server

	include("a-few-server-utils/sv_init.lua")
	include("a-few-server-utils/concmd.lua")
end