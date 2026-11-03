local GuideCtr = class("GuideCtr", require("src.layer.guide.GuideBase"))

-- local npc_talk_ctr = 
-- require("src.layer.NpcTalkCtr"):instance()
local is_finish = false             -- 是否已经完成
local is_recv_protocol = false      -- 是否在等待数据
local is_send_protocol = false
local is_wait_window_open = false
local is_wait_window_close = false

local _instance = nil

function GuideCtr:instance()
    if _instance == nil and (not is_finish) then
        _instance = self:create()
        _instance:retain()
        _instance:initDone()
    end
    return _instance
end

function GuideCtr:initDone()
    self.super.initDone(self)

    self.guide_num = self:getGuideNum()
    -- self.guide_num = 99999

    if is_skip_guide == true and ex.MainSceneCtr:instance():getMainScene() and cc.Director:getInstance():getRunningScene():getChildByTag(88888889) == nil then
        local layer = require("src.comp.EventLayer"):create()
        -- layer:setScale()
        layer:setContentSize(cc.size(130, 30))
        layer:setTag(88888889)
        layer:setPosition(0, 500)
        cc.Director:getInstance():getRunningScene():addChild(layer, 9999)

        local bg = cc.LayerColor:create(cc.c4b(0,0,0,255), layer:getContentSize().width, layer:getContentSize().height)
        layer:addChild(bg)

        local lbl_xx = cc.Label:createWithTTF(ex.Tools:getLang(47264), FONT_DEFAULT_NAME_BOLD, 20)
        lbl_xx:setAnchorPoint(cc.p(0, 0))
        layer:addChild(lbl_xx)

        layer.onExit = function()
            local event_dispatcher = layer:getEventDispatcher() 
            event_dispatcher:removeEventListener(layer.listener_touch)
            cc.Director:getInstance():getRunningScene().layer_skip_guide = nil
        end

        layer.listener_touch = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
        layer.listener_touch:setSwallowTouches(false)
        layer.listener_touch:registerScriptHandler(function (touch, event)
            local touchLocation = touch:getLocation()
            touchLocation = layer:getParent():convertToNodeSpace(touchLocation)
            local bBox = layer:getBoundingBox()
            if cc.rectContainsPoint(bBox, touchLocation) then
                ex.MessageView:add(ex.Tools:getLang(47264))
                layer:runAction(cc.RemoveSelf:create())

                local guide_ctr = require("src.layer.guide.GuideCtr"):instance()
                if guide_ctr then
                    guide_ctr.guide_num = 1900
                    guide_ctr:saveGuideNum()
                    guide_ctr:remove(true)
                    if ex.Player.is_rename == 0 then
                        require("src.layer.NpcTalkCtr"):instance():closeWindow()
                        require("src.layer.RenameCtr"):instance():openWindow()
                    end
                end

            end
            return false
        end, cc.Handler.EVENT_TOUCH_BEGAN)
        layer.listener_touch:registerScriptHandler(function() end, cc.Handler.EVENT_TOUCH_MOVED)
        layer.listener_touch:registerScriptHandler(function() end, cc.Handler.EVENT_TOUCH_ENDED)
        layer.listener_touch:registerScriptHandler(function() end, cc.Handler.EVENT_TOUCH_CANCELLED)
        local event_dispatcher = layer:getEventDispatcher() 
        event_dispatcher:addEventListenerWithFixedPriority(layer.listener_touch, -99999999)

        cc.Director:getInstance():getRunningScene().layer_skip_guide = layer
    end

    if device.platform == "mac" then
        -- print("guide_num 11111")
        -- self.guide_num = 0
        -- self.guide_num = 400
        -- self.guide_num = 99999
        -- self:saveGuideNum()
    end
end

-----------------------模块------------------------
function GuideCtr:restart()
    local guide_ctr = GuideCtr:instance()
    if guide_ctr and guide_ctr.vec_guide_data ~= nil then
        if  table.nums(guide_ctr.vec_guide_data) > 0 or (guide_ctr:executeEntireFile()) then
            -- guide_ctr.
            guide_ctr:executeGuide()
        end
    end
