local data = {
	{call = "waitSceneLoadingEnd"},
	{call = "wait", time=300},
	{call = "closeOtherWindow"},
	{call = "wait", time=10},
	{call = "openWindow", file = "src.layer.promotion.RechargeFirstCtr"},
	{call = "wait", time=200},
	{call = "openNPCLayer", auto=1,npc_name="",content=930030007},
	{call = "openNPCLayer", auto=1,npc_name="",content=930030008},
}
return data