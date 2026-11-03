local FetterPreviewCtr = class("FetterPreviewCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FetterPreviewLayer = class("FetterPreviewLayer", require("src.comp.EventLayer"))

--------------------------------------------

function FetterPreviewLayer:onCreate()
	self:addBlackBackground()
	local ctr = FetterPreviewCtr:instance()
	self.btn_close:registerScriptTapHandler(handler(ctr, ctr.closeWindow))

	self.lbl_unlock:setString(ex.Tools:getLang(47025))
	self.lbl_unlock:enableOutline(cc.c3b(14,0,136), 1)
	self.btn_right:getNormalImage():setFlippedX(true)
	self.level = 1

	self:addFont()
	self:registerBtnEvent()
end

function FetterPreviewLayer:updateLayer()
	local fetter_type = self.spine_data[1]
	local skill_type = ex.Player.fetter_data:getSkillType(fetter_type)
	ex.Tools:setSpriteFrame(self.spr_icon, string.format("skill-icon/%d.png", skill_type + 10000000))

	self.lbl_name:setString(ex.Player.hero_data:getSkillName(skill_type))
	self.lbl_info:setString(ex.Player.hero_data:getSkillDescription(skill_type, self.level))
	-- self.lbl_info:setString(ex.Player.hero_data:getSkillDescription(self.spine_data[1], self.spine_idx, 0))
end

function FetterPreviewLayer:addFont()
	self.lbl_title = cc.Label:createWithTTF("lbl_title", FONT_DEFAULT_NAME_BOLD, 26)
	self.lbl_title:enableOutline(cc.c3b(203,165,58), 2)
	self.spr_title:addChild(self.lbl_title)
	self.lbl_title:setPosition(self.spr_title:getContentSize().width / 2,self.spr_title:getContentSize().height / 2)
end

function FetterPreviewLayer:registerBtnEvent()
	self.btn_left:registerScriptTapHandler(handler(self, self.onLeft))
	self.btn_right:registerScriptTapHandler(handler(self, self.onRight))
end

function FetterPreviewLayer:unlockInfo( )
	local unlock = self:unLockType(self.type) and ex.Player.fetter_data:isUnlockSkin(self.type,self.spine_data[self.spine_idx])
	self.spr_unlock:setVisible(not unlock)
	self.lbl_unlock:setVisible(not unlock)
	self.lbl_name:setVisible(unlock)
	self.lbl_info:setVisible(unlock)
	self.spr_icon:setVisible(unlock)

	if not unlock then 
		local level = 0 
		for i = 0, table.nums(cfg.goddessbreak.goddessbreak) do
			local v = cfg.goddessbreak.goddessbreak[i]
			if self.spine_idx == v.skin then 
				level = v.lv
				break
			end
		end
		self.lbl_unlock:setString(string.format( ex.Tools:getLang(47026),level))
	end
end

function FetterPreviewLayer:onLeft(tag,pSender)
	if self.spine_idx <= 1 then return end
	self.spine_idx = self.spine_idx - 1
	self.level = self.level - 1
	self:addSpine(self.spine_idx)

	self:unlockInfo()
	-- local str = string.format(ex.Tools:getLang(47330),self.spine_data[self.spine_idx].vip_level)
	-- self.lbl_title:setString(str)
	self:updateLayer()
end

function FetterPreviewLayer:onRight(tag,pSender)
	if self.spine_idx >= #self.spine_data then return end
	self.spine_idx = self.spine_idx + 1
	self.level = self.level + 1
	self:addSpine(self.spine_idx)

	self:unlockInfo()
	-- local str = string.format(ex.Tools:getLang(47330),self.spine_data[self.spine_idx].vip_level)
	-- self.lbl_title:setString(str)
	self:updateLayer()
end

function FetterPreviewLayer:addSpine(idx)
	if self.spine_data[idx] == nil then return end

	if self.spine ~= nil then 
		self.spine:removeFromParent()
		self.spine = nil
	end

	local json = string.format("spine/%d.json",self.spine_data[idx])
	local atlas = string.format("spine/%d.atlas",self.spine_data[idx])

	self.spine = sp.SkeletonAnimation:create(json,atlas, 1)
    self.spine:setAnimation(0, "stand", true);
    self.spine:setPosition(0, 0)
    self.node_spine:addChild(self.spine)
end

function FetterPreviewLayer:unLockType(type)
	local level = ex.Player.fetter_data.vip:getVIP()
	local data = cfg.goddessunlock.goddessunlock[type]
	if not data then return false end
	return level >= data.vip_level
end


function FetterPreviewLayer:onExit()

end

-----------------------------------------------------------------------------
function FetterPreviewCtr:onCreate()
	self:setCCBIPath("ccbi/FetterPreviewLayer.ccbi")
	self:setIsSingle(false)
end

function FetterPreviewCtr:getLayerClass()
	return FetterPreviewLayer
end

function FetterPreviewCtr:getFetterPreviewLayer()
	return self.layer
end

function FetterPreviewCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()

	self:loadLayer()
	self:open()
	self:initData(data,idx)
end

function FetterPreviewCtr:initData(data)
	
	local layer = self.layer
	-- 
	local spine_data = {}
	local spine_type = data -1
	local count = 1
	-- local passive = cfg.goddesspassive.goddesspassive[data.type]

	for i=1,3 do
		-- if passive["skin"..i] ~= "" then 
			table.insert(spine_data, spine_type+count)
			count = count + 1
		-- end
	end
	layer.spine_data = spine_data
	layer.type = data
	layer.spine_idx = 1
	layer.level = 1
	layer:addSpine(layer.spine_idx)
	local str = ex.Tools:getLang(data + 3000000)
	layer.lbl_title:setString(str)
	layer:updateLayer()

	layer:unlockInfo()
end

function FetterPreviewCtr:onClickUpgrade(tag,pSender)

end

return FetterPreviewCtr
