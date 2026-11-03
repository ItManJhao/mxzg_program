local DreamRankCtr = class("DreamRankCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local DreamRankLayer = class("DreamRankLayer", require("src.comp.EventLayerAdaptiveWidth"))

------------------------------------------------

DreamRank = {}
DreamRank.RANK = 10   
DreamRank.REWARD = 20   

function DreamRankLayer:onCreate()
	self:addBlackBackground()


	self.btn_left:setLabelText(ex.Tools:getLang(5649))
    self.btn_right:setLabelText(ex.Tools:getLang(5025))

end

function DreamRankLayer:initDone()

    self.btn_left:registerScriptTapHandler(handler(self, self.onRank))
	self.btn_right:registerScriptTapHandler(handler(self, self.onReward))

	self:changeLayer(DreamRank.RANK)
end


function DreamRankLayer:onRank(tag, pSender)
    self:changeLayer(DreamRank.RANK)
end

function DreamRankLayer:onReward(tag, pSender)
    self:changeLayer(DreamRank.REWARD)
end


function DreamRankLayer:changeLayer( type )
	
	if type == self.select_type then return end  
	self.select_type = type

    self.btn_left:setChecked(self.select_type == DreamRank.RANK)
    self.btn_right:setChecked(self.select_type == DreamRank.REWARD)

	if type == DreamRank.RANK then 
		self.rank:setVisible(true)
		self.reward:setVisible(false)
	elseif type == DreamRank.REWARD then 
		self.rank:setVisible(false)
		self.reward:setVisible(true)
	end 
	
	self:initScroll()
end


function DreamRankLayer:initScroll( )
	-- 刷新数据
	if self.select_type == DreamRank.RANK then 
		self.cell_rank_data = ex.Player.dream_data.rank_list_data.list

		if not self.rank_list then 
			local win_size = cc.size(self.rank_scroll_bg:getContentSize().width,self.rank_scroll_bg:getContentSize().height - 10)
			self.rank_list = ex.Tools:initTableView(self.rank_scroll_bg,self.cell_rank_data, {require("src.layer.dream.DreamRankCell"),"ccbi/DreamRankCell.ccbi"} , win_size, 5,cc.p(0,5),true)
		else
			self.rank_list:initData(self.cell_rank_data)
			self.rank_list:reloadData()
		end 	

		
		-- 下面还有一个跑名
		self.spr_photo:setSpriteFrame(string.format("head-icon/%d.png", ex.Player.dream_data.my_rank_data.head_id))
		self.spr_frame:setSpriteFrame(ex.Tools:getBorderIconByIdx(ex.Player.dream_data.my_rank_data.border_id))
		self.lbl_name:setString(ex.StringUtil.getServerName(ex.Player.dream_data.my_rank_data.server_id)..ex.Player.dream_data.my_rank_data.name)
		self.lbl_fight:setString(ex.Player.dream_data.my_rank_data.combat_num)

		if ex.Player.dream_data.my_rank_data.rank < 0 then 
			self.lbl_rank:setString(ex.Tools:getLang(47749))
		else 
			self.lbl_rank:setString(ex.Player.dream_data.my_rank_data.rank)
		end 
		self.lbl_rank:enableOutline(FONT_BLACK_C4B, 2)

		self.lbl_max:setString(string.format( ex.Tools:getLang(47526),ex.Player.dream_data.my_rank_data.score ))
		self.lbl_max:enableOutline(FONT_BLACK_C4B, 2)

		
	elseif self.select_type == DreamRank.REWARD then  
		self.cell_reward_data = cfg.infiniterankreward.infiniterankreward
		local win_size = cc.size(self.reward_scroll_bg:getContentSize().width,self.reward_scroll_bg:getContentSize().height - 58)
		if not self.reward_list then 
			self.reward_list = ex.Tools:initTableView(self.reward_scroll_bg,self.cell_reward_data, {require("src.layer.dream.DreamRewardCell"),"ccbi/DreamRewardCell.ccbi"} , win_size, 5,cc.p(0,5),true)
		else 
			self.reward_list:initData(self.cell_reward_data)
			self.reward_list:reloadData()
		end 
	end 


end

function DreamRankLayer:updateScroll( )
	
	


end



function DreamRankLayer:onShowInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

------------------------------------------------


function DreamRankCtr:onCreate()
	self:setCCBIPath("ccbi/DreamRankLayer.ccbi")
	self:setIsSingle(false)
end

function DreamRankCtr:getLayerClass()
	return DreamRankLayer
end

function DreamRankCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:initDone()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

end

return DreamRankCtr











