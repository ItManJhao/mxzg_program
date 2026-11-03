--[[
* @Description: 黑色星期五 - 英雄排行 英雄选择界面
* @Author: 熊梦
* @Date: 2021-3-2 1:26:00
* ]]

local PROMBlackFridayHeroRankHeroChoiceCtr = class("PROMBlackFridayHeroRankHeroChoiceCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMBlackFridayHeroRankHeroChoiceLayer = class("PROMBlackFridayHeroRankHeroChoiceLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIItemHero = require("src.comp.menu.UIMenuItemHero")
---------------------------------------------------------------------------------

function PROMBlackFridayHeroRankHeroChoiceLayer:onCreate()
    self:addBlackBackground()
	self:registerBtnEvent()
end

-- 关闭按钮
function PROMBlackFridayHeroRankHeroChoiceLayer:registerBtnEvent( )
	local ctr = PROMBlackFridayHeroRankHeroChoiceCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))
end

function PROMBlackFridayHeroRankHeroChoiceLayer:initData( )
    self.hero_data = {}
   
    self:addEvent(EVENT.BLACKFRIDAY.EVENT_CHOOSE_HEROES, handler(self,self.close))
end

function PROMBlackFridayHeroRankHeroChoiceLayer:onSelect(item_data,tag)
    self["node_hero_"..tag]:removeAllChildren()
    local item = UIItemHero:createWithData("0", item_data.type, item_data.elem, 1, item_data.star)
    item.type = item_data.type
    item:autoLocked()
    item:setSelected(false)
    self["node_hero_"..tag]:addChild(item)

    self.hero_data[tag] = item_data
end


function PROMBlackFridayHeroRankHeroChoiceLayer:onChoice(tag, pSender)
    require("src.layer.promotion.PROMBlackFridayHeroRankHeroChoicePanelCtr"):instance():openWindow(tag,
                                                                                                handler(self, self.onSelect),
                                                                                                self.hero_data)
end

function PROMBlackFridayHeroRankHeroChoiceLayer:onConfirm(tag, pSender)
    if #self.hero_data < 3 then 
        ex.MessageView:add(ex.Tools:getLang(100050))
        return 
    end

    local req = Promotion092_pb.GReqDeliverFlowerSelectHero()
    for i,v in ipairs(self.hero_data) do
        table.insert( req.hero_type, v.type )
    end
    NetManager:sendMessage(ProtocolID.GReqDeliverFlowerSelectHero, req)
end

function PROMBlackFridayHeroRankHeroChoiceLayer:close()
    local ctr = PROMBlackFridayHeroRankHeroChoiceCtr:instance()
    ctr:closeWindow()
end
---------------------------------------------------------------------------------

function PROMBlackFridayHeroRankHeroChoiceCtr:onCreate()
	self:setCCBIPath("ccbi/PROMBlackFridayHeroRankHeroChoiceLayer.ccbi")
	self:setIsSingle(false)
end

function PROMBlackFridayHeroRankHeroChoiceCtr:getLayerClass()
	return PROMBlackFridayHeroRankHeroChoiceLayer
end

function PROMBlackFridayHeroRankHeroChoiceCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
    self.layer:initData()
end

return PROMBlackFridayHeroRankHeroChoiceCtr
