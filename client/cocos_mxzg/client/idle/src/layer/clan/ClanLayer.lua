local ClanLayer = class("ClanLayer", require("src.comp.EventLayer"))

local ClanUncreateRecommendCell = class("ClanUncreateRecommendCell", require("src.comp.LuaLayerBase"))

function ClanUncreateRecommendCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

end

function ClanUncreateRecommendCell:initData(data)
    self.btn_join.data = data

    -- self.spr_photo:setSpriteFrame(string.format("clan-photo/%02d.png", data.clan_photo))
    ex.Tools:setSpriteFrame(self.spr_photo, string.format("clan-photo/%02d.png", data.clan_photo))
    self.lbl_name:setString(data.clan_name)
    self.lbl_level:setString(ex.Tools:getLang(5453).." "..data.clan_level)
    self.lbl_num:setString(string.format(ex.Tools:getLang(47767), data.clan_member_num, cfg.clanlevel.clanlevel[data.clan_level].member))
end

function ClanUncreateRecommendCell:setIsTouchInsideNode(scroll_view)
    self.menu:setSwallowsTouches(false)
    self.menu:setIsTouchInsideNode(scroll_view)
end

local ClanUncreateRecommendLayer = class("ClanUncreateRecommendLayer", require("src.comp.EventLayer"))
function ClanUncreateRecommendLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.scroll_view:setItemSize(cc.size(540, 135))
    self.scroll_view:setItemType(1)

    self:onRefresh()
end

function ClanUncreateRecommendLayer:getLayerClass()
    return ClanUncreateRecommendLayer
end

-- 刷新推荐
function ClanUncreateRecommendLayer:onRefresh()
    local req_recommend = Clan_pb.GReqClanSearch()
    req_recommend.search_type = 1
    req_recommend.clan_name = ""
    NetManager:sendMessage(ProtocolID.GReqClanSearch, req_recommend)
end

