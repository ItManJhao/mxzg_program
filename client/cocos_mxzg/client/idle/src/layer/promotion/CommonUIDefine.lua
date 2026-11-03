--[[
    func: 通用UI枚举定义
    author:徐东浩
    time:2019-10-26 22:02:28
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

module("CommonUIDefine")

UIDefine = {}

UIDefine.HeroAttrImage = {
    [122101] = "hero-info/spr-attr-1.png",
    [122102] = "hero-info/spr-attr-3.png",
    [122201] = "hero-info/spr-attr-4.png",
    [122202] = "hero-info/spr-attr-2.png",
}

-- 组件类型
UIDefine.ComponentType = {
    BTN = 1,       -- 按钮
    SPRITE = 2,    -- 精灵
    ANIMATION = 3, -- 动画
}

-- 组件坐标原点类型
UIDefine.ComponentOriginType = {
    LEFT_BOTTOM = 1,         -- 左下角
    LEFT_TOP = 2,            -- 左上角
    RIGHT_TOP = 3,           -- 右上角
    RIGHT_BOTTOM = 4,        -- 右下角
    RATIO = 5,               -- 百分比
}

-- 组件事件类型
UIDefine.ComponentEventType = {
    JUMP_TO_WINDOW = 1,       -- 打开某个界面
    OPEN_SHOP_WINDOW = 2,     -- 打开某个商城
    RMB_RECHARGE = 3,         -- RMB充值
    SWITCH_TAB = 4,           -- 切换选项卡
}

-- 组件属性对应名字
UIDefine.ComponentAttributeName = {
    ID = "id",                            -- 组件id
    COMPONENT_TYPE = "type",              -- 组件类型
    IMAGE_NAME = "res",                   -- 组件图片
    ATLAS_PLIST = "plist",                -- 组件图片所属图集
    POSITION_X = "posx",                  -- 组件x坐标
    POSITION_Y = "posy",                  -- 组件y坐标
    ORIGIN_TYPE = "origin_type",          -- 组件坐标原点类型
    ANCHOR_X = "anchor_x",                -- 组件锚点X值
    ANCHOR_Y = "anchor_y",                -- 组件锚点Y值
    SCALE = "scale",                      -- 组件缩放
    
    EVENT_TYPE = "event_type",            -- 组件事件类型
    EVENT_ARG = "event_arg",              -- 组件时间参数
    
    LABEL_TEXT = "labeltext",             -- 组件显示文字
    LABEL_COLOR_R = "labelcolorr",        -- 组件显示文字Red值
    LABEL_COLOR_G = "labelcolorg",        -- 组件显示文字Green值
    LABEL_COLOR_B = "labelcolorb",        -- 组件显示文字Blue值

    STATUS_HANDLE = "status_handle",      -- 组件状态处理

    CHILDREN = "children",                -- 子节点
}

-- UI子层布局类型
UIDefine.UISubLayoutType = {
    VERTICAL_BANNER_TABLE_VIEW = 1,          -- 垂直布局包含banner以及滚动列表
    OVERRALL_POSTER_TYPE = 2,                -- 整版海报类型页面
    EXTERNAL = 3,                            -- 不用本地组装地外部界面
}

-- 组件状态处理类型
UIDefine.ComponentStatusHandleType = {
    HAPPYMONTH_PRIVILEGE = 1,           -- 狂欢特权是否开启
    LIMIT_SHOP_ACTIVITY = 2,            -- 秘境商城是否开启
}

-- 按钮状态
ItemBtnStatus = {
    NONE = 1,   -- 不做任何处理
    HINT = 2,   -- 提示
    JUMP = 3,   -- 转跳
    GET = 4,    -- 领取
    GOT = 5,    -- 领取完成
}