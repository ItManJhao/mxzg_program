-- local PassChapterTipsCtr = class("PassChapterTipsCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PassChapterTipsLayer = class("PassChapterTipsLayer", require("src.comp.LuaLayerBase"))

function PassChapterTipsLayer:onCreate()
	-- self:addBlackBackground()
	-- local ChapterPreview_ctr = PassChapterTipsCtr:instance()
	local win_size = cc.Director:getInstance():getWinSize()
	-- self.lbl_title:enableOutline(FONT_BLACK_C4B, 1)
	self:setCascadeOpacityEnabled(true)
	self:setSwallowTouches(false)
	self:setAutoClose(false)
	self:setVisible(false)

	-- :setCascadeOpacityEnabled(true)
end

function PassChapterTipsLayer:reset(chapter_idx)
	local pre_cfg = cfg.chapterreward.chapterreward[chapter_idx - 1]
	local cur_cfg = cfg.chapterreward.chapterreward[chapter_idx]

	self:setVisible(true)

	-- if not pre_cfg or not pre_cfg.reward_base then return end
	if not cur_cfg or not cur_cfg.reward_base then return end
	for i,v in ipairs(cur_cfg.reward_base) do
		local tips = self["lbl_tips" .. i]
		local icon = self["spr_icon" .. i]
		local pre = self["lbl_pre" .. i]
		local cur = self["lbl_cur" .. i]
		cur:setString((v.item_num)  .. ex.Tools:getLang(47484) )
		if not pre_cfg then 
			pre:setString(0)
		else
			pre:setString((pre_cfg.reward_base[i].item_num) )
		end
		tips:setString(ex.Tools:getLang(cfg.item.item[v.item_type].name) .. "：")
		icon:setSpriteFrame(string.format("backpack/%d.png", v.item_type))
	end

    -- local config = cfg.chapterreward.chapterreward[math.max(1, ex.Player.chapter_data.chapter_id)]
    -- local str_name = ex.Tools:getLang(43100 + config.chapter_id)
    -- local str_mission = string.format("%d", math.max(1, ex.Player.chapter_data.chapter_id))

    -- self.lbl_title:setString(str_name .. str_mission)

	local fade_in = cc.EaseExponentialOut:create(cc.FadeIn:create(1))
	local delay_time = cc.DelayTime:create(0.5)
	local fade_out = cc.FadeOut:create(3)
	local func = cc.CallFunc:create(function ()
		self:setVisible(false)
	end)

	local seq = cc.Sequence:create(fade_in,delay_time,fade_out,func)
	self:runAction(seq)

	-- ex.Tools:ergodicAllNode(self, function(node)
	-- 	node:setOpacity(0)
	-- 	node:runAction(seq:clone())
	-- end)
end

return PassChapterTipsLayer

-----------------------------------------------------------------------------
-- function PassChapterTipsCtr:onCreate()
-- 	self:setCCBIPath("ccbi/PassChapterTipsLayer.ccbi")
-- 	self:setIsSingle(false)
-- end

-- function PassChapterTipsCtr:getLayerClass()
-- 	return PassChapterTipsLayer
-- end

-- function PassChapterTipsCtr:getPassChapterTipsLayer()
-- 	return self.layer
-- end

-- function PassChapterTipsCtr:openWindow(chapter_idx)
-- 	if self:isOpened() then
-- 		return
-- 	end
-- 	-- local sfc = cc.SpriteFrameCache:getInstance()
-- 	-- sfc:addSpriteFrames("ccbi-base/equip-icon.plist")
-- 	-- sfc:addSpriteFrames("ccbi-res/equip-refine.plist")
-- 	-- sfc:addSpriteFrames("ccbi-res/item-ChapterPreview.plist")
-- 	self:loadLayer()
-- 	self:open()
-- 	self:initData(chapter_idx)
-- end


-- function PassChapterTipsCtr:initData(chapter_idx)
-- 	local layer = self.layer
-- 	local pre_cfg = cfg.chapterreward.chapterreward[chapter_idx - 1]
-- 	local cur_cfg = cfg.chapterreward.chapterreward[chapter_idx]

-- 	-- if not pre_cfg or not pre_cfg.reward_base then return end
-- 	if not cur_cfg or not cur_cfg.reward_base then return end
-- 	for i,v in ipairs(cur_cfg.reward_base) do
-- 		local tips = layer["lbl_tips" .. i]
-- 		local icon = layer["spr_icon" .. i]
-- 		local pre = layer["lbl_pre" .. i]
-- 		local cur = layer["lbl_cur" .. i]
-- 		cur:setString(v.item_num)
-- 		if not pre_cfg then 
-- 			pre:setString(0)
-- 		else
-- 			pre:setString(pre_cfg.reward_base[i].item_num)
-- 		end
-- 		tips:setString(ex.Tools:getLang(v.item_type))
-- 		icon:setSpriteFrame(string.format("backpack/%d.png", v.item_type))
-- 	end

--     local config = cfg.chapterreward.chapterreward[ex.Player.chapter_data:getNowIdx()]
--     local str_name = ex.Tools:getLang(43100 + config.chapter_id)
--     local str_mission = string.format("%d-%d", config.chapter_id, config.mission_id)

--     layer.lbl_title:setString(str_name .. str_mission)

-- 	local fade_in = cc.EaseExponentialOut:create(cc.FadeIn:create(1))
-- 	local delay_time = cc.DelayTime:create(2)
-- 	local fade_out = cc.EaseExponentialOut:create(cc.FadeOut:create(1))
-- 	local func = cc.CallFunc:create(function ()
-- 		self:closeWindow()
-- 	end)

-- 	local seq = cc.Sequence:create(fade_in,delay_time,fade_out,func)
-- 	layer:runAction(seq)
-- end

-- return PassChapterTipsCtr