function ClanUncreateRecommendLayer:updateList(event)
    print("ClanUncreateRecommendLayer:updateTableView")
    self.scroll_view:getContainer():removeAllChildren()

    self.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = ClanUncreateRecommendCell:createWithCCBIFile("ccbi/ClanUncreateRecommendCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data)
        cell:setIsTouchInsideNode(self.scroll_view)

        cell.btn_join:registerScriptTapHandler(handler(self, self.onClanJoin))
    
        return cell
    end

    self.scroll_view:reloadData(ex.Player.clan_data.clan_recommend_list)
end

function ClanUncreateRecommendLayer:onClanJoin(tag, pSender)
    -- 创建公会距离上次退出公会有间隔
    local left_time = ex.Player.clan_data.last_join_time - ex.Game:getServerTime()
    if left_time > 0 then
        ex.MessageView:add(string.format(ex.Tools:getLang(70150), ex.StringUtil.convertToTimeFormat(left_time, 4)))
        return
    end

    local data = pSender.data
    if data.clan_member_num >= cfg.clanlevel.clanlevel[data.clan_level].member then
        ex.MessageView:add(ex.Tools:getLang(47539))
        return
    end

    -- 请求加入公会
    local req_join = Clan_pb.GReqClanJoin()
    req_join.clan_id = data.clan_id
    NetManager:sendMessage(ProtocolID.GReqClanJoin, req_join)
end

local ClanUncreateCreateLayer = class("ClanUncreateCreateLayer", require("src.comp.EventLayer"))
function ClanUncreateCreateLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    -- 公会名输入框
    self.edit_box_name = ccui.EditBox:create(cc.size(self.spr_input_bg:getContentSize().width - 10, self.spr_input_bg:getContentSize().height), "other/spr-null.png", 1)  --输入框尺寸，背景图片
    self.edit_box_name:setName("clan_name")
    self.edit_box_name:setPosition(cc.p(self.spr_input_bg:getPositionX() + 5, self.spr_input_bg:getPositionY()))
    self.edit_box_name:setAnchorPoint(cc.p(0.5, 0.5))
    self.edit_box_name:setFontSize(26)
    self.edit_box_name:setFontColor(cc.c3b(122,71,45))
    self.edit_box_name:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) --输入键盘返回类型，done，send，go等
    self.edit_box_name:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE) --输入模型，如整数类型，URL，电话号码等，会检测是否符合
    self.edit_box_name:setPlaceholderFontSize(20)
    self.edit_box_name:setPlaceHolder(ex.Tools:getLang(41342))
    self.edit_box_name:registerScriptEditBoxHandler(handler(self, self.editboxHandle)) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    -- self.edit_box_name:setText(tostring(pre_input_id))
    self.edit_box_name:setText("")
    self:addChild(self.edit_box_name, 9999)

    -- 公会公告输入框
    self.edit_box_notice = ccui.EditBox:create(cc.size(self.lbl_notice:getContentSize().width * self.lbl_notice:getScaleX() + 450 , 
                                                        self.lbl_notice:getContentSize().height * self.lbl_notice:getScaleY() + 130), 
                                                "other/spr-null.png", 
                                                1)  --输入框尺寸，背景图片
    self.edit_box_notice:setName("clan_notice")
    self.edit_box_notice:setPosition(cc.p(self.lbl_notice:getPosition()))
    self.edit_box_notice:setAnchorPoint(cc.p(0.5, 0.5))
    self.edit_box_notice:setFontSize(40)
    self.edit_box_notice:setScale(0.5)
    self.edit_box_notice:setFontColor(cc.c3b(122,71,45))
    self.edit_box_notice:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) --输入键盘返回类型，done，send，go等
    self.edit_box_notice:setInputMode(cc.EDITBOX_INPUT_MODE_ANY) --输入模型，如整数类型，URL，电话号码等，会检测是否符合
    self.edit_box_notice:registerScriptEditBoxHandler(handler(self, self.editboxHandle)) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    self.edit_box_notice:setText(ex.Tools:getLang(41343))
    self.edit_box_notice:setFontName(FONT_DEFAULT_NAME_BOLD)
    --self.edit_box_notice:setText("")
    self:addChild(self.edit_box_notice, 9999)

    
    self.lbl_notice:setString("")

    -- 创建按钮添加价格显示
    local price = ex.Tools:getSysCfg("create_clan_gem")
    print("create_clan_gem: ", price[1].item_num)
    local spr_gem = cc.Sprite:createWithSpriteFrameName("backpack/"..price[1].item_type..".png")
    spr_gem:setScale(0.3)
    self.btn_create:addChild(spr_gem)
    local lbl_gem = cc.Label:createWithTTF(string.format(""..price[1].item_num..ex.Tools:getLang(41340)), FONT_DEFAULT_NAME_BOLD, 42)
    lbl_gem:enableOutline(cc.c3b(13,91,45), 4)
    lbl_gem:setAnchorPoint(0.5, 0.5)
    lbl_gem:setScale(0.5)
    self.btn_create:addChild(lbl_gem)

    local flag = ex.Player.gem < price[1].item_num
    if flag == false then
        lbl_gem:setColor(cc.WHITE)
    else
        lbl_gem:setColor(cc.RED)
    end

    spr_gem:setPosition(25, self.btn_create:getContentSize().height / 2 + 2)
    lbl_gem:setPosition(self.btn_create:getContentSize().width / 2 + 10, self.btn_create:getContentSize().height / 2)

    local recharge_need = ex.Tools:getSysCfg("create_clan_total_charge_require")
    if recharge_need > 0 then
        self.lbl_clan_create_tip:setString(string.format(ex.Tools:getLang(41139), tostring(ex.Player.total_charge / 100)))
    else
        self.lbl_clan_create_tip:setString("")
    end

    if recharge_need > ex.Player.total_charge then
        self.btn_create:getNormalImage():setGLProgram(cpp.ShaderFactory:instance():getGLProgram(2))
        self.btn_create:setEnabled(false)
    end

    -- 公会创建时的头像默认随机
    ex.Player.clan_data.clan_photo = math.random(1, 44) - 1
    self:updatePhoto()
end

function ClanUncreateCreateLayer:getLayerClass()
    return ClanUncreateCreateLayer
end

function ClanUncreateCreateLayer:updatePhoto()
    -- self.spr_clan_photo:setSpriteFrame(string.format("clan-photo/%02d.png", ex.Player.clan_data.clan_photo))
    ex.Tools:setSpriteFrame(self.spr_clan_photo, string.format("clan-photo/%02d.png", ex.Player.clan_data.clan_photo))
