local Tools = class("Tools")

require("src.layer.promotion.CommonUIDefine")
local UIMenuItemHeroPiece = require("src.comp.menu.UIMenuItemHeroPiece")
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

-- local audio_manager = require("src.model.AudioManager"):instance()

lang_key = "value"

starttime = 0
Money2GemRate = 0.1 -- 以分为单位的宝石兑换比例，一元=10宝石

function Tools:resetLangKey()
    local res_language, config_idx = require("src.native.Native").getLanguageAdapter()
    if config_idx then
        lang_key = cfg.languagetype.languagetype[config_idx].lang_key
    end
end

--[[
    func: 金钱数转宝石数
    --@money_unit: 基于金钱单位的金钱数(例如：以分为单位，1元=100)
    @return: 基于游戏中的兑换比例应得宝石数
]]
function Tools:Money2GemNumber(money_unit)
    money_unit  = money_unit or 0
    return money_unit * Money2GemRate
end

--node  要加红点的节点
--bool	是否显示红点
--anchor   {x=1,y=1}默认显示在右上角，如果要定义位置写入位置
function Tools:addRedPoint(node,bool,anchor)
    if not node or tolua.isnull(node) then     
        return
    end
    
	local redPoint = node:getChildByName("redPoint")
	local content = node:getContentSize()
	if not redPoint then
		redPoint = cc.Sprite:createWithSpriteFrameName("other/spr-reddot-1.png")
		redPoint:setName("redPoint")
        redPoint:setAnchorPoint(0.5,0.5)
		node:addChild(redPoint)
    end
    local pos = {}
	if not anchor then 
		pos.x = content.width -- redPoint:getContentSize().width/2 +7
		pos.y = content.height -- redPoint:getContentSize().height/2 +3

    else
        pos.x = anchor.x * content.width
        pos.y = anchor.y * content.height
	end
	redPoint:setPosition(pos.x,pos.y)
	redPoint:setLocalZOrder(100000)
	redPoint:setVisible(bool)
end

-- 每天只出现一次的红点
function Tools:checkReddotStatusOnceDay(type, is_save)
    -- key格式  "rednode-role_id-type"
    local key = string.format("rednode-%s-%d", ex.Player.role_id, type)
    local now_day = Maths.getDays(cpp.Game:instance():getServerTime())
    local tag = cc.UserDefault:getInstance():getIntegerForKey(key, -1)
    
    -- 存贮的时间不是今天。则显示该红点
    if is_save and tag ~= now_day  then
        cc.UserDefault:getInstance():setIntegerForKey(key, now_day)
    end

    return tag ~= now_day 
end

function Tools:getRedDotOnceDayStatus(type, is_save)
    local key = string.format("rednode-%s-%d", ex.Player.role_id, type)
    local now_day = Maths.getDays(cpp.Game:instance():getServerTime())
    local tag = cc.UserDefault:getInstance():getIntegerForKey(key, -1)

    local is_visible = tag ~= now_day

    if is_save then
        cc.UserDefault:getInstance():setIntegerForKey(key, now_day)
    end

    return is_visible
end

function Tools:getAchievementStatus(type, is_save)
    local key = string.format("rednode-%s-%d", ex.Player.role_id, type)
    local tag = cc.UserDefault:getInstance():getIntegerForKey(key, -1)

    local is_visible = tag <= 0

    if is_save then
        cc.UserDefault:getInstance():setIntegerForKey(key, 1)
    end

    return is_visible
end

function Tools:resetAchievementStatus(type)
    if type == nil then
        return
    end
    local key = string.format("rednode-%s-%d", ex.Player.role_id, type)
    cc.UserDefault:getInstance():setIntegerForKey(key, -1)
end

function Tools:getServerTimeWithUTC()
    return self:getTimeWithUTC(ex.Game:getServerTime())
end

function Tools:getTimeWithUTC(time)
    if time == nil or time <= 0 then
        return time
    end

    local offset_utc = ex.Player.offset_utc - self:getTimeZone()
    return time + offset_utc
end

-- 获取这周剩余时间
function Tools:getWeekRemainingTime()
    local cur_time = self:getServerTimeWithUTC()
    local cur_date = self:FormatUnixTime2Date(cur_time)
    local cur_wday = cur_date.wday 
    local day 
    if cur_wday == 0 then 
        day = cur_wday
    else
        day = 7 - cur_wday
    end
    local next_week = cur_date.day + day
    local RemainingTime = os.time({day=next_week, month=cur_date.month, year=cur_date.year, hour=24, minute=0, second=0}) -1
    return RemainingTime
end

-- 获取这周已过时间
function Tools:getWeekPassedTime()
    return TIME.WEEK - (self:getWeekRemainingTime() - ex.Game:getServerTime() + ex.Player.offset_utc - self:getTimeZone())
end

function Tools:getMonthRemainingTime()
    local cur_time = self:getServerTimeWithUTC()
    local cur_date = self:FormatUnixTime2Date(cur_time)

    local month_day = os.date("%d",os.time({year=os.date("%Y"),month=os.date("%m")+1,day=0}))
    local RemainingTime = os.time({day=month_day, month=cur_date.month, year=cur_date.year, hour=24, minute=0, second=0}) -1
    return RemainingTime
end

function Tools:getDayRemainingTime()
    local cur_time = self:getServerTimeWithUTC()
    local cur_date = self:FormatUnixTime2Date(cur_time)
    local RemainingTime = os.time({day=cur_date.day + 1, month=cur_date.month, year=cur_date.year, hour=0, minute=0, second=0}) -1
    return RemainingTime
end

function Tools:FormatUnixTime2Date(unixTime)
    if unixTime and unixTime >= 0 then
        local tb = {}
        tb.year = tonumber(os.date("%Y",unixTime))
        tb.month =tonumber(os.date("%m",unixTime))
        tb.day = tonumber(os.date("%d",unixTime))
        tb.wday = tonumber(os.date("%w",unixTime))
        tb.hour = tonumber(os.date("%H",unixTime))
        tb.minute = tonumber(os.date("%M",unixTime))
        tb.second = tonumber(os.date("%S",unixTime))
        return tb
    end
end

function Tools:getTimeZone()
    local now = os.time()
    return os.difftime(now, os.time(os.date("!*t", now)))
end


function Tools:getItem(byte_array)
    local item = {}
    item.id = byte_array:readInt64()
    item.item_type = byte_array:readInt()
    item.item_num = byte_array:readInt()
    return item
end

