local FantasyTowerLayer = class("FantasyTowerLayer", require("src.comp.EventLayer"))
local FantasyTowerCell = class("FantasyTowerCell", require("src.comp.LuaLayerBase"))
local FantasyTowerBattleLayer = class("FantasyTowerBattleLayer", require("src.comp.LuaBattleLayer"))

FantasyTowerLayer.ctr = ctr.fantasy_tower

function FantasyTowerCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.spr_stage_bg:setLocalZOrder(1)
    self.lbl_stage:setLocalZOrder(1)

    -- 创建一个富文本,展示
    self.lbl_sweep = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#5A3509")
	:setPosition(cc.p(464.0, 46))
	:setAnchorPoint(cc.p(0.5, 0.5))
    self.node_sweep:addChild(self.lbl_sweep)     
end

function FantasyTowerCell:resetData(data)
    self.data = data
    -- 加两层空白层 第一层和最后一层不显示
    if data.mission_id == 0 or data.mission_id > data.stage_max then
        self.lbl_stage:removeFromParent()
        self.spr_stage_bg:removeFromParent()
        self.spr_status:removeFromParent()
        self.node_sweep:removeFromParent()
        self.node_first_ward:removeFromParent()
        self.lbl_battle:removeFromParent()
        self.node_first_ward = nil
        return
    else
         -- 每一层 4个状态 可以挑战，扫荡，已通过, 未挑战
        self.lbl_stage:setString(string.format(ex.Tools:getLang(47375), data.mission_id))
        self:setLocalZOrder(99999 - data.mission_id)
           
        if data.mission_id == data.now_stage then
            --可以挑战
           self:showAtk(data)
        elseif data.mission_id == data.now_stage - 1 then
            -- 扫荡
           self:showMoppingUp(data)
        else
            --已通过, 未挑战
          self:showPassOrNoPass(data)
        end
    end
    self:showReward(data)
end

--可以挑战
function FantasyTowerCell:showAtk(data)
    local x, y = self.spr_status:getPosition()
    self.spr_status:removeFromParent()
    self.node_sweep:removeFromParent()
    self.node_first_ward:setPositionY(self.spr_stage_bg:getPositionY() )

    ex.Tools:setSpriteFrame(self.spr_bg, string.format("fantasy-tower/spr-bg-%d.png", 2))
    ex.Tools:setSpriteFrame(self.spr_stage_bg, "fantasy-tower/spr-bg-12.png")
    
    -- 添加刀剑特效
    local spine_sword = sp.SkeletonAnimation:create("spine/battle-sword.json","spine/battle-sword.atlas", 1)
    spine_sword:setAnimation(0, "stand", true);
    spine_sword:setPosition(460, self:getContentSize().height * 0.5 )
    spine_sword:setScale(0.5)
    spine_sword:setName("tower_cur_cell")
    self:addChild(spine_sword, 10)
end

 -- 扫荡
function FantasyTowerCell:showMoppingUp(data)
    self.node_first_ward:removeFromParent()
    self.node_first_ward = nil
    self.lbl_battle:removeFromParent()

    ex.Tools:setSpriteFrame(self.spr_status, "fantasy-tower-lang/spr-status-1.png")
    ex.Tools:setSpriteFrame(self.spr_bg, "fantasy-tower/spr-bg-2.png")

    local max_times = table.nums(cfg.towersweep.towersweep)

    local config = cfg.towersweep.towersweep[ex.Player.tower_data.sweep_times + 1]
    local free_count = ex.Player.tower_data:getFreeSweepCount()
    if ex.Player.tower_data.sweep_times < free_count then
        self.lbl_sweep:setXmlTextLua(string.format(ex.Tools:getLang(47560),  free_count - ex.Player.tower_data.sweep_times))
        self.spr_status:removeFromParent()
    elseif max_times > ex.Player.tower_data.sweep_times then
        self.lbl_sweep:setXmlTextLua(string.format(ex.Tools:getLang(47724), "backpack/" .. ItemType.IT_GEM ,config.cost_gem))
        self.spr_status:removeFromParent()
    else
        self.node_sweep:removeFromParent()
    end
