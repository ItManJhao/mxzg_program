NodeUtils = {}

--[[
    将指定的node根据父对象的尺寸水平、垂直同时居中，并且可以提供一个居中后的偏移位置(x, y)

    注意 : node必须已经添加到某个父Node中

    node           : 需要调整位置的Node对象
    offsetPosition : 偏移位置，一个(x,y)对象，可以让node居中之后偏移。默认是(0,0)
]]
NodeUtils.center = function(node, offsetPosition)
    if offsetPosition == nil then
        offsetPosition = cc.p(0, 0)
    end

    local parentNode = node:getParent()
    local parentSize = parentNode:getContentSize()
    node:setPosition(
        parentSize.width  / 2 + offsetPosition.x,
        parentSize.height / 2 + offsetPosition.y
    )
end

--[[
    将指定的node根据父对象的尺寸水平居中，并且可以提供一个居中后的偏移位置值

    注意 : node必须已经添加到某个父Node中

    node   : 需要调整位置的Node对象
    offset : 水平偏移值。number
]]
NodeUtils.centerHorizontal = function(node, offset)
    if offset == nil then
        offset = 0
    end

    local parentNode = node:getParent()
    node:setPositionX(
        parentNode:getContentSize().width / 2 + offset
    )
end

--[[
    将指定的node根据父对象的尺寸垂直居中，并且可以提供一个居中后的偏移位置值

    注意 : node必须已经添加到某个父Node中

    node   : 需要调整位置的Node对象
    offset : 垂直偏移值。number
]]
NodeUtils.centerVertical = function(node, offset)
    if offset == nil then
        offset = 0
    end
    
    local parentNode = node:getParent()
    node:setPositionY(
        parentNode:getContentSize().height / 2 + offset
    )
end

--[[
    把node的y方向的位置调整到父对象的顶部，并且可以提供一个置顶后的偏移位置值

    注意 : node必须已经添加到某个父Node中

    node   : 需要调整位置的Node对象
    offset : y方向的偏移值
]]
NodeUtils.adjustTop = function(node, offset)
    if offset == nil then
        offset = 0
    end
    node:setPositionY(node:getParent():getContentSize().height + offset)
end

--[[
    把node的x方向的位置调整到父对象的右边，并且可以提供一个置底后的偏移位置值

    注意 : node必须已经添加到某个父Node中

    node   : 需要调整位置的Node对象
    offset : y方向的偏移值
]]
NodeUtils.adjustBottom = function(node, offset)
    if offset == nil then
        offset = 0
    end
    node:setPositionY(offset)
end

--[[
    把node的x方向的位置调整到父对象的左边，并且可以提供一个靠左后的偏移位置值

    注意 : node必须已经添加到某个父Node中

    node   : 需要调整位置的Node对象
    offset : x方向的偏移值
]]
NodeUtils.adjustLeft = function(node, offset)
    if offset == nil then
        offset = 0
    end
    node:setPositionX(offset)
end

--[[
    把node的x方向的位置调整到父对象的右边，并且可以提供一个靠右后的偏移位置值

    注意 : node必须已经添加到某个父Node中

    node   : 需要调整位置的Node对象
    offset : x方向的偏移值
]]
NodeUtils.adjustRight = function(node, offset)
    if offset == nil then
        offset = 0
    end
    node:setPositionX(node:getParent():getContentSize().width + offset)
end
