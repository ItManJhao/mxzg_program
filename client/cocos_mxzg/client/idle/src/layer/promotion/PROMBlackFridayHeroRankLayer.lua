--[[
* @Description: 黑色星期五-英雄排行榜
* @Author: 熊梦
* @Date: 2021-3-1 14:45:00
* ]]
local PROMBlackFridayHeroRankLayer = class("PROMBlackFridayHeroRankLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMBlackFridayHeroRankCell = class("PROMBlackFridayHeroRankCell", require("src.comp.LuaLayerBase"))


function PROMBlackFridayHeroRankCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

end

function PROMBlackFridayHeroRankCell:setTableView(table_view)
    self.menu:setIsTouchInsideNode(table_view)
    self.menu:setSwallowsTouches(false)
end

function PROMBlackFridayHeroRankCell:initData(data)
    if data == nil or data.rank == nil then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/rank.plist")
    sfc:addSpriteFrames("ccbi-res/super-stage-icon.plist")

    -- dump(data)

    self.lbl_name:setString(data.name)

    self.lbl_level:setString(string.format(ex.Tools:getLang(19), data.level))


    ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data.head_id))

    self.lbl_num:setString(data.count)

    self.lbl_server_name:setString(ex.StringUtil.getServerName(data.server_id))

    if data.rank <= 3 then
        self.spr_rank:setSpriteFrame(string.format("prom-blackfriday/spr-prom-92-%dst.png", data.rank))
        self.lbl_rank:setVisible(false)
    else
        self.spr_rank:setVisible(false)
        self.lbl_rank:setString(ex.StringUtil.getServerName(data.rank))
    end

end



-----------------------------------------------------------------------------
function PROMBlackFridayHeroRankLayer:onCreateDone()
    self:setSwallowTouches(false)
    self:setAutoClose(false)
    self:addPlist()
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)

    ex.Tools:setLabelOffset(self.lbl_time_tip, self.lbl_time)

    self.node_right:setPosition(ex.p.width,self.layer_promotion:getTopY() - 100)
    self.node_left:setPosition(0,self.layer_promotion:getTopY() - 100)
    self.node_lower:setPositionY(self.layer_promotion:getTopY() - 480)
    local globla_scale = ex.p.width / 640
    self.node_upper:setScale(globla_scale < 1 and globla_scale or 1)
    self.node_upper:setPositionY(self.layer_promotion:getTopY() - (globla_scale < 1 and globla_scale * 30 or 0))


    self.scroll_view:setItemSize(cc.size(540, 135))
    self.scroll_view:setItemType(1)

    self.hero_image = nil
    self.floor_idx = nil
    self.lbl_hero_choice_title:setVisible(false)

    if #ex.Player.promotion_data.promotion92_data.hero_scores ~= 0 then
        self.btn_choose_heroes:setEnabled(false)
        ex.Tools:setAllGrayAuto(self.btn_choose_heroes:getNormalImage(),true)
    end
    
    -- -- 献花输入框
    -- self.edit_box= ccui.EditBox:create(cc.size(self.spr_notice_bg:getContentSize().width - 20, self.spr_notice_bg:getContentSize().height - 20), "other/spr-null.png", 1)  --输入框尺寸，背景图片
    -- self.edit_box:setName("clan_info_notice")
    -- self.edit_box:setPosition(cc.p(self.spr_notice_bg:getPositionX(), self.spr_notice_bg:getPositionY()))
    -- self.edit_box:setAnchorPoint(cc.p(0.5, 0.5))
    -- self.edit_box:setFontSize(26)
    -- self.edit_box:setFontColor(cc.c3b(122,71,45))
    -- self.edit_box:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) --输入键盘返回类型，done，send，go等
    -- self.edit_box:setInputMode(cc.EDITBOX_INPUT_MODE_ANY) --输入模型，如整数类型，URL，电话号码等，会检测是否符合
    -- self.edit_box:registerScriptEditBoxHandler(handler(self, self.editboxHandle)) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    -- -- self.edit_box_notice:setText(tostring(pre_input_id))
    -- -- add 熊梦 修改 公会公告
    -- self.edit_box:setFontName(FONT_DEFAULT_NAME_BOLD)
    -- self.edit_box:setText(ex.Player.clan_data.clan_notice)
    -- self:addChild(self.edit_box)

    -- promotion92_data

    self:addRedDotNode(RedDotType.ZCJ_DHZC_HSXQW_YXPHB_JLYL, self.btn_reward_preview)

    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    self:updateTimer()
    self:updateView()
    self:updateScrollView()
    self:updateBoss()


    self:addEvent(EVENT.BLACKFRIDAY.EVENT_CHOOSE_HEROES, handler(self,  self.updateBoss))
    self:addEvent(EVENT.BLACKFRIDAY.EVENT_SEND_FLOWERS, handler(self, self.updateScrollView))
    self:addEvent(EVENT.BLACKFRIDAY.EVENT_UPDATA_FLOWER, handler(self,  self.updateView))
    
    
