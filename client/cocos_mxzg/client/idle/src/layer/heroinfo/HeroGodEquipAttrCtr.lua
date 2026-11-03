
local HeroGodEquipAttrCtr = class("HeroGodEquipAttrCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local HeroGodEquipAttrLayer = class("HeroGodEquipAttrLayer", require("src.comp.EventLayer"))


function HeroGodEquipAttrLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(false)
	self:addBlackBackground()

	self.height  =  120    -- 默认高度

end 

function HeroGodEquipAttrLayer:resetSize(now_height)
	self:setContentSize(cc.size(self:getContentSize().width, now_height))
	self.bg:setContentSize(self:getContentSize())
	self.show_message:setPositionY(self:getContentSize().height)
	-- self.base_layer:resetSize()
end



function HeroGodEquipAttrLayer:initDone( hero_id)
	self.hero_id = hero_id
	
	self.score:setString("")

	local req = GodEquip_pb.GReqGodEquipFighting()
	req.hero_id = self.hero_id
	NetManager:sendMessage(ProtocolID.GReqGodEquipFighting, req)

	-- 检测神装，有可能是2套的
	local equip_data = ex.Player.backpack_data:getGodEquipByHeroid(hero_id)

	local show_msg = {}
	show_msg.ability = {}
	show_msg.skill = 0
	show_msg.min_star = 0

	local settype_data = {}
	for i,v in ipairs(equip_data) do
		local equip_ment_config = cfg.godequipment.godequipment[v.item_type]
		if not settype_data[equip_ment_config.settype] then 
			settype_data[equip_ment_config.settype] = {}
		end 
		-- 先行计算，基础属性，还有随机属性
		for ai,av in ipairs(equip_ment_config.ability) do
			table.insert( show_msg.ability, av )
		end
		-- 
		for vi,vv in ipairs(v.attrs) do
			local rand_attr = ex.Player.backpack_data:getgodequipmentrandomability( equip_ment_config.place, equip_ment_config.star, vv.sys_id, vv.level)
			for ki,kv in ipairs(rand_attr) do
				table.insert( show_msg.ability, kv )
			end 
		end

		table.insert( settype_data[equip_ment_config.settype], equip_ment_config.star )
	end

	-- 开始计算属性
	for kk,kv in pairs(settype_data) do
		-- Kk peizhi 
		local nums = #kv
		local min_star = 1000
		for vi,vv in ipairs(kv) do
			if 	min_star > vv then 
				min_star = vv
			end 
		end
		for i,v in ipairs(cfg.godequipmentsettype.godequipmentsettype) do
			if kk == v.settype and min_star == v.star and nums >= v.num then 
				if v.ability ~= "" then 
					for ai,av in ipairs(v.ability) do
						table.insert( show_msg.ability, av )
					end
				end 
				if v.skill ~= 0 then 
					show_msg.skill = v.skill
					show_msg.min_star = min_star
				end 
			end 
		end 
	end

	-- 重新组合数据
	local show_ability = {}
	for i,v in ipairs(show_msg.ability) do

		if not show_ability[v.attr] then 
			show_ability[v.attr] = 0
		end 
		show_ability[v.attr] = show_ability[v.attr] + v.value
	end
	local index = -1	
	local show_index= 0
	-- 开始展示数据
	if #show_msg.ability > 0 then
			
		for ia,va in pairs(show_ability) do
			show_index = show_index + 1
			index = index + 1
			local attr_show_type = cfg.attrshow.attrshow[ia].icon
			local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack-info/spr-attr-%d.png", attr_show_type))
			spr_icon:setScale(0.6)
			:setAnchorPoint(cc.p(0, 0.5))
			spr_icon:setPosition( (index % 2) * 200 ,  - math.floor(index / 2) * 30    )
			self.show_attr:addChild(spr_icon)

			local str = ex.Tools:getLang(2150000 + ia)..":"
			local lbl_ability = cc.Label:createWithTTF(str, FONT_DEFAULT_NAME_BOLD, 20)
			:setTextColor(cc.c3b(255,224,178))
			:setAnchorPoint(cc.p(0, 0.5))
			lbl_ability:setPosition( spr_icon:getPositionX() +  spr_icon:getContentSize().width, spr_icon:getPositionY())
			self.show_attr:addChild(lbl_ability)
	

			local attstr = ex.Tools:getLang(2141000 + ia)
			local flag = ex.StringUtil.formatAttrStrBool(attstr, "##" , va, "<font color='#219A00'>%s</font>")

			local show_nums_str = tostring(va)
			if flag == true then 
				show_nums_str = string.format("%.1f", va / 100) .. "%"
			end 

			local lbl_ability_num = cc.Label:createWithTTF(show_nums_str, FONT_DEFAULT_NAME_BOLD, 20)
			:setTextColor(cc.c3b(255,255,178))
			:setAnchorPoint(cc.p(0, 0.5))
			:setPosition(lbl_ability:getPositionX() + lbl_ability:getContentSize().width + 10, lbl_ability:getPositionY())
			self.show_attr:addChild(lbl_ability_num)
		end
	end 

	-- 计算出高度
	local now_height = self.height + math.ceil(show_index / 2) * 46
	self:resetSize(now_height )


	self.is_skill:setVisible(false)
	if show_msg.skill > 0 then 
		self.is_skill:setVisible(true)
		self.is_skill:setPositionY(-now_height)

		local skill_config = cfg.heroskill.getConfigByType(show_msg.skill, show_msg.min_star)
		local str = string.format( ex.Tools:getLang(47331), ex.Tools:getLang(skill_config.lan_name))
		self.skill_name:setString(str)

		local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("skill-icon/%d.png", skill_config.type))
		spr_icon:setScale(1)
		:setAnchorPoint(cc.p(0.5, 0.5))
		spr_icon:setPosition(0,0)
		self.skill_node:addChild(spr_icon)

		self.skill_msg:setString(ex.Tools:getLang(skill_config.lan_describe))

		self:resetSize(now_height + 150)

	end 

end


function HeroGodEquipAttrLayer:showFighting( fighting)
	self.score:setString(ex.Tools:getLang(72513) .. fighting)
end
------------------------------------------------
function HeroGodEquipAttrCtr:onCreate()
	self:setCCBIPath("ccbi/HeroGodEquipAttrLayer.ccbi")
	self:setIsSingle(false)
end

function HeroGodEquipAttrCtr:getLayerClass()
	return HeroGodEquipAttrLayer
end

function HeroGodEquipAttrCtr:openWindow( hero_id)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/backpack-info.plist")
	sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

	self:loadLayer()
	self:open()
    self.layer:initDone(hero_id)
   --  self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

end

function HeroGodEquipAttrCtr:showFighting( fighting)
	
	self.layer:showFighting(fighting)
end 

return HeroGodEquipAttrCtr