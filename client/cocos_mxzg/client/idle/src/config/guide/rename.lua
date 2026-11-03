local data = {
	{call = "waitSceneLoadingEnd"},
	{call = "checkFile", check_type="rename", r_beg=0, r_end= 999},
	{call = "wait", time=1},
	{call = "findNodeByName",name="main_chat"},
	{call = "setNodeVisible",visible=0},
	{call = "clearBattle"},
	{call = "updateMainBattle"},
	{call = "openNPCLayer", auto=1,music="music/guide002.mp3",npc_name="",content=930030024},
	{call = "openWindow", file = "src.layer.RenameCtr"},
	-- {call = "openNPCLayer", auto=1,npc_name="",content="来自异次元的你，顺着神明的指示，一定能再度让艾尼亚大陆恢复繁荣！"},
	-- {call = "openNPCLayer", auto=1,npc_name="Misa",content="唔，忘了自我介绍，我叫Misa！你呢你呢，快告诉我你的名字吧~"},
	{call = "setSwallow", is_swallow_touch = false},
	{call = "wait", time=1},
	{call = "addCloseWindowListen", next=false, step=999, ccbi_path="ccbi/RenameLayer.ccbi"},
	{call = "setSwallow", is_swallow_touch = true, finial=1},
	-- {call = "openNPCLayer", auto=1,music="music/guide002.mp3",npc_name="Misa",content="真是让人难忘的名字，很快，艾尼亚大陆一定会传遍它。"},
}
return data