end

 --已通过, 未挑战
function FantasyTowerCell:showPassOrNoPass(data)
    if data.mission_id < data.now_stage then
        self.node_first_ward:removeFromParent()
        self.node_first_ward = nil
    else
        self.spr_status:removeFromParent()
        self.node_first_ward:setPositionY(self.spr_stage_bg:getPositionY())
        self.lbl_tip1:removeFromParent()
        self.lbl_tip2:removeFromParent()
        self.lbl_tip3:removeFromParent()
        self.spr_reward_bg:setContentSize(cc.size(self.spr_reward_bg:getContentSize().width, self.spr_reward_bg:getContentSize().height - 25))
        self.scroll_view_reward1:setPositionY(self.scroll_view_reward1:getPositionY() + 7)
        self.lbl_tip4:setPositionY(self.lbl_tip4:getPositionY() + 7)

        if data.mission_id > data.now_stage + 2 then
            self.node_first_ward:removeFromParent()
            self.node_first_ward = nil
        end
    end
    self.lbl_battle:removeFromParent()
    self.node_sweep:removeFromParent()
    ex.Tools:setSpriteFrame(self.spr_bg, string.format("fantasy-tower/spr-bg-%d.png", data.mission_id < data.now_stage and 2 or 1))
end

function FantasyTowerCell:showReward(data)
    if self.node_first_ward ~= nil then
        local reward = ex.Player.tower_data:getRewardList(data.mission_id)

        -- 只显示最后一个奖励
        if table.nums(reward) > 0 then
            reward = {[1] = reward[table.nums(reward)]}
        end

        self.scroll_view_reward1:setItemSize(cc.size(72, 60))
        self.scroll_view_reward1.createItemFunction = function(data, scale)
            local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
            item:setScale(0.58)
            item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
            return item
        end
        self.scroll_view_reward1:reloadData(reward)
    end
end


function FantasyTowerLayer:getAsynImage()
    local vec_image = {
    }
    return vec_image
end

function FantasyTowerLayer:onCreate()
    print("FantasyTowerLayer:onCreate")
    
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    local win_size = cc.Director:getInstance():getWinSize()
    self.cell_size = cc.Sprite:createWithSpriteFrameName("fantasy-tower/spr-bg-1.png"):getContentSize()
    local scale = (win_size.width / (self.cell_size.width))
    self.cell_scale = scale
    self.cell_size.width = self.cell_size.width * scale
    self.cell_size.height = self.cell_size.height * scale

    local bang_height = require("src.model.Game"):instance():getNotchHeight()
    self.node_energy:setPositionY(self.node_energy:getPositionY() - bang_height)
    self.node_btn:setPositionY(self.node_btn:getPositionY() - bang_height)
    self.btn_info:setPositionY(self.btn_info:getPositionY() - bang_height)

    self.scroll_view = require("src.comp.UIScrollViewBackpack"):createWithSize(cc.size(win_size.width, win_size.height))
    self.scroll_view:setItemType(1)
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view.nodeTouched = handler(self, self.tableCellTouched)	
    self.scroll_view:setItemSize(cc.size(self.cell_size.width, self.cell_size.height))
    self:addChild(self.scroll_view, -1)

    self.scroll_view_reward1:setItemSize(cc.size(72, 72))
    self.scroll_view_reward2:setItemSize(cc.size(90, 90))

    -- 创建一个富文本,展示
    self.lbl_tip = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(20)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#5A3509")
	:setPosition(cc.p(self.spr_tip_bg:getPositionX(), self.spr_tip_bg:getPositionY() + 10))
	:setAnchorPoint(cc.p(0.5, 0.5))
    self.spr_tip_bg:getParent():addChild(self.lbl_tip)

    self:addEvent(EVENT.TOWER_EVENT.TOWER_LAYER_UPDATE, handler(self, self.updateLayer))
    self:addEvent(EVENT.RANK_EVENT.UPDATE_TOWER_LAYER, handler(self, self.updateRank))
    self:updateLayer()
 
    self:addRedDotNode(RedDotType.ZCJ_DHZC_HJZT_STJL, self.btn_reward)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_HJZT_HMT, self.btn_magic_tower)
