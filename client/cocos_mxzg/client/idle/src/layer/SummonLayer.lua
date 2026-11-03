local SummonLayer = class("SummonLayer", require("src.comp.EventLayer"))
local SummonCell = class("SummonCell", require("src.comp.EventLayer"))
local SummonJFCell = class("SummonJFCell", require("src.comp.LuaLayerBase"))
local SummonJFCtr = class("SummonJFCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local string_format = string.format
local ExTimer = require("src.ex.ExTimer")

function SummonCell:onCreate()
    --ex.log("SummonLayer:onCreate")
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.timer = ExTimer:new():bind(self)

    self.type_id = 0
    self.freeTime = 0

    --self.btn_add:setVisible(false)
end

function SummonCell:setGem()
    -- 招募一次 按钮文字 数字
    local config_type1 = 1 + (self.type_id - 1) * 2  -- 1 3 5
    local cell_item = cfg.lotterypoint.summon[config_type1].need_item[1]

    local need_type = cell_item.item_type
    local need_num = cell_item.item_num

    local hasNum = ex.Player:getItemNum(need_type)

    self.lbl_num:setString(tostring(hasNum))


    local btn_size = cc.Sprite:createWithSpriteFrameName("button/btn-buy-1.png"):getContentSize()
    btn_size.width = btn_size.width / 2
    btn_size.height = btn_size.height / 2

    if need_type == ItemType.IT_TICKET_HIGH and hasNum < need_num then
        -- 高级券不够时候 用钻石
        need_type =  ItemType.IT_GEM
        need_num = tonumber(ex.ShopSeniorTicketTable:getConfig(1).need_gem)
    end

    local spr_icon1 = self.btn_one:getChildByTag(10)
    if spr_icon1 then
        spr_icon1:removeFromParent()
        spr_icon1 = nil
    end

    spr_icon1 = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", need_type))
    :setScale(0.25)
    :setPosition(btn_size.width - 40, btn_size.height - 14)
    self.btn_one:addChild(spr_icon1, 10, 10)
    self.btn_one:setName("summon_one")

    local lbl_btn_num1 = self.btn_one:getChildByTag(100)
    if lbl_btn_num1 then
        lbl_btn_num1:setString(tostring(need_num))
    end


     -- 招募十次 按钮文字 数字
    local config_type10 = self.type_id * 2   -- 2 4 6
    cell_item = cfg.lotterypoint.summon[config_type10].need_item[1]

    need_type = cell_item.item_type
    -- need_num = hasNum < cell_item.item_num and hasNum or cell_item.item_num
    need_num =  cell_item.item_num

    -- if need_type == ItemType.IT_TICKET_HIGH then 
    --     need_num = hasNum < cell_item.item_num and hasNum or cell_item.item_num
    -- end 

    --if need_type == ItemType.IT_TICKET_HIGH and hasNum < need_num then
    if need_type == ItemType.IT_TICKET_HIGH and hasNum < 1 then
        -- 高级券不够时候 用钻石
        need_type =  ItemType.IT_GEM
        need_num = tonumber(ex.ShopSeniorTicketTable:getConfig(10).need_gem)
    end

    local spr_icon10 = self.btn_ten:getChildByTag(10)
    if spr_icon10 then
        spr_icon10:removeFromParent()
        spr_icon10 = nil
    end

    spr_icon10 = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", need_type))
    :setScale(0.25)
    :setPosition(btn_size.width - 40, btn_size.height - 14)
    self.btn_ten:addChild(spr_icon10, 10, 10)

    print("summon" , need_type)
    local lbl_btn_num10 = self.btn_ten:getChildByTag(100)
    if lbl_btn_num10 then
        lbl_btn_num10:setString(tostring(need_num))

        -- local  str = string.format("<img src='backpack/%s.png' width='30' height='30' /><font color='#ffffff'>%s/%s</font>",need_type,hasNum, need_num)
        -- if hasNum < need_num then 
        --     str = string.format("<img src='backpack/%s.png' width='30' height='30' /><font color='#FF0000'>%s</font><font color='#ffffff'>/%s</font>",need_type,hasNum, need_num)
        -- end 

        -- lbl_btn_num10:setXmlTextLua(str)

    end
end

function SummonCell:initDone(type_id)
    self.type_id = type_id
    
    -- self.spr_bg:setSpriteFrame(string.format("main-summon-lang/bg-%d.png", type_id))
    ex.Tools:setSpriteFrame(self.spr_bg, string.format("main-summon-lang/bg-%d.png", type_id))

     -- 招募描述
    self.lbl_desc:setString(ex.Tools:getLang(70000 + type_id))

    -- 招募一次 按钮文字 数字
    local config_type1 = 1 + (type_id - 1) * 2  -- 1 3 5
    local cell_item = cfg.lotterypoint.summon[config_type1].need_item[1]

    -- 物品icon
    self.spr_icon:setSpriteFrame(string.format("backpack/%d.png", cell_item.item_type))

    local btn_size = cc.Sprite:createWithSpriteFrameName("button/btn-buy-1.png"):getContentSize()
    btn_size.width = btn_size.width / 2
    btn_size.height = btn_size.height / 2

    -- 召唤一次
    local lbl_btn_txt1 = cc.Label:createWithTTF(ex.Tools:getLang(70004), FONT_DEFAULT_NAME_BOLD, 24)
    :enableOutline(FONT_BROWN, 1)
    :enableShadow(FONT_BROWN, cc.size(1, -1))
    :setPosition(btn_size.width, btn_size.height + 11)
    self.btn_one:addChild(lbl_btn_txt1)

    local lbl_btn_num1 = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 40)
    :setTextColor(FONT_BROWN)
    :setScale(0.5)
    :setPosition(btn_size.width, btn_size.height - 14)
    self.btn_one:addChild(lbl_btn_num1, 100, 100)


    -- 招募十次 按钮文字 数字
    local config_type10 = type_id * 2   -- 2 4 6

    -- 召唤十次
    local lbl_btn_txt10 = cc.Label:createWithTTF(ex.Tools:getLang(70005), FONT_DEFAULT_NAME_BOLD, 24)
    :enableOutline(FONT_BROWN, 1)
    :enableShadow(FONT_BROWN, cc.size(1, -1))
    :setPosition(btn_size.width, btn_size.height + 11)
    self.btn_ten:addChild(lbl_btn_txt10)

    local lbl_btn_num10 = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 40)
    :setScale(0.5)
    :setPosition(btn_size.width, btn_size.height - 14)
    self.btn_ten:addChild(lbl_btn_num10, 100, 100)


    -- local lbl_btn_refresh = require("src.comp.RichTextEx"):create()
	-- :setFontSize(20)
	-- :setFontFace(FONT_DEFAULT_NAME_BOLD)
	-- :setAnchorTextShadow(true)
    -- :setWrapMode(1)

	-- self.btn_ten:addChild(lbl_btn_refresh, 100, 100)
    -- lbl_btn_refresh:setPosition(self.btn_ten:getContentSize().width * 0.5, self.btn_ten:getContentSize().height * 0.5 - 14)


    self.btn_one:setTag(config_type1)
    self.btn_ten:setTag(config_type10)

    self.btn_prayer:setVisible(config_type10 == 6)
    if config_type10 == 6 then
        -- 高级十连抽 特效
        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_summon_10")
        spr_effect:setPosition(self.btn_ten:getPositionX(), self.btn_ten:getPositionY() + 5)
        self:addChild(spr_effect)
        self:addRedDotNode(RedDotType.ZCJ_DHZC_ZHFZ_YXXY, self.btn_prayer)

        ex.EffectCtr:playNormalEff(35, self.btn_prayer:getContentSize().width / 2, self.btn_prayer:getContentSize().height * 0.5 + 10, nil, self.btn_prayer, 0)

        self.iszhe:setVisible(true) 
            
            local discount = cfg.system["adv_summon_discount_show"]
            local spr_discount_bg = cc.Sprite:createWithSpriteFrameName("other/spr-discount-bg.png")
            spr_discount_bg:setPosition(self.btn_ten:getPositionX() -self.btn_ten:getContentSize().width * 0.5  , self.btn_ten:getPositionY() + self.btn_ten:getContentSize().height * 0.5)
            spr_discount_bg:setScale(0.9)
            self:addChild(spr_discount_bg)

            if math.floor(discount / 10) == discount / 10 then
                discount = math.floor(discount / 10)
            end

            local lbl_discount_1 = cc.Label:createWithTTF(tostring(discount), FONT_DEFAULT_NAME_BOLD, 60)
            lbl_discount_1:setScale(0.5)
            :setColor(cc.c4b(255,238,145,255))
            :enableOutline(cc.c4b(190, 0, 0, 255), 2)
            lbl_discount_1:setPosition(spr_discount_bg:getContentSize().width / 2 - 10, spr_discount_bg:getContentSize().height / 2 + 5)
            spr_discount_bg:addChild(lbl_discount_1)

            local lbl_discount_2 = cc.Label:createWithTTF(ex.Tools:getLang(47553), FONT_DEFAULT_NAME_BOLD, 44)
            lbl_discount_2:setScale(0.5)
            :setColor(cc.c4b(255,255,255,255))
            :enableOutline(cc.c4b(190, 0, 0, 255), 2)
            lbl_discount_2:setPosition(spr_discount_bg:getContentSize().width / 2 + 10, spr_discount_bg:getContentSize().height / 2 - 5)
            spr_discount_bg:addChild(lbl_discount_2)
    else
        self.iszhe:setVisible(false) 
    end
    --self:setGem()

    self:setCurrentType()