end

function ClanUncreateCreateLayer:editboxHandle(event, sender)
    local name = sender:getName()

    if name == "clan_name" then
        local str_name = sender:getText()
        if str_name == nil then
            str_name = ""
        end
        local is_input = (event == "return") and (#str_name > 0)
        if not is_input then
            return
        end

        str_name = cpp.StringUtil:cutNameWithLength(str_name, NAME_LENGTH, 2, 3.57)

        self.clan_create_name = str_name
        sender:setText(str_name)
    elseif name == "clan_notice" then
        if event == "return" then
            local str_name = sender:getText()
            if str_name == nil then
                str_name = ""
            end
            if #str_name <= 0 then
                return
            end

            str_name = cpp.StringUtil:cutNameWithLength(str_name, 301, 2, 3.57)

            self.clan_create_notice = str_name
            --sender:setText("")

            --self.lbl_notice:setString(self.clan_create_notice)
        elseif event == "began" then
            -- sender:setText(self.lbl_notice:getString())
            local str_name = sender:getText()
            if #str_name <= 0 or str_name == nil then
                str_name = ex.Tools:getLang(41343)
            end
            self.edit_box_notice:setText(str_name)
            self.lbl_notice:setString("")
        end
    end

    
end

-- 选择头像
function ClanUncreateCreateLayer:onPhotoSelect()
    require("src.layer.clan.ClanPhotoCtr"):instance():openWindow()
end

-- 创建公会
function ClanUncreateCreateLayer:onClanCreate()
    local recharge_need = ex.Tools:getSysCfg("create_clan_total_charge_require")
    if recharge_need > ex.Player.total_charge then
        ex.MessageView:add(string.format(ex.Tools:getLang(41063), recharge_need / 100))
        return
    end

    -- 创建公会距离上次退出公会有间隔
    -- local left_time = ex.Player.clan_data.last_join_time - ex.Game:getServerTime()
    -- if left_time > 0 then
    --     ex.MessageView:add(string.format(ex.Tools:getLang(70150), ex.StringUtil.convertToTimeFormat(left_time, 4)))
    --     return
    -- end

    local res_need = ex.Tools:getSysCfg("create_clan_gem")
    local flag = ex.Player.gem < res_need[1].item_num
    if flag == true then
        ex.MessageView:add(ex.Tools:getLang(47222))
        return
    end

    local str_clan_name = self.clan_create_name
    if str_clan_name == nil then
        str_clan_name = ""
    end
    
    if str_clan_name == nil or str_clan_name == "" or #str_clan_name <= 0 then
        ex.MessageView:add(ex.Tools:getLang(47652))
        return
    elseif #str_clan_name > NAME_LENGTH then
        ex.MessageView:add(string.format(ex.Tools:getLang(47532), NAME_LENGTH))
        return
    end

    local flag = ex.StringUtil.checkName(str_clan_name)
    if flag == false then
        ex.MessageView:add(ex.Tools:getLang(47308))
        return
    end

    local str_clan_notice = self.clan_create_notice
    if str_clan_notice == nil then
        str_clan_notice = ""
    end
    
    flag = ex.StringUtil.checkName(str_clan_notice)
    if flag == false and str_clan_notice ~= "" then
        ex.MessageView:add(ex.Tools:getLang(47284))
        return
    end

    local req_create = Clan_pb.GReqClanCreate()
    req_create.clan_name = str_clan_name
    req_create.clan_photo = ex.Player.clan_data.clan_photo
    req_create.clan_notice = str_clan_notice
    NetManager:sendMessage(ProtocolID.GReqClanCreate, req_create)
end

local ClanUncreateSearchLayer = class("ClanUncreateSearchLayer", require("src.comp.EventLayer"))
function ClanUncreateSearchLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.scroll_view:setItemSize(cc.size(540, 135))
    self.scroll_view:setItemType(1)

    self.edit_box= ccui.EditBox:create(cc.size(self.spr_input_bg:getContentSize().width - 10, self.spr_input_bg:getContentSize().height), "other/spr-null.png", 1)  --输入框尺寸，背景图片
    self.edit_box:setName("clan_name")
    self.edit_box:setPosition(cc.p(self.spr_input_bg:getPositionX() + 5, self.spr_input_bg:getPositionY()))
    self.edit_box:setAnchorPoint(cc.p(0.5,0.5))
    self.edit_box:setFontSize(26)
    self.edit_box:setFontColor(cc.c3b(122,71,45))
    self.edit_box:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND ) --输入键盘返回类型，done，send，go等
    self.edit_box:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE) --输入模型，如整数类型，URL，电话号码等，会检测是否符合
    self.edit_box:setPlaceholderFontSize(20)
    self.edit_box:setPlaceHolder(ex.Tools:getLang(41344))
    self.edit_box:registerScriptEditBoxHandler(handler(self, self.editboxHandle)) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    -- self.edit_box:setText(tostring(pre_input_id))
    self.edit_box:setText("")
    self:addChild(self.edit_box, 9999)