end

function FantasyTowerLayer:updateRank()
    for i=1,3 do
        local rank_data = ex.Player.tower_data.rank_list[i]
        local name = rank_data and rank_data.name or ex.Tools:getLang(47593)
        local stage = rank_data and rank_data.score or ""
        self["lbl_rank_name"..i]:setString(name)
        self["lbl_rank_stage"..i]:setString(stage)
    end

    self.lbl_self_rank:setString(ex.Player.tower_data.rank_self.rank <= 0 and ex.Tools:getLang(47749) or ex.Player.tower_data.rank_self.rank)
end

function FantasyTowerLayer:tableCellTouched(tag,pSender)
    local now_stage = ex.Player.tower_data:getNowStage()
    local stage_num = ex.Player.tower_data:getStageNum()

    -- 点击的cell。是第0层。或者最大层。或者不是当前通关的层数。则是无效的点击
    if pSender.data.mission_id == 0 or pSender.data.mission_id > stage_num or (pSender.data.mission_id ~= now_stage and pSender.data.mission_id ~= now_stage - 1) then
        return
    end
    if ex.Player.tower_data.energy <= 0 then 
        ex.MessageView:add(ex.Tools:getLang(47743))
        return 
    end
    require("src.layer.fantasytower.FantasyTowerPreviewCtr"):instance():openWindow(pSender.data.mission_id, handler(self, self.createBattle))
end

function FantasyTowerLayer:onExit()
    if self.scheduler_id then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_id)
        self.scheduler_id = nil
    end
end

function FantasyTowerLayer:updateLayer()
    local now_stage = ex.Player.tower_data:getNowStage()
    self.scroll_view.createItemFunction = function(data)
		local cell = FantasyTowerCell:createWithCCBIFile("ccbi/FantasyTowerCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setScale(self.cell_scale)
		cell:resetData(data)
		return cell
	end

    local stage_data_list = {}
    table.insert(stage_data_list, {mission_id = 1301, stage_max = 1300})
    local tower_max = table.nums(cfg.towerreward.towerreward)
    for i=1,tower_max do
        local config_data = clone(cfg.towerreward.towerreward[tower_max - i + 1])
        config_data.stage_max = tower_max
        config_data.challenger_data = nil
        config_data.is_show_sword = (config_data.mission_id == now_stage + 1)
        config_data.is_max = false
        config_data.now_stage = now_stage
        config_data.callback = handler(self, self.tableCellTouched)

        table.insert(stage_data_list, config_data)
    end
    table.insert(stage_data_list, {mission_id = 0})
    self.scroll_view:reloadData(stage_data_list)

    self:updatePos()
    self:updateTime()
    self:updateReward()
   
    NetManager:sendMessage(ProtocolID.GReqTowerRank)
end

function FantasyTowerLayer:updatePos()  
    local index_diff = ex.Player.tower_data:getNowStage() 
    self.btn_magic_tower:setVisible(cfg.funcopen.magic_tower.isVisible())
    self.lbl_res:setString(string.format("%d", ex.Player.tower_data.energy))

    -- 当前位置居中显示
    local y = index_diff * self.cell_size.height
    y = -(y - self.scroll_view:getViewSize().height / 2)
    y = math.min(y, 0)
    -- 设置位置
    self.scroll_view:setContentOffset(cc.p(0, y))
end

function FantasyTowerLayer:updateTime()
    local max_energy = ex.Tools:getSysCfg("tower_tickets_limit")
    local is_schedul = ex.Player.tower_data.energy < max_energy
    self.lbl_time:setVisible(is_schedul)
    self.lbl_time_text:setVisible(is_schedul)

    if is_schedul then
        if not self.scheduler_id then
            self.scheduler_id = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.update), 1, false)
            self:update()
        end
    elseif self.scheduler_id then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_id)
        self.scheduler_id = nil
    end
