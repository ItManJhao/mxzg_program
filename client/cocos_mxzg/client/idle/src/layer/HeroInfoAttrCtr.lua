local HeroInfoAttrCtr = class("HeroInfoAttrCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroInfoAttrCtr = class("HeroInfoAttrCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroInfoAttrLayer = class("HeroInfoAttrLayer", require("src.layer.ui.UI_HeroInfoAttrLayer"))
------------------------------------------------
function HeroInfoAttrLayer:onCreate()
    self.super.onCreate(self)
	self:setName("HeroInfoAttrLayer")
    
    self:setVisible(false)
    self:addEvent(EVENT.HERO_EVENT.HERO_DETAIL, handler(self,self.updateLayer))
end

function HeroInfoAttrLayer:updateLayer(evt, hero_data)
    if hero_data == nil then
        return
    end
    self:setVisible(true)

    local data = {}
    for i,v in ipairs(cfg.abilityshow.abilityshow) do
        local group = TableEx.findValueFunction(data, function(a)
            return a.group == v.group
        end)

        if group == nil then
            group = {group=v.group, lan_id = v.group_id, info_title= v.info_title, info_desc = v.info_desc, list= {}}
            table.insert(data, group)
        end
        table.insert(group.list, {key=v.key, attr=v.type})
    end

    local width_half = self:getContentSize().width / 2

    for i,v in ipairs(data) do
        local group_title = require("src.layer.ui.UI_HeroInfoAttrTitleCell"):create()
        group_title.lbl_title:setString(ex.Tools:getLang(v.lan_id))
        group_title:setPositionX(width_half)
        self.spr_bg:addChild(group_title)

        group_title.info_title = v.info_title
        group_title.info_desc = v.info_desc
        group_title.btn_info:setVisible(v.info_title ~= "" and v.info_title ~= 0)
        group_title.btn_info:registerScriptTapHandler(handler(self, self.onInfo))

        local group_boby = require("src.layer.ui.UI_HeroInfoAttrBodyCell"):create()
        group_boby:setPositionX(width_half)
        self.spr_bg:addChild(group_boby)

        for ii,vv in ipairs(v.list) do
            if hero_data.detail[vv.key] ~= nil then
                local group_attr = require("src.layer.ui.UI_HeroInfoAttrCell"):create()
                group_attr:setPositionX(width_half)
                group_attr.lbl_attr:setString(ex.Tools:getAttrTextOnly(vv.attr))
                group_attr.lbl_value:setString(ex.Tools:getAttrValue(vv.attr, hero_data.detail[vv.key]))
                group_boby:addChild(group_attr)

                ex.Tools:setSpriteFrameAsyn(group_attr.spr_attr, string.format("hero-info-2/spr-attribute-%d.png", vv.attr), "hero-info-2")
            end
        end
        group_boby:resetLyt()
    end

    self:resetLyt()
    self:setPositionCenter()
end

function HeroInfoAttrLayer:onInfo(tag, pSender)
    local group_title = pSender:getParent():getParent()
    ex.InfoCtr:openWindow(ex.Tools:getLang(group_title.info_title), ex.Tools:getLang(group_title.info_desc))
end

-----------------------------------------------
function HeroInfoAttrCtr:loadLayer()
	local tmp_layer = HeroInfoAttrLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function HeroInfoAttrCtr:onCreate()
	self:setIsSingle(false)
end

function HeroInfoAttrCtr:openWindow(hero_data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
    self:open()
    self:initData(hero_data)
end

function HeroInfoAttrCtr:initData(hero_data)
    local req_detail = Hero_pb.GReqHeroDetail()
    req_detail.hero_id = hero_data.hero_id
    NetManager:sendMessage(ProtocolID.GReqHeroDetail, req_detail)
end

return HeroInfoAttrCtr
