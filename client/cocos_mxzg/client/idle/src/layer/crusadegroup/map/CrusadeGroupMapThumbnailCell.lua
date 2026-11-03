local CrusadeGroupMapThumbnailCell = class("CrusadeGroupMapThumbnailCell", require("src.comp.EventLayer"))

function CrusadeGroupMapThumbnailCell:onCreate()
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)

    self.btn_jump:setContentSize(cc.size(200, 30))
    self.btn_jump:getParent():setSwallowsTouches(false)
end

function CrusadeGroupMapThumbnailCell:reset(data)
    self.data = data
    
    self.lbl_mark:setString(data.name)
    ex.Tools:setLimitWidth(self.lbl_mark, 200)
end

function CrusadeGroupMapThumbnailCell:onJump()
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.SET_MAP_FOCUS_ID_ANIM, self.data.territory_id)
end

function CrusadeGroupMapThumbnailCell:onDelete()
    local req = CrusadeGroup_pb.GReqUnmark()
    req.territory_id = self.data.territory_id
    NetManager:sendMessage(ProtocolID.GReqUnmark, req)
end

return CrusadeGroupMapThumbnailCell