function Tools:onClickItemInfo(item_type, item_id, is_show_use, order, hero_id)
    local tag = ex.Player.backpack_data:getPropType(item_type)
    local layer 
    print("Tools:onClickItemInfo:", item_type, tag)
    if tag == ItemData.IT_EQUIP then 
        local config = cfg.equipmenttype.equip[item_type]
        local ctr = require("src.layer.AbilityInfoCtr"):instance()
        ctr:openWindow()
        ctr:addEquipInfo(config,{})
        layer = ctr.layer
    elseif tag == ItemData.IT_HERO_FASHION then 
        local ctr = require("src.layer.skinsystem.HeroUseSkinCtr"):instance()
        ctr:openWindow(item_type, false)
        layer = ctr.layer
    elseif tag == ItemData.IT_RUNES then 
        print("item_id:", item_id)
        if item_id ~= nil and item_id > 0 then
            local runes = ex.Player.backpack_data:getItemById(item_id, true)
            if runes ~= nil then
                local ctr = require("src.layer.runes.RunesTipsCtr"):instance()
                ctr:openWindow()
                :addEquipInfo(runes)
                layer = ctr.layer
            end
        else
            local ctr = require("src.layer.BackpackInfoCtr"):instance()
            ctr:openWindow(item_type, nil, nil, is_show_use)
            layer = ctr.layer
        end
    elseif tag == ItemData.IT_HERO_GODEQUIP then
        local equip_data = ex.Player.backpack_data:getGodEquipDataByID(item_id)
        if equip_data == nil then
            equip_data = {}

            equip_data.item_id = item_id
            equip_data.item_type = item_type
            equip_data.hero_id = 0

            -- 初始化属性，根据品质添加随机属性条数
            local attrs = {}
            local config_rare = cfg.godequipmentrare.godequipmentrare[cfg.godequipment.godequipment[equip_data.item_type].rare]
            for i=1,config_rare.random_ability_num do
                local attr_data = {}
                attr_data.sys_id = -1
                attr_data.value = -1
                table.insert(attrs, attr_data)
            end

            equip_data.attrs = attrs
        end

        local info_ctr = require("src.layer.heroinfo.HeroGodEquipAbilityInfoCtr"):instance()
        info_ctr:openWindow()
        :setDataInfo(equip_data)
        layer = info_ctr.layer
    elseif tag == ItemData.IT_HERO or tag == ItemData.IT_HERO_MATERIAL then
        local hero_type = tag == ItemData.IT_HERO and item_type or cfg.item.item[item_type].use_value
        local hero_config = cfg.herotype.star[hero_type]
        local hero_star = tag == ItemData.IT_HERO and hero_config.star or cfg.item.item[item_type].star
        -- 构造英雄数据
        local hero_info = {}
        if hero_id ~=nil then
            hero_info = ex.Player.hero_data:getHeroDataById(hero_id) or {}
        end
        local hero_data = {}
        hero_data.type = hero_type
        hero_data.star = hero_info.star and hero_info.star or hero_star
        hero_data.occupation = hero_info.occupation and hero_info.occupation or hero_config.occupation
        hero_data.elem = hero_info.elem and hero_info.elem or hero_config.elem
        hero_data.level = hero_info.level and hero_info.level or 1
        hero_data.stage = hero_info.stage and hero_info.stage or 0
        local ctr = require("src.layer.HeroInfoTipsCtr"):instance()
        ctr:openWindow(hero_data)
        layer = ctr.layer
    elseif tag == ItemData.IT_HALLOWS then
        local info_ctr = require("src.layer.dragon.HallowsInfoCtr"):instance()
        info_ctr:openWindow()
        info_ctr:addDataInfo(item_type)
        layer = info_ctr.layer
    elseif tag == ItemData.IT_PROP_LIMIT_TIME then
        local info_ctrl = require("src.layer.BackpackInfoCtr"):instance()
        info_ctrl:openWindow(item_type,nil, nil, is_show_use)

        if item_id then
            local prop_data = ex.Player.backpack_data:getLimitTimeItemById(item_id)
            if prop_data then
                info_ctrl:addCountdown(prop_data.end_time, true)
            end
        end
        layer = info_ctrl.layer
    elseif tag == ItemData.ARTIFACTS then 
        local data = {}
        data.equip = {sys_id = item_type}
        local equip_list = {}
        equip_list[1] = item_type
        data.equip_list = equip_list
        local ctr = require("src.layer.artifacts.ArtifactTipsCtr"):instance()
        ctr:openWindow()
        :addEquipInfo(data)
        layer = ctr.layer
    elseif tag == ItemData.TOTEM then 
        local ctr = require("src.layer.totems.TotemTipsCtr"):instance()
        local totem_data = {}
        totem_data.sys_id = item_type
        totem_data.quality = 1
        totem_data.level = 1
        ctr:openWindow(totem_data)
    elseif tag == ItemData.SHEN_BING then
        require("src.layer.crusadegroup.godarms.GodArmsComposeCtr"):instance():openWindow( nil,  nil,  item_type,  nil, 3)
    elseif tag == ItemData.MAGIC_WAND then
        local data = ex.Player.backpack_data:getMagicWand(item_id)
        if data == nil or is_show_use == true then
            data = {item_type = item_type, strengthen_lv = 0, base_attrs={}, random_attrs = {}}
        end
        require("src.layer.heromagicwand.HeroMagicWandInfoCtr"):instance():openWindow(data, 1)
    else
        local ctr = require("src.layer.BackpackInfoCtr"):instance()
        ctr:openWindow(item_type,nil, nil, is_show_use)
        layer = ctr.layer
    end
    -- add 熊梦 设置界面层级
    if order ~= nil and layer ~= nil then
        layer:setLocalZOrder(order)
    end
end

--[[
    点击道具来源回调，打开道路来源显示窗口，或者打开道具购买界面
]]
function Tools:onClickItemSrc(item_type)
    local config_item = cfg.item.item[item_type]
    if config_item == nil or type(config_item.source) ~= "table" or table.nums(config_item.source) <= 0 then
        ex.MessageView:add("the source of item "..item_type.." is undefined")
        return
    elseif config_item.source[1].source ~= nil then
        require("src.layer.BackpackSrcCtr"):instance():openWindow(item_type)
    elseif config_item.source[1].buy ~= nil then
        local config_price = ex.Player.market_data:getCfgByType(config_item.source[1].shop)[config_item.source[1].buy]
        if config_price == nil then
            return
        end

        local cur_buy_num = 0
            local limit_data = ex.Player.market_data:getDataByType(config_item.source[1].shop)
        if limit_data ~= nil then
            for _,v in pairs(limit_data) do
                if v.idx == config_price.idx then
                    cur_buy_num = v.buy_num
                    break
                end
            end
        end

        local callback = function(num)
            if num > config_price.buy_limit - cur_buy_num then
                ex.MessageView:add(ex.Tools:getLang(74601))
                return
            end

            local res_buy = Shop_pb.GReqShopBuy()
			res_buy.idx = config_price.idx 
			res_buy.type = config_item.source[1].shop
			res_buy.buy_times = num or 1
			NetManager:sendMessage(ProtocolID.GReqShopBuy, res_buy)
        end
        require("src.layer.ItemSelectCtr"):instance():openWindow(ex.Tools:getLang(41228), 
                                                                 config_price.item_type[1], 
                                                                 callback, config_price.need_item[1], 
                                                                 config_price.buy_limit, 
                                                                 cur_buy_num, 
                                                                 config_item.source[1].shop,
                                                                 true)
    end
end

function Tools:getIllustratHeroSkinByStar(type,star)
    local config = cfg.skin.skin[type]
    local skin = type
    if not config then return skin end

    for i,v in ipairs(config.handbook) do
        skin = config.skin[i]
        if v >= star then break end
    end

    return skin
end

function Tools:getHeroSkinByStar(hero_type,star,evolve)
    if evolve and type(evolve.type) == "number" and evolve.type > 0 then
        local evolve_config = cfg.heroevolvelevel.getEvolutionConfig(hero_type, evolve.level, evolve.type)
        if evolve_config and evolve_config.evolve_fashion_id then
            return evolve_config.evolve_fashion_id
        end
    end

    local config = cfg.skin.skin[hero_type]
    local skin = hero_type
    if not config then return skin end

    for i,v in ipairs(config.star_limit) do
        skin = config.skin[i]
        if v >= star then break end
    end

    return skin
end

function Tools:getHeroSkinByImageId(image_id)
    local hero_type = math.floor(image_id % 100000000)
    local star = math.floor(image_id / 100000000)
	return star, self:getHeroSkinByStar(hero_type, star)
end


function Tools:getHeroIconByStar(type,star)
    local config = cfg.skin.skin[type]
    local skin = type
    if not config then return skin end

    for i,v in ipairs(config.star_limit) do
        skin = config.skin[i]
        if v >= star then break end
    end

    return skin
end

--战力展示面板
function Tools:showPowerEff(oldPower,newPoew)
    local scene = cc.Director:getInstance():getRunningScene()
    local power_layer = scene:getChildByName("power_layer")
    if not power_layer then 
        power_layer = require("src.layer.PowerLayer"):createWithCCBIFile("ccbi/PowerLayer.ccbi")
        scene:addChild(power_layer,99999)
        power_layer:setName("power_layer")
        power_layer:setPosition(222,555)
    end
    power_layer:setPower(oldPower,newPoew)
end

