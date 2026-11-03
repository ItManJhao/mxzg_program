local GodArmsOneKeyComposeTipsCtr = class("GodArmsOneKeyComposeTipsCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GodArmsOneKeyComposeTipsLayer = class("GodArmsOneKeyComposeTipsLayer", require("src.comp.EventLayer"))
local table_1 = {}
function GodArmsOneKeyComposeTipsLayer:onCreate()
	self:addBlackBackground()
	local hs_ctr = GodArmsOneKeyComposeTipsCtr:instance()
	local win_size = cc.Director:getInstance():getWinSize();
	local height = Maths.min(self:getContentSize().height, win_size.height);
	self:setScale(height / self:getContentSize().height);
	self.viewSize = cc.size(400, 150)

	self.scroll_view = cc.ScrollView:create(self.viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(65, 157)
	self:addChild(self.scroll_view)
	ex.Tools:setLimitWidth(self.lbl_show, 500)

end

function GodArmsOneKeyComposeTipsLayer:onExit()
	-- ex.Player.hero_data.equip:setOneKeyNeedGold(0)
end

-----------------------------------------------------------------------------
function GodArmsOneKeyComposeTipsCtr:ctor()
	local ccbi_file = "ccbi/GodArmsOneKeyComposeTipsLayer.ccbi"
	self:setCCBIPath(ccbi_file)
	self:registerCCBLoader()
	self:setIsSingle(false)
end

function GodArmsOneKeyComposeTipsCtr:loadLayer()
	local layer = GodArmsOneKeyComposeTipsLayer
	local ccbi_file = self:getCCBIPath()
	self.layer = layer:create(ccbi_file)
	self:setLayer(self.layer)

    -- 创建点击事件
    self:registerTouchListen()
end


function GodArmsOneKeyComposeTipsCtr:getGodArmsOneKeyComposeTipsLayer()
	return self.layer
end

function GodArmsOneKeyComposeTipsCtr:openWindow(hole, job, corelv, sb_id, need_num, iscompose ,need_data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(hole, job, corelv, sb_id, need_num, iscompose, need_data)
end

function GodArmsOneKeyComposeTipsCtr:initData(hole, job, corelv, sb_id, need_num, iscompose, need_data)

	self.layer:addEvent(EVENT.CRUSADE_GROUP.UPDATE_GOD_ARMS_CLOSE, handler(self, self.closeWindow))
	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer.btn_remove:registerScriptTapHandler(handler(self, self.closeWindow))
	self.hole = hole
	self.job = job
	self.corelv = corelv
	self.need_num = need_num
	self.iscompose = iscompose
	self.sb_id = sb_id
	self.need_data = need_data

	self:updateLayer(sb_id, need_num)
end

function GodArmsOneKeyComposeTipsCtr:updateLayer(sb_id, need_num)

	local item_need_show = {} --装备消耗表展示表

	local vec_item_need = {}
	self.need_sb_num = {}
	-- ctr.crusade_group.data:getComposeEquip(self.sb_id, 1)
	local material = ctr.crusade_group.data:getComposeEquip(sb_id, 1)
	if material ~= 0 then
		local equip = {}
		equip.item_type = 902048
		equip.item_num = material
		table.insert( self.need_sb_num, equip )
	end

	local layer = self.layer

	local equip_consume = self:canComposeEquip(sb_id,1,vec_item_need)
	dump(equip_consume)
	self.data = {}
	
	for i,v in ipairs(equip_consume) do
		local bool = true
		if self.data == nil or #self.data == 0  then
			table.insert(self.data,v )
		else
			for j,k in ipairs(self.data) do
				if v.item_type == k.item_type then
					bool = false
					k.item_num = k.item_num + v.item_num
				end
			end
			if bool then
				table.insert( self.data,v )
			end
		end
	end
	if self.data == nil or #self.data == 0  then
		self.data = equip_consume
	end

	local srcoll_view = layer.scroll_view

	local height 
	srcoll_view:getContainer():removeAllChildren()
	local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(srcoll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    srcoll_view:getContainer():addChild(menu)
    local UIMenuItemHero = require("src.comp.menu.UIMenuItemBackpack")
	local cell_content 
	local scale = 0.7
	
    if #self.data > 0 then 
		for i,v in ipairs(self.data) do
			local cell_props = UIMenuItemHero:createWithData(v.item_type,v.item_num)
			cell_content = cell_props:getContentSize()
			menu:add(cell_props)
			-- cell_props:registerScriptTapHandler(handler(self,self.onClickItem))
			if not height then height = math.ceil((#self.data / 5)) * (cell_content.height+10) end

			local idx = (i - 1) % 5
			local posX = (cell_content.width + 10) * (idx) * scale + 5
			local posY = height - (math.ceil(i / 5)) * (cell_content.height + 10) * scale
			cell_props:setAnchorPoint(0,0)
			cell_props:setPosition(posX,posY)
			cell_props:setScale(scale)

		end

		local size = cc.size(layer.viewSize.width,math.ceil((#self.data / 5)) * (cell_content.height+10) + 10)
		srcoll_view:setContentSize(size)
		srcoll_view:setContentOffset(cc.p(0, layer.viewSize.height - height)) 
	end
end

function GodArmsOneKeyComposeTipsCtr:canComposeEquip(sb_id, num)
	local vec_backpack = clone(ctr.crusade_group.data.role_god_arms_info.roleShenBins)
	self.item_num = clone(cfg.crusadegroupshenbin.crusadegroupshenbin)
    return self:canComposeEquipRecursive(sb_id, num, vec_backpack)
end

function GodArmsOneKeyComposeTipsCtr:canComposeEquipRecursive(sb_id, num, vec_item)	
	local item_need_list = {} --装备消耗表
	self.bool = true

	local function getID (id)
        for k,v in pairs(vec_item) do
            if id == v.item_type then
                return v.itemNum
            end
        end
        return 0
	end
	
	local sb_config = TableEx.findValueFunction(self.item_num,function(v)
		return v.sb_id == sb_id
	end)

	for i, v in ipairs(sb_config.compose_sb) do
		local need_num = v.item_num * num

		--背包的数量减去所需要的数量
		local surplus_num = getID(v.item_type) - need_num

		local backpack_data = TableEx.findValueFunction(vec_item, function(data)
            return data.item_type == v.item_type
		end)
		
		if backpack_data and surplus_num >= 0 then
			backpack_data.itemNum = surplus_num
			if v.item_num < need_num  then
				v.item_num = need_num
			end
			table.insert( self.need_sb_num, v )
		end
		
		if surplus_num < 0 then
			if backpack_data and getID(v.item_type) > 0  then
				local a = {}
				a.item_type = clone(v.item_type)
				a.item_num = clone(getID(v.item_type))
				backpack_data.itemNum = 0
				table.insert( self.need_sb_num, a )
			end
			self:canComposeEquipRecursive(v.item_type, -surplus_num, vec_item)
        end

	end

	return self.need_sb_num
end

function GodArmsOneKeyComposeTipsCtr:onConfirm()

	local req = CrusadeGroupShenBin_pb.GReqShenBinCompose()
	req.job = self.job
	req.equip_type = self.sb_id
	NetManager:sendMessage(ProtocolID.GReqShenBinCompose,req)

	if self.need_data.sb_id == self.sb_id then
		require("src.layer.crusadegroup.godarms.GodArmsComposeCtr"):instance():openWindow(self.hole, self.job, self.sb_id, self.corelv, 2)		
	end

end

return GodArmsOneKeyComposeTipsCtr
