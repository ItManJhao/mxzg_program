local ChampionEditBiuCtr = class("ChampionEditBiuCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ChampionEditBiuLayer = class("ChampionEditBiuLayer", require("src.comp.EventLayer"))

function ChampionEditBiuLayer:onCreate()
    self:addBlackBackground()

    local biu_ctr = ChampionEditBiuCtr:instance()
    self.btn_close:registerScriptTapHandler(handler(biu_ctr, biu_ctr.closeWindow))

    local size = self.spr_input_bg:getContentSize()
    size = cc.size(size.width - 20, size.height - 30)
	self.edit_box = ccui.EditBox:create(size, "other/spr-null.png", 1)
	self.edit_box:setPosition(self.spr_input_bg:getPositionX() + 10, self.spr_input_bg:getPositionY() - 10)
	-- self.selectCount:anch(cc.p(0.5,0.5))
	self.edit_box:setAnchorPoint(cc.p(0,1))
	self.edit_box:setFontSize(22)
    self.edit_box:setFontColor(cc.c3b(122, 71, 45))
    self.edit_box:setPlaceholderFontSize(22)
	self.edit_box:setPlaceHolder(ex.Tools:getLang(47572))
	self.edit_box:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
	self.edit_box:setInputMode(cc.EDITBOX_INPUT_MODE_ANY) 
	-- self.edit_box:registerScriptEditBoxHandler(handler(self,self.editboxHandle))
    self:addChild(self.edit_box)
    
end

function ChampionEditBiuLayer:onConfirm()
    local now_time = ex.Game:getServerTime()
    if ex.Player.champion_data.biu_cd - now_time > -1 then
        -- ex.MessageView:add(string.format(ex.Tools:getLang(47076), math.max(ex.Player.champion_data.biu_cd - now_time + 1, 0)))
        ex.MessageView:add(ex.Tools:getLang(34109))
        return
    end

    local text = string.gsub(self.edit_box:getText(), "\r", "")
    text = string.gsub(text, "\n", "")
    text = string.gsub(text, "\r\n", "")
    if string.len(text) <= 0 then
        ex.MessageView:add(ex.Tools:getLang(47499))
        return
    end

    local cut_name = cpp.StringUtil:cutNameWithLength(text, 40, 1, 1) 
    if text ~= cut_name then
        -- ex.MessageView:add(ex.Tools:getLang(47099))
        ex.MessageView:add(ex.Tools:getLang(34110))
        return
    end

    -- 判断资源是否足够
    local need_num = 500
    if ex.Tools:hasItem(ItemType.IT_GOLD, need_num, false) == false then
        return
    end

    local req_biu = Champion_pb.GReqChampionBiubiu()
    req_biu.content = text
    NetManager:sendMessage(ProtocolID.GReqChampionBiubiu, req_biu)

    ChampionEditBiuCtr:instance():closeWindow()
end

-- function ChampionEditBiuLayer:editboxHandle()

-- end

-----------------------------------------------------------------------------
function ChampionEditBiuCtr:onCreate()
	self:setCCBIPath("ccbi/ChampionEditBiuLayer.ccbi")
	self:setIsSingle(false)
end

function ChampionEditBiuCtr:getLayerClass()
	return ChampionEditBiuLayer
end

function ChampionEditBiuCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData()
end

function ChampionEditBiuCtr:initData()
end


return ChampionEditBiuCtr
