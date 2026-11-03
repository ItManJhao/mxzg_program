local FetterUnlockLayer = class("FetterUnlockLayer",require("src.comp.EventLayer"))

function FetterUnlockLayer:getAsynImage()
    local vec_image = {
		{image_name = "ccbi-res/map-bg-fetters-unlock-1.jpg", remove_type=1},
    }
    return vec_image
end


function FetterUnlockLayer:onCreate()
    self:setAutoClose(false)
	self:setSwallowTouches(false)
	
	local notch_height = require("src.model.Game"):instance():getNotchHeight()

    self.btn_back:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
                              self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 42 - notch_height)

	local viewsize = cc.Director:getInstance():getWinSize()
	local size = self.spr_bg:getContentSize()
	self.scaleX = viewsize.width / size.width
	self.scaleY = viewsize.height / size.height
	self.spr_bg:setScale(self.scaleX , self.scaleY)

	local x,y = self.spr_info:getPosition()
	self.spr_info:setPosition(self.scaleX * x, self.scaleY * y)

	local x,y = self.spr_title:getPosition()
	self.spr_title:setPosition(self.scaleX * x, self.scaleY * y - notch_height)

	self.spine_data = {}

	local function sor (a,b)
		return a.type < b.type
	end

	for k,v in pairs(cfg.goddessunlock.goddessunlock) do
		table.insert(self.spine_data, v)
	end

	table.sort(self.spine_data,sor)

	-- self.viewSize = cc.size(560,245)

	-- self.skill_icon = require("src.layer.fetters.FetterSkillIcon"):createWithData()
	-- local x,y = self.skill:getPosition()
	-- self.menu:addChild(self.skill_icon)
	-- self.skill_icon:setPosition(x,y)

	-- self.reward_icon = require("src.layer.fetters.FetterRewardIcon"):createWithData()
	-- x,y = self.vip_get:getPosition()
	-- self.menu:addChild(self.reward_icon)
	-- self.reward_icon:setPosition(x,y)

    local spr_effect_1 = ex.EffectFactory:createEffectWithNodeByName("eff_fetters_light_1")
    spr_effect_1:setPosition(self.spr_bg:getContentSize().width * 0.5, 170 + 744 / 2)
    -- spr_effect_1:setScaleX(self.spr_bg:getScaleX())
    -- spr_effect_1:setScaleY(self.spr_bg:getScaleY())
    self.spr_bg:addChild(spr_effect_1, 0, 10)

    local spr_effect_2 = ex.EffectFactory:createEffectWithNodeByName("eff_fetters_light_2")
    spr_effect_2:setPosition(self.spr_bg:getContentSize().width * 0.5 - 8, 170 + 484 / 2 - 5)
    -- spr_effect_2:setScaleX(self.spr_bg:getScaleX())
    -- spr_effect_2:setScaleY(self.spr_bg:getScaleY())
    self.spr_bg:addChild(spr_effect_2, 0, 10)

	self:addFont()

	-- self.scroll_view
	self:updateView()
	self:registerBtnEvent()
end

function FetterUnlockLayer:registerBtnEvent()
	self.btn_back:registerScriptTapHandler(handler(self, self.onBack))

end

function FetterUnlockLayer:onBack(tag,pSender)
	local layer_type = ex.Player.fetter_data:isUnlockAll() and MainSceneType.FETTER_INFO or MainSceneType.FETTER_MAIN_VIEW
	ex.MainSceneCtr:changeLayer(layer_type)
end



function FetterUnlockLayer:addFont()
	self.lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(47733), FONT_DEFAULT_NAME_BOLD, 26)
	self.lbl_title:enableOutline(cc.c3b(56,52,121), 3)
	self.spr_title:addChild(self.lbl_title)
	self.lbl_title:setPosition(self.spr_title:getContentSize().width / 2,self.spr_title:getContentSize().height / 2)

    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_fetters_light_3")
    spr_effect:setPosition(self.spr_title:getContentSize().width * 0.5, self.spr_title:getContentSize().height * 0.5 + 5)
    spr_effect:setScaleX(1)
    self.spr_title:addChild(spr_effect, 0, 10)
end

function FetterUnlockLayer:updateView()
	self.items = {}
	for k,v in pairs(self.spine_data) do
		local item = require("src.layer.fetters.FetterUnlockIcon"):createWithData(v)
		local x,y = self["item_" .. k]:getPosition()
		-- item:setPosition(x,y)
		item:setPosition(x*self.scaleX,y*self.scaleY)
		item:registerScriptTapHandler(handler(self,self.onClick))
		self.menu:addChild(item)
	end
end

function FetterUnlockLayer:onClick(tag, pSender)
	-- body
	local data = pSender:getData()
	local unlock = ex.Player.fetter_data.vip:getVIP() >= data.vip_level


	-- if unlock == false then 
	-- 	ex.MessageView:add(ex.Tools:getLang(47479))
	-- else
	-- end
	ex.Player.fetter_data.vip_selected_type = data.type
	ex.MainSceneCtr:changeLayer(MainSceneType.FETTER_INFO)
end

function FetterUnlockLayer:onExit()
	
end


return FetterUnlockLayer