end

function SummonCell:setCurrentType()
    
    local freeState = ex.Player.summon_data:getFree(self.type_id)

    if freeState == 0 then
        self.lbl_free:setString(ex.Tools:getLang(1102)) --本次免费
    elseif freeState == 1 then
        local freeTime = ex.Player.summon_data:getFreeTime(self.type_id) - ex.Game:getServerTime()
        if freeTime <= 0 then
            self.freeTime = 0
            self.timer:stop()
            self.lbl_free:setString(ex.Tools:getLang(1102)) --本次免费
        else
            self.freeTime = freeTime
            self.timer:run(handler(self, self.updateFreeTime), 1.0)
            self:updateFreeTime()
        end
    else -- 如果是禁用状态就隐藏
        self.lbl_free:setVisible(false)
    end

end

function SummonCell:updateFreeTime()
    self.freeTime = self.freeTime - 1

    if self.freeTime <= 0 then
        self.freeTime = 0
        self.timer:stop()
        self.lbl_free:setString(ex.Tools:getLang(1102)) --本次免费
        return
    end

    self.lbl_free:setString(string.format("%d:%02d:%02d%s", 
        math.floor(self.freeTime / 3600),
        math.floor(self.freeTime / 60 % 60),
        math.floor(self.freeTime % 60),
        ex.Tools:getLang(1102)))
