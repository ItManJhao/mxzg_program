local HeroPernuteLayerCtr = class("HeroPernuteLayerCtr", require("src.comp.EventLayer"))

local HeroPernuteType =
{
    btn1 =10,
    btn2 =20
}

function HeroPernuteLayerCtr:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-blessing-pool-2.jpg", remove_type=1},
    }
    return vec_image
end

function HeroPernuteLayerCtr:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    local last_content_size = self:getContentSize()
    local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 200)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    local notch_height = require("src.model.Game"):instance():getNotchHeight()
    
    self:setContentSize(cur_content_size)
    self:setPosition(ex.p.width / 2 - self:getContentSize().width / 2, ex.p.height / 2 - self:getContentSize().height / 2 + 50)

    self.btn_back:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
                              self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 42 - notch_height)

    self.btn_1:setPosition(self.btn_1:getPositionX() + offset.x / 2, self.btn_1:getPositionY() + offset.y - notch_height)
    self.btn_2:setPosition(self.btn_2:getPositionX() + offset.x / 2, self.btn_2:getPositionY() + offset.y - notch_height)
    
    self.spr_bg = cc.Sprite:create("ccbi-res/map-bg-blessing-pool-2.jpg")
    self.spr_bg:setScale(ex.p.width / self.spr_bg:getContentSize().width, ex.p.height / self.spr_bg:getContentSize().height)
    self.spr_bg:setPosition(ex.p.center().x - self:getPositionX(), ex.p.center().y - self:getPositionY())
    self:addChild(self.spr_bg, -1)


    self.btn_1:setLabelText(ex.Tools:getLang(5427))
    self.btn_2:setLabelText(ex.Tools:getLang(5544))


    self:initDone()

    --self:addEvent(EVENT.HERO_EVENT.SELECT_HERO, handler(self,self.onSelectHeroEvevt))
end


function HeroPernuteLayerCtr:initDone( )
    
    self:changeLayer(HeroPernuteType.btn1)

end


function HeroPernuteLayerCtr:onBtn1(tag, pSender)
    self:changeLayer(HeroPernuteType.btn1)
end



function HeroPernuteLayerCtr:onToHeroBack()
    self:changeLayer(HeroPernuteType.btn2)
end



function HeroPernuteLayerCtr:onBtn2(tag, pSender)
    self:changeLayer(HeroPernuteType.btn2)
end

function HeroPernuteLayerCtr:changeLayer(tab)

    if tab == self.cur_layer_tab then return end 

    if tab == HeroPernuteType.btn2 then
        local isOpen = ex.JumpManager:checkOpenConditionByAtom("main_hero_rollback")
        if isOpen ~= true then
            self.btn_1:setChecked(self.cur_layer_tab == HeroPernuteType.btn1)
            self.btn_2:setChecked(self.cur_layer_tab == HeroPernuteType.btn2)
            return
        end
    end 


    self.cur_layer_tab = tab

    self.btn_1:setChecked(self.cur_layer_tab == HeroPernuteType.btn1)
    self.btn_2:setChecked(self.cur_layer_tab == HeroPernuteType.btn2)

    if self.cur_layer ~= nil then
        self.cur_layer:removeFromParent()
        self.cur_layer = nil
    end

    if self.cur_layer_tab == HeroPernuteType.btn1 then
        self.cur_layer = require("src.layer.HeroPernuteCell"):createWithCCBIFile("ccbi/HeroPernuteCell.ccbi")
    
        self.btn_1:setLabelColor(cc.c3b(255, 255, 255))
        self.btn_2:setLabelColor(cc.c3b(211, 225, 238))  

    elseif self.cur_layer_tab == HeroPernuteType.btn2 then
        
        self.cur_layer = require("src.layer.HeroRollBackLayer"):createWithCCBIFile("ccbi/HeroRollBackLayer.ccbi")

        self.btn_1:setLabelColor(cc.c3b(255, 255, 255))
        self.btn_2:setLabelColor(cc.c3b(211, 225, 238))  

    end
    self.cur_layer:setPosition(0, 0)
    self:addChild(self.cur_layer)    
end


function HeroPernuteLayerCtr:onBack(tag , pSender)
    ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_LAYER)
end


return HeroPernuteLayerCtr