end

function GuideCtr:isExecutingGuide()
    if is_finish then
        return false
    end

    local guide_ctr = GuideCtr:instance()
    if guide_ctr then
        return table.nums(guide_ctr.vec_guide_data) > 0
    end
    
    return false
end

-- 移除自己
function GuideCtr:remove(is_reset)
    print("GuideCtr:remove")
    is_recv_protocol = false
    is_send_protocol = false
    is_wait_window_open = false
    is_wait_window_close = false
    
    if is_finish then
        return
    end

    local guide_ctr = GuideCtr:instance()
    if guide_ctr then
        guide_ctr:removeAllData()
    end

    if is_reset then
        is_finish = false
    end

    _instance = nil

    -- if cpp.SocialPlatform:instance():isDebug() then
        cc.Director:getInstance():getRunningScene():removeChildByTag(88888889)
    -- end
end


-----------------------删除------------------------

-- 重置文件数据
function GuideCtr:resetData()
    self.super.resetData(self)

    is_recv_protocol = false
    is_send_protocol = false
    is_wait_window_open = false
    is_wait_window_close = false
end



-- 读取文件队列.并执行对应的文件.
function GuideCtr:executeEntireFile()
    self:resetData()

    if self.guide_num ~= 0 and (not self.is_saved_num) then
        self:saveGuideNum()
    end

    local file_num = 0
    local is_succeed = false

    self.is_loading_scene = true
    self.is_saved_num = false

    local file_name = "src.config.guide.guideentire"

    local file_content = self:readFile(file_name)
    if file_content then
        for i,v in ipairs(file_content) do
            file_num = v.serial
            if file_num == self.guide_num then
                local data = file_content[i + 1]
                if data then
                    file_name = data.branch_guide
                    self.guide_num = data.serial
                    is_succeed = true
                end
                break
            end
        end
    end


    



    if is_succeed then
        self:readGuideFile(file_name)
        print("guide execute_file_name =", file_name)
    else
        self:remove(true)
        is_finish = true
        print(ex.Tools:getLang(47459))

        -- 执行一次等级奖励
        if ex then
            require("src.layer.guide.GuideLevelCtr"):instance():executeFile(1, ex.Player.level)
        end
    end
    
    return is_succeed
end


function GuideCtr:executeGuide()

    -- 判断当前文件步骤是否执行完毕
    if self.step_num >= table.nums(self.vec_guide_data) then
        -- 不处于分离任务中..并且有剩余文件未执行
        -- 执行下一个文件
        if self:executeEntireFile() then
            self:executeGuide()
        end
        return
    end

    self.super.executeGuide(self)
end


-- 保存文件进度.
function GuideCtr:saveGuideNum()
    -- local req_serial = cpp.ByteArray:create()
    -- req_serial:writeInt(ProtocolID.GReqGuideSerial)
    -- req_serial:writeInt(self.guide_num)
    -- cpp.NetManager:instance():sendByteArray(req_serial)
    local req_serial = Role_pb.GReqGuideSerial()
    table.insert(req_serial.serial, self.guide_num)
    NetManager:sendMessage(ProtocolID.GReqGuideSerial, req_serial)
    
    require("src.data.Player"):instance().guide_serial = self.guide_num
    require("src.platform.SocialPlatform"):submitRoleInfoLua("guide_num")
    
    print("guide saveGuideNum =", self.guide_num)
end


-- 获取文件进度
function GuideCtr:getGuideNum()
    return require("src.data.Player"):instance().guide_serial
end

-- 
function GuideCtr:getGuideDataByStep(step)
    return self.vec_guide_data[step + 1]
end

-- 关闭其他的窗口
function GuideCtr:closeOtherWindow()
    -- cpp.NodeCtr:closeOtherWindow()
    require("src.comp.LuaNodeCtr"):closeOtherWindow()
    -- require("src.comp.LuaNodeCtr"):closeOtherWindow()
    self:finishGuide()
end