end

function PROMBlackFridayHeroRankLayer:updateBoss()
    if #ex.Player.promotion_data.promotion92_data.hero_scores ~= 0 and self.btn_choose_heroes:isEnabled() then
        self.btn_choose_heroes:setEnabled(false)
        ex.Tools:setAllGrayAuto(self.btn_choose_heroes:getNormalImage(),true)
    end

    if self.floor_idx == nil then
        if #ex.Player.promotion_data.promotion92_data.hero_scores ~= 0 then
            self.floor_idx = 1
        else
            self.lbl_hero_choice_title:setVisible(true)
            return
        end
    end
    self.lbl_hero_choice_title:setVisible(false)
    local hero_image = ex.Player.promotion_data.promotion92_data.hero_scores[self.floor_idx].key
    if self.hero_image == hero_image then -- boss相同的话 就不重新加载形象
        return
    end
    self.hero_imag = hero_image

    self.node_hero_image:removeAllChildren()

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")

    -- 创建 boss 骨骼
    local sp_hero = require("src.person.Hero"):create("1", "1", self.hero_imag, 250, 13, nil)
	sp_hero:setShadowVisible(false)
    sp_hero:setScale(1.5 * 1.42)
    sp_hero:setPosition(0, 0)
    self.node_hero_image:addChild(sp_hero)

    local name = cfg.item.item[self.hero_imag].name
    self.lbl_hero_name:setString(ex.Tools:getLang(name))
    
    self.lbl_Integral:setString(ex.Tools:getLang(5134)..ex.Player.promotion_data.promotion92_data.hero_scores[self.floor_idx].value)

    self.lbl_flower_number:setString(ex.Player.promotion_data.promotion92_data.hero_scores[self.floor_idx].value / cfg.promotion092config.promotion092config[1].score)
end

function PROMBlackFridayHeroRankLayer:onExit()
    self:removeTimerByName("timer")
end

function PROMBlackFridayHeroRankLayer:addPlist()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/prom-blackfriday.plist")
end

function PROMBlackFridayHeroRankLayer:updateTimer()
    local is_open = cfg.funcopen["act_black_friday"].isVisible()
    if is_open ~= true then
        if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    local data = ex.Player.promotion_data:getPromotion92Data()
    if data == nil then
         if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    local cur_time = ex.Game:getServerTime()
    if cur_time > data.end_time then
         if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    self.lbl_time:setString(ex.Tools:formatTime5(data.end_time - ex.Game:getServerTime()))
end

function PROMBlackFridayHeroRankLayer:updateView()
    local config = cfg.promotion092config.promotion092config[1].deliver_cost[1]
    self.lbl_flower_item:setString(ex.Player:getItemNum(config.item_type))
end

function PROMBlackFridayHeroRankLayer:updateScrollView()


    local list = ex.Player.promotion_data.promotion92_data.flower_rank.list
    self.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = PROMBlackFridayHeroRankCell:createWithCCBIFile("ccbi/PROMBlackFridayHeroRankCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data)
        cell:setTableView(self.scroll_view)
    
        -- cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerInfo))

        return cell
    end

    self.scroll_view:reloadData(list)

    local config = cfg.promotion092config.promotion092config[1].deliver_cost[1]
    self.lbl_flower_item:setString(ex.Player:getItemNum(config.item_type))

    -- 更新我的排名
    if ex.Player.promotion_data.promotion92_data.flower_rank.self.rank <= 0 then
        self.lbl_rank_self:setString(ex.Tools:getLang(74811)..ex.Tools:getLang(74812))
    else
        self.lbl_rank_self:setString(ex.Tools:getLang(74811)..ex.Player.promotion_data.promotion92_data.flower_rank.self.rank)
    end

end



-----------------------------------------------------------------------------------
-- 奖励预览
function PROMBlackFridayHeroRankLayer:onRewardPreview()
    require("src.layer.promotion.PROMBlackFridayHeroRankRewardCtr"):instance():openWindow(1)
end

-- 英雄排行
function PROMBlackFridayHeroRankLayer:onHeroRank()
    require("src.layer.promotion.PROMBlackFridayHeroRankHeroRankCtr"):instance():openWindow()