--打开奖励展示界面
function Tools:openRewardPanel(award_list, callback, type)
    type = type or 3
    local main_ctr = require("src.scene.MainSceneCtr"):instance()
    local main_scene = main_ctr.layer
    if main_ctr:isRuning() ~= true then
        return
    end

    local node = require("src.layer.RewardLayer"):createAward(2, award_list, false, function()
        local is_show = ex.Player.promotion_data:isExistStarGiftForStar(5)  -- 华仔说一定是只有5星的，无辜脸
        if is_show then
            -- 获得5星以上英雄 限时礼包跳转
            ex.ConfirmCtr:openWindow("", string.format(ex.Tools:getLang(2725), 5), function()
                ex.EventManager:fire(EVENT.OPEN_LAYER_CLOSE_OTHER.OPEN_HERO_STAR_GIFT)	-- 关闭其他打开controller，底层功能缺陷，先这样
                ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LIMIT_GIFT)
            end)
        end
    end, true)
    -- node.spr_bg:setVisible(false)
    main_scene:addChild(node, 1000000)
end
--[[
    dir  为 1 是垂直 0 为水平
    order  为 0 升序 1 降序
]]
function Tools:initTableView(parent,cell_data, obj, size, margin , pos , offset, dir, order)
    if not parent then return end
    if not cell_data then cell_data = {} end
    if not obj then return end
    if not margin then margin = 0 end
    if not pos then pos = cc.p(0,0) end
    if not dir then dir = 1 end
    if not order then order = 0 end




    -- 这里会有内存泄漏
    -- 原因：ccbi layer 注册移除事件时是在下一帧生效，但是如果没有父节点的话。会在当前帧就移除了。导致无法调用资源释放函数
    -- local itemSize = obj[1]:createWithCCBIFile(obj[2]):getContentSize()

    -- FIX
    local tmp_cell = obj[1]:createWithCCBIFile(obj[2])
    tmp_cell:setVisible(false)

    if tmp_cell.setAutoClose then
        -- self:setAutoClose(true)
        -- self:setSwallowTouches(true)
    end

    if tmp_cell.setSwallowTouches then
        tmp_cell:setSwallowTouches(false)
    end




    local itemSize = tmp_cell:getContentSize()
    if not size then size = cc.size(125,200) end
    local tableView = cc.TableView:create(size)
    tableView:setAnchorPoint(cc.p(0,0))
    tableView:setDirection(dir)
    tableView:setVerticalFillOrder(order)
    tableView:setDelegate()
    parent:addChild(tableView)
    tableView:setPosition(pos)
    tableView:addChild(tmp_cell, -999)

    tableView.obj = obj

    -- tableView.setObj = function (obj)
    --     tableView.obj = obj
    -- end

    tableView.data = cell_data

    tableView.initData = function(tableView, data)
        if not data then return end
        tableView.data = data
        tableView:reloadData()
    end

    tableView.getData = function (tableView)
        return tableView.data
    end

    tableView.setDidScrollCB = function (tableView , callback)
        tableView.didScrollCB = callback
    end

    tableView.setDidZoomCB = function (tableView , callback)
        tableView.didZoomCB = callback
    end

    tableView.setCellTouchedCB = function (tableView , callback)
        tableView.cellTouchedCB = callback
    end

    local function scrollViewDidScroll(view)
        -- view 是当前tableview的实力，同下方的table
        if tableView.didScrollCB then 
            tableView.didScrollCB(view)
        end
    end

    local function scrollViewDidZoom(view)
         if tableView.didZoomCB then 
            tableView.didZoomCB(view)
        end
    end

    local function tableCellTouched(table,cell)
        -- cell:getIdx()来获取cell的index值
         if tableView.cellTouchedCB then 
            tableView.cellTouchedCB(cell)
        end
    end

    local size = cc.size(0,0)
    if not offset then  
        if dir == 1 then 
            size.height = itemSize.height + margin
            size.width = itemSize.width
        else
            size.width = itemSize.width + margin
            size.height = itemSize.height
        end
    else
        size.height = itemSize.height + margin
        size.width = itemSize.width + margin
    end

    local function cellSizeForTable(table,idx)
        return size.width * (tableView:getViewSize().width / size.width), size.height * (tableView:getViewSize().width / size.width)
    end

    local function tableCellAtIndex(table, idx)

        local cell = table:dequeueCell() -- cc.TableViewCell:create()
        if cell == nil then
            cell = cc.TableViewCell:create()
        else
            cell:removeAllChildren()
        end

        local createCell = function()
            local item = tableView.obj[1]:createWithCCBIFile(tableView.obj[2])
            item:setTag(idx)
            item:setAnchorPoint(cc.p(0,0))
            local posX 
            local posY 
            if not offset then 
                posX = dir == 1 and 0 or margin / 2
                posY = dir == 0 and 0 or margin / 2
            else
                posX = margin / 2
                posY = margin / 2
            end
            item:setPosition(posX,posY)
            cell:addChild(item)
    
            item:setScale((tableView:getViewSize().width - 2 * posX) / itemSize.width)
            
            if item.setTableView then 
                item:setTableView(table)
            end
            item:reset(tableView.data[idx+1])
        end

        -- createCell()
        local status, msg = xpcall(createCell, __G__TRACKBACK__)
        if not status then
            print(msg)
        end

        return cell
    end

    local function numberOfCellsInTableView(table)
       return #tableView.data
    end


    --registerScriptHandler functions must be before the reloadData funtion
    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
    tableView:registerScriptHandler(scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end

--把一个对象变灰
function Tools:setGray(obj)
    if obj.setGLProgramState == nil then return end
    obj:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgramName("ShaderUIGrayScale"))
end

--取消变灰
function Tools:delGray(obj)
    if obj.setGLProgramState == nil then return end
    obj:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgramName("ShaderPositionTextureColor_noMVP"))
end

-- 设置变灰
function Tools:setGrayAuto(obj, is_gray)
    if not obj then
        return obj
    end
    
    if is_gray then
        self:setGray(obj)
    else
        self:delGray(obj)
    end
    
    return obj
end

--[[
    func: 设置节点下所有节点自动置灰
    time:2019-11-29 10:38:11
    --@obj: 根节点
	--@is_gray: 是否置灰
]]
function Tools:setAllGrayAuto(obj, is_gray)
    if obj == nil or obj.getChildren == nil or type(is_gray) ~= "boolean" then
        return
    end

    self:setGrayAuto(obj, is_gray)

    local children = obj:getChildren()
    for i,v in ipairs(children) do
        self:setAllGrayAuto(v, is_gray)
    end
end

--格式化时间，
function Tools:formatTime( timestamp)
    local d = math.floor(timestamp / 60 / 60 / 24)
    local h = math.floor(timestamp / 60 / 60 % 24)
    local m = math.floor(timestamp / 60 % 60)
    local s = (timestamp % 60)
    return d,h,m,s
end


--格式化时间，
function Tools:formatTime2(timestamp)
    local str = nil
    local d,h,m,s = ex.Tools:formatTime(timestamp)
    if d >= 1 then
        str = string.format(ex.Tools:getLang(47050), d , h, m, s)
    else
        str = string.format(ex.Tools:getLang(47533), d * 24 + h, m, s)
    end
    return str
end

--格式化时间，
function Tools:formatTime3(timestamp)
    local str = nil
    local d,h,m,s = ex.Tools:formatTime(timestamp)
    if d >= 1 then
        str = string.format(ex.Tools:getLang(47554), d)
    else
        str = string.format(ex.Tools:getLang(47533), d * 24 + h, m, s)
    end
    return str
end

--格式化时间，
function Tools:formatTime4(timestamp)
    local str = nil
    local d,h,m,s = ex.Tools:formatTime(timestamp)
    if d >= 1 then
        str = string.format(ex.Tools:getLang(47090), d, h, m)
    else
        if d < 1 and m < 1 then 
            str = string.format(ex.Tools:getLang(47470), h, 1)
        else
            str = string.format(ex.Tools:getLang(47470), h, m)
        end
    end
    return str
end

function Tools:formatTime5(timestamp)
    local str = nil
    local d,h,m,s = ex.Tools:formatTime(timestamp)
    if d >= 1 then
        str = string.format(ex.Tools:getLang(47050), d , h, m, s)
    else
        str = string.format(ex.Tools:getLang(47533), d * 24 + h, m, s)
    end
    return str
end

