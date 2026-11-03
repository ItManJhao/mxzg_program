local data = {
	{call = "waitSceneLoadingEnd"},
	{call = "wait", time=300},
	{call = "closeOtherWindow"},
	{call = "wait", time=10},
	{call = "findNodeByName",name="main_chat"},
	{call = "setNodeVisible",visible=0},
	{call = "checkLayerType", layer_type=MainSceneType.MLT_BATTLE, r_beg=1, r_end=2},
	{call = "findSpriteByFileName", plist="ccbi-res/main-scene-lang.plist",getParent=1,file="main-scene-lang/spr-battle.png"},
	{call = "createMask"},
	{call = "wait", time=300},
	{call = "showMissionRewardOnScene"},
	{call = "openNPCLayer", auto=1,npc_name="Misa",content=930030050},	
	{call = "hideMissionRewardOnScene"},
	{call = "setSwallow", is_swallow_touch = false, finial=1},	
	{call = "wait", time=3000},
	{call = "setSwallow", is_swallow_touch = true, finial=1},	
}
return data