end

function ClanUncreateSearchLayer:getLayerClass()
    return ClanUncreateSearchLayer
end

function ClanUncreateSearchLayer:updateList(event)
    print("ClanUncreateSearchLayer:updateTableView")
    self.scroll_view:getContainer():removeAllChildren()

    self.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = ClanUncreateRecommendCell:createWithCCBIFile("ccbi/ClanUncreateRecommendCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data)
        cell:setIsTouchInsideNode(self.scroll_view)

        cell.btn_join:registerScriptTapHandler(handler(self, self.onClanJoin))
    
        return cell
    end

    self.scroll_view:reloadData(ex.Player.clan_data.clan_search_list)
end

function ClanUncreateSearchLayer:onClanJoin(tag, pSender)
    -- 创建公会距离上次退出公会有间隔
    local left_time = ex.Player.clan_data.last_join_time - ex.Game:getServerTime()
    if left_time > 0 then
        ex.MessageView:add(string.format(ex.Tools:getLang(70150), ex.StringUtil.convertToTimeFormat(left_time, 4)))
        return
    end

    local data = pSender.data
    if data.clan_member_num >= cfg.clanlevel.clanlevel[data.clan_level].member then
        ex.MessageView:add(ex.Tools:getLang(47539))
        return
    end

    -- 请求加入公会
    local req_join = Clan_pb.GReqClanJoin()
    req_join.clan_id = data.clan_id
    NetManager:sendMessage(ProtocolID.GReqClanJoin, req_join)
end

function ClanUncreateSearchLayer:editboxHandle(event, sender)
    local is_input = (event == "return") and (#sender:getText() > 0)
    if not is_input then
        return
    end

    local name = sender:getName()
    local str_name = sender:getText()
    str_name = cpp.StringUtil:cutNameWithLength(str_name, NAME_LENGTH, 2, 3.57)

    if name == "clan_name" then
        self.clan_search_name = str_name
        self.edit_box:setText(str_name)
    end
end
-- 查找公会
function ClanUncreateSearchLayer:onClanSearch()
    local str_clan_name = self.edit_box:getText()
    if str_clan_name == nil or str_clan_name == "" or #str_clan_name <= 0 then
        ex.MessageView:add(ex.Tools:getLang(47669))
        return
    elseif #str_clan_name > NAME_LENGTH then
        ex.MessageView:add(string.format(ex.Tools:getLang(47452), NAME_LENGTH))
        return
    end

    local flag = ex.StringUtil.checkName(str_clan_name)
    if flag == false then
        ex.MessageView:add(ex.Tools:getLang(47481))
        return
    end


    print("on clan search with clan name", str_clan_name)

    local req_search = Clan_pb.GReqClanSearch()
    req_search.search_type = 2
    req_search.clan_name = str_clan_name
    NetManager:sendMessage(ProtocolID.GReqClanSearch, req_search)
end

local ClanUncreateLayer = class("ClanUncreateLayer", require("src.comp.EventLayer"))
function ClanUncreateLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.btn_recommend:setLabelOffset(cc.p(0, -2))
    self.btn_create:setLabelOffset(cc.p(0, -2))
    self.btn_search:setLabelOffset(cc.p(0, -2))

    -- 创建默认选中层
    self.cur_layer = ClanUncreateRecommendLayer:createWithCCBIFile("ccbi/ClanUncreateRecommendLayer.ccbi")
    self.cur_layer:setPosition(0, 0)
    self:addChild(self.cur_layer)

    self.btn_recommend:setChecked(true)


    self.btn_recommend:setLabelText(ex.Tools:getLang(47775))
    self.btn_create:setLabelText(ex.Tools:getLang(47388))
    self.btn_search:setLabelText(ex.Tools:getLang(47183))


end

function ClanUncreateLayer:getLayerClass()
    return ClanUncreateLayer
end

-- 公会推荐
function ClanUncreateLayer:onClanRecommend()
    if self.cur_layer ~= nil and self.cur_layer:getLayerClass() == ClanUncreateRecommendLayer then
        return
    end

    if self.cur_layer ~= nil then
        self.cur_layer:removeFromParent()
        self.cur_layer = nil
    end

    self.cur_layer = ClanUncreateRecommendLayer:createWithCCBIFile("ccbi/ClanUncreateRecommendLayer.ccbi")
    self.cur_layer:setPosition(0, 0)
    self:addChild(self.cur_layer)
end
-- 公会创建
function ClanUncreateLayer:onClanCreate()
    if self.cur_layer ~= nil and self.cur_layer:getLayerClass() == ClanUncreateCreateLayer then
        return
    end

    if self.cur_layer ~= nil then
        self.cur_layer:removeFromParent()
        self.cur_layer = nil
    end

    self.cur_layer = ClanUncreateCreateLayer:createWithCCBIFile("ccbi/ClanUncreateCreateLayer.ccbi")
    self.cur_layer:setPosition(0, 0)
    self:addChild(self.cur_layer)
end
-- 公会查找
function ClanUncreateLayer:onClanSearch()
    if self.cur_layer ~= nil and self.cur_layer:getLayerClass() == ClanUncreateSearchLayer then
        return
    end

    if self.cur_layer ~= nil then
        self.cur_layer:removeFromParent()
        self.cur_layer = nil
    end

    self.cur_layer = ClanUncreateSearchLayer:createWithCCBIFile("ccbi/ClanUncreateSearchLayer.ccbi")
    self.cur_layer:setPosition(0, 0)
    self:addChild(self.cur_layer)
end
function ClanUncreateLayer:updateList(event)
    print("clan_uncreate_layer updateList event: ", event)
    if event == EVENT.CLAN_EVENT.CLAN_RECOMMEND and self.cur_layer ~= nil and self.cur_layer:getLayerClass() == ClanUncreateRecommendLayer then
        self.cur_layer:updateList(event)
    elseif event == EVENT.CLAN_EVENT.CLAN_SEARCH and self.cur_layer ~= nil and self.cur_layer:getLayerClass() == ClanUncreateSearchLayer then
        self.cur_layer:updateList(event)
    end
end

-- 公会信息
local ClanInfoLayer = class("ClanInfoLayer", require("src.comp.EventLayer"))
function ClanInfoLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.scroll_notice:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)

    self.lbl_notice = cc.Label:createWithTTF(" ", FONT_DEFAULT_NAME_BOLD, 42)
    self.lbl_notice:setDimensions(self.scroll_notice:getViewSize().width * 2, 0)
    self.lbl_notice:setColor(cc.c3b(122,71,45))
    self.lbl_notice:setScale(0.5)
    self.lbl_notice:setAnchorPoint(cc.p(0, 1))
    self.lbl_notice:setPosition(0, 0)
    self.scroll_notice:addChild(self.lbl_notice)

    self:addRedDotNode(RedDotType.ZCJ_DHGH_SQLB, self.btn_apply)
    self:addRedDotNode(RedDotType.ZCJ_DHGH_ZCBOSSAN_SJBOSS, self.btn_boss)
    self:addRedDotNode(RedDotType.ZCJ_DHGH_ZCGHZAN_GHZ, self.btn_gvg)
    self:addRedDotNode(RedDotType.ZCJ_DHGH_GHJX, self.btn_donate)
    self:addRedDotNode(RedDotType.ZCJ_DHGH_GHFB, self.btn_mission)
    self:addRedDotNode(RedDotType.ZCJ_DHGH_KJ, self.btn_skill)
    
    self:updateLayer()
end

function ClanInfoLayer:updateLayer()
    local config = cfg.clanlevel.clanlevel[ex.Player.clan_data.clan_level]

    -- 公会头像
    self.btn_clan_photo:setNormalImage(cc.Sprite:createWithSpriteFrameName(string.format("clan-photo/%02d.png", ex.Player.clan_data.clan_photo)))
    self.btn_clan_photo:setSelectedImage(cc.Sprite:createWithSpriteFrameName(string.format("clan-photo/%02d.png", ex.Player.clan_data.clan_photo)))
    -- 公会名
    self.lbl_clan_name:setString(ex.Player.clan_data.clan_name)
    -- 公会等级
    self.lbl_clan_level:setString(string.format(ex.Tools:getLang(47719),ex.Player.clan_data.clan_level))
    self.lbl_clan_exp:setString(ex.Player.clan_data.clan_exp.."/"..config.need_clan_exp)
    -- 公会简介
    self:setClanNotice(ex.Player.clan_data.clan_notice)
    -- 公会成员数
    self.lbl_clan_member:setString(#ex.Player.clan_data.clan_member_list.."/"..config.member)
    -- 公会会长
    local head_data = ex.Player.clan_data:getClanHead()
    if head_data ~= nil then
        print(ex.Tools:getLang(47601), head_data.nick)
        self.lbl_clan_leader:setString(string.format(ex.Tools:getLang(47489), head_data.nick))
    else 
        print(ex.Tools:getLang(47598))
        self.lbl_clan_leader:setString(" ")
    end
end

function ClanInfoLayer:setClanNotice(str_notice)
    self.lbl_notice:setString(str_notice)
    if self.lbl_notice:getContentSize().height * self.lbl_notice:getScaleY() <= self.scroll_notice:getViewSize().height then
        self.lbl_notice:setPositionY(self.scroll_notice:getViewSize().height)
        self.scroll_notice:setContentSize(self.scroll_notice:getViewSize())
        self.scroll_notice:setContentOffset(cc.p(0, 0))
    else
        self.lbl_notice:setPositionY(self.lbl_notice:getContentSize().height * self.lbl_notice:getScaleY())
        self.scroll_notice:setContentSize(cc.size(self.scroll_notice:getViewSize().width, self.lbl_notice:getContentSize().height * self.lbl_notice:getScaleY()))
        self.scroll_notice:setContentOffset(cc.p(0, self.scroll_notice:getViewSize().height - self.scroll_notice:getContentSize().height))
    end
end

function ClanInfoLayer:onExit()
    -- ex.RedDotManager:removeStickNode(RedDotType.ZCJ_DHGH_SQLB, self.btn_apply)
end

function ClanInfoLayer:getLayerClass()
    return ClanInfoLayer
end

-- 公告编辑
function ClanInfoLayer:onEditNotice()
    local data_self = ex.Player.clan_data:getMemberByRoleId(ex.Player.role_id)
    if data_self == nil or data_self.position == ClanPositionType.NORMAL then
        ex.MessageView:add(ex.Tools:getLang(47642))
        return
    end

    require("src.layer.clan.ClanEditCtr"):instance():openWindow()
end
-- 公告编辑
function ClanInfoLayer:onEditPhoto()
    local data_self = ex.Player.clan_data:getMemberByRoleId(ex.Player.role_id)
    if data_self == nil or data_self.position == ClanPositionType.NORMAL then
        ex.MessageView:add(ex.Tools:getLang(47642))
        return
    end

    require("src.layer.clan.ClanPhotoCtr"):instance():openWindow()
end
-- 公会排行
function ClanInfoLayer:onRank()
    require("src.layer.RankTopThreeCtr"):instance():openWindow(3)
end
-- 查看历史
function ClanInfoLayer:onHistory()
    require("src.layer.clan.ClanHistoryCtr"):instance():openWindow()
end
-- 查看成员
function ClanInfoLayer:onMember()
    require("src.layer.clan.ClanMemberCtr"):instance():openWindow()
end
-- 查看申请
function ClanInfoLayer:onApply()
    require("src.layer.clan.ClanRankCtr"):instance():openWindow(ClanRankLayerType.APPLY)
end
-- 公会商城
function ClanInfoLayer:onShop()
    cfg.funcopen.main_shop.open(SHOP_TYPE.CLAN)
end
-- 公会科技
function ClanInfoLayer:onSkill()
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_INFO_CHANGE_LAYER, ClanLayerType.SKILL)
end
-- 公会副本
function ClanInfoLayer:onMission()

    if ex.MainSceneCtr:instance():getKeepBuffer(MainSceneType.MAINCITY_CLAN_MISSION_BATTLE) ~= nil then
        -- ctr.clan_battle.battle_layer:setVisible(true)
        ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_CLAN_MISSION_BATTLE, nil, nil, true)
    else
        ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_INFO_CHANGE_LAYER, ClanLayerType.MISSION)
    end