end

function SummonCell:stopTimer()
    self.timer:stop()
end

function SummonCell:onPrayer()
    ex.JumpManager:jumpByAtom("main_summon_wish")
end

---------------------------------积分抽奖弹窗-------------------------------------
function SummonJFCell:onCreate()
    --ex.log("SummonJFCell:onCreate")
    self:setAutoClose(false)
    
    self.lbl_title:setString(ex.Tools:getLang(70006))

    local JF_ctr = SummonJFCtr:instance()
    self.btn_done:registerScriptTapHandler(handler(JF_ctr, JF_ctr.onDone))
    self.btn_close:registerScriptTapHandler(handler(JF_ctr, JF_ctr.closeWindow))

    -- self.lbl_privilege = ex.Tools:createRichText(self, "", 15, false, cc.p(self.lbl_vip:getPosition()))
    self.lbl_privilege = require("src.comp.RichTextEx"):create()
	self.lbl_privilege:setFontSize(15)
	self.lbl_privilege:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_privilege:setAnchorTextShadow(false)
	self.lbl_privilege:setWrapMode(1)
	self.lbl_privilege:setIgnoreAnchorPointForPosition(false)
	self.lbl_privilege:setAnchorPoint(ex.a.center)
	self.lbl_privilege:setPosition(self.lbl_vip:getPosition())
	-- self.lbl_privilege:setXmlTextLua(str)
	self.lbl_privilege:setCallback(function(atom)
		SummonJFCtr:instance():closeWindow()
		ex.JumpManager:jumpByAtom(atom)
	end)
	self:addChild(self.lbl_privilege)