end

-- 获得道具
function PROMBlackFridayHeroRankLayer:onGetItem()
    if self.hero_imag == nil then
        ex.MessageView:add(ex.Tools:getLang(91865))
        return
    end
    
    if ex.Player.promotion_data.promotion92_data.deliver_count < cfg.promotion092config.promotion092config[1].need_count then
        ex.MessageView:add(ex.Tools:getLang(5014))
        return
    end


    local function callback( num )
        local res_buy = Promotion092_pb.GReqBuyFlower()
        res_buy.count = num
        NetManager:sendMessage(ProtocolID.GReqBuyFlower,res_buy)
	end

    local limit_num = -1

    local item_price = {}

    local item = {}
 

    for i,v in ipairs(cfg.promotion092buyflower.promotion092buyflower) do
        if ex.Player.promotion_data.promotion92_data.buy_count < v.count_max then
            limit_num = v.count_max - ex.Player.promotion_data.promotion92_data.buy_count

            item_price.item_type = v.cost[1].item_type
            item_price.item_num = v.cost[1].item_num

            item.item_type = v.reward[1].item_type
            item.item_num =v.reward[1].item_num
            break
        end
    end
   
    require("src.layer.ItemSelectCtr"):instance():openWindow(ex.Tools:getLang(41228), item, callback, item_price, limit_num)
end

-- 说明
function PROMBlackFridayHeroRankLayer:onInfo()
    ex.InfoCtr:openWindow(ex.Tools:getLang(91855), ex.Tools:getLang(91864))
end

-- 左右滑动英雄
function PROMBlackFridayHeroRankLayer:onSliding(tag,pSender)

    if self.hero_imag == nil then
        ex.MessageView:add(ex.Tools:getLang(91865))
        return
    end

    if self.floor_idx + tag < 1 then
        return
    elseif self.floor_idx + tag > #ex.Player.promotion_data.promotion92_data.hero_scores then
        return
    else
        self.floor_idx = self.floor_idx + tag
    end
    self:updateBoss()
end

-- 放大镜 查看道具概率
function PROMBlackFridayHeroRankLayer:onProbability()
    local table_data={}
    local max_weight = 0
    for k,v in ipairs(cfg.promotion092deliverrandomreward.promotion092deliverrandomreward) do
        local table_data_temp = {}
        table_data_temp.cost = v.reward
        table_data_temp.weight = v.weight
        table_data_temp.idx = v.idx
        table.insert(table_data,table_data_temp)
        max_weight = max_weight + v.weight
	end
    require("src.layer.PROMChristmasHappyPreviewCtr"):instance():openWindow(table_data,max_weight)
end

-- 減
function PROMBlackFridayHeroRankLayer:onSub()
    local config = cfg.promotion092config.promotion092config[1].deliver_cost[1]
    local max_num = ex.Player:getItemNum(config.item_type)
    if tonumber(self.lbl_flower_item:getString()) == max_num and max_num == 0 then
        return
    end
    local num = tonumber(self.lbl_flower_item:getString()) - 1 
    self.lbl_flower_item:setString(tostring(num > 0 and num or 1))
end

-- 加
function PROMBlackFridayHeroRankLayer:onAdd()
    local config = cfg.promotion092config.promotion092config[1].deliver_cost[1]
    local max_num = ex.Player:getItemNum(config.item_type)

    local num = tonumber(self.lbl_flower_item:getString()) + 1 
    num = num > max_num and max_num or num
    num =  num > 999 and 999 or num
    self.lbl_flower_item:setString(tostring(num))
end

-- 选择英雄
function PROMBlackFridayHeroRankLayer:onChooseHeroes()
    require("src.layer.promotion.PROMBlackFridayHeroRankHeroChoiceCtr"):instance():openWindow()
end

-- 送花
function PROMBlackFridayHeroRankLayer:onSendflowers()
    if self.hero_imag == nil then
        ex.MessageView:add(ex.Tools:getLang(91865))
        return
    end

    local config = cfg.promotion092config.promotion092config[1].deliver_cost[1]
    if ex.Player:getItemNum(config.item_type) < config.item_num then
        ex.MessageView:add(ex.Tools:getLang(30503))
        return
    end

    local req = Promotion092_pb.GReqDeliverFlower()
    req.hero_type = self.hero_imag
    req.count = tonumber(self.lbl_flower_item:getString())
    NetManager:sendMessage(ProtocolID.GReqDeliverFlower, req)

end



return PROMBlackFridayHeroRankLayer