-- 检查是否可以执行该文件
function GuideCtr:checkFile(data)
    if data.check_type == "rename" then
        if ex.Player.is_rename == 0 then
            self:finishGuide()
            return
        end
    elseif data.check_type == "summon_num" then
        local has_summon_num = ex.Player:getItemNum(ItemType.IT_SUMMON_POINT)
        if has_summon_num < data.num then
            self:finishGuide()
            return
        end
    elseif data.check_type == "hero_num" then
        if table.nums(ex.Player.hero_data.hero_list) <= data.num then
            self:executeFailFile(data.fail_file)
            return
        else
            self:finishGuide()
            return
        end
    elseif data.check_type == "altar" then
        local num = ex.Player.hero_data:getHeroNum(data.hero_type)
        if num >= data.num then
            self:finishGuide()
            return 
        end
    elseif data.check_type == "item" then
        local num = ex.Player.backpack_data:getItemNum(data.item_type)
        if num >= data.num then
            self:finishGuide()
            return 
        end
    elseif data.check_type == "usepieces" then
        local item_type = data.item_type
        if data.mission_hero_config then
            local config = cfg.chapterreward.chapterreward[data.mission_hero_config]
            if config then
                for k,v in pairs(config.first_reward) do
                    if v.item_type >= 20000000 then
                        -- file_name =  string.format("hero-icon/%s.png", v.item_type)
                        item_type = v.item_type
                        break
                    end
                end
            end
        end
        


        local num = ex.Player:getItemNum(item_type)
        if num >= data.num then
            self:finishGuide()
            return 
        end
    elseif data.check_type == "hero_lineup" then
        local is_lineup = not ex.Player.lineup_data:isNullBattleList(LineupType.CHAPTER)
        if is_lineup == false then
            self:executeFailFile(data.fail_file)
            return
        else
            self:finishGuide()
            return 
        end
    elseif data.check_type == "gem_num" then
        if ex.Player.gem < data.num then
        else
            self:finishGuide()
            return
        end
    elseif data.check_type == "battle_num" then
        if ex.Player.battle_data:getBattleCount() < data.num then
            self:finishGuide()
            return
        end
    elseif data.check_type == "fetter_unlock" then
        local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(data.idx)
        -- dump(fetter_data, "fetter_data")
        if fetter_data and fetter_data.level < 1 then
            self:finishGuide()
            return
        end
    elseif data.check_type == "findNode" then
        if self.node_cache ~= nil then
            self:finishGuide()
            return
        end
    elseif data.check_type == "fetter_lineup" then
        local fetter_type = ex.Player.lineup_data:getFettersType(LineupType.CHAPTER)
        if fetter_type == 0 then
            self:finishGuide()
            return
        end
    end
    
    -- 移除失效的步骤
    self:removeMissStep(data)
    self:finishGuide()
end

-- 处理错误文件
function GuideCtr:executeFailFile(fail_file)
    local file = "src.config.guide.guideentire"
    local file_content = self:readFile(file)

    local pre_guide_num = 99999
    for i,v in ipairs(file_content) do
        if v.branch_guide == fail_file then
            self.guide_num = pre_guide_num
            break
        end
        pre_guide_num = v.serial
    end

    self:executeEntireFile()
    self:executeGuide()
end




-----------------------窗口------------------------
-- 监听窗口打开.
function GuideCtr:addOpenWindowListen(data)
    is_wait_window_open = true
    self.super.addOpenWindowListen(self, data)
end

function GuideCtr:removeOpenWindowListen(data)
    is_wait_window_open = false
    self.super.removeOpenWindowListen(self, data)
end


-- 监听窗口关闭.
function GuideCtr:addCloseWindowListen(data)
    is_wait_window_close = true
    self.super.addCloseWindowListen(self, data)
end

-- 取消窗口监听.
function GuideCtr:removeCloseWindowListen(data)
    is_wait_window_close = false
    self.super.removeCloseWindowListen(self, data)
end