end

--------------------------------
function SummonJFCtr:onCreate()
    self:setCCBIPath("ccbi/SummonJFCell.ccbi")
    self:setIsSingle(false)
end


function SummonJFCtr:getLayerClass()
    return SummonJFCell
end

function SummonJFCtr:openWindow(need, callback_done)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")
    sfc:addSpriteFrames("ccbi-res/hero-info-lang.plist")

    self:loadLayer()
    self:open()

    self.layer.need = need

    local is_clergy_privilege = cfg.clergyprivilege.isPrivilege(CLERGY_PRIVILEGE_TYPE.POINT_SUMMON, ex.Player.clergy_level)

    --召唤
    local lbl_btn_txt = cc.Label:createWithTTF(ex.Tools:getLang(70009), FONT_DEFAULT_NAME_BOLD, 26)
    :setPosition(self.layer.btn_done:getContentSize().width / 2, self.layer.btn_done:getContentSize().height / 2)
    self.layer.btn_done:addChild(lbl_btn_txt)

    local clergy_config = cfg.clergyprivilege.getConfigByPrivilegeType(CLERGY_PRIVILEGE_TYPE.POINT_SUMMON)
    if is_clergy_privilege then
        self.layer.lbl_desc:setString(string.format(ex.Tools:getLang(70007), need.item_num * clergy_config.unlock_privilege.value / 10000))
    else
        self.layer.lbl_desc:setString(string.format(ex.Tools:getLang(70007), need.item_num))
    end

    -- 进度未完成
    local hasNum = ex.Player:getItemNum(need.item_type)
    local is_not_enough = hasNum < need.item_num
    if is_clergy_privilege then is_not_enough = hasNum < need.item_num * clergy_config.unlock_privilege.value / 10000 end
    if is_not_enough or ex.Player.total_charge < cfg.system["point_summon_recharge_need"]  then
        self.layer.btn_done:setEnabled(false)
        local glp = cpp.ShaderFactory:instance():getGLProgram(ShaderType.ST_POSITION_TEXTURE_GRAY)
        self.layer.btn_done:getNormalImage():setGLProgram(glp)
        lbl_btn_txt:setTextColor(FONT_GRAY)
    else
        lbl_btn_txt:setTextColor(FONT_BLACK)
    end
    
    local is_charge_show = ex.Player.total_charge < cfg.system["point_summon_recharge_need"]
    self.layer.lbl_vip:setVisible(is_charge_show)
    self.layer.lbl_privilege:setVisible(not is_charge_show)
    if is_charge_show then 
        self.layer.lbl_vip:setString(ex.Tools:getLang(70008)) 
    else
        self.layer.lbl_privilege:setXmlTextLua(ex.Tools:getLang(is_clergy_privilege and 49312 or 49310))
    end

    self.layer.callback_done = callback_done
end

function SummonJFCtr:onDone(tag, pSender)
    if self:getLayer() == nil then
        return
    end




    if self.layer.callback_done then
        self.layer.callback_done()
    end

    self:closeWindow(tag, pSender)
end

function SummonJFCtr:onCancel(tag, pSender)
    self:closeWindow(tag, pSender)
