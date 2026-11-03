local GMCtr = class("GMCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GMLayer = class("GMLayer", require("src.comp.EventLayerAdaptiveWidth"))


local SendEndFunc = {
	["RESET_CRUSADE_GROUP"] = function(pram)
		-- NetManager:sendMessage()
		ctr.crusade_group:requestSignUp()
	end,
}

local item_size = cc.size(130, 30)
function GMLayer:onCreate()
	local gm_ctr = GMCtr:instance()
	-- 清除文件
	for i=1,4 do
		local str_file = cc.UserDefault:getInstance():getStringForKey("cite_file" .. i, "")
		local spr_cite = self["spr_cite"..i]
		local edit_cite = ccui.EditBox:create(cc.size(spr_cite:getContentSize().width, spr_cite:getContentSize().height),"other/spr-null.png", 1)
		edit_cite:setPosition(spr_cite:getPositionX() + spr_cite:getContentSize().width * 0.5, spr_cite:getPositionY() + spr_cite:getContentSize().height * 0.5)
	   	edit_cite:setAnchorPoint(cc.p(0.5, 0.5))
		edit_cite:setFontSize(18)
		edit_cite:setFontColor(cc.WHITE)
		edit_cite:setPlaceHolder(ex.Tools:getLang(47595))
		edit_cite:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
		edit_cite:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
	   	edit_cite:registerScriptEditBoxHandler(handler(self,self.editboxHandle))
	    edit_cite:setText(str_file)
		spr_cite:getParent():addChild(edit_cite)
		self["edit_cite"..i] = edit_cite
	end


	self.search_name = ""
	local edit_search = ccui.EditBox:create(cc.size(self.spr_search:getContentSize().width, self.spr_search:getContentSize().height),"other/spr-null.png", 1)
	edit_search:setPosition(self.spr_search:getPositionX() + self.spr_search:getContentSize().width * 0.5, self.spr_search:getPositionY() + self.spr_search:getContentSize().height * 0.5)
	edit_search:setAnchorPoint(cc.p(0.5, 0.5))
	edit_search:setFontSize(18)
	edit_search:setFontColor(cc.WHITE)
	edit_search:setPlaceHolder(ex.Tools:getLang(47730))
	edit_search:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
	edit_search:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
	edit_search:registerScriptEditBoxHandler(handler(self,self.editboxSearchHandle))
	edit_search:setText("")
	self.spr_search:getParent():addChild(edit_search)

	self:setErrorLog(nil, nil, false)
	self:updateScrollView()

	self:initSend()
end

function GMLayer:editboxSearchHandle(strEventName, sender)
	if strEventName == "began" then 
		-- sender:selectedAll()
	elseif strEventName == "ended" then 
		self.search_name = sender:getText()
		self:updateScrollView()
		-- local str = sender:getText()
		-- print(type(str), tonumber(str))
	elseif strEventName == "changed" then
		self.search_name = sender:getText()
		self:updateScrollView()
	end
end

function GMLayer:updateScrollView()
	local gm_ctr = GMCtr:instance()
	local vec_item = {}
	local vec_sort = {}
	for k,v in pairs(cfg.item.item) do
		table.insert(vec_sort, v)
	end

	table.sort(vec_sort, function(a, b)
		return a.idx < b.idx
	end)


	local function refreshClan()
		if ex.Player.clan_data.clan_id ~= NULL_ID then
			-- 公会信息
			local req_clan_info = Clan_pb.GReqClanInfo()
			req_clan_info.clan_id = ex.Player.clan_data.clan_id
			NetManager:sendMessage(ProtocolID.GReqClanInfo, req_clan_info)
	
			-- 公会操作相关信息
			NetManager:sendMessage(ProtocolID.GReqClanReqMsgInfo)
	
			-- 请求公会历史记录
			NetManager:sendMessage(ProtocolID.GReqClanMsgInfo)
	
			-- 请求公会科技列表
			NetManager:sendMessage(ProtocolID.GReqClanSkillList)
	
			-- 请求公会捐献列表
			NetManager:sendMessage(ProtocolID.GReqClanDonateList)
	
			-- 请求公会boss
			NetManager:sendMessage(ProtocolID.GReqClanMissionInfo)
	
			-- 请求伤害排行
			NetManager:sendMessage(ProtocolID.GReqClanRankDamage)
	
			-- 请求公会战信息
			NetManager:sendMessage(ProtocolID.GReqScanWarInfo)
	
			-- 请求公会BOSS战信息
			NetManager:sendMessage(ProtocolID.GReqScanWorldBoss)
			NetManager:sendMessage(ProtocolID.GReqScanClanRank)
			NetManager:sendMessage(ProtocolID.GReqScanRoleRank)
		end
	end

 --    table.insert(vec_item, {type = ItemType.IT_GEM           	  , name = ex.Tools:getLang(47082) 		, num = 10000})
 	table.insert(vec_item, {cmd="ROLE_LV",			  param = {1}, 		 		name = ex.Tools:getLang(47137), call=function()
		NetManager:sendMessage(ProtocolID.GReqRoleInfo)
	end})
	table.insert(vec_item, {cmd="ROLE_LV",			  param = {10}, 		 	name = ex.Tools:getLang(47739), call=function()
		NetManager:sendMessage(ProtocolID.GReqRoleInfo)
	end})

	table.insert(vec_item, {cmd="ROLE_LV",			  param = {100}, 		 	name = ex.Tools:getLang(47450), call=function()
		NetManager:sendMessage(ProtocolID.GReqRoleInfo)
	end})
	
	table.insert(vec_item, {cmd="OPEN_ALL_PROMOTION", param = {}, 			name = ex.Tools:getLang(47276), call=function()
		NetManager:sendMessage(ProtocolID.GReqRoleInfo)
	end})
	table.insert(vec_item, {cmd="ALL_HERO"			, param = {}, 			name = ex.Tools:getLang(47711), call=function()
		local req = Hero_pb.GReqHeroList()
		req.page = 1
		NetManager:sendMessage(ProtocolID.GReqHeroList, req)
	end})
	table.insert(vec_item, {cmd="ALL_EQUIP"			, param = {}, 			name = ex.Tools:getLang(47244), call=function()
		NetManager:sendMessage(ProtocolID.GReqBackPackList)
	end})
	table.insert(vec_item, {cmd="ADD_GODDESS"		, param = {1}, 			name = ex.Tools:getLang(47628), call=function()
		NetManager:sendMessage(ProtocolID.GReqFetterList)
	end})
	table.insert(vec_item, {cmd="CLEAN_SHELTER"		, param = {}, 			name = ex.Tools:getLang(47185)})
	table.insert(vec_item, {cmd="CWB_NEXT_STAGE"    , param = {}, 			name = ex.Tools:getLang(47383), call=refreshClan})
	table.insert(vec_item, {cmd="CLANWAR_NEXT_STAGE", param = {}, 			name = ex.Tools:getLang(47111), call=refreshClan})
	table.insert(vec_item, {cmd="CLEAN_ALL_HERO"    , param = {}, 			name = ex.Tools:getLang(47015), call=function()
		local req = Hero_pb.GReqHeroList()
		req.page = 1
		NetManager:sendMessage(ProtocolID.GReqHeroList, req)
	end})
	table.insert(vec_item, {cmd="ROLE_MISSION",	 	 param = {1}, 		 	name = ex.Tools:getLang(47699), call=function()
		for i=1,1 do
			NetManager:sendMessage(ProtocolID.GReqBattleMatch)
            NetManager:sendMessage(ProtocolID.GReqChapterEnd)
		end
	end})
	table.insert(vec_item, {cmd="ROLE_MISSION",	 	 param = {1}, 		 	name = ex.Tools:getLang(47048), call=function()
		for i=1,10 do
			NetManager:sendMessage(ProtocolID.GReqBattleMatch)
            NetManager:sendMessage(ProtocolID.GReqChapterEnd)
		end
	end})
	table.insert(vec_item, {cmd="ROLE_MISSION",	 	 param = {1}, 		 	name = ex.Tools:getLang(47670), call=function()
		for i=1,100 do
			NetManager:sendMessage(ProtocolID.GReqBattleMatch)
            NetManager:sendMessage(ProtocolID.GReqChapterEnd)
		end
	end})
	table.insert(vec_item, {cmd="",	 	 param = {}, 		 				name = ex.Tools:getLang(47443), call=function()
		local stage = ex.Player.tower_data:getNowStage()
		for i=1,10 do
			local req_battle = Tower_pb.GReqTowerBattle()
			req_battle.stage = stage
			NetManager:sendMessage(ProtocolID.GReqTowerBattle, req_battle)

			stage = stage + 1
		end
	end})
	table.insert(vec_item, {cmd="",	 	 param = {}, 		 				name = ex.Tools:getLang(47013), call=function()
		local stage = ex.Player.tower_data:getNowStage()
		for i=1,100 do
			local req_battle = Tower_pb.GReqTowerBattle()
			req_battle.stage = stage
			NetManager:sendMessage(ProtocolID.GReqTowerBattle, req_battle)

			stage = stage + 1
		end
	end})

	table.insert(vec_item, {cmd="CHAMPION_NEXT_STAGE",	 	 param = {}, 		name = ex.Tools:getLang(47662), call=function()
		NetManager:sendMessage(ProtocolID.GReqScanChampion)
		NetManager:sendMessage(ProtocolID.GReqScanChampionKnockout)
		NetManager:sendMessage(ProtocolID.GReqGuessChampionBattle)
	end})


	table.insert(vec_item, {cmd="GOD_RELIC_ADD_COUNT",	 	 param = {1}, 		name = "诸神遗迹次数+1", call=function()
		NetManager:sendMessage(ProtocolID.GReqGodRelicData)
	end})

	table.insert(vec_item, {cmd="GOD_RELIC_ADD_COUNT",	 	 param = {10}, 		name = "诸神遗迹次数+10", call=function()
		NetManager:sendMessage(ProtocolID.GReqGodRelicData)
	end})

	table.insert(vec_item, {cmd="GOD_RELIC_ADD_COUNT",	 	 param = {10}, 		name = "点赞", call=function()
		-- NetManager:sendMessage(ProtocolID.GReqGodRelicData)
		cpp.SocialPlatform:instance():dz()
	end})
	
	table.insert(vec_item, {cmd="GOD_RELIC_ADD_COUNT",	 	 param = {10}, 		name = "分享", call=function()
		cpp.SocialPlatform:instance():shareLink()
	end})

	table.insert(vec_item, {cmd="GOD_RELIC_ADD_COUNT",	 	 param = {10}, 		name = "评论", call=function()
		cpp.SocialPlatform:instance():discuss()
	end})

	table.insert(vec_item, {cmd="GOD_RELIC_ADD_COUNT",	 	 param = {10}, 		name = "版", call=function()
		local file_utils = cc.FileUtils:getInstance()
        local writable_path = file_utils:getWritablePath()
        cc.FileUtils:getInstance():removeFile(writable_path .. "version.rvs.pre")
	end})
	
	table.insert(vec_item, {cmd="SAN_RI_REN_WU",	 	 param = {}, 		name = "三日任务+1", call=function()
		ex.MessageView:add("请重登")
	end})
	
	table.insert(vec_item, {cmd="ADD_ONLINE_TIME",	 	 param = {},  name = ex.Tools:getLang(47210), call= nil})

	table.insert(vec_item, {cmd="RESET_DREAMLAND",	 	 param = {},  name = ex.Tools:getLang(47075), call=function()
		--永恒梦境初始信息
		ex.Player.dream_data:gReqDreamlandData()
		ex.Player.dream_data:gReqDreamlandRank()
		ex.Player.dream_data:gReqFriendAssistHeroList()
		ex.Player.dream_data:gReqDreamlandBattleStatus()
	end})

	table.insert(vec_item, {cmd="TIME_TOWER_RESET",	 	 param = {},  name = "恢復心心", call= function()
		-- 時空魔塔
		NetManager:sendMessage(ProtocolID.GReqTimeTowerInfo)
	end})

	for i,v in ipairs(vec_sort) do
		-- 1005000
		if (v.idx < 10000000 or v.idx > 2000000) and v.idx ~= 900003 then
			local str_name = ex.Tools:getLang(v.name)
			if str_name == "" or str_name == nil then
				str_name = tostring(v.idx)
			end

			local item_config = cfg.item.item[v.idx]
			
			local item_num = 100
			item_num = (v.idx == ItemType.IT_GOLD) and 1000000000 or item_num
			item_num = (v.idx == ItemType.IT_GEM) and 10000000 or item_num  
			item_num = (v.idx == ItemType.IT_HERO_EXP) and 100000000 or item_num
			item_num = (v.idx == ItemType.IT_HERO_UP_STONE) and 100000000 or item_num
			item_num = (v.idx == ItemType.IT_RUNES_CREAM) and 100000000 or item_num
			item_num = (v.idx == 901401) and 100000000 or item_num
			item_num = (item_config.mode == ItemData.IT_HERO) and 1 or item_num
			
			table.insert(vec_item, {cmd="ADD_ITEM", param = {v.idx, item_num} , name = str_name, call=function()
				NetManager:sendMessage(ProtocolID.GReqBackPackList)
			end})
		end
	end

	if self.search_name ~= "" then
		local num = table.nums(vec_item)
		for i=num,1,-1 do
			local str_name = vec_item[i].name
			local find_index = string.find(str_name, self.search_name)
			if find_index == nil then
				table.remove(vec_item, i)
			end
		end
	end

	self.scroll_view_item:setItemSize(item_size)
	self.scroll_view_item.createItemFunction = function(data)
		local lbl_text = cc.Label:createWithTTF(data.name, FONT_DEFAULT_NAME_BOLD, 40) --cc.Label:createWithSystemFont(data.name, "", 20);
		lbl_text:setTextColor(cc.c3b(85, 30, 20))
		-- lbl_text:enableOutline(ex.c3b.BLACK, 2)
		local item = cc.MenuItemLabel:create(lbl_text)
		item.data = data
    	item:setAnchorPoint(cc.p(0.5, 0.5))
		item:registerScriptTapHandler(handler(gm_ctr, gm_ctr.onItem))
		item:setScale(0.5)

		-- local item = cpp.UIMenuItemImage:create()
		-- item.data = data
		-- item:setContentSize(item_size)
    	-- item:setAnchorPoint(cc.p(0.5, 0.5))
		-- item:registerScriptTapHandler(handler(gm_ctr, gm_ctr.onItem))
		-- item:setScale(0.5)

		if lbl_text:getContentSize().width * 0.5 > item_size.width then
			item:setScale((item_size.width) / lbl_text:getContentSize().width)
		end

		return item
	end
	self.scroll_view_item:reloadData(vec_item)

end




function GMLayer:clearCite(tag)
	local file = self["edit_cite"..tag]:getText()
	
	cc.UserDefault:getInstance():setStringForKey("cite_file"..tag, file)
	cc.FileUtils:getInstance():purgeCachedEntries()
	ex.Tools:clearCite(file)
end

function GMLayer:onCloseGM()
	local layer = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MAINCITY_LAYER)
	if layer then
		local visible = function(node)
			if node:isVisible() then
				node:setVisible(false)
			else
				node:setVisible(true)
			end
		end

		ex.Tools:ergodicAllNode(layer:getChildByTag(999):getChildByTag(999) , visible)
		ex.Tools:ergodicAllNode(layer:getChildByTag(999):getChildByTag(1000), visible)

		layer:getChildByTag(999):getChildByTag(999):setVisible(true)
		layer:getChildByTag(999):getChildByTag(1000):setVisible(true)

	end