end
-- 公会战
function ClanInfoLayer:onGvg()
    ex.MainSceneCtr:changeLayer(MainSceneType.CLAN_GVG)
end
-- 公会Boss战
function ClanInfoLayer:onBoss()
    ex.MainSceneCtr:changeLayer(MainSceneType.CLAN_BOSS)
end
-- 公会捐献
function ClanInfoLayer:onDonate()
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_INFO_CHANGE_LAYER, ClanLayerType.DONATE)
end
-- 未开放
function ClanInfoLayer:onDefault()
    ex.MessageView:add(ex.Tools:getLang(47001))
end

-- 公会类型枚举
ClanLayerType = {}
ClanLayerType.INVALID = 0       -- 无效
ClanLayerType.UNCREATE = 10     -- 未创建界面
-- ClanLayerType.UNCREATE_RECOMMEND = 11   -- 公会推荐
-- ClanLayerType.UNCREATE_CREATE = 12      -- 公会创建
-- ClanLayerType.UNCREATE_SEARCH = 13      -- 公会查找
ClanLayerType.INFO = 20         -- 公会信息
ClanLayerType.MISSION = 30      -- 公会副本
ClanLayerType.SKILL = 40        -- 公会技能
ClanLayerType.DONATE = 50       -- 公会捐献



