local TotemNotActiveCell = class("TotemNotActiveCell", require("src.comp.LuaLayerBase"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")

function TotemNotActiveCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

end

function TotemNotActiveCell:showInfo(tag,pSender)
    local data = {}
    data.sys_id = self.data.totems_id
    data.quality = 1
    data.level = self.data.level
    require("src.layer.totems.TotemTipsCtr"):instance():openWindow(data)
end


function TotemNotActiveCell:onClick(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function TotemNotActiveCell:reset(data)
    self.data = data
    self.menu_icon:removeAllChildren()
    local item = UIMenuItemBag:createWithData(data.totems_id)
    item:registerScriptTapHandler(handler(self, self.showInfo))
    self.menu_icon:addChild(item)
    local item_cfg = cfg.item.item[data.totems_id]
    local name = ex.Tools:getLang(item_cfg.name)
    self.lbl_name:setString(name)
    local desc = ex.Tools:getLang(item_cfg.content)
    self.lbl_desc:setString(desc)
    self.lbl_info:setString(ex.Tools:getLang(data.totems_id % 10 + 76845))
end



return TotemNotActiveCell
