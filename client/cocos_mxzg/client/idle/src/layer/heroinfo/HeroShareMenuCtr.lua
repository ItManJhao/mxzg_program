local HeroShareMenuCtr = class("HeroShareMenuCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroShareMenu = class("HeroShareMenu", require("src.comp.EventLayer"))

local SHARE_TYEP = {
	[1] = "main_chat_cross_share",
	[2] = "main_chat_world_share",
	[3] = "main_chat_clan_share"
}

local SHARE_TAG = {
	[1] = 6,
	[2] = 2,
	[3] = 3
}

function HeroShareMenu:onCreate()
	self:setAutoClose(true)
	self:setSwallowTouches(true)
    for i=1,3 do
        local btn = self["btn_" .. i]
        local str = ex.Tools:getLang(41202 + i)
        btn:setLabelText(str)
        --btn:setLabelColor(FONT_BROWN)
        btn:setLabelColor(ex.c3b.WHITE)

        -- btn:registerScriptTapHandler(handler(self,self.onBtnClick))
        btn:setTag(i)
    end
end

function HeroShareMenu:onBtnClick(tag,pSender)
    print(self.__cname,"onclick",tag)
    local hero_data = ex.Player.hero_data.promote:getSelectHero()
    if not hero_data then return end 
    local req = HeroShare_pb.GReqHeroShare()
    
    req.hero_id = hero_data.hero_id
    req.channel_type = SHARE_TAG[tag]
	NetManager:sendMessage(ProtocolID.GReqHeroShare,req)
end


--------
function HeroShareMenuCtr:onCreate()
    self:setCCBIPath("ccbi/HeroShareMenu.ccbi")
    
    self:setIsSingle(false)
end

function HeroShareMenuCtr:getLayerClass()
    return HeroShareMenu
end

function HeroShareMenuCtr:getLayer()
    return self.layer
end

function HeroShareMenuCtr:initData()

end

function HeroShareMenuCtr:openWindow(callback)
    if self:isOpened() then
        return
    end
    
    -- self.delete_status = false
    self:loadLayer()
    self:open()
    -- local pos_x = pos.x - self.layer:getContentSize().width
    -- local pos_y = pos.y + self.layer:getContentSize().height
    -- self.layer:setPosition(pos_x,pos_y)
    -- self.initData()
    -- return self
    self.callback = callback
    for i=1,3 do
        local btn = self.layer["btn_" .. i]
        -- btn:setTag(i)
        btn:registerScriptTapHandler(handler(self,self.onShare))
    end
end

function HeroShareMenuCtr:onShare(tag,pSender)
	local is_open = ex.JumpManager:checkOpenConditionByAtomNoMsg(SHARE_TYEP[tag])
	if not is_open then 
		local conf = cfg.opencondition.condition[SHARE_TYEP[tag]]
		if tag == 1 then 
			ex.MessageView:add(string.format(ex.Tools:getLang(41212),conf.condition_value))
		elseif tag == 2 then 
			ex.MessageView:add(string.format(ex.Tools:getLang(41213),conf.condition_value))
		elseif tag == 3 then 
			ex.MessageView:add(ex.Tools:getLang(41214))
		end
		return 
	end 

	if tag == 3 and ex.Player.clan_data.clan_id == 0 then 
		ex.MessageView:add(ex.Tools:getLang(41214))
		return 
    end
    
    ---  deng ce hua  pei yi ge jian ge shi jian gen yu yan 
    if not self.last_share_hero_time then 
        self.last_share_hero_time = ex.Game:getServerTime() - 5
    end 

    if ex.Game:getServerTime() - self.last_share_hero_time < 5 then 
        ex.MessageView:add(ex.Tools:getLang(47735))
        return 
    end 
    
    self.last_share_hero_time = ex.Game:getServerTime()

    if self.callback then 
        self.callback(SHARE_TAG[tag], pSender)
    end
end



return HeroShareMenuCtr
