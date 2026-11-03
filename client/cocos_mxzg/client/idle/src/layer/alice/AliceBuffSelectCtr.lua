local AliceBuffSelectCtr = class("AliceBuffSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local AliceBuffSelectLayer = class("AliceBuffSelectLayer", require("src.layer.ui.UI_AliceBuffSelectLayer"))
local AliceBuffSelectCell = class("AliceBuffSelectCell", require("src.layer.ui.UI_AliceBuffSelectCell"))
local AliceBuffSelectItem = class("AliceBuffSelectItem", require("src.layer.ui.UI_AliceBuffSelectItem"))

function AliceBuffSelectItem:onCreate()
    self.super.onCreate(self)
	self:setName("AliceBuffSelectItem")

    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setIgnoreAnchorPointForPosition(false)
end

function AliceBuffSelectItem:resetData(data)
	ex.Tools:setSpriteFrameAsyn(self.spr_icon, "backpack-info/spr-attribute-"..data.add_attr[1].attr..".png", "backpack-info")
	self.lbl_point:setString(data.cost_point)
end

function AliceBuffSelectItem:setSelected(selected)
	self.spr_selected:setVisible(selected)
end

------------------------------------------------
function AliceBuffSelectCell:onCreate()
    self.super.onCreate(self)
	self:setName("AliceBuffSelectCell")

    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setIgnoreAnchorPointForPosition(false)
end

function AliceBuffSelectCell:resetData(data)
	self.lbl_title:setString(ex.Tools:getLang(580083 + data.data[1].attr_lv))

    for idx,attr_config in ipairs(data.data) do
		local btn = cpp.UIMenuItemImage:createWithSpriteFrameName(nil, nil, nil)
		btn:registerScriptTapHandler(data.handler)

		local item = AliceBuffSelectItem:create()
		item:setAnchorPoint(0, 0)
		item:setPosition(0, 0)
		item:resetData(attr_config)
		btn:setContentSize(item:getContentSize())
		btn:addChild(item)
		self.menu_item:addChild(btn)
		
		btn.item = item
		btn.attr_config = attr_config
		for i,select_buf in ipairs(data.all_select_buf) do
			if attr_config.idx == select_buf then
				item:setSelected(true)
			end
		end
	end
end

function AliceBuffSelectCell:setScrollView(scroll_view)
	self.menu_item:setIsTouchInsideNode(scroll_view)
end

------------------------------------------------
function AliceBuffSelectLayer:onCreate()
	self.super.onCreate(self)
	self:setName("AliceBuffSelectLayer")

	self:addBlackBackground()

    self.scroll_view.createItemFunction = function(data, scale)
		local item = AliceBuffSelectCell:create()
		item:resetData(data)
		item:setScrollView(self.scroll_view)
		return item
	end

	self.vec_select_buf = {}
end

function AliceBuffSelectLayer:updateLayer()
	-- 顯示我方已選中增益
	-- self:updateBuffSelect()
	self.all_select_buf = clone(ctr.alice.data:getSkillBuff())

	-- 顯示通可選增益列表
	local vec_buff = {{data = {}, handler = handler(self, self.onBuff), all_select_buf = self.all_select_buf}, 
					  {data = {}, handler = handler(self, self.onBuff), all_select_buf = self.all_select_buf}, 
					  {data = {}, handler = handler(self, self.onBuff), all_select_buf = self.all_select_buf}}
	for _,config in ipairs(cfg.aliceplayerattr.aliceplayerattr) do
		table.insert(vec_buff[config.attr_lv].data, config)
	end
	self.scroll_view:reloadData(vec_buff)
	self:updateSlillPoint()
	self:updateBuffSelect()
end

function AliceBuffSelectLayer:updateSlillPoint()
	-- 当前增益技能点
	local buff_point = clone(ctr.alice.data:getSkillPoint())
	for idx,attr_idx in ipairs(self.all_select_buf) do
		local config = cfg.aliceplayerattr.aliceplayerattr[attr_idx]
		buff_point = buff_point - config.cost_point
	end
	self.lbl_buff_point:setString(ex.Tools:getLang(710405)..":"..buff_point)
	self.buff_point = buff_point
end

-- 刷新顯示選中增益
function AliceBuffSelectLayer:updateBuffSelect()
	self.node_buff_select_list:removeAllChildren()
	local size = self.node_buff_select_list:getContentSize()
	for idx,attr in ipairs(self.all_select_buf) do
		local node_item = cc.Node:create()
		node_item:setPosition(0, size.height - (idx - 0.5) * 40)
		self.node_buff_select_list:addChild(node_item)
		
		local config = cfg.aliceplayerattr.aliceplayerattr[attr]
		if config ~= nil then
			local spr_buff_num_bg = cc.Sprite:createWithSpriteFrameName("alice/spr-circle.png")
			spr_buff_num_bg:setAnchorPoint(cc.p(0, 0.5))
			spr_buff_num_bg:setPosition(0, 0)
			node_item:addChild(spr_buff_num_bg, 5)
			
			local lbl_buff_num = cc.Label:createWithTTF(config.cost_point, FONT_DEFAULT_NAME_BOLD, 20)
			lbl_buff_num:setColor(cc.c3b(255,255,255))
			lbl_buff_num:setPosition(13, 0)
			node_item:addChild(lbl_buff_num, 10)
			
			local spr_buff_icon = cc.Sprite:createWithSpriteFrameName("backpack-info/spr-attribute-"..config.add_attr[1].attr..".png")
			if spr_buff_icon then
				spr_buff_icon:setScale(0.5)
				spr_buff_icon:setPosition(50, 0)
				node_item:addChild(spr_buff_icon, 5)
			end
			
			local str_content = string.format(ex.Tools:getLang(580073), ex.Tools:getLang(2150000 + config.add_attr[1].attr), config.add_attr[1].value / 100)
			local lbl_content = cc.Label:createWithTTF(str_content, FONT_DEFAULT_NAME_BOLD, 20)
			lbl_content:setColor(cc.c3b(235,219,180))
			lbl_content:setAnchorPoint(cc.p(0, 0.5))
			lbl_content:setPosition(70, 0)
			node_item:addChild(lbl_content, 10)
		end
	end
end

function AliceBuffSelectLayer:onBuff(tag, pSender)
	local config_selected = pSender.attr_config
	if config_selected == nil then
		return
	end

	local is_have = false
	for idx,attr_idx in ipairs(self.all_select_buf) do

		-- 如果發現buff是已選中的，則推出循環，並將按鈕設置未選中
		if config_selected.idx == attr_idx then
			is_have = true
			table.remove(self.all_select_buf, idx)
			pSender.item:setSelected(false)
			break
		end
	end

	-- 如果buff是未選中的，則判定buff點是否足夠，足夠則設置按鈕選中
	if not is_have then
		if self.buff_point < config_selected.cost_point then
			ex.MessageView:add(ex.Tools:getLang(580088))
			return
		end
		table.insert(self.all_select_buf, config_selected.idx)
		pSender.item:setSelected(true)
	end

	-- 刷新buff選中欄顯示
	self:updateBuffSelect()
	self:updateSlillPoint()
end

function AliceBuffSelectLayer:onConfirm(tag, pSender)
	if #self.all_select_buf <= 0 then
		ex.MessageView:add(ex.Tools:getLang(580087))
		return
	end

	local req = Alice_pb.GReqSelectPlayerAttr()
	for _,v in ipairs(self.all_select_buf) do
		table.insert(req.idx, v)
	end
	req.star = ctr.alice.data.star
	NetManager:sendMessage(ProtocolID.GReqSelectPlayerAttr, req)
	self:onClose()
end

-----------------------------------------------
function AliceBuffSelectCtr:loadLayer()
    local tmp_layer = AliceBuffSelectLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function AliceBuffSelectCtr:onCreate()
	self:setIsSingle(false)
end

function AliceBuffSelectCtr:openWindow()
	if self:isOpened() then
		return
	end

	cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/backpack-info.plist")
	
	self:loadLayer()
	self:open()
    self:initData()
end

function AliceBuffSelectCtr:initData()
	self.layer:updateLayer()
end

return AliceBuffSelectCtr