--格式化时间，
function Tools:formatTime6(timestamp)
    local str = nil
    local d,h,m,s = ex.Tools:formatTime(timestamp)
    if d >= 1 then
        str = string.format("%02d:%02d:%02d:%02d", d , h, m, s)
    else
        str = string.format("%02d:%02d:%02d", d * 24 + h, m, s)
    end
    return str
end


-- 计算多少天之后的时间戳
function Tools:getTimeFuture(future_hour, future_days)
    local cur_timestamp = cpp.Game:instance():getServerTime()
    local one_hour_timestamp = 24*60*60
    local temp_time = cur_timestamp + one_hour_timestamp * future_days
    local temp_date = os.date("*t", temp_time)
    
    local resultTime = os.time({year=temp_date.year, month=temp_date.month, day=temp_date.day, hour=future_hour})
    return resultTime
end


function Tools:stringSplit(szFullString, szSeparator)  
    local nFindStartIndex = 1  
    local nSplitIndex = 1  
    local nSplitArray = {}  
    while true do  
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
        if not nFindLastIndex then  
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
            break  
        end  
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
        nSplitIndex = nSplitIndex + 1  
    end  
    return nSplitArray  
end


-- 打开物品详细信息窗口
function Tools:showItemInfo(tag, pSender)
    self:onClickItemInfo(pSender.item_type)
end

-- 创建一个物品图标。
function Tools:createBackpackItem(item_type, item_num, bg_path)
    local item = nil
    if ex.Player.backpack_data:isPiece(item_type) then
        item = UIMenuItemHeroPiece:createWithData(item_type, false, bg_path)
        item:setNum(item_num)
    else
        item = UIMenuItemBackpack:createWithData(item_type, item_num, bg_path)
    end
    return item
end

-- 屏幕会出现获得资源的文字
function Tools:addBackpackMsg(item_type, item_num, str)
    local file_name = self:getItemImageName(item_type)

    local content = string.format(ex.Tools:getLang(47314), file_name, ex.Tools:getLang(cfg.item.item[item_type].name), item_num)
    if str ~= nil then 
        content = content .. str
    end
    ex.MessageView:add(content, 0)
end

--[[
    func: 获取物品图片在图集中的名称
    author:徐东浩
    time:2019-10-28 17:54:14
    --@item_type: 物品类型id
    @return: 物品图片在图集中的名称
]]
function Tools:getItemImageName(item_type)
    local prop_type = ex.Player.backpack_data:getPropType(item_type)
    local file_name = ""
    if prop_type == ItemData.IT_PROP or prop_type == ItemData.IT_EQUIP or prop_type == ItemData.IT_RES or prop_type == ItemData.IT_PROP_LIMIT_TIME  then
        file_name = string.format("backpack/%d.png", item_type)
    elseif prop_type == ItemData.IT_PIECE then
        file_name = string.format("backpack/%d.png", ex.Player.backpack_data:getPieceIcon(item_type))
    elseif prop_type == ItemData.IT_SPECIAL_ELITE then
        file_name = string.format("backpack/%d.png", item_type)
    end

    return file_name
end

function Tools:randTableIndex(tab, exclude)
    if type(tab) ~= "table" then
        return
    end
    exclude = exclude or -1
    local index = 1
    while(true)
    do
        index = math.random(1, #tab)
        if index ~= exclude then
            break
        end
    end
    return index
end

-- 根据界面。自动播放一个背景音乐
function Tools:autoPlaySceneMusic(delay, file)
    local main_ctr = ex.MainSceneCtr
    local main_scene = main_ctr:getMainScene()
    local layer_type = main_ctr:getCurLayerType()
    local layer = main_ctr:getCurLayer()
    if main_ctr:isRuning() ~= true then
        return
    end

    if delay then
        main_scene:runAction(cc.Sequence:create(cc.DelayTime:create(delay),cc.CallFunc:create(
            function()
                self:autoPlaySceneMusic(nil, file)
            end
        )))
    end


    local music = ""
    local effect = ""

    local layer_config = TableEx.findValueFunction(cfg.mainscenepage.mainscenepage, function(config)
        return MainSceneType[config.layer_type] == layer_type
    end)

    if file ~= nil then
        music = file
    elseif layer_config then
        music = layer_config.music

        if layer and layer.battle_layer and string.len(layer_config.music2) > 0 then
            music = layer_config.music2
        end
        
        if layer_config.audio_effect and layer_config.audio_effect ~= "" and table.nums(layer_config.audio_effect) > 0 then
            local effect_index = ex.Tools:randTableIndex(layer_config.audio_effect, main_ctr.vec_audio_effect[layer_type])
            if effect_index ~= nil then
                effect = layer_config.audio_effect[effect_index]
                main_ctr.vec_audio_effect[layer_type] = effect_index
            end
        end
    end

    if main_ctr.layer_effect_id ~= nil then
        ex.AudioManager:stopEffect(main_ctr.layer_effect_id)
        main_ctr.layer_effect_id = nil
    end

    if layer_type == MainSceneType.MLT_BATTLE and layer and layer.getKeepLayer then
        -- 主线战斗
        -- 判断当前是挂机还是战斗
        music = string.format("music/battle-%d.mp3", layer:getLayerType())
    elseif layer_type == MainSceneType.MAINCITY_LAYER and layer and layer.getKeepLayer then
        -- 判断当前显示的图层
        if layer:getKeepLayer(MainSceneType.MAINCITY_PVP_BATTLE) and layer:getKeepLayer(MainSceneType.MAINCITY_PVP_BATTLE):isVisible() then
            -- PVP战斗中
            music = layer_config.music2
        else
            music = layer_config.music
        end
    elseif layer_type == MainSceneType.CLAN then
        -- 军团
        if layer.cur_layer_tab == ClanLayerType.MISSION and layer.battle_layer then
            music = layer_config.music2
        else
            music = layer_config.music
        end
    end

    if string.len(music) > 0 then
        ex.AudioManager:playMusic(music)
    end

    if string.len(effect) > 0 then
        main_ctr.layer_effect_id = ex.AudioManager:playEffect(effect)
    end
end



function Tools:setMenuItemFrame(btn, normal, select)
    if not btn then
        return 
    end

    if normal then
        self:setSpriteFrame(btn:getNormalImage(), normal)
    end

    if select then
        self:setSpriteFrame(btn:getSelectedImage(), select)
    end
end

function Tools:setSpriteFrame(spr, file)
    if not spr then
        return
    end
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(file)
    if frame then
        spr:setSpriteFrame(frame)
    else
        -- dump(debug.traceback())
        print("frame is null", file)
    end
end

function Tools:setSpriteFrameAsyn(spr, frame, file, callback)
    local asyn_call = function(...)
        local params = {...}
        if tolua.isnull(spr) then
            return
        end

        display.loadSpriteFrames("ccbi-res/" .. file .. ".plist", "ccbi-res/" .. file .. ".pvr.ccz")

        local sprite_frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frame)
        
        if callback then
            callback(spr, frame)
        elseif sprite_frame then
            spr:setSpriteFrame(sprite_frame)
        end
    end
    display.loadImage("ccbi-res/" .. file .. ".pvr.ccz", asyn_call)
end

function Tools:setScale9SpriteFrame(spr, file, rect)
    if not spr then
        return
    end


    if rect == nil then
        rect = spr:getCapInsets()
    end


    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(file)
    if frame then
        local content_size = spr:getContentSize()
        spr:setSpriteFrame(frame, rect)
        spr:setContentSize(content_size)
    else
        -- dump(debug.traceback())
        print("frame is null", file)
    end
end

function Tools:setBtnRewardStatus(btn, status, text1, text0)
    if not btn or tolua.isnull(btn) then
        return
    end

    if status == 1 then
        btn:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-1.png"))
        btn:setSelectedImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-1.png"))
        -- self.btn_submit:setLabelText(ex.Tools:getLang(47627))
        btn:setLabelColor(cc.WHITE)
        btn:setLabelOutLine(FONT_RED, 4)
        if text1 then btn:setLabelText(text1) end
    else
        btn:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-green-1.png"))
        btn:setSelectedImage(cc.Sprite:createWithSpriteFrameName("button/btn-green-1.png"))
        -- btn:setLabelText(ex.Tools:getLang(47695))
        btn:setLabelColor(cc.WHITE)
        btn:setLabelOutLine(FONT_DARK_BLUE_C4B, 4)
        if text0 then btn:setLabelText(text0) end
    end
