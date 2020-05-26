
-- Since redirections were banned, this is the best method I could come up with
AFSU.AddResponse("Connect", function(Data)
	gui.OpenURL("https://connect.kryptonnetworks.co.uk/" .. Data.IP)
end)
