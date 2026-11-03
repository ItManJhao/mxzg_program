--[[
    func: 星盘技能选择界面
    author:徐东浩
    time:2020-04-29 23:03:30
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local HeroAstrolabeSelectSkillCtrl = class("HeroAstrolabeSelectSkillCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroAstrolabeSelectSkillLayer = class("HeroAstrolabeSelectSkillLayer", require("src.comp.EventLayer"))

function HeroAstrolabeSelectSkillLayer:onCreate()
    self:addBlackBackground()

    self.btn_skill_callback = nil
    self.btn_need_materials = nil

    self.ui_nodes = {
        [1] = {
            btn = self.btn_skill_1,
            node_label = self.node_label_1,
            border = nil,
            lbl_desc = self.lbl_desc_1,
            lbl_value = self.lbl_value_1
        },
        [2] = {
            btn = self.btn_skill_2,
            node_label = self.node_label_2,
            border = nil,
            lbl_desc = self.lbl_desc_2,
            lbl_value = self.lbl_value_2
        },
        [3] = {
            btn = self.btn_skill_3,
            node_label = self.node_label_3,
            border = nil,
            lbl_desc = self.lbl_desc_3,
            lbl_value = self.lbl_value_3
        },
        [4] = {
            btn = self.btn_skill_4,
            node_label = self.node_label_4,
            border = nil,
            lbl_desc = self.lbl_desc_4,
            lbl_value = self.lbl_value_4
        },
        [5] = {
            btn = self.btn_skill_5,
            node_label = self.node_label_5,
            border = nil,
            lbl_desc = self.lbl_desc_5,
            lbl_value = self.lbl_value_5
        },
    }

    local btn_size = self.ui_nodes[1].btn:getContentSize()
    for i,v in ipairs(self.ui_nodes) do
        v.btn:registerScriptTapHandler(handler(self, self.onSkill))
        v.btn.local_data = {idx = 0}
        
        v.border = cc.Sprite:createWithSpriteFrameName("astrolabe/spr_select.png")
        v.border:setScale(0.78)
        -- v.border:setBlendFunc({src = gl.ONE, dst = gl.ONE_MINUS_SRC_ALPHA})
		v.border:setPosition(cc.p(btn_size.width / 2, btn_size.height / 2))
        v.btn:addChild(v.border, 20)

        v.border:setVisible(false)
    end
end

function HeroAstrolabeSelectSkillLayer:refershSkillPanel(configs, actived_idx)
    local is_actived = actived_idx ~= 0
    configs = configs or {}

    for i, v in ipairs(self.ui_nodes) do
        local config = configs[i]

        v.btn:setVisible(config ~= nil)
        v.node_label:setVisible(config ~= nil)

        if config then
            v.btn.local_data = {idx = config.idx}

            v.btn:setNormalImage(cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", config.skill_type)))

            local text = string.format(ex.Tools:getLang(config.language), ex.Tools:getLang(2100 + config.attrs[1].element), ex.Tools:getLang(122000 + config.attrs[1].attr))
            v.lbl_desc:setString(text)
            v.lbl_value:setString(string.format("+%d%%", config.attrs[1].value / 100))

            if is_actived then
                ex.Tools:setGrayAuto(v.btn:getNormalImage(), actived_idx ~= config.idx)

                v.btn:setEnabled(actived_idx == config.idx)
            end
        end
    end
end

function HeroAstrolabeSelectSkillLayer:setNeedMaterials(item_type, cur_num, need_num)
    if self.btn_need_materials then
        self.btn_need_materials:removeFromParent()
        self.btn_need_materials = nil
    end
    
    self.btn_need_materials = ex.Tools:createBackpackItem(item_type, 0)
    self.btn_need_materials:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
    self.btn_need_materials:setPosition(self.node_item:getPosition())
    self.btn_need_materials:setScale(0.75)
    self.menu:addChild(self.btn_need_materials)
    
    self.lbl_num:setString(string.format("%d/%d", cur_num, need_num))
    self.lbl_num:setColor(cur_num < need_num and cc.c3b(255, 0, 0) or cc.c3b(0, 255, 0))
end

function HeroAstrolabeSelectSkillLayer:setSelectSkill(idx)
    for i, v in ipairs(self.ui_nodes) do
        v.border:setVisible(v.btn.local_data.idx == idx)
    end
end

function HeroAstrolabeSelectSkillLayer:onSkill(tag ,pSender)
    if self.btn_skill_callback then
        self.btn_skill_callback(pSender.local_data.idx)
    end
end

function HeroAstrolabeSelectSkillLayer:setActived(is_actionable, is_actived)
    if is_actived then
        self.btn_active:setVisible(false)
        self.node_item:setVisible(false)
        if self.btn_need_materials then self.btn_need_materials:setVisible(false) end
		self.lbl_actived:setVisible(true)

		self.lbl_actived:setString(ex.Tools:getLang(4113))
	else
        if is_actionable then
            self.node_item:setVisible(true)
            if self.btn_need_materials then self.btn_need_materials:setVisible(true) end
			self.btn_active:setVisible(true)
			self.lbl_actived:setVisible(false)
        else
            self.node_item:setVisible(false)
            if self.btn_need_materials then self.btn_need_materials:setVisible(false) end
			self.btn_active:setVisible(false)
			self.lbl_actived:setVisible(true)

			self.lbl_actived:setString(ex.Tools:getLang(4112))
		end
    end
end

-----------------------------------------------------------------------------
function HeroAstrolabeSelectSkillCtrl:onCreate()
    self:setCCBIPath("ccbi/HeroAstrolabeSelectSkillLayer.ccbi")
    
    self:setIsSingle(false)

    self.idx = 0
    self.select_skill_idx = 0
    self.config = nil
    self.skill_config = {}
    self.is_actived = false
    self.is_actionable = false
end

function HeroAstrolabeSelectSkillCtrl:openWindow(idx)
	if self:isOpened() then
		return
    end
    
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

    self.idx = idx

    self:refreshData()
    
	self:loadLayer()
    self:open()
    
	self:init()
end

function HeroAstrolabeSelectSkillCtrl:refreshData()
    self.config = cfg.astrolabe.getConfigByIdx(self.idx)
    self.skill_config = {}
    self.select_skill_idx = self.config.skills[1]
    self.is_actived = ex.Player.hero_data.astrolabe:isActivedByStar(self.idx)

    local star_actionable_idx = ex.Player.hero_data.astrolabe:getNextStarActionable()
    self.is_actionable = star_actionable_idx == self.idx

    if cfg.astrolabe.isSkillByIdx(self.idx) then
        for i, v in ipairs(self.config.skills) do
            local config = cfg.astrolabeskill.getConfigByIdx(v)
            table.insert(self.skill_config, config)
        end
    end
end

function HeroAstrolabeSelectSkillCtrl:getLayerClass()
	return HeroAstrolabeSelectSkillLayer
end

function HeroAstrolabeSelectSkillCtrl:closeWindow()
    self:close(self.layer)
end

function HeroAstrolabeSelectSkillCtrl:init()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_active:registerScriptTapHandler(handler(self, self.onActive))

    self.layer.btn_skill_callback = handler(self, self.onSkill)

	self:updateLayer()
end

function HeroAstrolabeSelectSkillCtrl:updateLayer()
    local actived_idx = 0
    if self.is_actived then
        actived_idx = ex.Player.hero_data.astrolabe:getSkillByIdx(self.idx) or 0

        if actived_idx ~= 0 then    -- 选中已激活
            self.select_skill_idx = actived_idx
        end
    end
    self.layer:refershSkillPanel(self.skill_config, actived_idx)
    
    self.layer:setSelectSkill(self.select_skill_idx)

    if not self.is_actived then
        local cur_num = ex.Player:getItemNum(self.config.cost[1].item_type)
        self.layer:setNeedMaterials(self.config.cost[1].item_type, cur_num, self.config.cost[1].item_num)
    end

    self.layer:setActived(self.is_actionable, self.is_actived)
end

--------------------------响应处理--------------------------
function HeroAstrolabeSelectSkillCtrl:onActive()
    if ex.Player.hero_data.astrolabe.max_star < self.config.star then
		ex.MessageView:add(ex.Tools:getLang(4115))
		return
    end
    
    local cur_num = ex.Player:getItemNum(self.config.cost[1].item_type)
    if cur_num < self.config.cost[1].item_num then
        ex.MessageView:add(ex.Tools:getLang(4102))
        return
    end

    local req = Astrolabe_pb.GReqAstrolabeLight()
    req.idx = self.idx
    req.skill_id = self.select_skill_idx
    NetManager:sendMessage(ProtocolID.GReqAstrolabeLight, req)

    self:closeWindow()
end

function HeroAstrolabeSelectSkillCtrl:onSkill(idx)
    if self.select_skill_idx == idx then  return end

    self.select_skill_idx = idx

    self.layer:setSelectSkill(self.select_skill_idx)
end

return HeroAstrolabeSelectSkillCtrl
