local LadderHeroTempleCtr = class("LadderHeroTempleCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local LadderHeroTempleLayer = class("LadderHeroTempleLayer", require("src.comp.EventLayerAdaptiveWidth"))

function LadderHeroTempleLayer:onCreate()
	self:addBlackBackground()
	local temple_ctr = LadderHeroTempleCtr:instance()
	local win_size = cc.Director:getInstance():getWinSize()
	local width = Maths.min(self:getContentSize().width, win_size.width)
	self:setScale(width / self:getContentSize().width)
    self.btn_close:registerScriptTapHandler(handler(temple_ctr, temple_ctr.closeWindow))


    NetManager:sendMessage(ProtocolID.GReqLikeList)
    self:addEvent(EVENT.LADDER_EVENT.REFRESH_HERO_TEMPLE, handler(self, self.updateLayer))

    self:updateLayer()
end


function LadderHeroTempleLayer:updateLayer()
    
    for i=1,3 do
        local player_data = TableEx.findValueFunction(ex.Player.rank_data.rank_ladder_like_list or {}, function(value)
            return value.rank == i
        end)
        self["node_hero"..i]:removeAllChildren()
        self["btn_like"..i]:setVisible(player_data ~= nil)
        self["lbl_like"..i]:setVisible(player_data ~= nil)
        self["lbl_clan"..i]:setVisible(player_data ~= nil)
        if player_data then
            local hero = require("src.person.Hero"):create("1", "1", 1, 1, ex.Tools:getHeroSkinByImageId(player_data.image)) 
            hero:setScale(i == 1 and 1.2 * 1.2 or 1 * 1.2)
            self["node_hero"..i]:addChild(hero)

            self["lbl_name"..i]:setString(player_data.nick)
            self["lbl_like"..i]:setString(player_data.like_num)
            self["lbl_clan"..i]:setString(player_data.clan_name == "" and "" or (ex.Tools:getLang(47240)..player_data.clan_name))
            self["btn_like"..i]:setEnabled(player_data.can_like)

            ex.Tools:setGrayAuto(self["btn_like"..i]:getNormalImage(), player_data.can_like == false)
            self["btn_like"..i]:setEnabled(player_data.can_like)
        else
            self["lbl_name"..i]:setString(ex.Tools:getLang(47593))
            self["lbl_clan"..i]:setString("")
        end
    end
end

function LadderHeroTempleLayer:onLike(tag, pSender)
    local player_data = TableEx.findValueFunction(ex.Player.rank_data.rank_ladder_like_list, function(value)
        return value.rank == tag
    end)

    if not player_data then
        return
    end

    if player_data.can_like ~= true then
        return
    end

    local req_like = Ladder_pb.GReqLikeSuperior()
    req_like.rank = tag
    NetManager:sendMessage(ProtocolID.GReqLikeSuperior, req_like)

    NetManager:sendMessage(ProtocolID.GReqLikeList)
end


-----------------------------------------------------------------------------
function LadderHeroTempleCtr:onCreate()
	self:setCCBIPath("ccbi/LadderHeroTempleLayer.ccbi")
	self:setIsSingle(false)
end

function LadderHeroTempleCtr:getLayerClass()
	return LadderHeroTempleLayer
end


function LadderHeroTempleCtr:openWindow()
	if self:isOpened() then
		return
    end
    
	self:loadLayer()
	self:open()
	self:initData()
end

function LadderHeroTempleCtr:initData()


end


return LadderHeroTempleCtr