end

-- 添加图片到UIMenuItemLabel按钮上并和文字居中显示
function Tools:addImgToUIMenuItemLabel(btn, plist_path, img_path, img_scale, space)
    if btn == nil or img_path == nil then
        return
    end

    local space = space or -2.0
    local btn_size = btn:getContentSize()
    local label = btn:getLabel()
    local label_width = label:getContentSize().width * label:getScaleX()

    if plist_path then
        cc.SpriteFrameCache:getInstance():addSpriteFrames(plist_path)
    end

    if btn.spr_res == nil then
        btn.spr_res = cc.Sprite:createWithSpriteFrameName(img_path)
        btn:addChild(btn.spr_res)
        btn.spr_res:setScale(img_scale or 1.0)
    end

    local sprite_width = btn.spr_res:getContentSize().width * btn.spr_res:getScaleX()

    btn.spr_res:setPosition(0.5 * (btn_size.width - space - label_width), 0.5 * btn_size.height)
    local offset = cc.p(0.5 * (btn_size.width + space + sprite_width) - 0.5 * btn_size.width, 0.5 * btn_size.height - 0.5 * btn_size.height)
    btn:setLabelOffset(offset)
end

-- 获得词条文字说明
function Tools:getAttrText(type, value)
    local str = ex.Tools:getLang(2140000 + type)       
    str = ex.StringUtil.formatAttrStr(str, "##" , value)
    return str
end

function Tools:getAttrValue(type, value)
    return ex.StringUtil.formatAttrNum(ex.Tools:getLang(2160000 + type), value)
end

function Tools:getAttrTextOnly(type)
    return ex.Tools:getLang(2150000 + type) 
end

-- 获得属性带品质颜色的富文本字段
function Tools:getAttrRareTextXML(type, value, rare)
    rare = rare or GOD_EQUIP_RARE_GRADE.PuTong

    local str = ex.Tools:getLang(2170000 + type)
    --替换颜色
    str = string.format(str, GOD_EQUIP_RARE_COLOR.HEX[rare])

    str = ex.StringUtil.formatAttrStr(str, "##" , value)
    return str
end

-- 设置label的颜色。is_enough：true 为白色。。 is_enough：false 为红色
function Tools:setCostColor(lbl, is_enough)
    if not lbl then
        return
    end
    lbl:setTextColor(is_enough ~= true and cc.c3b(233, 91, 72) or cc.c3b(255, 249, 234))
end

function Tools:setLabelCostColor(lbl, is_enough)
    if not lbl then
        return
    end
    lbl:setColor(is_enough ~= true and cc.c3b(233, 91, 72) or cc.c3b(24, 146, 0))
end

-- 遍历节点下的所有子节点
function Tools:ergodicAllNode(node, callback)
    if (not node) or (not callback) then
        return
    end
    
    local vec_children = node:getChildren()
    local len = table.getn(vec_children)
    for i=1,len do
        local child = vec_children[i]
        callback(child)
    end
    callback(node)
end

-- 记录开始时间
function Tools:startClock()
    starttime = os.clock();                           --> os.clock()用法
    print(string.format("start time : %.4f", starttime));
end

-- 记录结束时间
function Tools:markClock(tag)
    -- 打印标识符。用于区分是哪里打印的。
    tag = tag or ""

    local endtime = os.clock();                           --> os.clock()用法
    print(string.format("%s end : %.4f, cost time  : %.4f", tag, endtime, endtime - starttime));
    return endtime - starttime
    -- print(string.format("%s cost time  : %.4f", tag, endtime - starttime));
end

function Tools:getLang(lang_id)
    local str = cfg.language.language[lang_id]
    if not str then 
        if lang_id == nil then
            print("language id is nil")
        else
            print("language id [" .. lang_id .. "] is nil")
        end
        return ""
    end
    
    -- dump(str, "Tools:getLang")
    return str[lang_key] or ""
end

function Tools:taskString(lang_id,target,condition,subCondition)
	local language_str = self:getLang(lang_id)

    if language_str ~= "" then 
        if target ~= nil then 
            language_str = string.gsub(language_str, "%[1%]", self:convertNumToStr(target))
        end

        if condition ~= nil then 
            if lang_id == 2317 or lang_id == 53216 or lang_id == 53217 or lang_id == 53219 or lang_id == 53220 then
                language_str = string.gsub(language_str, "%[2%]", ex.Tools:getTarvernRareName(condition))
            elseif lang_id == 55701 or lang_id == 55704 then
                language_str = string.gsub(language_str, "%[2%]", ex.Tools:getLang(cfg.item.item[condition].name))
            else
                language_str = string.gsub(language_str, "%[2%]", tostring(condition))
            end
        end

        if subCondition ~= nil then 
            language_str = string.gsub(language_str, "%[3%]", tostring(subCondition))
        end
    end

	return language_str
end

function Tools:taskNum(type, num)
    if type == nil or num == nil  then
        return ""
    end

    if type == "TOTAL_RECHARGE" or type == "RECHARGE" then
        return string.format("%g", num / 100)
    end
    
    return num
end

function Tools:convertNumToStr(num)
    local str = tostring(num)

    if num >= 100000000 then 
        str = math.floor(num / 100000000) .. ex.Tools:getLang(47357)
    elseif num >= 10000 then 
        str = math.floor(num / 10000) .. ex.Tools:getLang(47010)
    end

    return str
end

function Tools:getSysCfg(key)
    local data = cfg.system[key]

    if not data then 
        if key == nil then
            print("system key is nil")
        else
            print("system key [" .. key .. "] is nil")
        end
    end

    return data or ""
end

function Tools:isExistValueInTable(tab, value)
    if tab ~= nil and value ~= nil then
        for k, v in pairs(tab) do
            if v == value then
                return true
            end
        end
    end

    return false
end

--[[
    func: 调整全屏自适应伸展
    author:徐东浩
    time:2019-10-13 10:47:38
]]
function Tools:AdjustFullScreenExtend(node)
    if node == nil or node.getContentSize == nil then
        return
    end

    local size = node:getContentSize()
    local node_ratio = size.width / size.height
    if node_ratio > ex.p.width / ex.p.height then
        node_ratio = ex.p.height / size.height
    else
        node_ratio = ex.p.width / size.width
    end

    node:setScale(node_ratio)
end


function Tools:showDebugStatus(text)
    if cpp.SocialPlatform:instance():isDebug() ~= true then
        -- 非测试模式则无效
        ex.Tools.showDebugStatus = function ()
        end
        return
    end
    
    ex.MessageView:add(text)
end

--[[
    func: 获取相对父节点的相对位置
    author:徐东浩
    time:2019-11-23 22:29:08
    --@pos: 相对位置坐标
	--@origin_type: 相对父节点锚点类型(1.左下角 2.左上角 3.右上角 4.右下角 5.百分比)
	--@container: 父节点，如无父节点则相对于全屏
    @return: 返回节点在父节点的绝对坐标
]]
function Tools:getAbsolutePosition(pos, origin_type, container)
    local containerSize = ex.s.full
    if container ~= nil then
        containerSize = container:getContentSize()
    end

    local absPt = cc.p(0, 0);

    if origin_type == CommonUIDefine.UIDefine.ComponentOriginType.LEFT_BOTTOM then
        absPt = pos
    elseif origin_type == CommonUIDefine.UIDefine.ComponentOriginType.LEFT_TOP then
        absPt.x = pos.x
        absPt.y = containerSize.height - pos.y

        if containerSize.height >= ex.s.full.height then    -- 减掉刘海
            absPt.y = absPt.y - require("src.model.Game"):instance():getNotchHeight()
        end
    elseif origin_type == CommonUIDefine.UIDefine.ComponentOriginType.RIGHT_TOP then
        absPt.x = containerSize.width - pos.x
        absPt.y = containerSize.height - pos.y

        if containerSize.height >= ex.s.full.height then    -- 减掉刘海
            absPt.y = absPt.y - require("src.model.Game"):instance():getNotchHeight()
        end
    elseif origin_type == CommonUIDefine.UIDefine.ComponentOriginType.RIGHT_BOTTOM then
        absPt.x = containerSize.width - pos.x
        absPt.y = pos.y
    elseif origin_type == CommonUIDefine.UIDefine.ComponentOriginType.RATIO then
        absPt.x = math.floor(containerSize.width * pos.x / 100)
        absPt.y = math.floor(containerSize.height * pos.y / 100)
    end

    return absPt;