end

function GMLayer:clearError()
	local game = require("src.model.Game"):instance()
	game.error_log = ""
end

function GMLayer:setErrorLog(tag, pSender, is_click)
	
	is_click = is_click == nil and true or false

	local is_open = cc.UserDefault:getInstance():getBoolForKey("open_error_windows", true)
	if is_click then
		is_open = is_open == false
	end

	cc.UserDefault:getInstance():setBoolForKey("open_error_windows", is_open)
	local str = is_open and ex.Tools:getLang(47732) or ex.Tools:getLang(47267)
	self.btn_error_status:setLabelText(ex.Tools:getLang(47351) .. str .. ")")
end

function GMLayer:openErrorLog()
	require("src.layer.ErrorCtr"):instance():openWindow(require("src.model.Game"):instance().error_log)
end


function GMLayer:initSend()

	for i=1,3 do
		local str_file = cc.UserDefault:getInstance():getStringForKey("send_gm" .. i, "")
		local spr_send = self["spr_send"..i]
		local edit_send = ccui.EditBox:create(cc.size(spr_send:getContentSize().width, spr_send:getContentSize().height),"other/spr-null.png", 1)
		edit_send:setPosition(spr_send:getPositionX() + spr_send:getContentSize().width * 0.5, spr_send:getPositionY() + spr_send:getContentSize().height * 0.5)
	   	edit_send:setAnchorPoint(cc.p(0.5, 0.5))
		edit_send:setFontSize(18)
		edit_send:setFontColor(cc.WHITE)
		edit_send:setPlaceHolder(ex.Tools:getLang(47049))
		edit_send:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
		edit_send:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
	   	edit_send:registerScriptEditBoxHandler(handler(self,self.editboxHandle))
	    edit_send:setText(str_file)
		spr_send:getParent():addChild(edit_send)
		self["edit_send"..i] = edit_send
	end