-- 窗口打开
function GuideCtr:windowsOpen(window, ccbi_path)
    if is_finish then
        return
    end

    if is_wait_window_open == false then
        return
    end

    local scene = require("src.scene.SceneCtr"):getRunningSceneCtr()
    if not scene then
        return
    end

    local guide_ctr = GuideCtr:instance()
    if guide_ctr and guide_ctr.is_listen_open then
        local data = guide_ctr.vec_guide_data[guide_ctr.step_open_num]
        local window_ccbi_path = data.ccbi_path

        if window_ccbi_path == ccbi_path then
            guide_ctr.step_num = data.step - 1
            guide_ctr:finishGuide()
        end
    end
end

-- 窗口关闭
function GuideCtr:windowsClose(window, ccbi_path)
    -- print("GuideCtr:windowsClose111")
    if is_finish then
        return
    end
        -- print("GuideCtr:windowsClose222")
    if is_wait_window_close == false then
        return
    end
        -- print("GuideCtr:windowsClose333")

    local scene = require("src.scene.SceneCtr"):getRunningSceneCtr()
    if not scene then
        return
    end
        -- print("GuideCtr:windowsClose333")

    local guide_ctr = GuideCtr:instance()
    if guide_ctr and guide_ctr.is_listen_close then
        local data = guide_ctr:getGuideDataByStep(guide_ctr.step_close_num)
        local window_ccbi_path = data.ccbi_path
        print("window_ccbi_path == ccbi_path", window_ccbi_path, ccbi_path)
        if window_ccbi_path == ccbi_path then
            guide_ctr.step_num = data.step - 1
            guide_ctr.is_listen_close = false;
            guide_ctr:finishGuide()
        end
    end
end


-- 新手指引停止在这里.
function GuideCtr:waitRecv(data)
    is_recv_protocol = true

    if data.time_out then
        local time = 1.0 * data.time_out / 1000
        local action_manager = cc.Director:getInstance():getActionManager()
        local act_delay = cc.Sequence:create(cc.DelayTime:create(0.001),
                                            cc.DelayTime:create(0.001),
                                            cc.DelayTime:create(0.001),
                                            cc.DelayTime:create(0.001),
                                            cc.DelayTime:create(0.001),
                                            cc.DelayTime:create(0.001),
                                            cc.DelayTime:create(0.001),
                                            cc.DelayTime:create(time),
                                            cc.DelayTime:create(0.001),
                                            cc.DelayTime:create(0.001),
                                            cc.DelayTime:create(0.001),
                                            cc.DelayTime:create(0.001),
                                            cc.CallFunc:create(handler(self, self.finishGuide)),
                                            cc.DelayTime:create(0.001),
                                            cc.DelayTime:create(0.001),
                                            cc.DelayTime:create(0.001),
                                            cc.DelayTime:create(0.001),
                                            cc.DelayTime:create(0.001))
        act_delay:setTag(9999999)
        action_manager:removeActionByTag(9999999, self)
        action_manager:addAction(act_delay, self, false)
    end
end

-- 等待收到某个协议
function GuideCtr:waitRecvProtocol(protocol, tag1, tag2)
    if is_finish then
        return
    end

    if is_recv_protocol == false then
        return
    end

    local guide_ctr = GuideCtr:instance()
    if guide_ctr then
        local data = guide_ctr:getGuideDataByStep(guide_ctr.step_num)
        if data and data.protocol then
            print(data.protocol, protocol)
            local wait_protocol = data.protocol
            local is_tag1 = data.tag1 and (data.tag1 == tag1) or true
            local is_tag2 = data.tag2 and (data.tag2 == tag2) or true
            if wait_protocol == protocol and is_tag1 and is_tag2 then
                -- scheduler->unschedule(schedule_selector(GuideCtr::finishGuideDt),guide_ctr);
                local action_manager = cc.Director:getInstance():getActionManager()
                action_manager:removeActionByTag(9999999, guide_ctr)
                
                guide_ctr:finishGuide()
            end
        end
    end
end


