
local DreamShowRewardCell = class("DreamShowRewardCell", require("src.comp.LuaLayerBase"))
function DreamShowRewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end


function DreamShowRewardCell:initData(data)

    

end


function DreamShowRewardCell:updateItem( award_list)
    local menu = cpp.UIMenu:create()
    :setPosition(cc.p(0, 0))
    self:addChild(menu)

    local goods_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    goods_size.width = goods_size.width * 0.75 + 10

    local begin = 10
    local margin = 5
    local posY = 50
    local scale = 0.75
    for i,v in ipairs(award_list) do
        local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        local posX = (begin + item:getContentSize().width * scale / 2) + (i - 1) * ((item:getContentSize().width * scale) + margin)
    	
        item:setPosition(posX, posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClick))
        menu:addChild(item)
    end

end

function DreamShowRewardCell:onClick(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


function DreamShowRewardCell:reset(data)

    if not data then print("not data") return end
    self.data = data
    self:updateItem(data.award_list)    

    self.lbl_my_rank_tip:setString(ex.Tools:getLang(72053 + data.idx))
    self.lbl_my_rank_tip:enableOutline(cc.c4b(68,32,11,255), 1)
    
end

return DreamShowRewardCell