end


function GMLayer:onSend(tag)
	local str_send = self["edit_send"..tag]:getText()
	if string.len(str_send) <= 0 then
		return
	end
	cc.UserDefault:getInstance():setStringForKey("send_gm"..tag, str_send)

	local vec_key = ex.StringUtil.splist(str_send, " ")

	dump(vec_key, "vec_key")


	local vec_param = {}


	local req_command = Role_pb.GReqGMCommandNew()
	req_command.command = vec_key[1]
	for i=2, #vec_key do
		table.insert(req_command.param, vec_key[i])
		table.insert(vec_param, vec_key[i])
	end

	NetManager:sendMessage(ProtocolID.GReqGMCommandNew, req_command)

	self:onSendComplete(vec_key[1], vec_param)
end

function GMLayer:onSendComplete(command, param)

	local func = SendEndFunc[command]

	if func then
		func()
	end
end



function GMLayer:editboxHandle( strEventName,sender )
	if strEventName == "began" then 
		-- sender:selectedAll()
	elseif strEventName == "ended" then 
		local str = sender:getText()
		-- print(type(str), tonumber(str))
	elseif strEventName == "changed" then

	end
end

-----------------------------------------------------------------------------
function GMCtr:onCreate()
	self:setCCBIPath("ccbi/GMLayer.ccbi")
	self:setIsSingle(false)
	self.pre_touch_time = 0