function ClanLayer:getAsynImage()
    local vec_image = {
    }
    return vec_image
end

function ClanLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

	local main_ctr = ex.MainSceneCtr

    local notch_height = require("src.model.Game"):instance():getNotchHeight()
	local height_diff = main_ctr:getBottomHeight() - main_ctr:getMenuScaleHeight();
    local top_height = ex.p.height - (height_diff + 70) - 22 - notch_height - 70;
    local scaleX = ex.p.width / 640
    local scaleY = (top_height - main_ctr:getBottomHeight() ) / 860


    self:setScale(math.min(scaleX, scaleY))
    

    self.cur_layer = nil

    self:reorderChild(self.node_title, 10)

    self:initDone()

	-- 请求上次公会退出时间，用来限制公会创建间隔
    NetManager:sendMessage(ProtocolID.GReqQuitClanTime)
end

function ClanLayer:initDone()
    print("ClanLayer:initDone")

    local spr_bg = cc.Sprite:create("ccbi-res/map-bg-clan-1.jpg")
    spr_bg:setScale(ex.p.width / spr_bg:getContentSize().width + 0.1, ex.p.height / spr_bg:getContentSize().height + 0.1)
    spr_bg:setPosition(ex.p.center().x - self:getPositionX(), ex.p.center().y - self:getPositionY())
    self:addChild(spr_bg, -1)

    self:registerEvent()

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan.plist")
    sfc:addSpriteFrames("ccbi-res/clan-photo.plist")
    sfc:addSpriteFrames("ccbi-res/box-effect.plist")

    local layer_tab = ClanLayerType.INVALID
    if ex.Player.clan_data.clan_id ~= 0 then
        layer_tab = ClanLayerType.INFO
    else
        layer_tab = ClanLayerType.UNCREATE
    end

    self.cur_layer_tab = ClanLayerType.INVALID
    self:changeLayer(layer_tab)

    -- ex.Player.vip_level = 10
