local data = {
	{call = "waitSceneLoadingEnd"},
	{call = "wait", time=300},
	{call = "closeOtherWindow"},
	{call = "wait", time=10},
	{call = "openNPCLayer", auto=1,npc_name="",content=930030004},
	{call = "checkLayerType", layer_type=MainSceneType.MISSION, r_beg=1, r_end=2},
	{call = "findSpriteByFileName", plist="ccbi-res/main-scene-lang.plist",getParent=1,file="main-scene/spr-skin.png"},
	{call = "createMask"},
	{call = "wait", time=300},
	{call = "findSpriteByFileName", plist="ccbi-res/slzm.plist",getParent=1,file="slzm/rcfb-1.png"},
	{call = "createMask", mask=false, falsifying = true},
	{call = "changeMainLayer", layer_type=MainSceneType.MISSION},
	{call = "wait", time=300},
	{call = "findSpriteByFileName", plist="ccbi-res/common-ui.plist",getParent=1,file="button/btn-green-1.png"},
	{call = "wait", time=500},
	{call = "createMask"},
}
return data