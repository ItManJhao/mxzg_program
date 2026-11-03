local FriendCtr = class("FriendCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FriendLayer = class("FriendCtr", require("src.comp.EventLayerAdaptiveWidth"))
local FriendCell =  require("src.layer.friend.FriendCell")
local PopupMenuCtr = require("src.layer.PopupMenuCtr"):instance()
local ConfirmCtr = require("src.layer.ConfirmCtr"):instance() 
local FriendSearchCtr = require("src.layer.friend.FriendSearchCtr"):instance()

-- local FRIEND_LAYER_TYPE = {
--     FRIEND_LIST = 1,
--     GIFT_LIST = 2,
--     REQUEST_LIST = 3,
--     BLACK_LIST = 4,
-- }

function FriendLayer:getAsynImage()
    local vec_image = {
    }
    return vec_image
end

function FriendLayer:onCreate()
    self:addBlackBackground()

    self.select_role_id = "0"
    self.cell_data = ex.Player.friend_data:getDataByLayerType(FRIEND_LAYER_TYPE.FRIEND_LIST)
    self.layer_type = FRIEND_LAYER_TYPE.FRIEND_LIST

	self.btn_friend:setLabelText(ex.Tools:getLang(47046))
    self.btn_reward:setLabelText(ex.Tools:getLang(47362))
    self.btn_request:setLabelText(ex.Tools:getLang(47657))
    self.btn_black_list:setLabelText(ex.Tools:getLang(47485))

    self.btn_friend:setLabelScale(0.6,0.6)
    self.btn_reward:setLabelScale(0.6,0.6)
    self.btn_request:setLabelScale(0.6,0.6)
    self.btn_black_list:setLabelScale(0.6,0.6)

    self.btn_friend:setLabelOffset(cc.p(0, -2))
    self.btn_reward:setLabelOffset(cc.p(0, -2))
    self.btn_request:setLabelOffset(cc.p(0, -2))
    self.btn_black_list:setLabelOffset(cc.p(0, -2))
    
    self.btn_friend:setTag(FRIEND_LAYER_TYPE.FRIEND_LIST)
    self.btn_reward:setTag(FRIEND_LAYER_TYPE.GIFT_LIST)
    self.btn_request:setTag(FRIEND_LAYER_TYPE.REQUEST_LIST)
    self.btn_black_list:setTag(FRIEND_LAYER_TYPE.BLACK_LIST)

    self.btn_friend:setChecked(self.layer_type == FRIEND_LAYER_TYPE.FRIEND_LIST)
    self.btn_reward:setChecked(self.layer_type == FRIEND_LAYER_TYPE.GIFT_LIST)
    self.btn_request:setChecked(self.layer_type == FRIEND_LAYER_TYPE.REQUEST_LIST)
    self.btn_black_list:setChecked(self.layer_type == FRIEND_LAYER_TYPE.BLACK_LIST)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_HYAN_HYTJ, self.btn_request)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_HYAN_HYLW, self.btn_reward)
    self.layer = {}
    self.layer[FRIEND_LAYER_TYPE.FRIEND_LIST] = require("src.layer.friend.FriendListLayer"):createWithCCBIFile("ccbi/FriendListLayer.ccbi")
    self.layer[FRIEND_LAYER_TYPE.GIFT_LIST] = require("src.layer.friend.FriendGivedLayer"):createWithCCBIFile("ccbi/FriendGivedLayer.ccbi")
    self.layer[FRIEND_LAYER_TYPE.REQUEST_LIST] = require("src.layer.friend.FriendRequestLayer"):createWithCCBIFile("ccbi/FriendRequestLayer.ccbi")
    self.layer[FRIEND_LAYER_TYPE.BLACK_LIST] = require("src.layer.friend.FriendBlackListLayer"):createWithCCBIFile("ccbi/FriendBlackListLayer.ccbi")
    for i,v in ipairs(self.layer) do
        self:addChild(v)
        v:setPosition(0,0)
        v:setVisible(i == self.layer_type)
    end
    
    self:addEvent(EVENT.FRIEND_EVENT.UPDATE_FRIEND_LIST,handler(self,self.updateList))
    self:addEvent(EVENT.FRIEND_EVENT.UPDATE_BLACK_LIST,handler(self,self.updateList))
    self:addEvent(EVENT.FRIEND_EVENT.DELETE_FRIEND,handler(self,self.onDeleteFriend))
    self:addEvent(EVENT.FRIEND_EVENT.ONE_KEY_REWARD,handler(self,self.updateOneKey))
    self:addEvent(EVENT.FRIEND_EVENT.GET_FRIEND_REWARD,handler(self,self.updateOneKey))
    self:addEvent(EVENT.FRIEND_EVENT.ONE_KEY_GIVED,handler(self,self.updateOneKeyGived))
    self:addEvent(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM,handler(self,self.updateFriendNum))
end

function FriendLayer:onDeleteFriend(event,data)
    self.layer[self.layer_type]:updateView(true)
end

function FriendLayer:updateList(event,data)
    self.layer[self.layer_type]:updateView()
end

function FriendLayer:updateOneKey(event,data)
    self.layer[self.layer_type]:updateView()
end

function FriendLayer:updateOneKeyGived(event,data)
    if self.layer_type ~= FRIEND_LAYER_TYPE.FRIEND_LIST then return end 
    
    self.cell_data = ex.Player.friend_data:getDataByLayerType(self.layer_type)
    self.layer[self.layer_type]:updateView()
end

function FriendLayer:onExit()
    -- self.select_role_id = nil
    self.layer_type = nil
    FriendCtr:instance().delete_status = false
end

-- 刷新好友数量
function FriendLayer:updateFriendNum()
    local layer = self.layer[self.layer_type]
    if layer.updateFriendNum then 
        layer:updateFriendNum()
    end
end

---------------------------------

function FriendCtr:onCreate()
    self:setCCBIPath("ccbi/FriendLayer.ccbi")
    
    self:setIsSingle(false)
end

function FriendCtr:getLayerClass()
    return FriendLayer
end

function FriendCtr:getLayer()
    return self.layer
end

function FriendCtr:initData()
    self.layer.btn_friend:registerScriptTapHandler(handler(self, self.changeTab))
    self.layer.btn_reward:registerScriptTapHandler(handler(self, self.changeTab))
    self.layer.btn_request:registerScriptTapHandler(handler(self, self.changeTab))
    self.layer.btn_black_list:registerScriptTapHandler(handler(self, self.changeTab))

    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    NetManager:sendMessage(ProtocolID.GReqFriendsList)
end

function FriendCtr:openWindow(layer_type)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

    self.delete_status = false

    self:loadLayer()
    self:open()
    
    self:initData()

    if layer_type ~= nil then
        self:changeTab(layer_type)
    end
end

function FriendCtr:changeTab(tag, pSender)
    if self.layer == nil or self.layer.layer_type == tag then return end 
    self.layer.layer_type = tag

    self.layer.btn_friend:setChecked(self.layer.layer_type == FRIEND_LAYER_TYPE.FRIEND_LIST)
    self.layer.btn_reward:setChecked(self.layer.layer_type == FRIEND_LAYER_TYPE.GIFT_LIST)
    self.layer.btn_request:setChecked(self.layer.layer_type == FRIEND_LAYER_TYPE.REQUEST_LIST)
    self.layer.btn_black_list:setChecked(self.layer.layer_type == FRIEND_LAYER_TYPE.BLACK_LIST)

    for i,v in ipairs(self.layer.layer) do
        v:setVisible(i == self.layer.layer_type)
    end
    self.layer.layer[self.layer.layer_type]:updateView()
end

return FriendCtr