local ContractSummonLayer = class("ContractSummonLayer", require("src.comp.EventLayer"))
local ContractSummonCtr = class("ContractSummonCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local ContractSummonCell = class("ContractSummonCell", require("src.comp.EventLayer"))
local ContractSummonTip = class("ContractSummonTip", require("src.comp.EventLayer"))

-----------------------------------------------------------------------------
function ContractSummonTip:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self.sub_nums = 0
    self.max_num = 0

    self.contract2Unlock = false

    self.btn_enter:registerScriptTapHandler(handler(self, self.btnEnter))

    self:addEvent(EVENT.BATTLE_EVENT.UNLOCK_2_CONTRACT, function(evt, data)
        self.contract2Unlock = true
        self:initDone(2)
    end)

    self:addEvent(EVENT.BATTLE_EVENT.QUERY_FORMATIONS, function(evt, data)
        if data.unlock then
            self.contract2Unlock = true
            self:initDone(self.select_id)
        end
	end)
	
	NetManager:sendMessage(ProtocolID.GReqQueryFormation)
end

function ContractSummonTip:onExit()
    self:removeEvent()
end

function ContractSummonTip:btnEnter( tag, pSender )
    if self.select_id == 2 then
        NetManager:sendMessage(ProtocolID.GReqUnlock)
    else
        local req = Fetter_pb.GReqFetterContractActive()
        req.type = self.select_id
        NetManager:sendMessage(ProtocolID.GReqFetterContractActive, req)
    end
    
    ex.AudioManager:playEffect("music/item-get.mp3")
end

function ContractSummonTip:initDone(select_id)
    self.show_girl_list:removeAllChildren()
    self.btn_enter:setVisible(false)
    self._contract2CondLabel:setVisible(false)
    self.show_num:setString("")
    self.show_rich:removeAllChildren()

    self.select_id = select_id
    if self.select_id == 1 then 
        self:showFetterList(ex.Player.fetter_data.vec_fetter)
        self:refreshFetternum()
    elseif self.select_id == 2 then
        local condInfo = cfg.system['contract_2_mission']
        if condInfo.type == 'GET_HERO' then
            local count = self:_getConditionHeroCount()
            if count > condInfo.target then count = condInfo.target end
            local text = string.format('任意英雄升到%d星解锁: %d/%d', condInfo.condition, count, condInfo.target)
            self._contract2CondLabel:setString(text)
            self._contract2CondLabel:setVisible(true)

            if not self.contract2Unlock and count >= condInfo.target then
                self.btn_enter:setVisible(true)
            end
        end
    end
end

function ContractSummonTip:_getConditionHeroCount()
    local condInfo = cfg.system['contract_2_mission']
    local count = 0
    for i, v in ipairs(ex.Player.hero_data.hero_list) do
        if v.star >= condInfo.condition then
            count = count + 1
        end
    end

    return count
end

function ContractSummonTip:refreshFetternum()

    self.show_num:setString( string.format(ex.Tools:getLang(41291),self.max_num, (self.max_num - self.sub_nums), self.max_num ))
    -- 创建富文本前往激活
    
    -- 检测激活状态
    local flag = false
    for i,v in ipairs(ex.Player.fetter_data.fetterContractInfo) do
        if v == self.select_id then
            flag = true
        end
    end

    if flag == true then 
        self.show_num:setString("")

        local rich_lable = require("src.comp.RichTextEx"):create()
        :setFontSize(20)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setAnchorTextShadow(true)
        :setWrapMode(1)
        :setFontColor("#79FF17")

        rich_lable:setPosition(0, 0 )
        rich_lable:setXmlTextLua(ex.Tools:getLang(41297))
        self.show_rich:addChild(rich_lable)   
    else
        if self.sub_nums == 0 then 
            -- 激活按钮
            self.btn_enter:setVisible(true)
        else 
            -- show_rich
            local rich_lable = require("src.comp.RichTextEx"):create()
            :setFontSize(20)
            :setFontFace(FONT_DEFAULT_NAME_BOLD)
            :setAnchorTextShadow(true)
            :setWrapMode(1)
            
            rich_lable:setPosition(0, 0 )
            rich_lable:setXmlTextLua(ex.Tools:getLang(41292))
            rich_lable:setCallback(handler(self, self.openRichTextUrl))
            self.show_rich:addChild(rich_lable)
        end 
    end 

end

function ContractSummonTip:openRichTextUrl(url)
    if string.len(url) <= 0 then
        return
    end
    require("src.comp.LuaNodeCtr"):closeOtherWindow()
    ex.JumpManager:jumpByAtom(url)
end

function ContractSummonTip:showFetterList( data_list )
    -- show_girl_list
    self.show_girl_list:removeAllChildren()
    self.show_girl_list:setPosition(270,88)

    local show_list = {}
    for k,v in pairs(data_list) do
        table.insert( show_list, clone(v))
    end
    local sort = function ( a, b )
        if a.level == b.level then 
            return a.type < b.type
        else 
            return a.level > b.level
        end 

    end
    table.sort( show_list, sort )


    local fetter_bg_list = {}
    local fetter_icno_list = {}
    local need_offset_x = 15
    local index = 0
    local item_width = 0
    
    self.sub_nums = 0
    self.max_num = 0
    for k,v in ipairs(show_list) do
        index = index + 1
        local bg_image = cc.Sprite:createWithSpriteFrameName("contract/spr-quan.png")
        bg_image:setScale(1)
        bg_image:setAnchorPoint(ex.a.zero)
        self.show_girl_list:addChild(bg_image, 100)

        item_width = bg_image:getContentSize().width

        local icno_image = cc.Sprite:createWithSpriteFrameName(string.format("hero-icon/%d.png", v.type))
        icno_image:setScale(0.8)
        icno_image:setAnchorPoint(ex.a.center)
        self.show_girl_list:addChild(icno_image, 99)

        icno_image:setPosition(bg_image:getContentSize().width * 0.5,bg_image:getContentSize().height * 0.5)

        if v.level == 0 then
            self.sub_nums = self.sub_nums + 1
            ex.Tools:setGrayAuto(bg_image,true)
            ex.Tools:setGrayAuto(icno_image,true)
        end 

        bg_image:setPosition((k - 1) * bg_image:getContentSize().width + k * need_offset_x, - bg_image:getContentSize().height * 0.5)

        icno_image:setPosition(bg_image:getPositionX()+ bg_image:getContentSize().width * 0.5, bg_image:getPositionY() + bg_image:getContentSize().height * 0.5)
    end
    self.max_num = index
    -- chongxin shuaxin wei zhi 
    self.show_girl_list:setPosition(self.show_girl_list:getPositionX() - index  * 0.5 * (item_width + need_offset_x) - 5 , self.show_girl_list:getPositionY() - 5)

end

-----------------------------------------------------------------------------

function ContractSummonCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end 

function ContractSummonCell:initDone( id )
    self.now_index = id
    ex.Tools:setSpriteFrame(self.btn_submit:getNormalImage(), string.format( "contract-lang/spr-d%d.png", self.now_index))
end 


-----------------------------------------------------------------------------

function ContractSummonLayer:onCreate()

    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:addBlackBackground()

    self.show_msg = self:addContractSummonTip()
    self:showAddList()

    -- 进行暂时
    self.show_msg_state = true 
    self.select_index = 1
    self:refreshList( )
end 


function ContractSummonLayer:clickItem( )
   
    
end

function ContractSummonLayer:showAddList( )
    self.cellList = {}
    for i=1,4 do
        local task_node = self:addContractSummonCell(i)
        task_node:setName("task_cell" .. i)
        self.show_list:addChild(task_node)
        table.insert(self.cellList, task_node)  
    end
end



function ContractSummonLayer:refreshList( )
    
    local item_size = ContractSummonCell:createWithCCBIFile("ccbi/ContractSummonCell.ccbi"):getContentSize()
    item_size.height = item_size.height  + 5

    -- 按排好的顺序显示
    local start = cc.p(0 ,  - item_size.height * 0.5)
    
    local need_tips_height = 0
    for i,v in ipairs(self.cellList) do
        v:setPosition(start.x, start.y - (i - 1) * item_size.height - need_tips_height)

        if self.show_msg_state == true and  v.now_index == self.select_index then 
            need_tips_height = 150

            self.show_msg:setPosition(start.x, start.y - (i - 1) * item_size.height - 120)
            self.show_msg:initDone( i )
        end 
    end

end


function ContractSummonLayer:addContractSummonCell(id)
    local cell = ContractSummonCell:createWithCCBIFile("ccbi/ContractSummonCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)
	
    cell:initDone( id )
    cell.btn_submit:setTag(id)
    cell.btn_submit:registerScriptTapHandler(handler(self, self.onClickDone))
    
	return cell
end

function ContractSummonLayer:addContractSummonTip()
    local cell = ContractSummonTip:createWithCCBIFile("ccbi/ContractSummonTip.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)
	self.show_list:addChild(cell)
	return cell
end

function ContractSummonLayer:onClickDone( tag, pSender )
    local flag1 = false
    for i,v in ipairs(ex.Player.fetter_data.fetterContractInfo) do
        if v == 1 then 
            flag1 = true
        end 
    end

    if (tag ~= 1 and not flag1) or tag > 2 then
        if tag == 2 then
            ex.MessageView:add(ex.Tools:getLang(41319))
        else
            ex.MessageView:add(ex.Tools:getLang(41296))
        end
        return
    end
    
    if self.select_index == tag and self.show_msg_state == true then 
        self.show_msg:setVisible(false)
        self.show_msg_state = false
    else
        self.show_msg:setVisible(true)
        self.show_msg_state = true 
    end 

    self.select_index = tag

    self:refreshList( )
end



-----------------------------------------------------------------------------
function ContractSummonCtr:onCreate()
	self:setCCBIPath("ccbi/ContractSummonLayer.ccbi")
    self:setIsSingle(false)
    
    self._initData = nil
end

function ContractSummonCtr:getLayerClass()
	return ContractSummonLayer
end

function ContractSummonCtr:getContractSummonLayer()
	return self.layer
end


function ContractSummonCtr:openWindow(data)
	if self:isOpened() then
		return
	end
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/contract.plist")
    sfc:addSpriteFrames("ccbi-res/contract-lang.plist")

	self:loadLayer()
	self:open()
	self:initData(data)
end

function ContractSummonCtr:initData(data)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end

return ContractSummonCtr