end

function FantasyTowerLayer:updateReward()
    local now_stage = ex.Player.tower_data:getNowStage()
    local reward_stage = math.min(now_stage, table.nums(cfg.towerreward.towerreward))
    -- 更新塔的奖励
    self.lbl_now_reward:setString(string.format(ex.Tools:getLang(47147), reward_stage))
    -- self.lbl_tip:setXmlTextLua(cfg.towerreward.towerreward[reward_stage].tip)
    self.lbl_tip:setXmlTextLua(ex.Tools:getLang(cfg.towerreward.towerreward[reward_stage].tip))

    self.scroll_view_reward1.createItemFunction = function(data, scale)
        local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
        item:setScale(0.56)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        return item
    end
    self.scroll_view_reward1:reloadData(ex.Player.tower_data:getRewardList(now_stage))

    local str_stage, str_reward, reward = ex.Player.tower_data:getNextTip() 
    self.scroll_view_reward2.createItemFunction = function(data, scale)
        local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
        item:setScale(0.7)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        return item
    end
    self.scroll_view_reward2:reloadData(reward)
    self.lbl_stage_tip:setString(str_stage)
    self.lbl_tip:setXmlTextLua(str_reward)
end

function FantasyTowerLayer:update()
    local now_time = ex.Game:getServerTime()
    local time_interval = ex.Tools:getSysCfg("tower_tickets_regenerate_time")
    local time_diff = now_time - (ex.Player.tower_data.energy_time)

    if time_diff > time_interval then
        local add_num = math.floor(time_diff / time_interval)
        time_diff = time_diff - add_num * time_interval
        ex.Player.tower_data.energy_time = ex.Player.tower_data.energy_time + add_num * time_interval

        NetManager:sendMessage(ProtocolID.GReqTowerData)

        -- 显示时间
        local str_time = string.format("%.2d:%.2d:%.2d", time_diff / (60 * 60), time_diff / 60 % 60, time_diff % 60)
        self.lbl_time:setString(str_time)
        self:updateLayer()
    else
        time_diff = time_interval - time_diff
        -- 显示时间
        local str_time = ex.StringUtil.convertToTimeFormat(time_diff)
        self.lbl_time:setString(str_time)
    end
end

function FantasyTowerLayer:createBattle(stage, vec_battle, fetter_type)
    -- 判断体力值
    if ex.Player.tower_data.energy <= 0 then
        ex.MessageView:add(ex.Tools:getLang(47527))
        return
    end

    ctr.fantasy_tower:battle(stage)
end

function FantasyTowerLayer:onBattleEnd(event, is_win)
    self:updateLayer()

    -- 如果当前显示不是这个layer。则这一步会删除本身
    -- local main_ctr = ex.MainSceneCtr
    -- main_ctr:removeKeepLayer(MainSceneType.MAINCITY_FANTASY_TOWER)
    ex.Tools:autoPlaySceneMusic()
end

function FantasyTowerLayer:onBuyEnergy(tag, pSender)
    require("src.layer.fantasytower.FantasyTowerBuyCtr"):instance():openWindow()
end

function FantasyTowerLayer:onBack(tag, pSender)
    if not ex.MainSceneCtr:backLastLayer() then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    end
end

function FantasyTowerLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42012), ex.Tools:getLang(42013))
end

function FantasyTowerLayer:onRank(tag, pSender)
    ex.Player.rank_data:onRefresh()
    require("src.layer.RankTopThreeCtr"):instance():openWindow(2)
end

function FantasyTowerLayer:onReward(tag, pSender)
    ex.Player.tower_data:sortReward()
    require("src.layer.MissionRewardCtr"):instance():openWindow(ex.Player.tower_data.vec_tower_reward_status,
    require("src.layer.fantasytower.FantasyTowerRewardCell"))
end

function FantasyTowerLayer:onMagicTower(tag, pSender)
    ex.JumpManager:jumpByAtom("magic_tower")
end

return FantasyTowerLayer