end

function ClanLayer:registerEvent()
   self:addEvent(EVENT.CLAN_EVENT.CLAN_RECOMMEND, handler(self, self.receiveRes))
   self:addEvent(EVENT.CLAN_EVENT.CLAN_SEARCH, handler(self, self.receiveRes))
   self:addEvent(EVENT.CLAN_EVENT.CLAN_INFO, handler(self, self.receiveRes))

   self:addEvent(EVENT.CLAN_EVENT.CLAN_CREATE_UPDATE_PHOTO, handler(self, self.receiveRes))

   self:addEvent(EVENT.CLAN_EVENT.CLAN_INFO_CHANGE_LAYER, handler(self, self.changeLayerEvent))
end

function ClanLayer:changeLayer(tab)
    if tab == ClanLayerType.MISSION then
        require("src.layer.clan.ClanMissionCtr"):instance():openWindow()
        return
    elseif tab == ClanLayerType.SKILL then
        require("src.layer.clan.ClanSkillCtr"):instance():openWindow()
        return
    elseif tab == ClanLayerType.DONATE then
        require("src.layer.clan.ClanDonateCtr"):instance():openWindow()
        return
    end

    if self.cur_layer_tab == tab then
        return
    end

    local flag = ex.Player.clan_data.clan_id ~= 0
    if tab ~= ClanLayerType.UNCREATE and flag == false then
        tab = ClanLayerType.UNCREATE
    end

    self.cur_layer_tab = tab

    if self.cur_layer ~= nil then
        self.cur_layer:removeFromParent()
        self.cur_layer = nil
    end

    if self.cur_layer_tab == ClanLayerType.UNCREATE then
        self.lbl_title:setString(ex.Tools:getLang(47487))
        self.cur_layer = ClanUncreateLayer:createWithCCBIFile("ccbi/ClanUncreateLayer.ccbi")
    elseif self.cur_layer_tab == ClanLayerType.INFO then
        self.lbl_title:setString(ex.Tools:getLang(47487))
        self.cur_layer = ClanInfoLayer:createWithCCBIFile("ccbi/ClanInfoLayer.ccbi")
    end

    self.cur_layer:setPosition(0, 0)

    self:addChild(self.cur_layer)
