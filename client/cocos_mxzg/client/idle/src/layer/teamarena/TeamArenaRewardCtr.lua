local TeamArenaRewardLayer = class("TeamArenaRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))
local TeamArenaRewardCtr = class("TeamArenaRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local TeamArenaRewardCell = class("TeamArenaRewardCell", require("src.comp.EventLayer"))

-----------------------------------------------------------------------------
function TeamArenaRewardCell:onCreate()

    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self.reward_id = 0

    self.btn_submit:setLabelText(ex.Tools:getLang(74427))
    self.btn_go:setLabelText(ex.Tools:getLang(74428))

    self.btn_submit:registerScriptTapHandler(handler(self, self.onSubmit))
    self.btn_go:registerScriptTapHandler(handler(self, self.onGo))

end 

function TeamArenaRewardCell:onSubmit( tag, pSender)

    if ex.Player.team_arena_data.curr_battle_reward_num >=  self.reward_data.need_count  then 
        local flag = ex.Player.team_arena_data:getBattleRewardstatus(self.reward_data.idx)
        if flag == false then 
            
            local req = TeamArena_pb.GReqTeamArenaGetChallengeReward()
            req.idx = self.reward_id
            NetManager:sendMessage(ProtocolID.GReqTeamArenaGetChallengeReward, req)

            ex.Player.team_arena_data:saveBattleRewardList(self.reward_id)
        end         
    end 

    -- 重新排序
    require("src.layer.teamarena.TeamArenaRewardCtr"):instance():showTaskList()
    
end

function TeamArenaRewardCell:onGo( tag, pSender)
    require("src.layer.teamarena.TeamArenaRewardCtr"):instance():closeWindow()
end


function TeamArenaRewardCell:initDone(reward_data,  scroll_view)
    self.reward_id = reward_data.idx
    self.reward_data = reward_data
    self.is_get = 2
    self:updateItem( reward_data.reward, scroll_view)
    if ex.Player.team_arena_data.curr_battle_reward_num <  reward_data.need_count  then 
        self.btn_submit:setVisible(true)
        self.btn_go:setVisible(false)

        ex.Tools:setGrayAuto(self.btn_submit:getNormalImage(), true)
        

    else 
        
        self.btn_go:setVisible(false)
        local flag = ex.Player.team_arena_data:getBattleRewardstatus(reward_data.idx)
        if flag == true then 
            self.btn_submit:setLabelText(ex.Tools:getLang(2703))
            self.btn_submit:setVisible(true)
            self.is_get = 3

            ex.Tools:setGrayAuto(self.btn_submit:getNormalImage(), true)

        else 
            self.is_get = 1
            self.btn_submit:setVisible(true)
        end 
    end 

    self.num_lab:setString(string.format("(%s/%s)", ex.Player.team_arena_data.curr_battle_reward_num ,  reward_data.need_count ) )
    
    self.top_lab:setString(string.format(ex.Tools:getLang(74426),  reward_data.need_count ) )
    
end 



function TeamArenaRewardCell:onClick(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function TeamArenaRewardCell:updateItem( award_list, scroll_view)
    local menu = cpp.UIMenu:create()
    :setPosition(cc.p(0, 0))
    self:addChild(menu)

    menu:setIsTouchInsideNode(scroll_view)
    menu:setSwallowsTouches(false)

    local goods_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    goods_size.width = goods_size.width * 0.75 + 10

    local begin = 24
    local margin = 5
    local posY = 55
    local scale = 0.75
    for i,v in ipairs(award_list) do
        local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        local posX = (begin + item:getContentSize().width * scale / 2) + (i - 1) * ((item:getContentSize().width * scale) + margin)
    	
        item:setPosition(posX, posY)
        item:setScale(scale)
        item:registerScriptTapHandler(handler(self, self.onClick))
        menu:addChild(item)
    end

end


-----------------------------------------------------------------------------
function TeamArenaRewardLayer:onCreate()

    self:setAutoClose(true)
    self:setSwallowTouches(false)
    self:addBlackBackground()


    local viewSize = cc.size(self.spr_rank_bg:getContentSize().width, self.spr_rank_bg:getContentSize().height - 20 )

    self.scroll_view = cc.ScrollView:create(viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.spr_rank_bg:getPositionX() + 2, self.spr_rank_bg:getPositionY() + 10)
    self:addChild(self.scroll_view)

    self:showTaskList( )
end 

function TeamArenaRewardLayer:showTaskList( )
    
    self.scroll_view:getContainer():removeAllChildren()

    self.cellList = {}

    for _,v in pairs(cfg.teamarenachallengereward.teamarenachallengereward) do
        local task_node = self:addCell(v)
        task_node:setName("task_cell" .. v.idx)
        self.scroll_view:addChild(task_node)
        table.insert(self.cellList, task_node)
    end


    -- 排序顺序 已完成 可以接取 正在进行
    table.sort(self.cellList, function(a, b)

        if a.is_get == b.is_get then 
            return a.reward_id < b.reward_id
        else 
            return a.is_get < b.is_get
        end 

    end)

    local viewSize = self.scroll_view:getViewSize()
    --cc.size(480, 150)
    local item_size = TeamArenaRewardCell:createWithCCBIFile("ccbi/TeamArenaRewardCell.ccbi"):getContentSize()
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

    -- 更新列表后可以Touch
    -- self:touchSwallowTouches(false)


end 


function TeamArenaRewardLayer:addCell( v )
    local cell = TeamArenaRewardCell:createWithCCBIFile("ccbi/TeamArenaRewardCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)
    cell:initDone(v, self.scroll_view)
    return cell
end

-----------------------------------------------------------------------------
function TeamArenaRewardCtr:onCreate()
	self:setCCBIPath("ccbi/TeamArenaRewardLayer.ccbi")
	self:setIsSingle(false)
end

function TeamArenaRewardCtr:getLayerClass()
	return TeamArenaRewardLayer
end

function TeamArenaRewardCtr:getTeamArenaRewardLayer()
	return self.layer
end

function TeamArenaRewardCtr:showTaskList()
	self.layer:showTaskList()
end

function TeamArenaRewardCtr:openWindow()
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/team-arena.plist")

	self:loadLayer()
	self:open()
	self:initData()
end

function TeamArenaRewardCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end


return TeamArenaRewardCtr