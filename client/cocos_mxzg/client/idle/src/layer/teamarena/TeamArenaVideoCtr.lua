-- 


local TeamArenaVideoLayer = class("TeamArenaVideoLayer", require("src.comp.EventLayerAdaptiveWidth"))
local TeamArenaVideoCtr = class("TeamArenaVideoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local TeamArenaVideoCell = class("TeamArenaVideoCell", require("src.comp.EventLayer"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
-----------------------------------------------------------------------------
function TeamArenaVideoCell:onCreate()

    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.btn_playback:registerScriptTapHandler(handler(self, self.onBtnBack))
    self.btn_data:registerScriptTapHandler(handler(self, self.onBtnData))
    self.my_list = {}
    self.enemy_list = {}
end 


function TeamArenaVideoCell:onBtnData( tag,pSender )
    require("src.layer.BattleDetailCtr"):instance():openWindow(self.video_data.battle_log)
end

function TeamArenaVideoCell:onBtnBack( tag,pSender )

    local data = {}
    data.battle_id = self.video_data.battle_log.battleId
    data.type = EVENT.VIDEO_STUDIO_EVENT.VIDEO_PLAY_BACK
    ex.EventManager:fire(EVENT.VIDEO_STUDIO_EVENT.VIDEO_PLAY_BACK_REQ,data)
end


function TeamArenaVideoCell:initDone(video_data ,  scroll_view)
    self.video_data = video_data

    self.lbl_name1:setString(video_data.battle_log.attacker_log.name)
    self.lbl_name2:setString(video_data.battle_log.defender_log.name)

    self.lbl_battle1:setString(video_data.battle_log.attacker_log.fighting)
    self.lbl_battle2:setString(video_data.battle_log.defender_log.fighting)


    -- battle_time
    local show_time = os.date("%Y-%m-%d %H:%M:%S", video_data.battle_time)
    self.lbl_time:setString(show_time)

    self.lbl_type:setString(video_data.battle_round.. ex.Tools:getLang(74429))

    if video_data.battle_log.win_id == video_data.battle_log.attacker_log.rid then 
        -- self.team_result_1:setSpriteFrame("clan-gvg-lang/spr-gvg-win.png")
        -- self.team_result_2:setSpriteFrame("clan-gvg-lang/spr-gvg-fail.png")

        ex.Tools:setSpriteFrame(self.team_result_1, "clan-gvg-lang/spr-gvg-win.png")
        ex.Tools:setSpriteFrame(self.team_result_2, "clan-gvg-lang/spr-gvg-fail.png")
    else 
        -- self.team_result_1:setSpriteFrame("clan-gvg-lang/spr-gvg-fail.png")
        -- self.team_result_2:setSpriteFrame("clan-gvg-lang/spr-gvg-win.png")

        ex.Tools:setSpriteFrame(self.team_result_1, "clan-gvg-lang/spr-gvg-fail.png")
        ex.Tools:setSpriteFrame(self.team_result_2, "clan-gvg-lang/spr-gvg-win.png")
    end 

    self.team_result_1:setScale(0.5)
    self.team_result_2:setScale(0.5)



    self:createMenuItem()
    self:refreshList(1)
    self:refreshList(2)

end 



function TeamArenaVideoCell:createMenuItem( )
    local menu = cpp.UIMenu:create()
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    :setName("menu_hero")
    self.node:addChild(menu)

    for i=1,2 do
        local list = i == 1 and  self.my_list or self.enemy_list   
        for j=1,8 do
            local key = string.format( "node_list%s_%s",i,j)
            if self[key] then 
                local x,y = self[key]:getPosition()
                local item = UIMenuItemHero:createWithData()
                item:setPosition(x,y)
                item:setScale(0.6)
                menu:addChild(item)
                item:setEnableAction(false)
                table.insert( list,item )
            end
        end
    end
end


function TeamArenaVideoCell:refreshList(idx)

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-select.plist")
    

    local list = idx == 1 and self.my_list or self.enemy_list
    local data = idx == 1 and  self.video_data.battle_log.attacker_log or self.video_data.battle_log.defender_log  

    -- for i,v in ipairs(list) do
    --     v:reset(data.hero_log[i])
    --     if data.hero_log[i] and data.hero_log[i].fashion_id ~= 0 and data.hero_log[i].fashion_id ~= nil then   -- 有皮肤
    --         v:setFashionShowForce(data.hero_log[i].fashion_id)
    --     end
    -- end

    for i=1, 8 do
        local hero_item = list[i]
        local hero_data = TableEx.findValueFunction(data.hero_log, function(value)
            return value.position == i
        end)

        if hero_data then
            hero_item:reset(hero_data)
            if hero_data.fashion_id ~= 0 and hero_data.fashion_id ~= nil then   -- 有皮肤
                hero_item:setFashionShowForce(hero_data.fashion_id)
            end
        end
        hero_item:enableForPos(cfg.battlematrixaddition.isEnableForPos(data.formation_id, i))
    end

    -- for i,v in pairs(data.hero_log) do
    --     local hero_item = list[v.position]
    --     hero_item:reset(v)

    --     print(cfg.battlematrixaddition.isEnableForPos(data.formation_id, v.position))
    --     hero_item:enableForPos(cfg.battlematrixaddition.isEnableForPos(data.formation_id, v.position))

    --     -- if data.hero_log[i] and data.hero_log[i].fashion_id ~= 0 and data.hero_log[i].fashion_id ~= nil then   -- 有皮肤
    --     --     hero_item:setFashionShowForce(data.hero_log[i].fashion_id)
    --     -- end
    -- end
end




-----------------------------------------------------------------------------
function TeamArenaVideoLayer:onCreate()

    self:setAutoClose(true)
    self:setSwallowTouches(false)
    self:addBlackBackground()


    -- 发送拉起数据协议
    self.lbl_title:setString(ex.Tools:getLang(74430))

    local viewSize = cc.size(self.spr_bg:getContentSize().width, self.spr_bg:getContentSize().height - 20 )

    self.scroll_view = cc.ScrollView:create(viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.spr_bg:getPositionX() + 2, self.spr_bg:getPositionY() + 10)
    self:addChild(self.scroll_view)

	self:addEvent(EVENT.VIDEO_STUDIO_EVENT.VIDEO_PLAY_BACK_REQ,handler(self,self.onBattleReq))

end 

function TeamArenaVideoLayer:onBattleReq(event,data)
	local req_battle = Battle_pb.GReqBattleReport()
    req_battle.battle_id = data.battle_id
    req_battle.type = data.type
	NetManager:sendMessage(ProtocolID.GReqBattleReport, req_battle)

    local battle_layer = self:addBattleLayer(BattleType.TEAM_ARENA,
                                            MainSceneType.MAINCITY_LAYER,
                                            "",
                                            data.type,
                                            function()
                                                return true, false
                                            end)
	battle_layer:showCloseBtn(true)
	battle_layer:showSpeedBtn(true,false)
    battle_layer:setScale(1.0 / self:getScaleX())
    battle_layer:setPosition(self:getContentSize().width * 0.5 - ex.p.width  * 0.5,
	                        self:getContentSize().height * 0.5  - ex.p.height * 0.5)
end


function TeamArenaVideoLayer:resetData( battle_data)
    -- 显示交战双方  battle_data  
    self.battle_data = battle_data


    if battle_data.attack_team.team_id == ex.Player.team_arena_data.curr_my_team_data.team_id then 
        self.lbl_a_namebg:setString(ex.Tools:getLang(74431))
        self.lbl_b_namebg:setString(ex.Tools:getLang(74432))
    else 
        self.lbl_a_namebg:setString(ex.Tools:getLang(74432))
        self.lbl_b_namebg:setString(ex.Tools:getLang(74431))
    end 

    self.lbl_a_name:setString(battle_data.attack_team.team_name)
    self.lbl_b_name:setString(battle_data.defend_team.team_name)

end

function TeamArenaVideoLayer:showList(data )

    self.scroll_view:getContainer():removeAllChildren()

    self.cellList = {}
    local index = 0
    for i,v in ipairs(data) do
        local task_node = self:addCell(v)
        task_node:setName("task_cell" .. index)
        self.scroll_view:addChild(task_node)
        table.insert(self.cellList, task_node)
        index = index + 1
    end



    local a_att_nums = 0
    local b_att_nums = 0
    for i,v in ipairs(data) do
        if v.battle_log.win_id == v.battle_log.attacker_log.rid then 
            a_att_nums = a_att_nums + 1
        else 
            b_att_nums = b_att_nums + 1
        end 
    end

    self.lbl_score:setString(a_att_nums .. " : " .. b_att_nums)

    -- 排序顺序 已完成 可以接取 正在进行
    -- table.sort(self.cellList, function(a, b)
    --     return a.reward_id < b.reward_id
    -- end)

    local viewSize = self.scroll_view:getViewSize()
    --cc.size(480, 150)
    local item_size = TeamArenaVideoCell:createWithCCBIFile("ccbi/TeamArenaVideoCell.ccbi"):getContentSize()
    item_size.height = item_size.height + 5

    -- 调整ScrollView
    local cont_height = item_size.height * table.nums(self.cellList)
    cont_height = math.max(cont_height , viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))


    -- 按排好的顺序显示
    local start = cc.p(viewSize.width * 0.5 - 2, cont_height - item_size.height * 0.5)

    for i,v in ipairs(self.cellList) do
        v:setPosition(start.x, start.y - (i - 1) * item_size.height)
    end