end




-----------------------------------------------------------------------------

function SummonLayer:getAsynImage()
    -- dump(cc.Director:getInstance():getTextureCache():getCachedTextureInfo())
    local vec_image = {
        {image_name = "ccbi-res/map-bg-summon-2.jpg", remove_type=1},
        {image_name = "spine/lizi.png", remove_type=1},
        {image_name = "spine/shangcheng.png", remove_type=1},
        -- {image_name = "ccbi-res/pub-effect-10.pvr.ccz", plist_name = "ccbi-res/pub-effect-10.plist", remove_type=2},
        {image_name = "ccbi-res/reward-layer.pvr.ccz", plist_name = "ccbi-res/reward-layer.plist", remove_type=2},
        {image_name = "ccbi-res/summon-effect.pvr.ccz", plist_name = "ccbi-res/summon-effect.plist", remove_type=2},
        {image_name = "ccbi-res/summon-big-effect.pvr.ccz", plist_name = "ccbi-res/summon-big-effect.plist", remove_type=2, rgb_type=1},
    }
    return vec_image
end

function SummonLayer:onCreate()
	self:setAutoClose(false)

    local spr_bg = cc.Sprite:create("ccbi-res/map-bg-summon-2.jpg")
    local scale_x = ex.p.width / spr_bg:getContentSize().width
    local scale_y = ex.p.height / spr_bg:getContentSize().height
    spr_bg:setScale(scale_x > scale_y and scale_x or scale_y)
    spr_bg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2 - 20)
    -- spr_bg:setCascadeOpacityEnabled(true)
    self:addChild(spr_bg, -1)

    self:setScale(math.min(1, ex.s.global_scale))

    local spine_girl = sp.SkeletonAnimation:create("spine/act.json", "spine/act.atlas", 1)
    spine_girl:setAnimation(0, "act", true)
    spine_girl:setScale(0.75)
    spine_girl:setPosition(100, 520)
    self.spr_box:addChild(spine_girl, -1)

    local notch_height = require("src.model.Game"):instance():getNotchHeight()

    self.btn_back:setPositionY(self:getContentSize().height * self:getScaleY() / 2 + (ex.p.height / 2 - 120 - notch_height) / self:getScaleY())

    self.btn_award:getParent():setLocalZOrder(100)

    self:initDone()

    self:initSwallowLayer()

    self:updateCompleted()

    ex.Player.summon_data:setCallback(function(is_lock)
       self:touchSwallowTouches(is_lock)
    end)

    self:touchSwallowTouches(false)

    self.menu_main:setLocalZOrder(10)


    self.node_tip2:setVisible(ex.Player.summon_data:isVisibleTipSummon())
    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    self:updateTimer()
end



function SummonLayer:onClickBtn(tag, pSender)
    
    local hero_suggest_ctr = require("src.layer.heroinfo.HeroSuggestCtr"):instance()
    hero_suggest_ctr:openWindow()
    hero_suggest_ctr:onChangeLayer(4)
    --ex.JumpManager:jumpByAtom("main_hero_recommend")
end


function SummonLayer:updateTimer()
    local time = ex.Player.summon_data:getTipSummonTime()
    if time <= 0 then
        self.node_tip2:setVisible(false)
        self:removeTimerByName("timer")
        return
    end

    if time > 86400 then
        self.lbl_time:setString(string_format(ex.Tools:getLang(47554),
            math.floor(time / 86400)))
    else
        self.lbl_time:setString(string_format(ex.Tools:getLang(47140), 
            math.floor(time / 3600),
            math.floor(time / 60 % 60),
            math.floor(time % 60)))
    end
end


--触摸吞噬
function SummonLayer:initSwallowLayer()
    self.touch_layer = cc.Layer:create()
    self.touch_layer:setTouchEnabled(true)
    self.touch_layer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.touch_layer:registerScriptTouchHandler(function(event)
        if event == "began" then
            return true
        end
    end)
    self:addChild(self.touch_layer, 100)
