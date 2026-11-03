local BattleEditCtr = class("BattleEditCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local BattleEditLayer = class("BattleEditLayer", require("src.comp.EventLayer"))

function BattleEditLayer:onCreate()
	self:addBlackBackground()
	local win_size = cc.Director:getInstance():getWinSize();
	local height = Maths.min(self:getContentSize().height, win_size.height);
    self:setScale(height / self:getContentSize().height);
    

    local input_type = device.platform == "mac" and cc.EDITBOX_INPUT_MODE_SINGLELINE or cc.EDITBOX_INPUT_MODE_ANY
    self.edit_num = 1
	for i=1,self.edit_num do
		local str_file = cc.UserDefault:getInstance():getStringForKey("send_edit" .. i, "")
		local spr_send = self["spr_send"..i]
		local edit_send = ccui.EditBox:create(cc.size(spr_send:getContentSize().width, spr_send:getContentSize().height), "other/spr-null.png", 1)
		edit_send:setPosition(spr_send:getPositionX() + spr_send:getContentSize().width * 0.5, spr_send:getPositionY() + spr_send:getContentSize().height * 0.5)
	   	edit_send:setAnchorPoint(cc.p(0.5, 0.5))
		edit_send:setFontSize(18)
		edit_send:setFontColor(cc.WHITE)
		-- edit_send:setPlaceHolder(ex.Tools:getLang(47049))
		edit_send:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
		edit_send:setInputMode(input_type)
	   	edit_send:registerScriptEditBoxHandler(handler(self, self.editboxHandle))
	    edit_send:setText(str_file)
		spr_send:getParent():addChild(edit_send)
		self["edit_send"..i] = edit_send
	end

end

function BattleEditLayer:editboxHandle(strEventName, sender)
    local str = sender:getText()
    print(str)

end

function BattleEditLayer:onSend(tag)
    local str_send = self["edit_send"..tag]:getText()
	if string.len(str_send) <= 0 then
		return
    end

    cc.UserDefault:getInstance():setStringForKey("send_edit"..tag, str_send)
    local str_plist = cpp.SocialPlatform:instance():getPlatformStr() == "2" and '\r' or '\n'

    local data = {}
    local vec_line = ex.StringUtil.splist(str_send, str_plist)

    for i=1,#vec_line do
        -- local vec_value = ex.StringUtil.splist(vec_line[i], "	")
        -- table.insert(, [pos,] value )
        local str = string.gsub(vec_line[i],"\t", " ")
        table.insert(data, str)
    end

    local req_battle = Tower_pb.GReqEditBattle()
    req_battle.battle_info = json.encode(data)
    NetManager:sendMessage(ProtocolID.GReqEditBattle, req_battle)

    local edit_layer = ex.MainSceneCtr:getCurLayer()
    -- print("data", json.encode(data))
    print("-------------------------------------------------------------222")
    local battle_layer = edit_layer:addBattleLayerAuto(BattleType.TOWER,
                                                        MainSceneType.MAINCITY_EDIT,
                                                        MainSceneType.MAINCITY_EDIT_BATTLE,
                                                        "map_tower", 
                                                        EVENT.TOWER_EVENT.TOWER_BATTLE_START,
                                                        function(layer, data, vec_reward, ext)
                                                            -- require("src.layer.ChapterEndCtr"):instance():openWindow(true, vec_reward, nil, nil, ext.report.log)
                                                            return true, true
                                                        end)
    battle_layer:showSpeedBtn(nil, true)
    BattleEditCtr:instance():closeWindow()
    -- local vec_key = 
    -- dump(vec_key, "vec_key")
end

function BattleEditLayer:onClear()
    for i=1,self.edit_num do
        local edit_send = self["edit_send"..i]
        edit_send:setText("")
        cc.UserDefault:getInstance():setStringForKey("send_edit"..i, "")
    end
end
-----------------------------------------------------------------------------
function BattleEditCtr:onCreate()
	self:setCCBIPath("ccbi/BattleEditLayer.ccbi")
	self:setIsSingle(false)
end

function BattleEditCtr:getLayerClass()
	return BattleEditLayer
end

function BattleEditCtr:getBattleEditLayer()
	return self.layer
end

function BattleEditCtr:openWindow(str_title, str_content)
	if self:isOpened() then
		return
    end
    
	self:loadLayer()
	self:open()
	self:initData(str_title, str_content)
end

function BattleEditCtr:initData(str_title, str_content)
end

return BattleEditCtr