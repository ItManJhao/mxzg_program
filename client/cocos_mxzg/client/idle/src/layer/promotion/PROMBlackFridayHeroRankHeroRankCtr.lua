--[[
* @Description: 黑色星期五 - 英雄排行 英雄积分排行
* @Author: 熊梦
* @Date: 2021-3-2 1:26:00
* ]]

local PROMBlackFridayHeroRankHeroRankCtr = class("PROMBlackFridayHeroRankHeroRankCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMBlackFridayHeroRankHeroRankLayer = class("PROMBlackFridayHeroRankHeroRankLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIItemHero = require("src.comp.menu.UIMenuItemHero")

local PROMBlackFridayHeroRankHeroRankCell = class("PROMBlackFridayHeroRankHeroRankCell", require("src.comp.LuaLayerBase"))
---------------------------------------------------------------------------------
function PROMBlackFridayHeroRankHeroRankCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

end

function PROMBlackFridayHeroRankHeroRankCell:initData(data)
    if data == nil then
        return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/prom-blackfriday.plist")

	local hero_data = cfg.herotype.star[data.hero_type] 
	local item = UIItemHero:createWithData("0", hero_data.type, hero_data.elem, 1, hero_data.star)
    item.type = hero_data.type
    item:autoLocked()
    item:setSelected(false)
	item:setPosition(self.spr_frame:getPosition())
	self.node_touxiang:addChild(item)

	self.btn_photo:setContentSize(item:getContentSize())

    local name = cfg.item.item[data.hero_type].name
    self.lbl_name:setString(ex.Tools:getLang(name))

    self.lbl_num:setString(data.score)
	
	if data.rank <= 3 then
        self.spr_rank:setSpriteFrame(string.format("prom-blackfriday/spr-prom-92-%dst.png", data.rank))
        self.lbl_rank:setVisible(false)
    else
        self.spr_rank:setVisible(false)
        self.lbl_rank:setString(ex.StringUtil.getServerName(data.rank))
    end

end

function PROMBlackFridayHeroRankHeroRankCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

---------------------------------------------------------------------------------

function PROMBlackFridayHeroRankHeroRankLayer:onCreate()
    self:addBlackBackground()
	self:registerBtnEvent()
end

-- 关闭按钮
function PROMBlackFridayHeroRankHeroRankLayer:registerBtnEvent( )
	local ctr = PROMBlackFridayHeroRankHeroRankCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end


function PROMBlackFridayHeroRankHeroRankLayer:initData()

	self.scroll_view:setItemSize(cc.size(560, 140))
    self.scroll_view:setItemType(1)

	local req = Promotion092_pb.GReqHeroScoreRank()
	NetManager:sendMessage(ProtocolID.GReqHeroScoreRank, req)


	-- self:updateScrollView()

	self:addEvent(EVENT.BLACKFRIDAY.EVENT_UPDATA_HERO_SCORE, handler(self, self.updateScrollView))
end


function PROMBlackFridayHeroRankHeroRankLayer:updateScrollView()

	local list = ex.Player.promotion_data.promotion92_data.hero_rank_list

    self.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = PROMBlackFridayHeroRankHeroRankCell:createWithCCBIFile("ccbi/PROMBlackFridayHeroRankHeroRankCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data)
        return cell
    end

    self.scroll_view:reloadData(list)

end



---------------------------------------------------------------------------------

function PROMBlackFridayHeroRankHeroRankCtr:onCreate()
	self:setCCBIPath("ccbi/PROMBlackFridayHeroRankHeroRankLayer.ccbi")
	self:setIsSingle(false)
end

function PROMBlackFridayHeroRankHeroRankCtr:getLayerClass()
	return PROMBlackFridayHeroRankHeroRankLayer
end

function PROMBlackFridayHeroRankHeroRankCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
	self.layer:initData()
end

return PROMBlackFridayHeroRankHeroRankCtr