end 


function TeamArenaVideoLayer:addCell( v )
    local cell = TeamArenaVideoCell:createWithCCBIFile("ccbi/TeamArenaVideoCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)
    cell:initDone(v,  self.scroll_view)
    return cell
end





-----------------------------------------------------------------------------
function TeamArenaVideoCtr:onCreate()
	self:setCCBIPath("ccbi/TeamArenaVideoLayer.ccbi")
	self:setIsSingle(false)
end

function TeamArenaVideoCtr:getLayerClass()
	return TeamArenaVideoLayer
end

function TeamArenaVideoCtr:getTeamArenaVideoLayer()
	return self.layer
end


function TeamArenaVideoCtr:openWindow(battle_data)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/team-arena.plist")

    self.battle_data = battle_data
	self:loadLayer()
	self:open()
    self:initData(battle_data.record_id)
    self:resetData()
end

function TeamArenaVideoCtr:showList(data)
    self.layer:showList(data)
end


function TeamArenaVideoCtr:resetData()
    self.layer:resetData(self.battle_data)
end


function TeamArenaVideoCtr:initData(record_id)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))


    -- fasong xieyi 

    local req = TeamArena_pb.GReqTeamArenaBattleRecordDetail()
    req.record_id = record_id
    NetManager:sendMessage(ProtocolID.GReqTeamArenaBattleRecordDetail, req)

end


return TeamArenaVideoCtr