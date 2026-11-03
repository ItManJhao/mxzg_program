local MagicCubeLayer = class("MagicCubeLayer", require("src.comp.EventLayer"))

local HeroPernuteType =
{
    btn1 =10,
    btn2 =20
}

function MagicCubeLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-blessing-pool-2.jpg", remove_type=1},
    }
    return vec_image
end

function MagicCubeLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.menu_root:setLocalZOrder(100)
    self:initDone()
    self.cur_layer_tab = 1

    self.btn_1:setLabelText(ex.Tools:getLang(77301))
    self.btn_2:setLabelText(ex.Tools:getLang(77302))
    self.btn_1:setChecked(true)
    self.btn_1:setTag(1)
    self.btn_2:setTag(2)
    self.btn_1:registerScriptTapHandler(handler(self,self.changeLayer))
    self.btn_2:registerScriptTapHandler(handler(self,self.changeLayer))
    --self:addEvent(EVENT.HERO_EVENT.SELECT_HERO, handler(self,self.onSelectHeroEvevt))
end


function MagicCubeLayer:initDone( )
    self.views = {}
    self.views[self.btn_1:getTag()] = require("src.layer.magiccube.ResonateLayer"):createWithCCBIFile("ccbi/ResonateLayer.ccbi")
    self.main_node:addChild(self.views[self.btn_1:getTag()])

    local win_size = cc.Director:getInstance():getWinSize()
    self.views[self.btn_1:getTag()]:setPosition(cc.p(-320,-640))
    --self.views[self.btn_1:getTag()]:setPosition(cc.p(-win_size.width / 2,-win_size.height / 2))

    --self:changeLayer(HeroPernuteType.btn1)

end


function MagicCubeLayer:onBtn1(tag, pSender)
    --self:changeLayer(HeroPernuteType.btn1)
end



function MagicCubeLayer:onToHeroBack()
    --self:changeLayer(HeroPernuteType.btn2)
end



function MagicCubeLayer:onBtn2(tag, pSender)
    --self:changeLayer(HeroPernuteType.btn2)
end

function MagicCubeLayer:changeLayer(tag,pSender)

    if tag == self.cur_layer_tab then return end 
    if tag == 2 then 
        ex.MessageView:add(ex.Tools:getLang(30013))
        self.btn_1:setChecked(true)
        self.btn_2:setChecked(false)
        return 
    end 
    self.cur_layer_tab = tag
    --if tab == HeroPernuteType.btn2 then
        --local isOpen = ex.JumpManager:checkOpenConditionByAtom("main_hero_rollback")
        --if isOpen ~= true then
            --self.btn_1:setChecked(self.cur_layer_tab == HeroPernuteType.btn1)
            --self.btn_2:setChecked(self.cur_layer_tab == HeroPernuteType.btn2)
            --return
        --end
    --end 


    --self.cur_layer_tab = tab

    --self.btn_1:setChecked(self.cur_layer_tab == HeroPernuteType.btn1)
    --self.btn_2:setChecked(self.cur_layer_tab == HeroPernuteType.btn2)

    --if self.cur_layer ~= nil then
        --self.cur_layer:removeFromParent()
        --self.cur_layer = nil
    --end

    --if self.cur_layer_tab == HeroPernuteType.btn1 then
        --self.cur_layer = require("src.layer.HeroPernuteCell"):createWithCCBIFile("ccbi/HeroPernuteCell.ccbi")
    
        --self.btn_1:setLabelColor(cc.c3b(255, 255, 255))
        --self.btn_2:setLabelColor(cc.c3b(211, 225, 238))  

    --elseif self.cur_layer_tab == HeroPernuteType.btn2 then
        
        --self.cur_layer = require("src.layer.HeroRollBackLayer"):createWithCCBIFile("ccbi/HeroRollBackLayer.ccbi")

        --self.btn_1:setLabelColor(cc.c3b(255, 255, 255))
        --self.btn_2:setLabelColor(cc.c3b(211, 225, 238))  

    --end
    --self.cur_layer:setPosition(0, 0)
    --self:addChild(self.cur_layer)    
end


function MagicCubeLayer:onBack(tag , pSender)
    ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_LAYER)
end


return MagicCubeLayer