end

function ClanLayer:receiveRes(event, list)
    print("clan_layer receiveRes event: ", event)
    if event == EVENT.CLAN_EVENT.CLAN_RECOMMEND and self.cur_layer ~= nil and self.cur_layer:getLayerClass() == ClanUncreateLayer then
        self.cur_layer:updateList(event)
    elseif event == EVENT.CLAN_EVENT.CLAN_SEARCH and self.cur_layer ~= nil and self.cur_layer:getLayerClass() == ClanUncreateLayer then
        self.cur_layer:updateList(event)
    elseif event == EVENT.CLAN_EVENT.CLAN_INFO and self.cur_layer ~= nil then
        if ex.Player.clan_data.clan_id ~= 0 and self.cur_layer_tab == ClanLayerType.UNCREATE then
            self:changeLayer(ClanLayerType.INFO)
        elseif ex.Player.clan_data.clan_id <= 0 and self.cur_layer_tab ~= ClanLayerType.UNCREATE then
            self:changeLayer(ClanLayerType.UNCREATE)
        elseif ex.Player.clan_data.clan_id ~= 0 and self.cur_layer ~= nil and self.cur_layer:getLayerClass() == ClanInfoLayer then
            self.cur_layer:updateLayer()
        end
    elseif event == EVENT.CLAN_EVENT.CLAN_CREATE_UPDATE_PHOTO and self.cur_layer ~= nil and self.cur_layer:getLayerClass() == ClanUncreateLayer then
        if self.cur_layer.cur_layer:getLayerClass() == ClanUncreateCreateLayer then
            self.cur_layer.cur_layer:updatePhoto()
        end
    end
end

function ClanLayer:changeLayerEvent(event, layer_type)
    self:changeLayer(layer_type)
end

function ClanLayer:onClose()
    if self.cur_layer_tab == ClanLayerType.INFO or self.cur_layer_tab == ClanLayerType.UNCREATE then
        ex.MainSceneCtr:instance():changeLayer(MainSceneType.MAINCITY_LAYER)
        return
    end

    local layer_tab = ClanLayerType.INVALID
    if ex.Player.clan_data.clan_id ~= 0 then
        layer_tab = ClanLayerType.INFO
    else
        layer_tab = ClanLayerType.UNCREATE
    end

    self.cur_layer_tab = ClanLayerType.INVALID
    self:changeLayer(layer_tab)
end

-- 层切入时会被调用
function ClanLayer:changeLayerIn()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, true)
end

function ClanLayer:changeLayerOutEnd()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, false)
end

return ClanLayer
