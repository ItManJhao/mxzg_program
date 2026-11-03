local data = {
	{call = "findNodeByName",name="main_chat"},
	{call = "setNodeVisible",visible=0},
	{call = "showSubtitle", vec_text = {
		"数百年前的跨世之战，邪恶巨龙化身烈焰，将艾尼亚大陆融为无尽的废墟。",
		"这个被黑暗吞噬的世界，不再有女神一族的容身之地。",
		"她们将最后的意志封印在月神之地，祈祷未来某个时刻的重生。",
		"一个奇异的巧合，让时空指针划慢了一拍。",
		"那位从时空裂隙召唤而来的「异世界大人」，会与女神们的建立起羁绊，成为她们的最后救赎吗？",
		"……"
	},is_quick=true,movie="movie/guide-1.mp4"},
	{call = "wait", time=20},
	{call = "clearBattle"},
	{call = "setSwallow", is_swallow_touch = false,finial=1},
	{call = "addCloseWindowListen", next=false, step=8, ccbi_path="ccbi/SubtitleLayer.ccbi"},
	{call = "setSwallow", is_swallow_touch = true, finial=1},
	{call = "setSwallow", is_swallow_touch = true, finial=1},
	{call = "changeMainLayer", layer_type=MainSceneType.MLT_BATTLE, is_fast=true, finial=1},
	{call = "setSwallow", is_swallow_touch = true, finial=1},	
	{call = "setSwallow", is_swallow_touch = true, finial=1},	
	{call = "setSwallow", is_swallow_touch = true, finial=1},	
	{call = "setSwallow", is_swallow_touch = true, finial=1},	
	{call = "setSwallow", is_swallow_touch = true, finial=1},	
	{call = "setSwallow", is_swallow_touch = true, finial=1},	

}
return data