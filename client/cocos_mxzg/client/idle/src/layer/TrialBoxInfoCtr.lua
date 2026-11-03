local TrialBoxInfoCtr = class("TrialBoxInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local TrialBoxInfoLayer = class("TrialBoxInfoLayer", require("src.comp.LuaLayerBase"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")


function TrialBoxInfoLayer:onCreate()
    self:addBlackBackground()
	-- print("TrialBoxInfoLayer:onCreate")
	-- local btn_size = self.btn_start:getContentSize()
	-- lbl_btn_txt = cc.Label:createWithTTF(ex.Tools:getLang(47589), FONT_DEFAULT_NAME_BOLD, 26)
	-- :enableOutline(FONT_DARK_BLUE, 2)
	-- :setPosition(btn_size.width/2, btn_size.height/2 + 3)
	-- self.btn_start:addChild(lbl_btn_txt)
	-- self:createEmenyHero()
end

function TrialBoxInfoLayer:createReward(data)

    local menu = cpp.UIMenu:create()
    :setSwallowsTouches(false)
    :setName("reward_menu")
    :setPosition(cc.p(0, 0))
    self:addChild(menu)

    local posY = 170
    local margin = 10

	local max_width = self.spr_bg:getContentSize().width
    local item_size = UIMenuItemBackpack:createWithData()
    item_size = item_size:getContentSize()

    local length = #data.reward
    local posX = (max_width - (item_size.width + margin) * length) / 2
    local reward_data = data.reward

    for i=1,length do
        local item = UIMenuItemBackpack:createWithData(reward_data[i].item_type, reward_data[i].item_num)
        item:setPosition(posX + (item_size.width + margin) * (i - 1) + margin + item_size.width/2,posY)
        item:registerScriptTapHandler(handler(self, self.onClickItem))
        menu:add(item)
    end
end

function TrialBoxInfoLayer:showBtnString(tag)

    local box_status = ex.Player.trial_data:getBoxStatus(tag)
    local str = box_status == 0 and ex.Tools:getLang(47695) or ex.Tools:getLang(47589)
    local btn_size = self.btn_start:getContentSize()
    local lbl_btn_txt = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 26)
    :enableOutline(FONT_DARK_BLUE, 2)
    :setPosition(btn_size.width/2, btn_size.height/2 + 3)
    self.btn_start:addChild(lbl_btn_txt)
end

function TrialBoxInfoLayer:onClickItem(tag , pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function TrialBoxInfoLayer:onStartFight(tag,pSender)
	-- print(self.__cname,"onStartFight")
end

-----------------------------------------------------------------------------
function TrialBoxInfoCtr:onCreate()
	self:setCCBIPath("ccbi/TrialBoxInfoLayer.ccbi")
	self:setIsSingle(false)
end

function TrialBoxInfoCtr:getLayerClass()
	return TrialBoxInfoLayer
end

function TrialBoxInfoCtr:openWindow(tag)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(tag)
end

function TrialBoxInfoCtr:initData(tag)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer.btn_start:registerScriptTapHandler(handler(self, self.onStartFight))

    local reward_data = {}
    for i,v in ipairs(cfg.adventurereward.reward) do
        if v.mission == tag and v.level == ex.Player.trial_data.hard_lv then
            reward_data = v
            break
        end
    end
    self.layer:createReward(reward_data)
    self.layer:showBtnString(tag)
    self.tag = tag
end

function TrialBoxInfoCtr:onStartFight(tag,pSender)
    -- print(self.__cname,"onStartFight",self.tag)
    
    local box_status = ex.Player.trial_data:getBoxStatus(self.tag)
    print("TrialBoxInfoCtr:onStartFight", self.tag)
    if box_status == 0 then 
        -- local res_trial_box = cpp.ByteArray:create()
        -- res_trial_box:writeInt(ProtocolID.GReqTrialBox)
        -- res_trial_box:writeInt8(self.tag)
        -- cpp.NetManager:instance():sendByteArray(res_trial_box)
        print("self.tag", self.tag)

        local res_trial_box = Adven_pb.GReqTrialBox()
        res_trial_box.mission_id = self.tag
        NetManager:sendMessage(ProtocolID.GReqTrialBox,res_trial_box)
    end

	self:closeWindow(nil,self.layer)
end

return TrialBoxInfoCtr
