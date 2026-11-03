local ChapterPreviewCtr = class("ChapterPreviewCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ChapterPreviewLayer = class("ChapterPreviewLayer", require("src.comp.LuaLayerBase"))

function ChapterPreviewLayer:onCreate()
	self:addBlackBackground()
	local ChapterPreview_ctr = ChapterPreviewCtr:instance()
	local win_size = cc.Director:getInstance():getWinSize();
	local height = Maths.min(self:getContentSize().height, win_size.height);
	self:setScale(height / self:getContentSize().height);
	self.btn_close:registerScriptTapHandler(handler(ChapterPreview_ctr, ChapterPreview_ctr.closeWindow))


end

-----------------------------------------------------------------------------
function ChapterPreviewCtr:onCreate()
	self:setCCBIPath("ccbi/ChapterPreviewLayer.ccbi")
	self:setIsSingle(false)
end

function ChapterPreviewCtr:getLayerClass()
	return ChapterPreviewLayer
end

function ChapterPreviewCtr:getChapterPreviewLayer()
	return self.layer
end

function ChapterPreviewCtr:openWindow(chapter_idx)
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
	self:open()
	self:initData(chapter_idx)
end


function ChapterPreviewCtr:initData(chapter_idx)
	local layer = self.layer
	layer.idx = chapter_idx

    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onGo))

	local config = cfg.chapterreward.chapterreward[chapter_idx]
	local second = tostring(config.unique_gain_frequency / 60) .. "s"

	local chapter = config.chapter_id % 100
	local mission = config.mission_id % 100

	layer.lbl_name:setString(string.format(ex.Tools:getLang(47257), chapter, mission))

	-- 显示资源
	layer.lbl_res1:setString(tostring(config.reward_base[1].item_num) .. "/" .. second )
	layer.lbl_res2:setString(tostring(config.reward_base[3].item_num) .. "/" .. second )
	layer.lbl_res3:setString(tostring(config.reward_base[2].item_num) .. "/" .. second )


	local reward = config.reward_unique or {}
	-- 显示
	layer.scroll_view:getContainer():removeAllChildren()

	local menu = cpp.UIMenu:create()
    menu:setSwallowsTouches(false)
    menu:setPosition(cc.p(0, 0))
    menu:setIsTouchInsideNode(layer.scroll_view)
    layer.scroll_view:getContainer():addChild(menu)

    local view_size = layer.scroll_view:getViewSize()
    local item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
	item_size = cc.size(item_size.width + 20,  item_size.height + 30)
	
	local num = table.nums(reward)
	local col = math.floor(view_size.width / item_size.width) -- 列数
	col = math.min(col, num)
	local cont_height = item_size.height * math.ceil(1.0 * num / col)
	cont_height = math.max(cont_height , view_size.height)

	layer.scroll_view:setContentSize(cc.size(view_size.width, cont_height))
	layer.scroll_view:setContentOffset(cc.p(0, view_size.height - cont_height))

  	cont_height = cont_height - item_size.height * 0.5

 	local start = cc.p(view_size.width * 0.5 - item_size.width * (col - 1) * 0.5, cont_height)

    local index = 0
	for _,v in pairs(reward) do
		local x = index % col
        local y = math.floor(index / col)

        local pos = cc.p(start.x + x * item_size.width, start.y - y * item_size.height)

		local item = ex.Player.backpack_data:createWithData(v.type, v.num)
		item:setPosition(pos)
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        menu:addChild(item)

		index = index + 1
    end
end

function ChapterPreviewCtr:onItemInfo(tag, pSender)
	-- dump(pSender.item_type, "pSender")
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function ChapterPreviewCtr:onGo(chapter_idx)
	local layer_main_battle = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MLT_BATTLE)
	layer_main_battle:onBattleMissionDone(self.layer.idx)
	self:closeWindow()
end

return ChapterPreviewCtr
