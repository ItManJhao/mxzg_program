local BattleBuffBarNode = class('BattleBuffBarNode', cc.Node)

local NODE_ANCHOR = cc.p(0.5, 0)
local NODE_SIZE = cc.size(140, 120)
local NODE_HALF_WIDTH = 0.5 * NODE_SIZE.width
local SKILL_ICON_PATH_TPL = 'skill-icon/%d.png'
local ICON_WIDTH  = 60
local ICON_HEIGHT = 60
local ICON_Y_OFFSET = 5
local ICON_SIZE = cc.size(ICON_WIDTH, ICON_HEIGHT)
local ICON_SCALE = 0.4
local ICON_FONT_SIZE = 35
if cpp.SocialPlatform:instance():isDebug() then ICON_SCALE = 0.7 end
local ICON_START_X_OFFSET = 5
local ICON_X_GAP = ICON_SCALE*ICON_WIDTH + 5
local ICON_Y_GAP = ICON_SCALE*ICON_HEIGHT + 5

function BattleBuffBarNode:ctor()
    self:setAnchorPoint(NODE_ANCHOR)
    self:setContentSize(NODE_SIZE)

    self._iconsNode = cc.Node:create()
    self._iconsNode:setAnchorPoint(NODE_ANCHOR)
    self._iconsNode:setContentSize(NODE_SIZE)
    self._iconsNode:setPositionX(NODE_HALF_WIDTH)
    self._iconsNode:setPositionY(ICON_Y_OFFSET)
    self:addChild(self._iconsNode)

    --[[
        {
            <buff id> :
            {
                sprite : icon node对象
                label  : icon计数的显示对象
                count  : icon计数
            },
            ......
        }
    ]]
    self._iconInfos = {}
end

function BattleBuffBarNode:addBuff(buffId, skillId)
    local iconInfo = self._iconInfos[buffId]

    if iconInfo == nil then
        iconInfo = self:_createIconInfo(skillId)
        if iconInfo == nil then return nil end

        self._iconInfos[buffId] = iconInfo
        self._iconsNode:addChild(iconInfo.sprite)

        self:_updatePosition()
    else
        iconInfo.count = iconInfo.count + 1
        iconInfo.label:setString(tostring(iconInfo.count))
    end
end

function BattleBuffBarNode:removeBuff(buffId)
    local iconInfo = self._iconInfos[buffId]
    if iconInfo == nil then return end

    iconInfo.count = iconInfo.count - 1
    if iconInfo.count <= 0 then
        self._iconInfos[buffId] = nil
        self._iconsNode:removeChild(iconInfo.sprite)
        self:_updatePosition()
    else
        iconInfo.label:setString(tostring(iconInfo.count))
    end
end

function BattleBuffBarNode:clearBuffs()
    self._iconsNode:removeAllChildren()
    self._iconInfos = {}
end

function BattleBuffBarNode:_updatePosition()
    local i = 0
    for k,v in pairs(self._iconInfos) do
        local x = ICON_START_X_OFFSET + i * ICON_X_GAP
        local y = 0
        v.sprite:setPosition(cc.p(x, y))
        i = i + 1
    end
end

function BattleBuffBarNode:_createIconInfo(skillId)
    local iconInfo = {}
    local count = 1

    local path = string.format(SKILL_ICON_PATH_TPL, skillId)
    local iconSprite = cc.Sprite:createWithSpriteFrameName(path)

    if iconSprite == nil then return nil end

    iconSprite:setScale(ICON_SCALE)
    iconSprite:setContentSize(ICON_SIZE)

    local label = cc.Label:createWithTTF(tostring(count), FONT_DEFAULT_NAME_BOLD, ICON_FONT_SIZE)
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:setPosition(cc.p(
        ICON_SIZE.width/2,
        ICON_SIZE.height
    ))
    label:enableOutline(FONT_BLACK_C4B, 3)
    iconSprite:addChild(label)

    iconInfo.sprite = iconSprite
    iconInfo.label = label
    iconInfo.count = count
    
    return iconInfo
end

return BattleBuffBarNode
