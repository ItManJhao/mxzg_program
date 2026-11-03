local DreamRewardCell = class("DreamRewardCell", require("src.comp.LuaLayerBase"))

local string_format = string.format
function DreamRewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

end

function DreamRewardCell:onClick(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function DreamRewardCell:updateItem( award_list)
    local menu = cpp.UIMenu:create()
    :setPosition(cc.p(0, 0))
    self:addChild(menu)

    local goods_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    goods_size.width = goods_size.width * 0.75 + 10

    local begin = self:getContentSize().width - 30
    local margin = 5
    local posY = 50
    local scale = 0.75
    for i,v in ipairs(award_list) do
        local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        local posX = (begin - item:getContentSize().width * scale / 2) - (i - 1) * ((item:getContentSize().width * scale) + margin)
    	
        item:setPosition(posX, posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClick))
        menu:addChild(item)
    end

end

function DreamRewardCell:reset(data)

    if not data then print("not data") return end
    self.data = data

    self:updateItem(data.reward)

    local str_rank = tostring(data.rank_max)
    if data.rank_max > 4 then 
        str_rank = data.rank_min .."-"..data.rank_max
    end 

    self.lbl_my_rank_tip:setVisible(false)
    self.lbl_my_rank:setVisible(false)


	self.spr_rank:setVisible(false)
	self.lbl_rank:setVisible(true)
	if data.rank_max > 0 and data.rank_max < 4 then 
		self.spr_rank:setVisible(true)
		self.lbl_rank:setVisible(false)
        -- self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png",data.rank_max))
        ex.Tools:setSpriteFrame(self.spr_rank, string.format("rank/spr-paihang-%s.png",data.rank_max))
	end

	self.lbl_rank:setString(str_rank)
    self.lbl_rank:enableOutline(FONT_BLACK_C4B, 3)

    
end
return DreamRewardCell