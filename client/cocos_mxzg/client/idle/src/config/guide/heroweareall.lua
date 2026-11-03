local data = {
	-- 检查是否穿戴了装备
	{call = "waitSceneLoadingEnd"},
	{call = "wait", time=300},
	{call = "closeOtherWindow"},
	{call = "wait", time=10},
	{call = "findNodeByName",name="main_chat"},
	{call = "setNodeVisible",visible=0},
	{call = "checkLayerType", layer_type=MainSceneType.HERO_INFO_LAYER, r_beg=1, r_end=6},
	{call = "findSpriteByFileName", plist="ccbi-res/main-scene-lang.plist",getParent=1,file="main-scene-lang/spr-hero.png"},
	{call = "createMask"},
	{call = "wait", time=300},
	{call = "wait", time=1},
	{call = "findSpriteByFileName", plist="ccbi-res/hero-icon-2.plist",getParent=1,file="hero-icon/20204005.png", system_hero_config="first_ordinary_lottery"},
	{call = "createMask"},
	{call = "wait", time=300},
	{call = "findSpriteByFileName", plist="ccbi-res/common-ui.plist",getParent=1,file="button/btn-orange-big-1.png",count=0},
	{call = "createMask",mask=false},
	{call = "wait", time=300},
	{call = "openNPCLayer", auto=1,music="music/guide009.mp3",npc_name="Misa",content=930030020},
}
return data