end

function Tools:try(ftry, fcatch)
    local status, msg = xpcall(ftry, __G__TRACKBACK__)
    if not status then
        if fcatch then
            -- fcatch()
           fcatch()
        end
	end
end

function Tools:convertRewardList(list)
    local vec_reward = {}
    if list == nil then
        return vec_reward
    end

    for i,v in ipairs(list) do
        local data = {}
        data.item_type = v.type
        data.item_id = v.id
        data.item_num = v.num
        table.insert(vec_reward, data)
    end
    return vec_reward
end

function Tools:hasItem(item, num, is_array, show_tip)
    local is_has = true
    show_tip = show_tip or true

    if is_array then
        for k,v in pairs(item) do
            local item_num = ex.Player:getItemNum(v.item_type)
            if item_num < num then
                if show_tip then self:showEnoughTip(v.item_type) end
                is_has = false
                break
            end
        end
    else
        local item_num = ex.Player:getItemNum(item)
        if item_num < num then
            if show_tip then self:showEnoughTip(item) end
            is_has = false
        end
    end

    return is_has
end

function Tools:hasItemList(item_list, show_tip)
    item_list = clone(item_list)
    
    local is_has = true
    show_tip = show_tip or false
    local need_type = 0
    for k,v in pairs(item_list) do
        local item_num = ex.Player:getItemNum(v.item_type)
        if item_num < v.item_num then
            need_type = v.item_type
            is_has = false
            break
        end
    end

    if show_tip and not is_has then
        self:showEnoughTip(need_type, true)
    end

    return is_has
end

function Tools:showEnoughTip(item_type, is_show_src)
    local item_config = cfg.item.item[item_type]
    if item_config == nil then
        print("showEnoughTip ", item_type, "is nil")
        return
    end
    
    if is_show_src ~= nil and is_show_src == true then
        if ex.Player.level >= (tonumber(ex.Tools:getSysCfg("show_src_level")) or 12) then
            local config = cfg.item.item[item_type]
            if config ~= nil and config.source ~= "" and table.nums(config.source) > 0 then
                require("src.layer.BackpackSrcCtr"):instance():openWindow(item_type)
                return
            end
        end
    end

    local str = string.format(ex.Tools:getLang(47044), item_config.icon, ex.Tools:getLang(item_config.name))
    ex.MessageView:add(str)
end

function Tools:showEnoughTipList(vec_need)
    local cost_res = (vec_need ~= "" and vec_need ~= nil) and vec_need or {}
	for i,v in ipairs(cost_res) do
		local has_material = ex.Player:getItemNum(v.item_type)
		if has_material < v.item_num then
			ex.Tools:showEnoughTip(v.item_type)
			return true
		end
    end
    return false
end

function Tools:getBorderIconByIdx(idx)
    if idx <= 0 then
        return "backpack/border-default.png"
    end
    
    return "backpack/"..1005000 + idx..".png"
end

-- 创建一个容纳文本的可滑动节点
function Tools:getNodeWithScrollLabel(view_size, font_size, font_color, font_str)
    local scroll_view = cc.ScrollView:create(view_size)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    scroll_view:setBounceable(false)
    scroll_view:setIgnoreAnchorPointForPosition(false)
    scroll_view:setAnchorPoint(0.5, 0.5)

    local label_scale = 0.5
    local label = cc.Label:createWithTTF(font_str, FONT_DEFAULT_NAME_BOLD, font_size * 2)
    label:setColor(font_color)
    label:setScale(label_scale)
    label:setAnchorPoint(0, 0)
    label:setDimensions(view_size.width / label_scale, 0)
    scroll_view:addChild(label)

    scroll_view:setContentSize(label:getContentSize().width * label_scale, label:getContentSize().height * label_scale)

    if label:getContentSize().height * label_scale > view_size.height then
        scroll_view:setContentOffset(cc.p(0, view_size.height - label:getContentSize().height * label_scale))
    else
        label:setPosition(0, (view_size.height - label:getContentSize().height * label_scale) / 2)

        scroll_view:setTouchEnabled(false)
    end

    return scroll_view
end

function Tools:showTeamArenaPlayerInfo(role_id, server_id)

    if server_id == nil then
        server_id = cc.UserDefault:getInstance():getIntegerForKey("server_id", -1) --ex.Player.server_id
        server_id = server_id == -1 and nil or server_id
    end
    
    if role_id == nil or server_id == nil then
        print("role id or server id cannot be nil . . .")
        return
    end

    if role_id == 0 then
        ex.MessageView:add(ex.Tools:getLang(74019))
        return
    end
	
    if role_id == ex.Player.role_id then
        ex.MessageView:add(ex.Tools:getLang(41232))
        return
    end
	
	if role_id < 1000000 then
		ex.MessageView:add(ex.Tools:getLang(41198))
		return
	end
    -- 请求访问角色数据
    local req_player_info = TeamArena_pb.GReqTeamArenaRankRoleInfo()
    req_player_info.role_id  = role_id
    req_player_info.server_id = server_id
    NetManager:sendMessage(ProtocolID.GReqTeamArenaRankRoleInfo, req_player_info)
end



function Tools:showPlayerInfo(role_id, server_id)

    if server_id == nil then
        server_id = cc.UserDefault:getInstance():getIntegerForKey("server_id", -1) --ex.Player.server_id
        server_id = server_id == -1 and nil or server_id
    end
    
    if role_id == nil or server_id == nil then
        print("role id or server id cannot be nil . . .")
        return
    end

    if role_id <= 0 then
        return
    end
	
    if role_id == ex.Player.role_id then
        ex.MessageView:add(ex.Tools:getLang(41232))
        return
    end
	
	if role_id < 1000000 then
		ex.MessageView:add(ex.Tools:getLang(41198))
		return
	end
    -- 请求访问角色数据
    local req_player_info = Role_pb.GReqPlayerDetaile()
    req_player_info.rid = role_id
    req_player_info.server_id = server_id
    NetManager:sendMessage(ProtocolID.GReqPlayerDetaile, req_player_info)
end


function Tools:showHeroInfo(role_id, server_id, hero_id)

    if server_id == nil then
        server_id = cc.UserDefault:getInstance():getIntegerForKey("server_id", -1) --ex.Player.server_id
        server_id = server_id == -1 and nil or server_id
    end
    
    if role_id == nil or server_id == nil or hero_id == nil then
        print("role id or server id cannot be nil . . .")
        return
    end

    if role_id <= 0 or hero_id <= 0 then
        ex.MessageView:add(ex.Tools:getLang(41198))
        return
    end

	if role_id < 1000000 then
		ex.MessageView:add(ex.Tools:getLang(41198))
		return
    end
    
    local req = HeroShare_pb.GReqHeroBriefInfo()
    req.server_id = server_id
    req.rid = role_id
    req.hero_id = hero_id
    NetManager:sendMessage(ProtocolID.GReqHeroBriefInfo, req)

    -- -- 请求访问角色数据
    -- local req_player_info = Role_pb.GReqPlayerDetaile()
    -- req_player_info.rid = role_id
    -- req_player_info.server_id = server_id
    -- NetManager:sendMessage(ProtocolID.GReqPlayerDetaile, req_player_info)
end


