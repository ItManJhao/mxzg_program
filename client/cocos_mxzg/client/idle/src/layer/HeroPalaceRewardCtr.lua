local HeroPalaceRewardCtr = class("HeroPalaceRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroPalaceRewardLayer = class("HeroPalaceRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))

local HeroPalaceRewardCell = class("HeroPalaceRewardCell", require("src.comp.LuaLayerBase"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function HeroPalaceRewardCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

    -- 添加红点
    self.btn_reward.spr_reddot = cc.Sprite:createWithSpriteFrameName("other/spr-reddot-1.png")
    self.btn_reward.spr_reddot:setPosition(self.btn_reward:getContentSize().width * 0.9, self.btn_reward:getContentSize().height * 0.8)
    self.btn_reward.spr_reddot:setVisible(false)
    self.btn_reward:addChild(self.btn_reward.spr_reddot, 100)
end

function HeroPalaceRewardCell:reset(data)
	self.btn_reward.data = data

	if self.item ~= nil then
		self.item:removeFromParent()
		self.item = nil
	end

	local config = cfg.item.item[data.reward[1].item_type]

	self.item = UIMenuItemBackpack:createWithData(data.reward[1].item_type, 0)
	self.item:setPosition(80, 75)
	self:addChild(self.item, 10)

	self.lbl_name:setString(ex.Tools:getLang(config.name))
	self.lbl_desc:setString(ex.Tools:getLang(data.tips))

	self.btn_reward:setEnabled(data.reward_status == 0)
	if data.reward_status == -1 then
		self.btn_reward:setLabelText(ex.Tools:getLang(47620))
	elseif data.reward_status == 1 then
		self.btn_reward:setLabelText(ex.Tools:getLang(47677))
	else
		self.btn_reward:setLabelText(ex.Tools:getLang(47695))
		self.btn_reward.spr_reddot:setVisible(true)
	end
end

-----------------------------------------------------------------------------
function HeroPalaceRewardLayer:onCreate()
	self:addBlackBackground()

	self.lbl_title:setString(ex.Tools:getLang(73401))

    local item_size = cc.size(540, 160)
    
    self.scroll_view.margin = 2.5
    self.scroll_view:setCreateNum(3)
    self.scroll_view:setTouchEnabled(false)
    self.scroll_view:setItemSize(item_size)
	self.scroll_view:setItemType(1)
end

-----------------------------------------------------------------------------
function HeroPalaceRewardCtr:onCreate()
	self:setCCBIPath("ccbi/HeroPalaceRewardLayer.ccbi")
	self:setIsSingle(false)
end

function HeroPalaceRewardCtr:getLayerClass()
	return HeroPalaceRewardLayer
end

function HeroPalaceRewardCtr:getHeroPalaceRewardLayer()
	return self.layer
end

function HeroPalaceRewardCtr:openWindow(type,sever)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initDone(type,sever)
end

function HeroPalaceRewardCtr:initDone(type,sever)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer:addEvent(EVENT.HERO_PALACE_EVENT.UPDATE_LAYER, handler(self, self.updateScrollView))

	self.type = type

	self.cur_sever_select = sever
	
	self:updateScrollView()
end

function HeroPalaceRewardCtr:updateScrollView()
	-- 获取配置数据
	local vec_data = {}
	for k,v in pairs(cfg.heropalace.heropalace) do
		if v.type == self.type then
			table.insert(vec_data, clone(v))
		end
	end
	table.sort(vec_data, function(a, b)
		return a.rank < b.rank
	end)

	-- 判断是否可以领取 -1:不可领取；0：可领取；1：已领取
    local hero_palace_data = nil
	for k,v in pairs(ex.Player.hero_data.hero_palace_list) do
        if v.type == self.type then
            local table_data = {}
            table_data.is_reward = v.is_reward
            table_data.is_worship = v.is_worship
            for j,n in pairs(v.server_rank_role) do
                if n.server_id == self.cur_sever_select then
					table_data.rank_role = n.rank_role
					hero_palace_data = table_data
                    break
                end
            end
			break
		end
    end

	for i,v in ipairs(vec_data) do
		if hero_palace_data ~= nil and 
			hero_palace_data.rank_role[v.rank] ~= nil and 
			hero_palace_data.rank_role[v.rank].player_id == ex.Player.role_id then
			v.reward_status = (hero_palace_data.is_reward == true and 1 or 0)
		else
			v.reward_status = -1
		end
	end

	-- 刷新显示
	self.layer.scroll_view:getContainer():removeAllChildren()
	self.layer.scroll_view.createItemFunction = function(data)
		local cell = HeroPalaceRewardCell:createWithCCBIFile("ccbi/HeroPalaceRewardCell.ccbi")
			cell:setIgnoreAnchorPointForPosition(false)
			cell:setAnchorPoint(0.5, 0.5)
		
			cell:reset(data)

			cell.btn_reward:registerScriptTapHandler(handler(self, self.onReward))
		
			return cell
	end
	self.layer.scroll_view:reloadData(vec_data)
end

function HeroPalaceRewardCtr:onReward(tag, pSender)
	local data = pSender.data

	local req = HeroPalace_pb.GReqHeroPalaceGetReward()
	req.type = self.type
	NetManager:sendMessage(ProtocolID.GReqHeroPalaceGetReward, req)
end

return HeroPalaceRewardCtr
