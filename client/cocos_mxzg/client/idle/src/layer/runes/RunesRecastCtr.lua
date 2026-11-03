local RunesRecastCtr = class("RunesRecastLayer", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RunesRecastLayer = class("RunesRecastLayer",require("src.comp.EventLayer"))

local UIItem = require("src.comp.menu.UIMenuItemRunesSkill")

-- ---------------------------RunesRecastItem--------------------------
local RunesRecastItem = class("RunesRecastItem",require("src.comp.EventLayer"))
function RunesRecastItem:onCreate()
	self:setSwallowTouches(false)
	self:setAutoClose(false)
	
    self.lbl_attr_tips:setString(ex.Tools:getLang(47011))
    self.lbl_skill_tips:setString(ex.Tools:getLang(47275))
	self.lbl_attr_tips:enableOutline(cc.c4b(68,30,3,255), 2)
	self.lbl_skill_tips:enableOutline(cc.c4b(68,30,3,255), 2)
end

function RunesRecastItem:reset(data)
    if data == nil or data.item_type == nil then
        print("data is not valuable . . . ")
        return
    end

    local runes_cfg = cfg.runestype.runestype[data.item_type]
    if runes_cfg == nil then
        print("data's item_type is not valuable . . . ")
        return
    end

    self.data = data

    -- 设置精灵的属性加成显示
    local ability = nil
    if data.ability_id ~= nil then
        ability = ex.Player.backpack_data:getRunesAbilityConfig(runes_cfg.rare, data.ability_id)
    end

    if ability == nil or table.nums(ability) <= 0 then
        self.spr_attr:setVisible(false)
        self.lbl_attr:setString(ex.Tools:getLang(47634))
    else
        local str = ex.Tools:getLang(2140000 + ability.attr) 
        
        str = ex.StringUtil.formatAttrStr(str, "##" , ability.value)

        -- self.spr_attr:setSpriteFrame("runes/elem-"..ability.attr .. ".png")
        ex.Tools:setSpriteFrame(self.spr_attr, "runes/elem-"..ability.attr .. ".png")

        self.spr_attr:setVisible(true)
        -- layer.spr_attr:setSpriteFrame("")
        self.lbl_attr:setString(str)
    end
    
    -- 如果有技能数据，则显示对应技能数据，否则显示技能随机
    self.menu:removeAllChildren()
    for i = 1, runes_cfg.skill_max do 
    	if data.skill[i] ~= nil then 
			local skill_data = ex.Player.backpack_data:getRunesSkillConfig(data.skill[i].skill_id, data.skill[i].level)
    		
            if not skill_data then 
                print("data's skill data is not valuable . . .")
            else
                local item = UIItem:createWithIcon(skill_data)
                item:setScale(0.8)
                self.menu:addChild(item)
                local x,y = self["node_" .. i]:getPosition()
                item:setPosition(x,y)

                self["lbl_skill_"..i]:setString(ex.Tools:getLang(skill_data.skill_id + skill_data.level - 1 + 10000000))
    			local skill_data = ex.Player.backpack_data:getRunesSkillConfig(skill_data.skill_id, skill_data.level)
				local info_str = ex.Player.hero_data:getSkillDescription(skill_data.skill_id, skill_data.level)
                self["lbl_skill_info_"..i]:setString(info_str)	
                
                self["lbl_skill_"..i]:setVisible(true)
                self["lbl_skill_info_"..i]:setVisible(true)
                self["lbl_random_"..i]:setVisible(false)
                self["spr_random_"..i]:setVisible(false)
            end
        else 
            local skill_data = {}
    		skill_data.skill_id = 0
			skill_data.level = 0

            local item = UIItem:createWithIcon(skill_data)
            item:setScale(0.8)
			self.menu:addChild(item)
			local x,y = self["random_" .. i]:getPosition()
			item:setPosition(x,y)

            self["lbl_skill_"..i]:setVisible(false)
            self["lbl_skill_info_"..i]:setVisible(false)

            self["lbl_random_"..i]:setString(ex.Tools:getLang(41099))
            self["lbl_random_"..i]:setVisible(true)
            self["spr_random_"..i]:setVisible(true)		
            
        end
    end
end

-- ---------------------------RunesRecastLayer--------------------------
function RunesRecastLayer:onCreate()
    self:addBlackBackground()

    self.btn_recast1:setVisible(false)
    self.btn_save:setVisible(false)
    
    local lbl_recast = cc.Label:createWithTTF(ex.Tools:getLang(47511), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_recast:addChild(lbl_recast)
    lbl_recast:enableOutline(cc.c4b(68,30,3,255), 2)
    lbl_recast:setPosition(self.btn_recast:getContentSize().width / 2,self.btn_recast:getContentSize().height / 2)

    local lbl_recast1 = cc.Label:createWithTTF(ex.Tools:getLang(47511), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_recast1:addChild(lbl_recast1)
    lbl_recast1:enableOutline(cc.c4b(68,30,3,255), 2)
    lbl_recast1:setPosition(self.btn_recast1:getContentSize().width / 2,self.btn_recast1:getContentSize().height / 2)

    local lbl_save = cc.Label:createWithTTF(ex.Tools:getLang(47649), FONT_DEFAULT_NAME_BOLD, 24)
    self.btn_save:addChild(lbl_save)
    lbl_save:enableOutline(cc.c4b(68,30,3,255), 2)
    lbl_save:setPosition(self.btn_save:getContentSize().width / 2,self.btn_save:getContentSize().height / 2)

    self:addItemView()
    self:addEvent(EVENT.RUNES_EVENT.RECAST_RUNES,handler(RunesRecastCtr:instance(), RunesRecastCtr.receiveRes))
end

function RunesRecastLayer:addItemView()
    self.pre_item = RunesRecastItem:createWithCCBIFile("ccbi/RunesRecastItem.ccbi")
    self:addChild(self.pre_item)
    local x,y = self.node_pre:getPosition()
    self.pre_item:setPosition(x,y)

    self.next_item = RunesRecastItem:createWithCCBIFile("ccbi/RunesRecastItem.ccbi")
    self:addChild(self.next_item)
    x,y = self.node_next:getPosition()
    self.next_item:setPosition(x,y)
end

-- ---------------------------RunesRecastCtr--------------------------
function RunesRecastCtr:onCreate()
	self:setCCBIPath("ccbi/RunesRecastLayer.ccbi")
    self:setIsSingle(false)
end

function RunesRecastCtr:getLayerClass()
	return RunesRecastLayer
end

function RunesRecastCtr:getHeroSelectLayer()
	return self.layer
end

function RunesRecastCtr:openWindow(data)
	if self:isOpened() then
		return
	end
	
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/runes.plist")
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

	self:loadLayer()
	self:open()
	self:initData(data)
end

function RunesRecastCtr:initData(data)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    -- self.callback = callback

    self.layer.btn_recast:registerScriptTapHandler(handler(self, self.onRecast))
    self.layer.btn_recast1:registerScriptTapHandler(handler(self, self.onRecast))
    self.layer.btn_save:registerScriptTapHandler(handler(self, self.onSave))

	self:updateLayer(data)
end

function RunesRecastCtr:receiveRes(event, data)
    local runes_data = ex.Player.backpack_data:getRunesById(data)
    if runes_data == nil then
        return
    end

    self:updateLayer(runes_data)
end

function RunesRecastCtr:updateLayer(data)
    if self.layer == nil then
        print("RunesRecastCtr:updateLayer layer is nil . . .")
        return
    end
    self.data = data
    local layer = self.layer
    local cast_cfg = cfg.runestype.runestype[data.item_type]
    if not cast_cfg or cast_cfg.random_cost == "" then 
        print("cfg.runestype.runestype["..data.item_type .. "] is nil !")
        return 
    end
    
    if layer.item ~= nil then 
        layer.item:removeFromParent()
        layer.item = nil
    end

    layer.lbl_title:setString(ex.Tools:getLang(41103))
    -- layer.lbl_title:setString("fuck")

    layer.item = ex.Tools:createBackpackItem(data.item_type)
    layer.menu:addChild(layer.item)
    local x,y = layer.node:getPosition()
    layer.item:setPosition(x,y)
    local cast_cost = cast_cfg.random_cost
    layer.spr_soul_need:setSpriteFrame(string.format("backpack/%s.png",cast_cost[1].item_type))
    local hasNum = ex.Player:getItemNum(cast_cost[1].item_type)
    local color = hasNum >= cast_cost[1].item_num and cc.c3b(255,255,255) or cc.c3b(255,0,0)

    local str = string.format( "%s/%s",self:convertNum(hasNum),self:convertNum(cast_cost[1].item_num))
    layer.lbl_soul_need:setString(str)
    layer.lbl_soul_need:setColor(color)

    layer.spr_gold_need:setSpriteFrame(string.format("backpack/%s.png",cast_cost[2].item_type))
    local hasNum = ex.Player:getItemNum(cast_cost[2].item_type)
    local color = hasNum >= cast_cost[2].item_num and cc.c3b(255,255,255) or cc.c3b(255,0,0)
    local str = string.format( "%s/%s",self:convertNum(hasNum),self:convertNum(cast_cost[2].item_num))
    layer.lbl_gold_need:setString(str)
    layer.lbl_gold_need:setColor(color)

    layer.lbl_runes_name:setString(ex.Tools:getLang(data.item_type))

    -- 按钮显示与隐藏
    self.layer.btn_recast1:setVisible(data.wash_ability_id > 0)
    self.layer.btn_save:setVisible(data.wash_ability_id > 0)
    self.layer.btn_recast:setVisible(data.wash_ability_id <= 0)

    -- 初始化符文当前的属性及技能
    local data_cur = {}
    data_cur.item_id = data.item_id
    data_cur.item_type = data.item_type
    data_cur.ability_id = data.ability_id
    data_cur.skill = data.skill

    layer.pre_item:reset(data_cur)

    -- 初始化符文重生后的属性及技能，如果没有数据，则显示问号数据，否则显示重生后的数据
    local data_after = {}
    data_after.item_id = data.item_id
    data_after.item_type = data.item_type

    if data.wash_ability_id > 0 then
        data_after.ability_id = data.wash_ability_id
        data_after.skill = data.wash_skill
    else
        data_after.ability_id = 0
        data_after.skill = {}
    end

    layer.next_item:reset(data_after)
end

-- 重生按钮回调
function RunesRecastCtr:onRecast(tag, pSender)
    local req_recast = Rune_pb.GReqRuneWash()
    req_recast.rune_id = self.data.item_id
    NetManager:sendMessage(ProtocolID.GReqRuneWash, req_recast)
end

-- 重生保存按钮回调
function RunesRecastCtr:onSave(tag, pSender)
    local req_recast_save = Rune_pb.GReqRuneWashSave()
    req_recast_save.rune_id = self.data.item_id
    NetManager:sendMessage(ProtocolID.GReqRuneWashSave, req_recast_save)
end

function RunesRecastCtr:convertNum(num)
    if num >= 10000 then 
        return string.format( ex.Tools:getLang(47567),math.floor( num / 10000 ) )
    else
        return string.format( "%s",num )
    end
end

return RunesRecastCtr