function Tools:convertTimeInfo(remain_time)
    local str = ""
    if remain_time < TIME.HOUR then 
        local time = math.floor(remain_time / TIME.MINUTE)
        if time == 0 then time = 1 end 
        str = string.format(self:getLang(41173),time)
    elseif remain_time >= TIME.HOUR and remain_time < TIME.DAY then 
        local time = math.floor(remain_time / TIME.HOUR)
        if time == 0 then time = 1 end 
        str = string.format(self:getLang(41174),time)
    elseif remain_time >= TIME.DAY and remain_time < TIME.WEEK then 
        local time = math.floor(remain_time / TIME.DAY)
        if time == 0 then time = 1 end 
        str = string.format(self:getLang(41175),time)
    else
        local time = math.floor(remain_time / TIME.WEEK)
        if time == 0 then time = 1 end 
        str = string.format(self:getLang(41176),time)
    end
    return str
end

function Tools:isInVisible(node)
    if not node then
        return true
    end

    local visible = node:isVisible()
    if not visible then
        return false
    end

    local parent = node:getParent()
    if parent and (not parent:isVisible())  then
        return false
    end

    return self:isInVisible(parent)
end

function Tools:isRelation(node, child)
    if not node or not child then
        return false
    end

    local parent = child:getParent()
    while true do
        if not parent then
            break
        end

        if parent == node then
            return true
        end

        parent = parent:getParent()
    end

    return node == child
end

-- 获取功能按钮状态
function Tools:getMainCityBtnStatus(atom)
    local open_config = cfg.opencondition.condition[atom]

    local is_unlock, is_show, need_level, need_label = true, true, 0, nil
    if open_config ~= nil then
        need_level = (open_config.condition_value ~= "" and open_config.condition_value ~= nil) and open_config.condition_value or 0
        is_unlock = open_config.open == FUNCTION_OPEN_TYPE.DEFAULT_OPEN
        if not is_unlock and open_config.open ~= FUNCTION_OPEN_TYPE.NOT_OPEN then
            -- 玩家等级
            if open_config.condition_type == 1 then
                is_unlock = ex.Player.level >= need_level
                if not is_unlock then need_label = need_level < 0 and ex.Tools:getLang(47629) or string.format(ex.Tools:getLang(47609), need_level) end
            end
            -- 是否加入公会
            if open_config.condition_type == 2 then
                is_unlock = ex.Player.clan_data ~= nil and ex.Player.clan_data.clan_id ~= nil and ex.Player.clan_data.clan_id ~= 0
                if not is_unlock then need_label = ex.Tools:getLang(47646) end
            end
            -- 公会等级
            if open_config.condition_type == 3 then
                is_unlock = ex.Player.clan_data ~= nil and ex.Player.clan_data.clan_id ~= nil and ex.Player.clan_data.clan_id >= need_level
                if not is_unlock then need_label = need_level < 0 and ex.Tools:getLang(47629) or string.format(ex.Tools:getLang(47659), need_level) end
            end
        end
        is_show = is_unlock or (open_config.open == FUNCTION_OPEN_TYPE.COND_NOTICE_SHOW or open_config.open == FUNCTION_OPEN_TYPE.COND_NO_NOTICE_SHOW)
    end

    return is_unlock, is_show, need_label
end

--[[
    @desc: 快捷添加富文本
    time:2020-02-29 18:01:09
    --@parent:父节点
	--@text:文本
	--@font_size:文字大小(不考虑高清屏情况下)
	--@shadow_enabled:是否显示阴影
    --@pos:父节点空间下坐标(cc.p或者cc.tex2F(百分比偏移))
    --@origin_type: 相对父节点锚点类型(1.左下角(默认) 2.左上角 3.右上角 4.右下角 5.百分比)
	--@zorder:层级(默认1)
	--@color:文字颜色(默认白色)
	--@anchor:锚点(默认中心)
    @return:富文本节点
]]
function Tools:createRichText(parent, text, font_size, shadow_enabled, pos, origin_type, color, zorder, anchor)
    color = color or "#FFFFFF"
    anchor = anchor or ex.a.center
    zorder = zorder or 1
    origin_type = origin_type or 1

    if not pos or not pos.x or not pos.y then
        if pos and pos.u and pos.v then
            pos = self:getAbsolutePosition(cc.p(pos.u, pos.v), origin_type, parent)
        else
            pos = ex.p.zero
        end
    end

    local rich_text = cpp.RichTextEx:createWithXMLLua("")
	rich_text:setFontSize(font_size * 2)
	rich_text:setScale(0.5)
	rich_text:setFontFace(FONT_DEFAULT_NAME_BOLD)
	rich_text:setFontColor(color)
	rich_text:setAnchorTextShadow(shadow_enabled)
	rich_text:setAnchorPoint(anchor)
    rich_text:setPosition(pos)
    parent:addChild(rich_text, zorder)

    rich_text:setXmlTextLua(text)
    rich_text:formatText()

    return rich_text
end

function Tools:generationStar(parent, star, star_url, scale, space, offset, order)
    scale = scale or 1
    space = space or 0
    offset = offset or cc.p(0, 0)
    order = order or 0
    local star_type = math.floor(star / 5)
	local star_count

	if star % 5 == 0 then 
		if star > 5 then
			star_count = 1
		else 
			star_count = 5
			star_type = 0
		end
	else
		star_count = star % 5
    end
    
	if star > 10 then star_count = star_count + 1 end

	for i=1, star_count do
		local spr_star = cc.Sprite:createWithSpriteFrameName(string.format(star_url, star_type))
        spr_star:setScale(scale)

        -- 原公式：-0.5L + x = -0.5 * (star_count * spr_star:getContentSize().width * scale + (star_count - 1) * space) + (i - 0.5) * spr_star:getContentSize().width * scale + (i - 1) * space
        local pos = cc.p((i - 0.5 - 0.5 * star_count) * spr_star:getContentSize().width * scale + (i - 0.5 - 0.5 * star_count) * space, 0)
        
        pos = cc.pAdd(pos, offset)

		spr_star:setPosition(pos)
		parent:addChild(spr_star, order)
	end
end

function Tools:addLoadingTip(parent, pos)
    cfg = cfg or {}
    require("src.config.loadingtips")
    require("src.config.language")
    require("src.common.CommonDefine")
    
    local spr_tip_bg = cc.Sprite:createWithSpriteFrameName("loading/spr-bg-2.png")
    spr_tip_bg:setPosition(pos.x, pos.y)
    parent:addChild(spr_tip_bg, 0, 100000)
    
    local lbl_tip = cpp.RichTextEx:createWithXMLLua("")
    :setFontSize(18)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setFontColor("#FFEEB2")
    :setPosition(spr_tip_bg:getContentSize().width * 0.5, spr_tip_bg:getContentSize().height * 0.5 - 1)
    spr_tip_bg:addChild(lbl_tip)
    
    local refresh_tip = function()
        math.randomseed(tostring(os.time()):reverse():sub(1, 6))
        local rand_num = math.random(1, table.nums(cfg.loadingtips.loadingtips))
        local language = cfg.language[cfg.loadingtips.loadingtips[rand_num].tips]
        spr_tip_bg:setVisible(language ~= nil)
        lbl_tip:setXmlTextLua(language or "")
    end
    refresh_tip()
    lbl_tip:runAction(cc.RepeatForever:create(  cc.Sequence:create(cc.DelayTime:create(4), cc.CallFunc:create(refresh_tip))))
end

function Tools:getTarvernRareName(rare)
    -- if rare == 1 then
    --     return ex.Tools:getLang(47631)
    -- elseif rare == 2 then
    --     return ex.Tools:getLang(47230)
    -- elseif rare == 3 then
    --     return ex.Tools:getLang(47231)
    -- elseif rare == 4 then
    --     return ex.Tools:getLang(47688)
    -- elseif rare == 5 then
    --     return ex.Tools:getLang(47556)
    -- else
    --     return ex.Tools:getLang(47320)
    -- end
    return ex.Tools:getLang(41311 + rare)
end


function Tools:addBattleLayerAuto(self_layer, battle_type, keep_type, layer_type, map, evt_start, end_callback, map_pos, map_size)
    local battle_layer = require("src.comp.BattleReportBaseLayer"):create()
    battle_layer.parent_layer_type = keep_type
    battle_layer.battle_layer_type = layer_type
    battle_layer:initData(battle_type, map, evt_start, end_callback, map_pos, map_size)
    battle_layer:setRecoveryType(RecoveryType.RT_REMOVE_PARENT)
    battle_layer:setPosition(cc.p(ex.p.width * 0.5, ex.p.height * 0.5))
    ex.MainSceneCtr:addBattleLayer(self_layer, battle_layer, battle_layer.battle_layer_type, battle_layer.is_conflict and battle_layer.parent_layer_type or nil)
    return battle_layer
