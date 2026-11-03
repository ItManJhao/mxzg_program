local data = {
	{call = "waitSceneLoadingEnd"},
	{call = "wait", time=300},
	{call = "closeOtherWindow"},
	{call = "wait", time=10},
	-- {call = "wait", time=1, finial=1},
	{call = "findNodeByName",name="main_chat"},
	{call = "setNodeVisible",visible=0},
	{call = "openWindow", file = "src.layer.promotion.CreateNickRewardCtrl"},
	{call = "wait", time=300},
	{call = "findNodeByName",name="btn_name"},
	{call = "createMask",mask=false},
	{call = "waitRecv", protocol=2016},
	{call = "wait", time=3000, finial=1},
	-- {call = "findSpriteByFileName",plist="ccbi-res/common-ui.plist",file="win-bg/close-tips.png", extend_x=2500, extend_y = 2500},
	-- {call = "createMask",mask=false},
}
return data