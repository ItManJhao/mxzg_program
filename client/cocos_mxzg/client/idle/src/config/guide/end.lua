local data = {
	{call = "waitSceneLoadingEnd"},
	{call = "wait", time=300, finial=1},
	{call = "openNPCLayer", auto=1,music="music/guide012.mp3",npc_name="Misa",content=930030017},
	{call = "findNodeByName",name="main_chat"},
	{call = "setNodeVisible",visible=1},
}
return data