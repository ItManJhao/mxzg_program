local data = {
	{call = "waitSceneLoadingEnd"},
	{call = "wait", time=300},
	{call = "closeOtherWindow"},
	{call = "wait", time=10},
	{call = "openNPCLayer", auto=1,npc_name="",content=930030001},
	{call = "openNPCLayer", auto=1,npc_name="",content=930030002},
	{call = "checkLayerType", layer_type=MainSceneType.CLAN, r_beg=1, r_end=2},
	{call = "findSpriteByFileName", plist="ccbi-res/main-scene-lang.plist",getParent=1,file="main-scene/spr-clan.png"},
	{call = "createMask"},
	{call = "openNPCLayer", auto=1,npc_name="",content=930030003},
}
return data
