local ClanGvgRewardCtr = class("ClanGvgRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanGvgRewardLayer = class("ClanGvgRewardLayer", require("src.comp.LuaLayerBase"), require("src.comp.EventLayer"))
local UIMenu = require("src.comp.menu.UIMenu")

local ClanGvgRewardItem = class("ClanGvgRewardItem", require("src.comp.LuaLayerBase"))
function ClanGvgRewardItem:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.lbl_name:setVisible(false)
end

local ClanGvgRewardCell = class("ClanGvgRewardCell", require("src.comp.LuaLayerBase"))
function ClanGvgRewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self:reorderChild(self.menu, 10)
end

function ClanGvgRewardCell:setTableView(table)
    self.menu:setSwallowsTouches(false)
    self.menu:setIsTouchInsideNode(table)
end

function ClanGvgRewardCell:initData(data)
    if data == nil or table.nums(data) <= 0 then
        return
    end

    for i=1,3 do
        local tmp_data = data[i]
        self["btn_open"..i]:setContentSize(self["spr_bg"..i]:getContentSize())
        self["node_"..i]:setVisible(false)
        self["spr_box"..i]:setVisible(false)
        self["lbl_name"..i]:setVisible(false)
        if tmp_data ~= nil then
            self["node_"..i]:setVisible(true)
            if tmp_data.item_type ~= nil then
                local item = ex.Tools:createBackpackItem(tmp_data.item_type, tmp_data.item_num)
                item:setPosition(85, 94)
                item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
                self["menu"..i]:addChild(item)

                self["lbl_name"..i]:setVisible(true)
                self["lbl_name"..i]:setString(tmp_data.name)
                self["btn_open"..i]:setEnabled(false)
            else
                self["spr_box"..i]:setVisible(true)
                -- if tmp_data.box_type == 2 then
                --     self["spr_box"..i]:setSpriteFrame("clan-gvg/spr-reward-box-2.png")
                -- end
                self["btn_open"..i]:setTag(tmp_data.index)
            end
            self["node_"..i].index = tmp_data.index
            self["node_"..i].item_type = tmp_data.item_type
        else
            self["node_"..i].index = 0
            self["node_"..i].item_type = nil
        end
    end
end

function ClanGvgRewardCell:onRewardSelect(tag, pSender)
    print("ClanGvgRewardCtr:onRewardSelect,", tag)

    -- 如果未参与公会战，则不许领奖
    if ex.Player.clan_data.clan_gvg_reward_info.has_box == nil or 
        ex.Player.clan_data.clan_gvg_reward_info.has_box <= 0 then
        ex.MessageView:add(ex.Tools:getLang(70154))
        return
    end

    -- 判断是否已经领取过宝箱
    for i,v in ipairs(ex.Player.clan_data.clan_gvg_reward_info.box) do
        if v.rid == ex.Player.role_id then
            ex.MessageView:add(ex.Tools:getLang(70155))
            return
        end
    end

    pSender:setEnabled(false)
    local req_reward = ClanWar_pb.GReqOpenWarBox()
    req_reward.box_index = tag
    NetManager:sendMessage(ProtocolID.GReqOpenWarBox, req_reward)
end
-----------------------------------------------------------------------------
function ClanGvgRewardLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    self.lbl_tip:setString(ex.Tools:getLang(70137).."\n"..ex.Tools:getLang(70138))
end

-----------------------------------------------------------------------------
function ClanGvgRewardCtr:onCreate()
	self:setCCBIPath("ccbi/ClanGvgRewardLayer.ccbi")
    self:setIsSingle(false)
    
end

function ClanGvgRewardCtr:getLayerClass()
	return ClanGvgRewardLayer
end

function ClanGvgRewardCtr:getClanGvgRewardLayer()
	return self.layer
end

function ClanGvgRewardCtr:openWindow()
	if self:isOpened() then
		return
	end
	
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan.plist")

	self:loadLayer()
	self:open()
	self:initData()

end

function ClanGvgRewardCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    local gvg_info = ex.Player.clan_data.clan_gvg_info
    local now = ex.Game:getServerTime()
    ex.Player.clan_data.clan_gvg_reward_info.box = {}
        -- 请求刷新数据
    if gvg_info.round_start_time > now or gvg_info.round_end_time < now or table.nums(gvg_info.war_infos) <= 1 or gvg_info.stage ~= 5 then

    else
        ex.Player.clan_data.clan_gvg_reward_info.box_number = 0
        NetManager:sendMessage(ProtocolID.GReqScanWarBox)
    end

    self.layer.scroll_view:setItemSize(cc.size(520, 170))
    self.layer.scroll_view:setItemType(1)

	self:updateTableView()
end

function ClanGvgRewardCtr:updateCell()
    local data = self:DataProcessing()
    local vec_children = self.layer.scroll_view.menu:getChildren()
    for _,v in pairs(vec_children) do
        local isbreack = false
        for i=1,3 do
            -- indexTemp: 更新的index
            -- itemtypeTemp: 更新前的道具類型 如果為nil的話 代表未開啟
            local indexTemp =  v["node_"..i].index
            local itemtypeTemp = v["node_"..i].item_type
            for k,p in pairs(data) do
                for index,value in pairs(p) do
                    if indexTemp == value.index and value.item_type ~= nil and itemtypeTemp == nil then
                        local item = ex.Tools:createBackpackItem(value.item_type, value.item_num)
                        item:setPosition(85, 94)
                        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
                        self["menu"..i]:addChild(item)

                        self["lbl_name"..i]:setVisible(true)
                        self["lbl_name"..i]:setString(value.name)

                        v["node_"..i].index = value.index
                        v["node_"..i].item_type = value.item_type
                        self["btn_open"..i]:setEnabled(false)
                        isbreack = true
                        break
                    end
                end 
                if isbreack then break end
            end
        end 
    end
end

function ClanGvgRewardCtr:DataProcessing()
    -- 初始化数据，对数据做处理，使之在界面显示三个一排 { {}, {}, {} }
    -- {position, name, item_type, item_num}
    local data = {}
    local index = 1
    for i=1,ex.Player.clan_data.clan_gvg_reward_info.box_number do
        local tmp_data_1 = {}
        for j=1,3 do
            if index > ex.Player.clan_data.clan_gvg_reward_info.box_number then
                break
            end

            local tmp_data = {}
            tmp_data.index = index
            tmp_data.box_type = ex.Player.clan_data.clan_gvg_reward_info.box_type
            local item = ex.Player.clan_data.clan_gvg_reward_info.box[index]
            if item ~= nil then
                tmp_data.item_type = item.item_type
                tmp_data.item_num = item.item_num
                tmp_data.name = item.name
            end

            tmp_data_1[j] = tmp_data

            index = index + 1
        end
        local function sort_table (a,b)
            return a.index < b.index
        end
    
        table.sort( tmp_data_1, sort_table )

        table.insert(data, tmp_data_1)

        if index > ex.Player.clan_data.clan_gvg_reward_info.box_number then
            break
        end
    end
    return data
end

function ClanGvgRewardCtr:updateTableView()
    if not self:getLayer() then
        return
    end

    -- if self.layer.tableView ~= nil then
    --     self.layer.tableView:removeFromParent()
    --     self.layer.tableView = nil 
    -- end

    local data = self:DataProcessing()

    self.layer.scroll_view.createItemFunction = function(value, scale)
        -- 创建ccbi cell
        local cell_layer = ClanGvgRewardCell:createWithCCBIFile("ccbi/ClanGvgRewardCell.ccbi")
        cell_layer:setIgnoreAnchorPointForPosition(false)
        cell_layer:setAnchorPoint(0.5, 0.5)
        cell_layer:setScale(1)
        cell_layer:initData(value)

        return cell_layer
    end

    self.layer.scroll_view:reloadData(data)

end

return ClanGvgRewardCtr
