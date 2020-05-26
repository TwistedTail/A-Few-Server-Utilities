-- Serverside Globals file

AFSU.HostNameDelay =		15 -- Interval in seconds between each server name change
AFSU.LoadScreenDelay =		60 -- Interval in seconds between each loading screen change
AFSU.RestartDelay =			300 -- Delay in seconds after the last player disconnected to restart the server
AFSU.FirstRestartDelay =	21600 -- Timer to automatically restart the server if nobody joins

AFSU.DataPath =				"a-few-server-utils/"
AFSU.NamesFile =			AFSU.DataPath .. "server-names.json"
AFSU.MessagesFile =			AFSU.DataPath .. "server-messages.json"
AFSU.LoadingScreenFile =	AFSU.DataPath .. "loading-screens.json"
AFSU.HostnamesFile =		AFSU.DataPath .. "hostnames.json"

AFSU.ServerNames =			AFSU.ServerNames or {}
AFSU.ServerMessages =		AFSU.ServerMessages or {}
AFSU.LoadingScreens =		AFSU.LoadingScreens or {}
AFSU.Hostnames =			AFSU.Hostnames or {}