-- 等待发送某个协议
function GuideCtr:waitSendProtocol(protocol, tag1, tag2)
    if is_finish then
        return
    end

    if is_send_protocol == false then
        return
    end

    local scene_ctr = require("src.scene.SceneCtr"):getRunningSceneCtr()
    if not scene_ctr then
        return
    end

    local guide_ctr = GuideCtr:instance()
    if guide_ctr then
        local data = guide_ctr:getGuideDataByStep(guide_ctr.step_num)
        if data and data.protocol then
            local wait_protocol = data.protocol
            if  wait_protocol == protocol then
                guide_ctr:finishGuide()
            end
        end
    end
end



function GuideCtr:rollStep(data)
    if data.type == "hero_level" then
        local cfg = cfg.herolevel.level[data.value]

        -- 材料不足。。直接跳过指引
        if ex.Player:getItemNum(ItemType.IT_GOLD) < cfg.gold_need or ex.Player:getItemNum(ItemType.IT_HERO_EXP) < cfg.exp_need then
            self:finishGuide()
            return
        end

        local layer_info = ex.MainSceneCtr:getMainSceneLayer(MainSceneType.HERO_INFO_LAYER)
        if layer_info and layer_info.hero_data then
            if layer_info.hero_data.level < data.value then
                self.step_num = self.step_num + data.step_back - 1
                self:finishGuide()
                return
            end
        end
    elseif data.type == "fetter_level" then

        -- 限制回滚次数
        self.vec_roll_num[data.key] = self.vec_roll_num[data.key] and self.vec_roll_num[data.key] + 1 or 1
        local roll_num = self.vec_roll_num[data.key]

        print("fetter_level", roll_num, data.num)

        -- 回滚次数达到上限
        if roll_num - 1 >= data.num then
            self:finishGuide()
            return
        end

        local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(data.idx)
        if fetter_data and fetter_data.level >= 1 then
            self:finishGuide()
            return
        end

        -- 回滚到指定步骤
        self.step_num = self.step_num + data.step_back - 1
        self:finishGuide()
        return
    end
    self:finishGuide()
end

function GuideCtr:createBattlePreview(data)
    local layer_main_battle = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MLT_BATTLE)
    if layer_main_battle then
        layer_main_battle:createBattlePreview()
        GlobalBattleHelper.getScheduler():setTimeScale(1.5)
    end
    self:finishGuide() 
end


function GuideCtr:startBattlePreview(data)
    -- local layer_main_battle = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MLT_BATTLE)
    -- if layer_main_battle then
    --     layer_main_battle:startBattlePreview()
    -- end
    ex.EventManager:fire(EVENT.BATTLE_EVENT.GUIDE_BATTLE_START)
    self:finishGuide() 
end

function GuideCtr:waitBattlePreviewEnd(data)

end

function GuideCtr:battlePreviewEnd()
     if is_finish then
        return
    end

    local scene_ctr = require("src.scene.SceneCtr"):getRunningSceneCtr()
    if not scene_ctr then
        return
    end

    local guide_ctr = GuideCtr:instance()
    if guide_ctr then
        GlobalBattleHelper.getScheduler():setTimeScale(1.3)
        guide_ctr:finishGuide()
    end
end



function GuideCtr:clearBattle(data)
    local layer_main_battle = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MLT_BATTLE)
    if layer_main_battle and layer_main_battle.clearBattle then
        layer_main_battle:clearBattle()
    end
    self:finishGuide()
end

function GuideCtr:updateMainBattle(data)
    local layer_main_battle = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MLT_BATTLE)
    if layer_main_battle and layer_main_battle.battleMissionEnd then
        layer_main_battle:battleMissionEnd()
    end
    self:finishGuide()
end


function GuideCtr:showMissionRewardOnScene( )
    local layer_main_battle = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MLT_BATTLE)
    if layer_main_battle and layer_main_battle.showRewardOnScene then
        layer_main_battle:showRewardOnScene()
    end
    self:finishGuide()
end


function GuideCtr:hideMissionRewardOnScene( )
    local layer_main_battle = ex.MainSceneCtr:getKeepBuffer(MainSceneType.MLT_BATTLE)
    if layer_main_battle and layer_main_battle.hideRewardOnScene then
        layer_main_battle:hideRewardOnScene()
    end
    self:finishGuide()
end

return GuideCtr