end


function Tools:getLabelTextByAtom(atom)
    local config = cfg.opencondition.condition[atom]
    if not config then
        print("atom is nil", atom)
        return ""
    end

    if config.world_level > 1 then
        return string.format(self:getLang(41333), config.condition_value, config.world_level)
    else
        return string.format(self:getLang(47074), config.condition_value)
    end
end

function Tools:layerEnterAction(layer, scale, show_bomb, pos)
    if not layer then
        return
    end

    show_bomb = show_bomb or true
    scale = scale or 1.01
    pos = pos or cc.p(layer:getContentSize().width / 2, layer:getContentSize().height + 100)

    layer:setScale(scale)
	layer:runAction(cc.EaseBackOut:create(cc.ScaleTo:create(0.15, 1.0)))

	layer:setCascadeOpacityEnabled(true)
	layer:setOpacity(0)
    layer:runAction(cc.FadeTo:create(0.08, 255))

    if show_bomb then
        -- 播放彩带爆炸
        layer.spr_effect_bomb = ex.EffectFactory:createEffectWithNodeByName("eff_reward_bomb")
        layer.spr_effect_bomb:setPosition(pos.x, pos.y)
        layer:addChild(layer.spr_effect_bomb, 100)
    end
end

function Tools:itemEnterAction(item, scale)
    if not item then
        return
    end

    scale = scale or 2
	item:setScale(scale)
	item:setCascadeOpacityEnabled(true)
	item:setOpacity(0)
	item:runAction(cc.FadeTo:create(0.15, 255))
	item:runAction(cc.Sequence:create(
		cc.ScaleTo:create(0.1, 1.0),
		cc.CallFunc:create(function()
	end)))
end


function Tools:openComments()
    local url = ""

    if device.platform == "ios" then
        url = string.format("https://itunes.apple.com/app/id%s?action=write-review", cpp.SocialPlatform:instance():getAppId())
    elseif device.platform == "android" then
        -- url = "https://play.google.com/store/apps/details?id=com.game.qyzh.an"
        cpp.SocialPlatform:instance():discuss()
    end
    
    if url ~= "" then
        cc.Application:getInstance():openURL(url)
    end
end

-- 韩服钻石购买提示
function Tools:showCostGemTip(title, content, confirm_callback, is_not_skip)
    if cfg.socialplatform.isOpen("cost_gem_tip") and (is_not_skip == nil or is_not_skip == true) then
        -- 判断今天是否不在提示
        local day = cc.UserDefault:getInstance():getIntegerForKey(string.format("cost_gem_tip-%s", ex.Player.role_id), 0)
        if day == Maths.getDays(ex.Game:getServerTime()) then
            confirm_callback()
            return
        end
        ex.ConfirmCtr:openWindow(title, content, confirm_callback)
        ex.ConfirmCtr:showSkipNode()
    else
        confirm_callback()
    end
end

-- add 熊梦 适配精灵大小
function Tools:setSpriteLimitWidth(spr, width, scale_reset)
    if not spr then
        return
    end

    if scale_reset then
        spr:setScale(scale_reset)
    end

    -- 适配精灵宽度
    if spr:getContentSize().width * spr:getScaleX() > width then
        spr:setScale(width / spr:getContentSize().width)
    end
end

function Tools:setLimitWidth(lbl, width, scale_reset)
    if not lbl then
        return
    end

    if scale_reset then
        lbl:setScale(scale_reset)
    end

    -- 适配文字宽度
    if lbl:getContentSize().width * lbl:getScaleX() > width then
        lbl:setScale(width / lbl:getContentSize().width)
    end
end

function Tools:setTabBtnWidth(btn_list, width)

    local vec_lbl = {}
    for k,v in pairs(btn_list) do
        local lbl = v:getLabel()
        if lbl then
            table.insert(vec_lbl, lbl)
        end
    end
    self:setLblListWidth(vec_lbl, width)
end

function Tools:setLblListWidth(lbl_list, width)
    local min_scale = 100
    for k,v in pairs(lbl_list) do
        local lbl = v
        if lbl and lbl:getContentSize().width * lbl:getScaleX() > width then
            local scale = width / lbl:getContentSize().width
            if scale < min_scale then
                min_scale = scale
            end
        end
    end

    if min_scale < 100 then
        for k,v in pairs(lbl_list) do
            local lbl = v
            if lbl then
                lbl:setScale(min_scale)
            end
        end
    end
end

function Tools:setLabelOffset(lbl1, lbl2, offset)
    if not lbl1 or not lbl2 then
        return
    end
    offset = offset or 0
    lbl2:setPositionX(lbl1:getPositionX() + lbl1:getContentSize().width * lbl1:getScaleX() + offset)
end


function Tools:setLabelOffsetRight(lbl1, lbl2, offset)
    if not lbl1 or not lbl2 then
        return
    end
    offset = offset or 0
    lbl1:setPositionX(lbl2:getPositionX() - lbl2:getContentSize().width * lbl2:getScaleX() + offset)
end

function Tools:setLabelAlignmentMiddleX(lbl1, lbl2, x)
    if not lbl1 or not lbl2 then
        return 0
    end

    local width = lbl2:getContentSize().width * lbl2:getScaleX() + lbl1:getContentSize().width * lbl1:getScaleX()

    lbl1:setPositionX(x - width * 0.5)
    lbl2:setPositionX(lbl1:getPositionX() + lbl1:getContentSize().width * lbl1:getScaleX())
    
    return width
end

function Tools:setTabBtnTextSize(btn, size)
    local lbl = btn:getLabel()
    if lbl then
        local ttf_config = lbl:getTTFConfig()
        ttf_config.fontSize = size
        lbl:setTTFConfig(ttf_config)
    end
end


function Tools:getDiscountText(discount, suffix)

    local str = ""
    if cpp.SocialPlatform:instance():getPlatformId() == "kor" then
        -- 韩国要转换折扣
        str = (100 - discount * 10) .. "%"
    elseif cpp.SocialPlatform:instance():getPlatformId() == "jpn" then
        str = (100 - discount * 10)
    elseif cpp.SocialPlatform:instance():getPlatformId() == "vn" then
        str = (100 - discount) .. "%"
    else
        str = (discount * 10) .. "%"
    end

    if suffix then
        str = str .. self:getLang(47553)
    end
    
    return str
end

function Tools:getItemRareColor(rare)
    return COLOR_RARE[rare]
end


function Tools:addLayoutEx(node, type, resizeMode, direction, margin1, margin2, space, affectedByScale)
    local layoutex = require("src.comp.UILayoutEx"):create()
	layoutex:setLayoutType(type, resizeMode, direction, margin1, margin2, space, affectedByScale)
	layoutex.node = node
    node.layoutex = layoutex
    return layoutex, node
end


function Tools:clearCite(file)	
    -- 清除src目录下所有文件的缓存
    local len3 = string.len(file)
	if len3 <= 0 then
		return
    end
    
    local vec_reload = {}
    for k1, v1 in pairs(package.loaded) do
		for k2, v2 in pairs(USER_CLASS_PATH) do
            local len1 = string.len(k1)
			local len2 = string.len(v2)
            if len1 - 1 < len2 then
                break
            end

            local is_reload = true
            for i=1, len2 do
                if string.sub(k1, i, i) ~= string.sub(v2, i, i) then
                    is_reload = false
                    break
                end
			end

			for i=1, len3 do
				if string.sub(k1, len1-i + 1, len1-i + 1) ~= string.sub(file, len3-i + 1, len3-i + 1) then
                    is_reload = false
                    break
                end
			end

            if is_reload then
                table.insert(vec_reload, k1)
                break
            end
        end
    end

    -- 清除缓存
    for i, v in ipairs(vec_reload) do
        package.loaded[v] = nil
	end
end


return Tools
