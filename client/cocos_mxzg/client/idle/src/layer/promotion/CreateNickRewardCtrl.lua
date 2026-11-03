local CreateNickRewardCtrl = class("CreateNickRewardCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CreateNickRewardLayer = class("CreateNickRewardLayer", require("src.comp.EventLayer"))

--------------------------------------------

function CreateNickRewardLayer:onCreate()
    -- local bg_size = cc.size(ex.p.width - 18, ex.p.height - 100)
    -- self:setContentSize(cc.size(ex.p.width, ex.p.height))
    self:resetScaleAtWidth(true)
    self:addBlackBackground()
    -- local content_size = self:getContentSize()
    -- self:setScale(ex.p.width / content_size.width)
    -- self:setPosition(cc.p(ex.p.width / 2 - content_size.width / 2 * self:getScale() , ex.p.height / 2 - content_size.height / 2  * self:getScale()))


    -- self.spr_bg:setPreferredSize(bg_size)

    self.gift_menu = cpp.UIMenu:create()
    self.gift_menu:setIsTouchInsideNode(self.scroll_view)
    self.gift_menu:setSwallowsTouches(false)
    self.gift_menu:setPosition(0,0)
    self.scroll_view:getContainer():addChild(self.gift_menu)
    self.scroll_view:setLocalZOrder(100)
    self.gift_menu:setLocalZOrder(110)

end

function CreateNickRewardLayer:onExit()
    
end

-----------------------------------------------------------------------------
function CreateNickRewardCtrl:onCreate()
	self:setCCBIPath("ccbi/CreateNickRewardLayer.ccbi")
    self:setIsSingle(false)
    
    self.config = {}
end

function CreateNickRewardCtrl:getLayerClass()
	return CreateNickRewardLayer
end

function CreateNickRewardCtrl:getCreateNickRewardLayer()
	return self.layer
end

function CreateNickRewardCtrl:openWindow()
	if self:isOpened() then
		return
    end
    
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/create-nick-reward.plist")

    self:loadLayer()
    self:open()
    
    self.layer.btn_take:setName("btn_name")
    self.layer.btn_take:registerScriptTapHandler(handler(self, self.onTakeBtn))
	self:initData()
end

function CreateNickRewardCtrl:initData()
    self.config = {}
    self.config.reward = ex.Tools:getSysCfg("guide_initial_reward") or {} -- cfg.promotionnewgift.promotionnewgift[1] or {}
    
	self:updateView()
end

function CreateNickRewardCtrl:updateView()
    print("CreateNickRewardCtrl:updateView")

    local tags = {
        [1] = 'other/tag-jp.png',
        [2] = 'other/tag-hl.png',
    }
    
    local space = 10
    local margin = 15
    local item_size = {}
    local item_scale = 0.85
    local count = table.nums(self.config.reward)
    for i,v in ipairs(self.config.reward) do
        local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        item:setScale(item_scale)
        self.layer.gift_menu:addChild(item)

        item_size = item:getContentSize()
        item:setPosition((i - 0.5) * (item_size.width * item_scale + space + margin), item_size.height * item_scale / 2)
        local tagPath = tags[v.tag or 0]
        if tagPath then
            local posY = item_size.height
            local tagSprite = cc.Sprite:createWithSpriteFrameName(tagPath)
            tagSprite:setAnchorPoint(cc.p(0.5, 0.5))
            tagSprite:setLocalZOrder(100000)
            tagSprite:setPosition(
                0.5*tagSprite:getContentSize().width*item_scale * 0.3,
                (item_size.height - 0.5*tagSprite:getContentSize().height*item_scale)*1.2
            )
            item:addChild(tagSprite)
        end
    end

    if count > 0 then
        local anchorX, anchorY = self.layer.scroll_view_anchor:getPosition()
        local view_count = math.min(4, count)
        local view_size = cc.size((view_count + 0.5) * (item_size.width * item_scale + space), item_size.height * item_scale + 10)
        self.layer.scroll_view:setViewSize(view_size)
        self.layer.scroll_view:setPosition(cc.p(anchorX - view_size.width / 2, anchorY - view_size.height / 2))
        self.layer.scroll_view:setContentSize(cc.size(count * (item_size.width * item_scale + space + margin), view_size.height))
    end
end

function CreateNickRewardCtrl:onTakeBtn(tag,pSender)
    -- -- 发放奖励
    -- for k,v in pairs(self.config.reward) do
    --     ex.Tools:addBackpackMsg(v.item_type, v.item_num)
    -- end

    NetManager:sendMessage(ProtocolID.GReqGetNewbieReward)

    local listener = nil
    listener = ex.EventManager:add(EVENT.BACKPACK_RES_CHANGE.FIRST_REWARD, function()
        ex.EventManager:remove(listener)
        require("src.layer.FirstItemRewardCtr"):instance():openWindow()
        self:closeWindow()
    end)
end

return CreateNickRewardCtrl