end

function GMCtr:getLayerClass()
	return GMLayer
end

function GMCtr:getGMLayer()
	return self.layer
end

function GMCtr:openWindow()
	if self:isOpened() then
		return
	end

  	local sfc = cc.SpriteFrameCache:getInstance()
  	sfc:addSpriteFrames("ccbi-res/make-equip.plist")

	self:loadLayer()
	self:open()
	self:initData()
end

function GMCtr:initData()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end

function GMCtr:onItem(tag, pSender)
	local data = pSender.data

	if data.cmd == "" then
		data.call()
		return
	end

	local item_id = (data.type and data.type > 1000000) and tonumber(cpp.Game:makeLuaId()) or 0
    local req_command = Role_pb.GReqGMCommandNew()
	req_command.command = data.cmd
	for i,v in ipairs(data.param) do
		table.insert(req_command.param, tostring(v))
	end
	NetManager:sendMessage(ProtocolID.GReqGMCommandNew, req_command)

	print(data.param[1], data.param[2])
	if data.call then
		data.call()
	else
		NetManager:sendMessage(ProtocolID.GReqBackPackList)
	end

	local edit_send = self.layer["edit_send1"]
	if edit_send then
		local str = data.cmd .. " "
		for i,v in ipairs(data.param) do
			str = str .. tostring(v) .. " "
		end
		str = string.sub(str, 1, #str - 1)
		edit_send:setText(str)
	end

	if data.type == ItemType.IT_ROLE_EXP then
		ex.Player.level = ex.Player.level + 1
		ex.MainSceneCtr:setExp(ex.Player.level, ex.Player.exp)
	elseif data.type == ItemType.FETTER_LEVEL then
		NetManager:sendMessage(ProtocolID.GReqFetterList)
	end

	ex.MessageView:add("👌，大爷。物品已经放到背包中。", 0)
end

return GMCtr



-- local GMCtr = class("GMCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
-- local GMLayer = class("GMLayer", require("src.comp.EventLayerAdaptiveWidth"))

-- local item_size = cc.size(130, 30)
-- function GMLayer:onCreate()

-- end

-- function GMLayer:updateLayer()

-- end

-- function GMCtr:onCreate()
-- 	self:setCCBIPath("ccbi/GMLayer.ccbi")
-- 	self:setIsSingle(false)
-- 	self.pre_touch_time = 0
-- end

-- function GMCtr:getLayerClass()
-- 	return GMLayer
-- end

-- function GMCtr:getGMLayer()
-- 	return self.layer
-- end

-- function GMCtr:openWindow()
-- 	if self:isOpened() then
-- 		return
-- 	end

--   	local sfc = cc.SpriteFrameCache:getInstance()
--   	sfc:addSpriteFrames("ccbi-res/make-equip.plist")

-- 	self:loadLayer()
-- 	self:open()
-- 	self:initData()
-- end

-- function GMCtr:initData()
-- 	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
-- end
