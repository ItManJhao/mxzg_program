local TotemInfoCtr = class("TotemInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local TotemInfoLayer = class("TotemInfoLayer", require("src.comp.EventLayerAdaptiveWidth"))
local TotemSkillInfo = require("src.layer.totems.TotemSkillInfo")
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")

--------------------------------------------

function TotemInfoLayer:onCreate()
    self.is_onclick = false
    self:registerBtnEvent()
    self:upBtnLable()
    self:addBlackBackground()
    self:changeCostAndOperateMenu(self.is_onclick)
    self:initScrollView()
    self:addEvent(EVENT.TOTEM.UP_LEVEL,handler(self,self.onUplevel))
    self:addEvent(EVENT.TOTEM.UP_GRADE,handler(self,self.updateView))
    self:addEvent(EVENT.TOTEM.RESET,handler(self,self.updateView))
    self:addEvent(EVENT.TOTEM.UPDATA_EQUIP_INFO,handler(self,self.onChangeEquip))
end

function TotemInfoLayer:initScrollView( )
    -- self.srcoll_view:getContainer():
    local size
    for i = 1 , 3 do 
        self["skill_" .. i] = TotemSkillInfo:createWithCCBIFile("ccbi/TotemSkillInfo.ccbi")
        self.srcoll_view:getContainer():addChild(self["skill_" .. i])
        self["skill_" .. i]:setPosition(cc.p(40,0))
        size = self["skill_" .. i]:getContentSize()
    end

    local scroll_size = self.srcoll_view:getContainer():getContentSize()
    self.srcoll_view:getContainer():setContentSize(cc.size(scroll_size.width,size.height*3))
    for i=1,3 do
        local view_size = self.srcoll_view:getContainer():getContentSize()
        local node = self["skill_" .. i]
        node:setPositionY(view_size.height - size.height*i )
    end
    local view_size = self.srcoll_view:getViewSize()
    self.srcoll_view:setContentOffset(cc.p(0,view_size.height - (size.height*3))) 
end

function TotemInfoLayer:onChangeEquip( )
 
    self.totem_data = ex.Player.hero_data.totems:getTotemByHero(self.hero_id)
    self:updateView()
end

function TotemInfoLayer:onUplevel(event,data)
    self:playEffect()
    self:updateView()
end

function TotemInfoLayer:playEffect( )
    local spr = cc.Sprite:createWithSpriteFrameName("totem-lang/totem-lang-shengjichenggong.png")
    self:addChild(spr)
    spr:setLocalZOrder(10000)
    spr:setPosition(cc.p(320,700))
    local fade = cc.FadeOut:create(1)
    local call = cc.CallFunc:create(function ()
        spr:removeFromParent()
    end)
    local seq = cc.Sequence:create(fade,call)
    spr:runAction(seq)
end

function TotemInfoLayer:registerBtnEvent( )
    self.btn_up_level:registerScriptTapHandler(handler(self, self.onLevel))
    self.btn_up_grade:registerScriptTapHandler(handler(self, self.onGrade))
    self.btn_reset:registerScriptTapHandler(handler(self, self.onReView))
    self.btn_reset_max:registerScriptTapHandler(handler(self, self.onReView))
    self.btn_change:registerScriptTapHandler(handler(self, self.onChange))
    self.btn_disboard:registerScriptTapHandler(handler(self, self.onDisboard))
    self.btn_cannel:registerScriptTapHandler(handler(self, self.onCannel))
    for i = 1 ,2 do 
        local btn = self["cost_icon_" .. i]
        btn:registerScriptTapHandler(handler(self, self.onItemInfo))
    end
end

function TotemInfoLayer:onChange( )
    
    require("src.layer.totems.TotemListCtr"):instance():openWindow()
end

function TotemInfoLayer:onReView( )
    local cost_data = ex.Player.hero_data.totems:getLevelReturnCostByType(self.totem_data)
    local function send_reset()
        local req = Totems_pb.GReqTotemsReset()
        req.t_id = self.totem_data.t_id
        NetManager:sendMessage(ProtocolID.GReqTotemsReset, req)
    end
    require("src.layer.totems.TotemResetReViewCtr"):instance():openWindow(cost_data,send_reset)
end

function TotemInfoLayer:upBtnLable( )

    local lbl_disboard = cc.Label:createWithTTF(ex.Tools:getLang(76805), FONT_DEFAULT_NAME_BOLD, 24)
    lbl_disboard:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_disboard:setTextColor(cc.c3b(255,255,255))
    lbl_disboard:enableOutline(cc.c3b(13,91,45),2)
    self.btn_disboard:addChild(lbl_disboard)
    lbl_disboard:setPosition(self.btn_disboard:getContentSize().width / 2,self.btn_disboard:getContentSize().height / 2)

    local lbl_cannel = cc.Label:createWithTTF(ex.Tools:getLang(76815), FONT_DEFAULT_NAME_BOLD, 24)
    lbl_cannel:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_cannel:setTextColor(cc.c3b(255,255,255))
    lbl_cannel:enableOutline(cc.c3b(13,91,45),2)
    self.btn_cannel:addChild(lbl_cannel)
    lbl_cannel:setPosition(self.btn_cannel:getContentSize().width / 2,self.btn_cannel:getContentSize().height / 2)

    local lbl_reset = cc.Label:createWithTTF(ex.Tools:getLang(76816), FONT_DEFAULT_NAME_BOLD, 24)
    lbl_reset:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_reset:setTextColor(cc.c3b(255,255,255))
    lbl_reset:enableOutline(cc.c3b(13,91,45),2)
    self.btn_reset:addChild(lbl_reset)
    lbl_reset:setPosition(self.btn_reset:getContentSize().width / 2,self.btn_reset:getContentSize().height / 2)

    local lbl_reset_max = cc.Label:createWithTTF(ex.Tools:getLang(76816), FONT_DEFAULT_NAME_BOLD, 24)
    lbl_reset_max:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_reset_max:setTextColor(cc.c3b(255,255,255))
    lbl_reset_max:enableOutline(cc.c3b(13,91,45),2)
    self.btn_reset_max:addChild(lbl_reset_max)
    lbl_reset_max:setPosition(self.btn_reset_max:getContentSize().width / 2,self.btn_reset_max:getContentSize().height / 2)

    local lbl_upLevel = cc.Label:createWithTTF(ex.Tools:getLang(76807), FONT_DEFAULT_NAME_BOLD, 24)
    lbl_upLevel:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_upLevel:setTextColor(cc.c3b(255,255,255))
    lbl_upLevel:enableOutline(cc.c3b(131,43,22),2)
    self.btn_up_level:addChild(lbl_upLevel)
    lbl_upLevel:setPosition(self.btn_up_level:getContentSize().width / 2,self.btn_up_level:getContentSize().height / 2)

    local lbl_upGrade = cc.Label:createWithTTF(ex.Tools:getLang(76817), FONT_DEFAULT_NAME_BOLD, 24)
    lbl_upGrade:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_upGrade:setTextColor(cc.c3b(255,255,255))
    lbl_upGrade:enableOutline(cc.c3b(131,43,22),2)
    self.btn_up_grade:addChild(lbl_upGrade)
    lbl_upGrade:setPosition(self.btn_up_grade:getContentSize().width / 2,self.btn_up_grade:getContentSize().height / 2)

    local lbl_change = cc.Label:createWithTTF(ex.Tools:getLang(76806), FONT_DEFAULT_NAME_BOLD, 24)
    lbl_change:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_change:setTextColor(cc.c3b(255,255,255))
    lbl_change:enableOutline(cc.c3b(131,43,22),2)
    self.btn_change:addChild(lbl_change)
    lbl_change:setPosition(self.btn_change:getContentSize().width / 2,self.btn_change:getContentSize().height / 2)
end

function TotemInfoLayer:updateView( )
    local level_cfg = ex.Player.hero_data.totems:getLevelCfgByType(self.totem_data.sys_id,self.totem_data.level)
    local next_grade_cfg = ex.Player.hero_data.totems:getGradeCfgByType(self.totem_data.sys_id,self.totem_data.quality+1)
    local max_grade = next_grade_cfg == nil 
    local show_grade_panel = false 
    if max_grade == false then 
        show_grade_panel = next_grade_cfg.needlevel == self.totem_data.level
    end
    -- if self.is_onclick == false then 
    --     self:updateLevelPanel() 
    --     return 
    -- end
    self.btn_reset:setVisible(self.totem_data.level > 1 and self.is_onclick)
    self.btn_change:setVisible(not self.is_onclick)
    self:updatePanel(show_grade_panel)
end

function TotemInfoLayer:updatePanel(show_grade_panel)

    self.node_grade:setVisible(show_grade_panel)
    self.node_level:setVisible(not show_grade_panel)

    if show_grade_panel == true then
        self:updateGradePanel()
    else
        self:updateLevelPanel()
    end
end

function TotemInfoLayer:updateLevelPanel( )
    local level_cfg = ex.Player.hero_data.totems:getLevelCfgByType(self.totem_data.sys_id,self.totem_data.level)
    local next_level_cfg = ex.Player.hero_data.totems:getLevelCfgByType(self.totem_data.sys_id,self.totem_data.level+1)
    local next_grade_cfg = ex.Player.hero_data.totems:getGradeCfgByType(self.totem_data.sys_id,self.totem_data.quality+1)
    local all_grade_cfg = ex.Player.hero_data.totems:getGradeALLCfgByType(self.totem_data.sys_id)
    local max_level_cfg = ex.Player.hero_data.totems:getMaxLevelCfgByType(self.totem_data.sys_id)
    self:updateLevelInfo()
    self:upLevelIcon()
    local grade_attr = (next_level_cfg ~= nil and next_level_cfg.attr ~= "") and clone(next_level_cfg.attr) or nil


    local base_attr --= clone(level_cfg.attr)
    if all_grade_cfg[self.totem_data.quality].needlevel ~= 1 and all_grade_cfg[self.totem_data.quality].needlevel == self.totem_data.level then 
        base_attr = clone(all_grade_cfg[self.totem_data.quality].attr)
    else
        base_attr = clone(level_cfg.attr)
    end

    if grade_attr ~= nil then 
        for i,v in ipairs(grade_attr) do
            for idx,val in ipairs(base_attr) do
                if val.attr == v.attr then 
                    v.value = v.value - val.value
                    break
                end
            end
        end
    end


    self:upAttrPanel(base_attr,grade_attr)
    self:upSkillInfo(all_grade_cfg)
    self:upCost(level_cfg.cost)
    self.btn_up_level:setVisible(self.totem_data.level < max_level_cfg.level)
    self.btn_up_grade:setVisible(false)
    self.lbl_title:setString(ex.Tools:getLang(76802))
end

function TotemInfoLayer:updateLevelInfo( )
    self.lbl_level_quality:setString(ex.Tools:getLang(self.totem_data.quality + 76851))
    self.lbl_level:setString(self.totem_data.level)
    self.max_level:setPositionX(self.lbl_level:getPositionX()+self.lbl_level:getContentSize().width + 5 + self.max_level:getContentSize().width / 2)
    local max_cfg = ex.Player.hero_data.totems:getMaxLevelCfgByType(self.totem_data.sys_id)
    self.max_level:setVisible(self.totem_data.level == max_cfg.level)
    self.btn_reset_max:setVisible(self.totem_data.level == max_cfg.level)
    self.btn_reset:setVisible(self.totem_data.level > 1 and self.is_onclick and self.totem_data.level < max_cfg.level)
    self.btn_change:setVisible(not self.is_onclick or self.totem_data.level == max_cfg.level)
    self.btn_cannel:setVisible(self.is_onclick)
    self.btn_disboard:setVisible(not self.is_onclick)
end

function TotemInfoLayer:updateGradePanel( )
    local all_grade_cfg = ex.Player.hero_data.totems:getGradeALLCfgByType(self.totem_data.sys_id)
    local level_cfg = ex.Player.hero_data.totems:getLevelCfgByType(self.totem_data.sys_id,self.totem_data.level)
    local next_level_cfg = ex.Player.hero_data.totems:getLevelCfgByType(self.totem_data.sys_id,self.totem_data.level + 1)
    local next_grade_cfg = ex.Player.hero_data.totems:getGradeCfgByType(self.totem_data.sys_id,self.totem_data.quality+1)
    self:upGradeIcon(all_grade_cfg[self.totem_data.quality],all_grade_cfg[self.totem_data.quality+1])

    local cur_grade_attr = clone(level_cfg.attr)
    local up_attr = next_level_cfg ~= nil and clone(next_level_cfg.attr)
    if next_grade_cfg ~= nil and next_grade_cfg.needlevel == self.totem_data.level then 

        up_attr = clone(next_grade_cfg.attr)

    end

    if not up_attr then 
        up_attr = clone(all_grade_cfg[#all_grade_cfg].attr)
    end

    for i ,v in ipairs(up_attr) do 
        for idx,val in ipairs(cur_grade_attr) do
            if val.attr == v.attr then 
                v.value = v.value - val.value
                break
            end
        end
    end

    self:upAttrPanel(cur_grade_attr,up_attr)
    self:upSkillInfo(all_grade_cfg,true)
    self:upCost(all_grade_cfg[self.totem_data.quality].cost)
    self.btn_up_level:setVisible(false)
    self.btn_up_grade:setVisible(true)
    self.lbl_title:setString(ex.Tools:getLang(76817))
    self:updateGradeInfo(all_grade_cfg[self.totem_data.quality])
    self.btn_cannel:setVisible(self.is_onclick)
    self.btn_disboard:setVisible(not self.is_onclick)
end

function TotemInfoLayer:updateGradeInfo(grade_cfg)

    self.lbl_cur_quality:setString(ex.Tools:getLang(grade_cfg.quality + 76851))
    self.lbl_next_quality:setString(ex.Tools:getLang(grade_cfg.quality + 1 + 76851))
    local cur_color = ex.Tools:getItemRareColor(cfg.item.item[grade_cfg.totems_id].rare_mark - 1 + grade_cfg.quality)
    local next_color = ex.Tools:getItemRareColor(cfg.item.item[grade_cfg.totems_id].rare_mark + grade_cfg.quality)
    self.lbl_cur_quality:setTextColor(cur_color)
    self.lbl_next_quality:setTextColor(next_color)
end

function TotemInfoLayer:upGradeIcon(cur_cfg,next_cfg)
    self.menu_grade:removeAllChildren()
    local cur_item = UIMenuItemBag:createWithData(cur_cfg.totems_id)
    local next_item = UIMenuItemBag:createWithData(next_cfg.totems_id)
    cur_item:resetBg(nil,cfg.item.item[cur_cfg.totems_id].rare_mark - 1 + cur_cfg.quality)
    next_item:resetBg(nil, cfg.item.item[next_cfg.totems_id].rare_mark - 1 + next_cfg.quality)
    local cur_x,cur_y = self.cur_node:getPosition()
    local next_x,next_y = self.next_node:getPosition()
    cur_item:setPosition(cc.p(cur_x,cur_y))
    next_item:setPosition(cc.p(next_x,next_y))

    self.menu_grade:addChild(cur_item)
    self.menu_grade:addChild(next_item)

    local item_cfg = cfg.item.item[cur_cfg.totems_id]
    local name = ex.Tools:getLang(item_cfg.name)
    self.lbl_cur_name:setString(name)  

    local item_cfg = cfg.item.item[next_cfg.totems_id]
    local name = ex.Tools:getLang(item_cfg.name)
    self.lbl_next_name:setString(name)  
end

function TotemInfoLayer:upCost(cost_cfg)
    for i,v in ipairs(cost_cfg) do
        local icon = self["cost_icon_" .. i]
        local lbl = self["cost_lbl_" .. i]

        local has_num = ex.Player:getItemNum(v.item_type)
        local item_spr = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%s.png",v.item_type))
        icon:setNormalImage(item_spr)
        icon.data = v
        lbl:setString(ex.Tools:convertNumToStr(has_num).. "/" .. ex.Tools:convertNumToStr(v.item_num))
    end
end

function TotemInfoLayer:onCannel( )
    TotemInfoCtr:instance():closeWindow()
end

function TotemInfoLayer:onDisboard(tag,pSender)
    local req = Totems_pb.GReqTotemsOprea()
    req.t_id = self.totem_data.t_id
    req.hero_id = self.hero_id
    req.type = 2
    NetManager:sendMessage(ProtocolID.GReqTotemsOprea, req)
    TotemInfoCtr:instance():closeWindow()
end


function TotemInfoLayer:onItemInfo(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.data.item_type)
end

function TotemInfoLayer:onLevel(tag,pSender)
    if self.is_onclick == false then 

        self.is_onclick = true
        self:changeCostAndOperateMenu(self.is_onclick)
        self:updateView()
    else
        local req = Totems_pb.GReqTotemsUp()
        req.type = 1
        req.t_id = self.totem_data.t_id
        NetManager:sendMessage(ProtocolID.GReqTotemsUp, req)
    end

    
end

function TotemInfoLayer:onGrade(tag,pSender)
    if self.is_onclick == false then 

        self.is_onclick = true
        self:changeCostAndOperateMenu(self.is_onclick)
        self:updateView()
    else
        local req = Totems_pb.GReqTotemsUp()
        req.type = 2
        req.t_id = self.totem_data.t_id
        NetManager:sendMessage(ProtocolID.GReqTotemsUp, req)
    end

    
end

function TotemInfoLayer:changeCostAndOperateMenu(is_onclick)
    self.node_cost:setVisible(is_onclick)
    local y = is_onclick and 0 or 25
    self.menu_operate:setPositionY(y)
end


function TotemInfoLayer:upLevelIcon()
    self.menu_level_icon:removeAllChildren()
    local item = UIMenuItemBag:createWithData(self.totem_data.sys_id)
    item:resetBg(nil,cfg.item.item[self.totem_data.sys_id].rare_mark - 1 + self.totem_data.quality)
    self.menu_level_icon:addChild(item)
    item:setPosition(cc.p(0,0))
    local item_cfg = cfg.item.item[self.totem_data.sys_id]
    local name = ex.Tools:getLang(item_cfg.name)
    self.lbl_name:setString(name)
end

function TotemInfoLayer:upAttrPanel(attr,grade_attr)
    for i=1,2 do
        local node = self["node_attr_" .. i]
        if attr[i] ~= nil then 
            local lbl_name = node:getChildByTag(1)
            local lbl_num = node:getChildByTag(2)
            local spr = node:getChildByTag(3)
            local up_num = node:getChildByTag(4)
            spr:setVisible(grade_attr ~= nil and grade_attr[i] ~= nil)
            up_num:setVisible(grade_attr ~= nil and grade_attr[i] ~= nil)
            local name = ex.Tools:getLang(2150000 + attr[i].attr)
            lbl_name:setString(name)

            local num = ex.StringUtil.formatAttrStr(" +"..ex.Tools:getLang(2160000 + attr[i].attr), "##" , attr[i].value)
            lbl_num:setString(num)

            local x = lbl_name:getPositionX() + lbl_name:getContentSize().width
            lbl_num:setPositionX(x)

            local spr_size = spr:getContentSize()
            spr:setPositionX(lbl_num:getContentSize().width + lbl_num:getPositionX() + 15)

            up_num:setPositionX(spr:getPositionX() + 15)

            if grade_attr ~= nil and grade_attr[i] ~= nil then 
                num = ex.StringUtil.formatAttrStr(ex.Tools:getLang(2160000 + grade_attr[i].attr), "##" , grade_attr[i].value)
                up_num:setString(num)
            end


        end
        node:setVisible(attr[i] ~= nil)
    end
end

function TotemInfoLayer:upSkillInfo(grade_cfg,is_grade)
    for i=1,3 do
        local node = self["skill_" .. i]
        if node ~= nil then 
            local spr = node:getChildByTag(1)
            local lbl = node:getChildByTag(2)
            local path = self.totem_data.quality < grade_cfg[i].quality and "totem/totem-huidian.png" or "totem/totem-huangdian.png"
            print(self.__cname,self.totem_data.quality , grade_cfg[i].quality , i)
            local str = ex.Player.hero_data:getSkillDescription(grade_cfg[i].skill, grade_cfg[i].skill_level)
            local x =  0
            local color = self.totem_data.quality < grade_cfg[i].quality and cc.c3b(153,128,98) or cc.c3b(33,154,0)
            if is_grade then 
                if self.totem_data.quality + 1 == grade_cfg[i].quality then 
                    path = "totem-lang/totem-lang-jijiangjihuo.png"
                    x = -15
                    color = cc.c3b(223,96,33)
                end
            end
            

            
            lbl:setColor(color)

            -- spr:setSpriteFrame(path)
            ex.Tools:setSpriteFrame(spr, path)
            lbl:setString(str)
            spr:setPositionX(x)
        end
    end
end

function TotemInfoLayer:onExit()

end



-----------------------------------------------------------------------------
function TotemInfoCtr:onCreate()
	self:setCCBIPath("ccbi/TotemInfoLayer.ccbi")
	self:setIsSingle(false)
end

function TotemInfoCtr:getLayerClass()
	return TotemInfoLayer
end

function TotemInfoCtr:getTotemInfoLayer()
	return self.layer
end

function TotemInfoCtr:openWindow(hero_id)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/totem-lang.plist")

	self:loadLayer()
    self:open()
    self.layer.hero_id = hero_id
    self.layer.totem_data = ex.Player.hero_data.totems:getTotemByHero(hero_id)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer:updateView()

end

return TotemInfoCtr
