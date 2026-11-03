local BattleEditLayer = class("BattleEditLayer", require("src.comp.EventLayer"))

function BattleEditLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
	local win_size = cc.Director:getInstance():getWinSize()
    self:setContentSize(win_size)
    local bottom_height = ex.MainSceneCtr:getMenuScaleHeight()

    local spr_bg = cc.Sprite:create("ccbi-res/chapter/map01.jpg")
    spr_bg:setScale((win_size.width + 10) / spr_bg:getContentSize().width, win_size.height / spr_bg:getContentSize().height)
    spr_bg:setPosition(win_size.width * 0.5, win_size.height * 0.5)
    self:addChild(spr_bg)


    local menu_scene = cpp.UIMenu:create()
    menu_scene:setPosition(0,0)
    self:addChild(menu_scene)

    local btn_edit = cpp.UIMenuItemLabel:create("button/btn-small-1.png", nil, ex.Tools:getLang(47112), nil)
    btn_edit:setPosition(ex.p.cx, bottom_height)
    btn_edit:setLabelColor(cc.c3b(0, 0, 0))
    btn_edit:registerScriptTapHandler(handler(self, self.onEdit))
    menu_scene:addChild(btn_edit)
end

function BattleEditLayer:onEdit()
    require("src.layer.battle.BattleEditCtr"):instance():openWindow()
end

return BattleEditLayer