end

function SummonLayer:touchSwallowTouches(is_lock)
    self.touch_layer:setSwallowsTouches(is_lock)
end

function SummonLayer:initDone()
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/summon-effect.plist")

    local posBar = cc.p(0, 0)
    posBar.x = self.spr_bar0:getPositionX()
    posBar.y = self.spr_bar0:getPositionY()

    -- 进度条
    self.progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("main-summon/bar-1.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setPosition(posBar)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self:addChild(self.progressTimer)

    -- 进度数字
    self.lbl_completed = cc.Label:createWithTTF("0/0", FONT_DEFAULT_NAME_BOLD, 24)
	:setAnchorPoint(ex.a.center)
	:setPosition(posBar)
	:enableOutline(FONT_BROWN, 1)
	self:addChild(self.lbl_completed)

    self.completed = {}
    local need_item = cfg.lotterypoint.summon[7].need_item[1]
    self.completed.item_type = need_item.item_type
    self.completed.item_num = need_item.item_num

    -- 招募cell
    self.cellList = {}

    local box_size = self.spr_box:getContentSize()
    box_size.height = box_size.height - 15
    local cell_height = box_size.height / 3
    local start = cc.p(self.spr_box:getPositionX() + box_size.width / 2, self.spr_box:getPositionY() + cell_height / 2 + 7)
    for i=1,3 do
        local cell = self:addSummonCell(4 - i)
        cell:setPosition(start.x, start.y + (i - 1) * cell_height)
        
        self:addChild(cell)

        table.insert(self.cellList, cell)
    end
end

function SummonLayer:onExit()
    -- 停止计时器
    for _,v in pairs(self.cellList) do
        v:stopTimer()
    end

    -- 释放资源


end

function SummonLayer:onBack(tag , pSender)
    if not ex.MainSceneCtr:backLastLayer() then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    end
end

function SummonLayer:addSummonCell(summon_type)
    local cell = SummonCell:createWithCCBIFile("ccbi/SummonCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)

    cell:initDone(summon_type) -- 初始化状态

    cell.btn_one:registerScriptTapHandler(handler(self, self.onSummonConfirm))
    cell.btn_ten:registerScriptTapHandler(handler(self, self.onSummonConfirm))

	return cell
end


function SummonLayer:updateCompleted()
    local hasNum = ex.Player:getItemNum(self.completed.item_type)
    local need_num = self.completed.item_num

    local is_clergy_privilege = cfg.clergyprivilege.isPrivilege(CLERGY_PRIVILEGE_TYPE.POINT_SUMMON, ex.Player.clergy_level)
    if is_clergy_privilege then 
        local clergy_config = cfg.clergyprivilege.getConfigByPrivilegeType(CLERGY_PRIVILEGE_TYPE.POINT_SUMMON)
        need_num = need_num * clergy_config.unlock_privilege.value / 10000 
    end

    -- print(hasNum >= need_num, hasNum , need_num)

    if hasNum >= need_num then
        self.progressTimer:setPercentage(100.0)
        --
        if ex.Player.summon_data:checkBtnAwardRedDot() == true then 
            if self.zhaohuanlibao then 
                self.zhaohuanlibao:setVisible(true) 
            else
                self.zhaohuanlibao = sp.SkeletonAnimation:create("spine/zhaohuanlibao.json","spine/zhaohuanlibao.atlas", 1)
                self.zhaohuanlibao:setAnimation(0, "idle", true);
                self.zhaohuanlibao:setPosition(self.btn_award:getPositionX() ,self.btn_award:getPositionY() )
                self:addChild(self.zhaohuanlibao, 1000)
            end
            ex.Tools:addRedPoint(self.node_red, ex.Player.summon_data:checkBtnAwardRedDot())

            self.btn_award:setVisible(false)
            self.btn_award2:setVisible(true)

        end 
    else
        if self.zhaohuanlibao then 
            self.zhaohuanlibao:setVisible(false) 
        end
        ex.Tools:addRedPoint(self.node_red, false)
        self.progressTimer:setPercentage(100.0 * hasNum / need_num)

        self.btn_award:setVisible(true)
        self.btn_award2:setVisible(false)
    end

    self.lbl_completed:setString(string.format("%d/%d", hasNum, need_num))

    --self:touchSwallowTouches(false)


    -- 刷新拥有卷数
    for _,v in pairs(self.cellList) do
        v:setGem()
    end

    -- 处理免费
    local config = cfg.lotterypoint.summon[ex.Player.summon_data.last_summon_type]
    if config == nil then
        return
    end

    if config.summon_times == 1 then
        if ex.Player.summon_data:getFree(config.type) ~= 2 then
            for _,v in pairs(self.cellList) do
                if v.type_id == config.type then
                    v:setCurrentType()
                    return
                end
            end
        end
    end
end

function SummonLayer:onBtnLeft(tag, pSender)
	for k,v in pairs(self.cellList) do
		local x = v:getPositionX()
    	if x < 0 then
    		v:setPositionX(x + self.clipSize.width * 2)
    	else
    		v:runAction(cc.MoveBy:create(0.2, cc.p(-self.clipSize.width, 0)))
    	end
    end
end

function SummonLayer:onBtnRight(tag, pSender)
	for k,v in pairs(self.cellList) do
		local x = v:getPositionX()
    	if x > self.clipSize.width then
    		v:setPositionX(x - self.clipSize.width * 2)
    	else
    		v:runAction(cc.MoveBy:create(0.2, cc.p(self.clipSize.width, 0)))
    	end
    end
end

function SummonLayer:onBtnInfo(tag, pSender)
	ex.InfoCtr:openWindow(ex.Tools:getLang(42010), ex.Tools:getLang(42011))
end

function SummonLayer:onBtnAward(tag, pSender)
    -- 打开积分抽奖窗口

    ex.Player.summon_data:setRemmember()

    ex.Tools:addRedPoint(self.node_red, ex.Player.summon_data:checkBtnAwardRedDot())

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZHFZ, ex.Player.summon_data:checkRedDot())
    if self.zhaohuanlibao then self.zhaohuanlibao:setVisible(false) end
    
    self.btn_award:setVisible(true)
    self.btn_award2:setVisible(false)

    SummonJFCtr:instance():openWindow(self.completed, handler(self, self.onAward))
end

function SummonLayer:onAward()
    --英雄背包空间不足
    if ex.Player.hero_data:getLen() >= ex.Player.hero_data:getCapacity() then
        ex.MessageView:add(ex.Tools:getLang(1121))
       return
    end

    local is_clergy_privilege = cfg.clergyprivilege.isPrivilege(CLERGY_PRIVILEGE_TYPE.POINT_SUMMON, ex.Player.clergy_level)
    local clergy_config = cfg.clergyprivilege.getConfigByPrivilegeType(CLERGY_PRIVILEGE_TYPE.POINT_SUMMON)
    local hasNum = ex.Player:getItemNum(self.completed.item_type)
    local is_not_enough = hasNum < self.completed.item_num
    if is_clergy_privilege then is_not_enough = hasNum < self.completed.item_num * clergy_config.unlock_privilege.value / 10000 end
    if is_not_enough then
        ex.MessageView:add(string.format(ex.Tools:getLang(1108),
            ex.Tools:getLang(cfg.item.item[self.completed.item_type].name)))
        return
    end

    self:touchSwallowTouches(true)

    -- 扣除积分
    -- ex.Player:addItem(self.completed.item_type, -self.completed.item_num)

    ex.Player.summon_data:award()
end

function SummonLayer:onSummonConfirm(tag, pSender)
    -- ex.Player.summon_data:done(tag, true) -- 1 2 3 4 5 6
    ex.Player.summon_data:done(tag, false)
end


return SummonLayer