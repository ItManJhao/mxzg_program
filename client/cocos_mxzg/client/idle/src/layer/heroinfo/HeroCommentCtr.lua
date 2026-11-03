--[[
* @Description: 英雄评论界面
* @Author: 熊梦
* @Date: 2020-06-11 15:00:00
* ]]

local HeroCommentCtr = class("HeroCommentCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroCommentLayer = class("HeroCommentLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero") -- require("src.comp.menu.UIMenuItemHero")
local HeroCommentCell = class("HeroCommentCell", require("src.comp.LuaLayerBase"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

--hero_comment_max_count 		: 英雄评论最大数量
--hero_comment_count	 		: 英雄评论每个英雄可评论次数
--hero_comment_context_length	: 英雄评论每条评论最大字数限制
--hero_type						: 英雄类型
local hero_comment_max_count = cfg.system.hero_comment_max_count
local hero_comment_count = cfg.system.hero_comment_count
local hero_comment_context_length = cfg.system.hero_comment_context_length / 2
local hero_type

function HeroCommentCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function HeroCommentCell:initData(data)
    if data == nil then
        return
	end

	self.spr_mail_icon:setVisible(data.show_hot)
	self.comment_id = data.comment_id
	self.like_state = data.like_state
	self.lbl_comment_name:setString(data.name)
	self.lbl_fabulous_num:setString(data.like_count)
	self.lbl_difference_num:setString(data.hate_count)
	self.lbl_comment_context:setString(data.context)


	self.btn_fabulous:setContentSize(self.spr_likebg:getContentSize())
	self.btn_difference:setContentSize(self.spr_hatebg:getContentSize())

	self.btn_fabulous:setPosition(self.spr_likebg:getPosition())
	self.btn_difference:setPosition(self.spr_hatebg:getPosition())

	self.btn_fabulous:setEnabled(true)
	self.btn_difference:setEnabled(true)
	self.btn_fabulous:setTag(1)  	-- 1：喜欢
	self.btn_difference:setTag(2)  	-- 2：讨厌

	if data.like_state == 2 then -- 讨厌
		-- self.spr_hatebg:setSpriteFrame("hero-info/spr-huangkuang.png")
		ex.Tools:setSpriteFrame(self.spr_hatebg, "hero-info/spr-huangkuang.png")
	elseif data.like_state == 1 then -- 喜欢
		-- self.spr_likebg:setSpriteFrame("hero-info/spr-huangkuang.png")
		ex.Tools:setSpriteFrame(self.spr_likebg, "hero-info/spr-huangkuang.png")
	end
end

function HeroCommentCell:onLikeComment(event, sender)

	if self.like_state ~= 0 then
		ex.MessageView:add(ex.Tools:getLang(4604))
	else
		local req = HeroComment_pb.GReqLikeComment()
		req.hero_type = hero_type
		req.comment_id = self.comment_id
		req.like_state = sender:getTag()
		NetManager:sendMessage(ProtocolID.GReqLikeComment, req)
		self.btn_fabulous:setEnabled(false)
		self.btn_difference:setEnabled(false)
	end
end

---------------------------------------------------------
function HeroCommentLayer:onCreate()
	self:addBlackBackground()
	self:registerBtnEvent()
end


-- 关闭按钮
function HeroCommentLayer:registerBtnEvent( )
	local hero_comment_ctr = HeroCommentCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(hero_comment_ctr, hero_comment_ctr.closeWindow))
end

function HeroCommentLayer:initData()
	local hero = UIMenuItemHero:createWithData(self.hero_data.hero_id, self.hero_data.hero_type, self.hero_data.elem, self.hero_data.level, self.hero_data.star)
	hero:setScale(1.2)
	self.layer.node_hero:addChild(hero)

	self.scroll_view:setItemSize(cc.size(542, 130))
	self.scroll_view:setItemType(1)

	self:addEvent(EVENT.HERO_INFO_EVENT.UPDATE_COMMENT_INFO,handler(self,self.updateInfo))

	self:addEvent(EVENT.HERO_INFO_EVENT.UPDATE_COMMENT_LIKE_INFO,handler(self,self.updateCommentlikeCell))
	
	-- 英雄名字
	self.layer.lbl_hero_name:setString(ex.Tools:getLang(self.hero_data.hero_type))
	
	-- 设置按钮文字偏移
	self.layer.btn_like:setLabelOffset(cc.p(0,-25))

	-- 创建输入框
	self.edit_box = ccui.EditBox:create(cc.size(self.spr_input_bg:getContentSize().width * self.spr_input_bg:getScaleX(),
													 self.spr_input_bg:getContentSize().height * self.spr_input_bg:getScaleY()-14),
													 "other/spr-null.png", 1)  --输入框尺寸，背景图片
    self.edit_box:setPosition(cc.p(self.spr_input_bg:getPositionX() + 5, self.spr_input_bg:getPositionY()))
    self.edit_box:setAnchorPoint(cc.p(0.5, 0.5))
    self.edit_box:setMaxLength(200)
    self.edit_box:setFontSize(26)
    self.edit_box:setFontColor(cc.c3b(122, 71, 45))
    self.edit_box:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) --输入键盘返回类型，done，send，go等
    self.edit_box:setInputMode(cc.EDITBOX_INPUT_MODE_ANY) --输入模型，如整数类型，URL，电话号码等，会检测是否符合
    self.edit_box:setPlaceholderFontSize(26)
	self.edit_box:setPlaceHolder(ex.Tools:getLang(4602)) 
	self.edit_box:registerScriptEditBoxHandler(handler(self,self.editboxHandle))
	self.node_lower:addChild(self.edit_box)
end

function HeroCommentLayer:editboxHandle(event, sender)
	if event == "began" then 
		-- sender:selectedAll()
	elseif event == "ended" then 
		local str = sender:getText()
		local length = math.floor(hero_comment_context_length * 3.57)
		str = cpp.StringUtil:cutNameWithLength(str, length, 2, 3.57)
		print("str_name", str)
    	sender:setText(str)

	elseif event == "changed" then

	end
end

function HeroCommentLayer:onlike()
	local req = HeroComment_pb.GReqLikeHero()
	req.hero_type = self.hero_data.hero_type
	NetManager:sendMessage(ProtocolID.GReqLikeHero, req)
end

function HeroCommentLayer:onSendComment()
	
	local str_chat_text = self.edit_box:getText()
	local str_tmp = string.gsub(str_chat_text, " ", "")
    local str_tmp = string.gsub(str_tmp, "\n", "")
    if string.len(str_tmp) <= 0 then
		ex.MessageView:add(ex.Tools:getLang(41025))
		self.edit_box:setText("")
        return
    end

	if self.comment_data.comment_count >= hero_comment_count then
		ex.MessageView:add(string.format(ex.Tools:getLang(4606),hero_comment_count))
	elseif self.edit_box:getText() == "" then
		ex.MessageView:add(ex.Tools:getLang(4608))
	else
		local req = HeroComment_pb.GReqComment()
		req.hero_type = self.hero_data.hero_type
		req.context = self.edit_box:getText()
		NetManager:sendMessage(ProtocolID.GReqComment, req)
		self.edit_box:setText("")
	end
end

-- 单独数据进行点赞的刷新 如果此时新增了评论则不管 
function HeroCommentLayer:updateCommentlikeCell(event,data)
	local comment_data = data.comments

	local vec_children = self.scroll_view.menu:getChildren()
	for _,v in pairs(vec_children) do
		for k,h in pairs(comment_data.comments) do
			if h.comment_id == v.comment_id then
				v.like_state = h.like_state
				v.lbl_comment_name:setString(h.name)
				v.lbl_fabulous_num:setString(h.like_count)
				v.lbl_difference_num:setString(h.hate_count)
				v.lbl_comment_context:setString(h.context)
			
				v.btn_fabulous:setEnabled(true)
				v.btn_difference:setEnabled(true)
				v.btn_fabulous:setTag(1)  	-- 1：喜欢
				v.btn_difference:setTag(2)  	-- 2：讨厌
			
				if h.like_state == 2 then -- 讨厌
					-- v.spr_hatebg:setSpriteFrame("hero-info/spr-huangkuang.png")
					ex.Tools:setSpriteFrame(v.spr_hatebg, "hero-info/spr-huangkuang.png")
				elseif h.like_state == 1 then -- 喜欢
					-- v.spr_likebg:setSpriteFrame("hero-info/spr-huangkuang.png")
					ex.Tools:setSpriteFrame(v.spr_likebg, "hero-info/spr-huangkuang.png")
				end
			end
		end
    end
	 
end


function HeroCommentLayer:updateInfo(event,data)
	self:updateLayer(data.comments)
end

function HeroCommentLayer:updateLayer(comment_data)

	self.comment_data = comment_data

	self.btn_like:setVisible(not self.comment_data.had_like )
	
	self.lbl_like_num:setString(self.comment_data.like_count)

	local comment_num = #self.comment_data.comments
	-- 过万处理
    if comment_num >= 10000 then
		local tmp_num = math.floor(comment_num / 1000)
		tmp_num = 1.0 * tmp_num / 10.0
		comment_num = string.format(ex.Tools:getLang(5790), tmp_num)
	end
	self.lbl_comment_num:setString(string.format(ex.Tools:getLang(4603),tostring(comment_num)))

	if #self.comment_data.comments > 0 then
		self.scroll_view.createItemFunction = function(data, scale)
			-- 创建ccbi cell
			local cell_layer = HeroCommentCell:createWithCCBIFile("ccbi/HeroCommentCell.ccbi")
			cell_layer:setIgnoreAnchorPointForPosition(false)
			cell_layer:setAnchorPoint(0.5, 0.5)
	
			cell_layer:initData(data)
	
			return cell_layer
		end

		
		-- 热度排序
		local function sort_table (a,b)
			local astatus = a.like_count + a.hate_count 
			local bstatus = b.like_count + b.hate_count 
			if astatus == bstatus then 
				return a.comment_time < b.comment_time
			else 
				return astatus > bstatus
			end 
		end 

		table.sort( self.comment_data.comments, sort_table )

		for i,v in ipairs(self.comment_data.comments) do
			if i <= 10 then
				v.show_hot = true
			else
				v.show_hot = false
				break
			end
		end

		self.scroll_view:reloadData(self.comment_data.comments)
	end
end

-----------------------------------------------------------------------------
function HeroCommentCtr:onCreate()
	self:setCCBIPath("ccbi/HeroCommentLayer.ccbi")
	self:setIsSingle(false)
end

function HeroCommentCtr:getLayerClass()
	return HeroCommentLayer
end

function HeroCommentCtr:getDiscussLayer()
	return self.layer
end

function HeroCommentCtr:openWindow(hero_data,comment_data)
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
	hero_type = hero_data.hero_type
	self.layer.hero_data = hero_data
	self.layer.comment_data = comment_data
	self:initDone()
	--self.layer:updateLayer()
end

function HeroCommentCtr:initDone()
	self.layer:initData()
	self.layer:updateLayer(self.layer.comment_data)
end

return HeroCommentCtr
