local UILayoutEx = class("UILayoutEx")

function UILayoutEx:ctor()
    self.node = nil
    self.type = 0
    self.layoutDirty = true

    self.verticalDirection = UILayout.Direction.TTOB
    self.horizontalDirection = UILayout.Direction.LTOR

    self.startAxis = 0 -- grid 模式

    self.paddingLeft = 0
    self.paddingRight = 0
    self.paddingBottom = 0
    self.paddingTop = 0

    self.spacingX = 0
    self.spacingY = 0
    self.resizeMode = 0

    self.affectedByScale = false

    self.cellSize = cc.size(0, 0)

    -- self:registerScriptHandler(handler(self, self.eventHandler))
end

-- function UILayoutEx:eventHandler(eventType)
--     if eventType == "enter" then
--         self:onEnter()
--     elseif eventType == "exit" then
--         self:onExit()
--     end
-- end

-- function UILayoutEx:onEnter( )
--     self.doLayoutDirty()
-- end

-- function UILayoutEx:onExit( )
    
-- end

function UILayoutEx:doLayoutDirty( )
    self.layoutDirty = true
end


function UILayoutEx:setType(type) self.type = type end
function UILayoutEx:setResizeMode(model) self.resizeMode = model end
function UILayoutEx:setAffectedByScale(a) self.affectedByScale = a end
function UILayoutEx:setVerticalDirection(direction) self.verticalDirection = direction end
function UILayoutEx:setHorizontalDirection(direction) self.horizontalDirection = direction end
function UILayoutEx:setPaddingLeft(margin) self.paddingLeft = margin end
function UILayoutEx:setPaddingRight(margin) self.paddingRight = margin end
function UILayoutEx:setPaddingTop(margin) self.paddingTop = margin end
function UILayoutEx:setPaddingBottom(margin) self.paddingBottom = margin end
function UILayoutEx:setSpaceX(space) self.spacingX = space end
function UILayoutEx:setSpaceY(space) self.spacingY = space end

-- 这个方法废弃
function UILayoutEx:setLayoutType(type, resizeMode, direction, margin1, margin2, space, affectedByScale)
    self.type = type or UILayout.Type.NONE;
    -- self.direction = direction or UILayout.Direction.LTOR;
    -- if direction ==  then
        
    -- end
    if self.type == UILayout.Type.HORIZONTAL then
        self.horizontalDirection = direction
    elseif self.type == UILayout.Type.VERTICAL then
        self.verticalDirection = direction
    end


    self.affectedByScale = affectedByScale or false;
    self.resizeMode = resizeMode or UILayout.ResizeMode.NONE;

    if type == UILayout.Type.HORIZONTAL then
        self.paddingLeft = margin1 or 0
        self.paddingRight = margin2 or 0
        self.spacingX = space or 0
    else
        self.paddingTop = margin1 or 0
        self.paddingBottom = margin2 or 0
        self.spacingY = space or 0
    end
end

function UILayoutEx:doLayoutHorizontally(baseWidth, rowBreak, fnPositionY, applyChildren)
    local layoutAnchor = self.node:getAnchorPoint();
    local children = self.node:getChildren();

    local sign = 1;
    local paddingX = self.paddingLeft;
    local leftBoundaryOfLayout = 0 -- -layoutAnchor.x * baseWidth;
    if self.horizontalDirection == UILayout.Direction.RTOL then
        sign = -1;
        leftBoundaryOfLayout = baseWidth -- (1 - layoutAnchor.x) * baseWidth;
        paddingX = self.paddingRight;
    end

    local nextX = leftBoundaryOfLayout + sign * paddingX - sign * self.spacingX;
    local rowMaxHeight = 0;
    local tempMaxHeight = 0;
    local secondMaxHeight = 0;
    local row = 0;
    local containerResizeBoundary = 0;

    local maxHeightChildAnchorY = 0;

    local activeChildCount = 0;

    for i,child in ipairs(children) do
        if child:isVisible() then
            activeChildCount = activeChildCount + 1;
        end
    end


    local newChildWidth = self.cellSize.width;
    if self.resizeMode == UILayout.ResizeMode.CHILDREN then
        newChildWidth = (baseWidth - (self.paddingLeft + self.paddingRight) - (activeChildCount - 1) * self.spacingX) / activeChildCount;
    end

    for i,child in ipairs(children) do
        local childScaleX = self:getUsedScaleValue(child:getScaleX());
        local childScaleY = self:getUsedScaleValue(child:getScaleY());
        
        if child:isVisible() then
            if self.resizeMode == UILayout.ResizeMode.CHILDREN then
                local width = newChildWidth / childScaleX;
                local height = child:getContentSize().height;
                if self.type == UILayout.Type.GRID then
                    height = self.cellSize.height / childScaleY;
                end
                child:setContentSize(cc.size(width, height));
            end
    
            local anchorX = child:getAnchorPoint().x;
            local childBoundingBoxWidth = child:getContentSize().width * childScaleX;
            local childBoundingBoxHeight = child:getContentSize().height * childScaleY;

            
            if secondMaxHeight > tempMaxHeight then
                tempMaxHeight = secondMaxHeight;
            end
    
            if childBoundingBoxHeight >= tempMaxHeight then
                secondMaxHeight = tempMaxHeight;
                tempMaxHeight = childBoundingBoxHeight;
                maxHeightChildAnchorY = child:getAnchorPoint().y;
            end
    
            if self.horizontalDirection == UILayout.Direction.RTOL then
                anchorX = 1 - child:getAnchorPoint().x;
            end

            nextX = nextX + sign * anchorX * childBoundingBoxWidth + sign * self.spacingX;
            local rightBoundaryOfChild = sign * (1 - anchorX) * childBoundingBoxWidth;
    
            if rowBreak then
                local rowBreakBoundary = nextX + rightBoundaryOfChild + sign * (sign > 0 and self.paddingRight or self.paddingLeft);
                -- local leftToRightRowBreak = self.horizontalDirection == UILayout.Direction.LTOR and rowBreakBoundary > (1 - layoutAnchor.x) * baseWidth;
                -- local rightToLeftRowBreak = self.horizontalDirection == UILayout.Direction.RTOL and rowBreakBoundary < -layoutAnchor.x * baseWidth;
                local leftToRightRowBreak = self.horizontalDirection == UILayout.Direction.LTOR and rowBreakBoundary > baseWidth;
                local rightToLeftRowBreak = self.horizontalDirection == UILayout.Direction.RTOL and rowBreakBoundary > baseWidth;
    
                if leftToRightRowBreak or rightToLeftRowBreak then
    
                    if childBoundingBoxHeight >= tempMaxHeight then
                        if secondMaxHeight == 0 then
                            secondMaxHeight = tempMaxHeight;
                        end
                        rowMaxHeight = rowMaxHeight + secondMaxHeight;
                        secondMaxHeight = tempMaxHeight;
                    else 
                        rowMaxHeight = rowMaxHeight + tempMaxHeight;
                        secondMaxHeight = childBoundingBoxHeight;
                        tempMaxHeight = 0;
                    end
                    nextX = leftBoundaryOfLayout + sign * (paddingX + anchorX * childBoundingBoxWidth);
                    row = row + 1;
                end
            end
    
            local finalPositionY = fnPositionY(child, rowMaxHeight, row);
            if baseWidth >= (childBoundingBoxWidth + self.paddingLeft + self.paddingRight) then
                if applyChildren  then
                    child:setPosition(cc.p(nextX, finalPositionY));
                end
            end
    
            local signX = 1;
            local tempFinalPositionY;
            local topMarign = (tempMaxHeight == 0) and childBoundingBoxHeight or tempMaxHeight;
    
            if self.verticalDirection == UILayout.Direction.TTOB then
                containerResizeBoundary = containerResizeBoundary or self.node:getContentSize().height;
                signX = -1;
                tempFinalPositionY = finalPositionY + signX * (topMarign * maxHeightChildAnchorY + self.paddingBottom);
                if tempFinalPositionY < containerResizeBoundary then
                    containerResizeBoundary = tempFinalPositionY;
                end
            else
                containerResizeBoundary = containerResizeBoundary or -self.node:getContentSize().height;
                tempFinalPositionY = finalPositionY + signX * (topMarign * maxHeightChildAnchorY + self.paddingTop);
                if tempFinalPositionY > containerResizeBoundary then
                    containerResizeBoundary = tempFinalPositionY;
                end
            end
    
            nextX = nextX + rightBoundaryOfChild;
        end
    end

    return containerResizeBoundary;
end

function UILayoutEx:getUsedScaleValue(value) 
    return self.affectedByScale and math.abs(value) or 1;
end

function UILayoutEx:refreshLayout()
    self.layoutDirty = true
    self:updateLayout()
end

function UILayoutEx:updateLayout()
    if self.layoutDirty then
        self:doLayout()
        self.layoutDirty = false
    end
end

function UILayoutEx:getHorizontalBaseWidth(children)
    local newWidth = 0;
    local activeChildCount = 0;
    if (self.resizeMode == UILayout.ResizeMode.CONTAINER) then
        for i,child in ipairs(children) do
            if child:isVisible()  then
                activeChildCount = activeChildCount + 1;
                newWidth = newWidth + child:getContentSize().width * self:getUsedScaleValue(child:getScaleX());
            end
        end
        newWidth = newWidth + (activeChildCount - 1) * self.spacingX + self.paddingLeft + self.paddingRight;
    else 
        newWidth = self.node:getContentSize().width;
    end
    return newWidth;
end
    

function UILayoutEx:doLayoutVertically(baseHeight, columnBreak, fnPositionX, applyChildren)
    
    local layoutAnchor = self.node:getAnchorPoint();
    local children = self.node:getChildren();

    local sign = 1;
    local paddingY = self.paddingBottom;

    local bottomBoundaryOfLayout = 0  
    if self.verticalDirection == UILayout.Direction.TTOB then
        sign = -1;
        bottomBoundaryOfLayout = baseHeight;
        paddingY = self.paddingTop;
    end

    local nextY = bottomBoundaryOfLayout + sign * paddingY - sign * self.spacingY;
    local columnMaxWidth = 0;
    local tempMaxWidth = 0;
    local secondMaxWidth = 0;
    local column = 0;
    local containerResizeBoundary = 0;
    local maxWidthChildAnchorX = 0;

    local activeChildCount = 0;
    for i,child in ipairs(children) do
        if child:isVisible()  then
            activeChildCount = activeChildCount + 1;
        end
    end

    local newChildHeight = self.cellSize.height;
    if (self.type ~= UILayout.Type.GRID and self.resizeMode == UILayout.ResizeMode.CHILDREN) then
        newChildHeight = (baseHeight - (self.paddingTop + self.paddingBottom) - (activeChildCount - 1) * self.spacingY) / activeChildCount;
    end

    for i,child in ipairs(children) do
        
        local childScaleX = self:getUsedScaleValue(child:getScaleX());
        local childScaleY = self:getUsedScaleValue(child:getScaleY());
        if child:isVisible() then

            if (self.resizeMode == UILayout.ResizeMode.CHILDREN) then
                local width = child:getContentSize().width
                local height = newChildHeight / childScaleY;
                if self.type == UILayout.Type.GRID then
                    width = self.cellSize.width / childScaleX;
                end
                child:setContentSize(width, height);
            end
    
            local anchorY = child:getAnchorPoint().y;
            local childBoundingBoxWidth = child:getContentSize().width * childScaleX;
            local childBoundingBoxHeight = child:getContentSize().height * childScaleY;
    
            if (secondMaxWidth > tempMaxWidth) then
                tempMaxWidth = secondMaxWidth;
            end
    
            if (childBoundingBoxWidth >= tempMaxWidth) then
                secondMaxWidth = tempMaxWidth;
                tempMaxWidth = childBoundingBoxWidth;
                maxWidthChildAnchorX = child:getAnchorPoint().x;
            end
    
            if (self.verticalDirection == UILayout.Direction.TTOB) then
                anchorY = 1 - child:getAnchorPoint().y;
            end

            nextY = nextY + sign * anchorY * childBoundingBoxHeight + sign * self.spacingY;
            local topBoundaryOfChild = sign * (1 - anchorY) * childBoundingBoxHeight;
    
            if (columnBreak) then
                local columnBreakBoundary = nextY + topBoundaryOfChild + sign * (sign > 0 and self.paddingTop or self.paddingBottom);
                local bottomToTopColumnBreak = self.verticalDirection == UILayout.Direction.BTOT and columnBreakBoundary > (1 - layoutAnchor.y) * baseHeight;
                local topToBottomColumnBreak = self.verticalDirection == UILayout.Direction.TTOB and columnBreakBoundary < -layoutAnchor.y * baseHeight;
                -- local bottomToTopColumnBreak = self.verticalDirection == UILayout.Direction.BTOT and columnBreakBoundary > baseHeight;
                -- local topToBottomColumnBreak = self.verticalDirection == UILayout.Direction.TTOB and columnBreakBoundary < baseHeight;
    
                if (bottomToTopColumnBreak or topToBottomColumnBreak) then
                    if (childBoundingBoxWidth >= tempMaxWidth) then
                        if (secondMaxWidth == 0) then
                            secondMaxWidth = tempMaxWidth;
                        end
                        columnMaxWidth = columnMaxWidth + secondMaxWidth;
                        secondMaxWidth = tempMaxWidth;
                    else 
                        columnMaxWidth = columnMaxWidth + tempMaxWidth;
                        secondMaxWidth = childBoundingBoxWidth;
                        tempMaxWidth = 0;
                    end
                    nextY = bottomBoundaryOfLayout + sign * (paddingY + anchorY * childBoundingBoxHeight);
                    column = column + 1;
                end
            end
    
            local finalPositionX = fnPositionX(child, columnMaxWidth, column);
            if (baseHeight >= (childBoundingBoxHeight + (self.paddingTop + self.paddingBottom))) then
                if (applyChildren) then
                    child:setPosition(cc.p(finalPositionX, nextY));
                end
            end
    
            local signX = 1;
            local tempFinalPositionX;
    
            local rightMarign = (tempMaxWidth == 0) and childBoundingBoxWidth or tempMaxWidth;
    
            if (self.horizontalDirection == UILayout.Direction.RTOL) then
                signX = -1;
                containerResizeBoundary = containerResizeBoundary or self.node:getContentSize().width;
                tempFinalPositionX = finalPositionX + signX * (rightMarign * maxWidthChildAnchorX + self.paddingLeft);
                if (tempFinalPositionX < containerResizeBoundary) then
                    containerResizeBoundary = tempFinalPositionX;
                end
            else
                containerResizeBoundary = containerResizeBoundary or -self.node:getContentSize().width;
                tempFinalPositionX = finalPositionX + signX * (rightMarign * maxWidthChildAnchorX + self.paddingRight);
                if (tempFinalPositionX > containerResizeBoundary) then
                    containerResizeBoundary = tempFinalPositionX;
                end
            end

            nextY = nextY + topBoundaryOfChild;
        end
    end

    return containerResizeBoundary;

end

function UILayoutEx:getVerticalBaseHeight(children)
    local newHeight = 0;
    local activeChildCount = 0;
    if (self.resizeMode == UILayout.ResizeMode.CONTAINER) then
        for i,child in ipairs(children) do
            if child:isVisible() then
                activeChildCount = activeChildCount + 1;
                newHeight = newHeight + child:getContentSize().height * self:getUsedScaleValue(child:getScaleY())
            end
        end

        newHeight = newHeight + (activeChildCount - 1) * self.spacingY + self.paddingBottom + self.paddingTop;
    else 
        newHeight = self.node:getContentSize().height;
    end
    return newHeight;
end

function UILayoutEx:doLayoutBasic( )
    local children = self.node:getChildren();

    local allChildrenBoundingBox = nil;

    for i,v in ipairs(children) do
        local child = v;
        if child:isVisible() then
            if allChildrenBoundingBox == nil then
                allChildrenBoundingBox = child:getBoundingBox();
            else 
                allChildrenBoundingBox = cc.rectUnion(allChildrenBoundingBox, child:getBoundingBox());
            end
        end
    end

    if allChildrenBoundingBox then
        local leftBottomSpace = self.node:convertToNodeSpaceAR(cc.p(allChildrenBoundingBox.x, allChildrenBoundingBox.y));
        leftBottomSpace = cc.p(leftBottomSpace.x - self.paddingLeft, leftBottomSpace.y - self.paddingBottom);

        local rightTopSpace = self.node:convertToNodeSpaceAR(cc.p(allChildrenBoundingBox.x + allChildrenBoundingBox.width, allChildrenBoundingBox.y + allChildrenBoundingBox.height));
        rightTopSpace = cc.p(rightTopSpace.x + self.paddingRight, rightTopSpace.y + self.paddingTop);

        local newSize = cc.pSub(rightTopSpace, leftBottomSpace)
        newSize = cc.size(newSize.x, newSize.y);

        if (newSize.width ~= 0) then
            -- Invert is to get the coordinate point of the child node in the parent coordinate system
            local newAnchorX = (-leftBottomSpace.x) / newSize.width;
            self.node:setAnchorPoint(cc.p(newAnchorX, self.node:getAnchorPoint().y))
        end
        if (newSize.height ~= 0) then
            -- Invert is to get the coordinate point of the child node in the parent coordinate system
            local newAnchorY = (-leftBottomSpace.y) / newSize.height;
            self.node:setAnchorPoint(cc.p(self.node:getAnchorPoint().x, newAnchorY))
        end
        
        self.node:setContentSize(newSize);
    end
end

function UILayoutEx:doLayoutGridAxisVertical(layoutAnchor, layoutSize)
    local baseHeight = layoutSize.height;

    local sign = 1;
    -- local leftBoundaryOfLayout = -layoutAnchor.x * layoutSize.width;
    local leftBoundaryOfLayout = layoutSize.width;
    local paddingX = self.paddingLeft;
    if self.horizontalDirection == UILayout.Direction.RTOL then
        sign = -1;
        -- leftBoundaryOfLayout = (1 - layoutAnchor.x) * layoutSize.width;
        leftBoundaryOfLayout = layoutSize.width;
        paddingX = self.paddingRight;
    end

    local fnPositionX = function(child, leftOffset, column)
        return leftBoundaryOfLayout + sign * (leftOffset + child:getAnchorPoint().x * child:getContentSize().width * self:getUsedScaleValue(child:getScaleX()) + paddingX + column * self.spacingX);
    end

    local newWidth = 0;
    if (self.resizeMode == UILayout.ResizeMode.CONTAINER) then
        local boundary = self:doLayoutVertically(baseHeight, true, fnPositionX, false);
        newWidth = leftBoundaryOfLayout - boundary;
        if (newWidth < 0) then
            newWidth = newWidth * -1;
        end

        -- leftBoundaryOfLayout = -layoutAnchor.x * newWidth;
        leftBoundaryOfLayout = newWidth;

        if (self.horizontalDirection == UILayout.Direction.RTOL) then
            sign = -1;
            -- leftBoundaryOfLayout = (1 - layoutAnchor.x) * newWidth;
            leftBoundaryOfLayout = newWidth
        end
    end

    self:doLayoutVertically(baseHeight, true, fnPositionX, true);

    if (self.resizeMode == UILayout.ResizeMode.CONTAINER) then
        self.node:setContentSize(newWidth, baseHeight);
    end
end


function UILayoutEx:doLayoutGridAxisHorizontal(layoutAnchor, layoutSize)
    local baseWidth = layoutSize.width;

    local sign = 1;
    -- local bottomBoundaryOfLayout = -layoutAnchor.y * layoutSize.height;
    local bottomBoundaryOfLayout = 0;
    local paddingY = self.paddingBottom;
    if (self.verticalDirection == UILayout.Direction.TTOB) then
        sign = -1;
        bottomBoundaryOfLayout = layoutSize.height --(1 - layoutAnchor.y) * layoutSize.height;
        paddingY = self.paddingTop;
    end

    local fnPositionY = function (child, topOffset, row)
        return bottomBoundaryOfLayout + sign * (topOffset + (1 - child:getAnchorPoint().y) * child:getContentSize().height * self:getUsedScaleValue(child:getScaleY()) + paddingY + row * self.spacingY);
    end


    local newHeight = 0;
    if (self.resizeMode == UILayout.ResizeMode.CONTAINER) then
        -- calculate the new height of container, it won't change the position of it's children
        local boundary = self:doLayoutHorizontally(baseWidth, true, fnPositionY, false);
        newHeight = bottomBoundaryOfLayout - boundary;
        if (newHeight < 0) then
            newHeight = newHeight * -1;
        end

        -- bottomBoundaryOfLayout = -layoutAnchor.y * newHeight;
        bottomBoundaryOfLayout = 0;
        if (self.verticalDirection == UILayout.Direction.TTOB) then
            sign = -1;
            -- bottomBoundaryOfLayout = (1 - layoutAnchor.y) * newHeight;
            bottomBoundaryOfLayout = newHeight;
        end
    end

    self:doLayoutHorizontally(baseWidth, true, fnPositionY, true);

    if (self.resizeMode == UILayout.ResizeMode.CONTAINER) then
        self.node:setContentSize(baseWidth, newHeight);
    end
end

function UILayoutEx:doLayoutGrid( )
    local layoutAnchor = self.node:getAnchorPoint();
    local layoutSize = self.node:getContentSize();

    if (self.startAxis == UILayout.AxisDirection.HORIZONTAL) then
        self:doLayoutGridAxisHorizontal(layoutAnchor, layoutSize);

    elseif (self.startAxis == UILayout.AxisDirection.VERTICAL) then
        self:doLayoutGridAxisVertical(layoutAnchor, layoutSize);
    end
end

function UILayoutEx:doLayout()
    if (self.type == UILayout.Type.HORIZONTAL) then
        local newWidth = self:getHorizontalBaseWidth(self.node:getChildren());

        local fnPositionY = function (child) 
            return child:getPositionY();
        end

        self:doLayoutHorizontally(newWidth, false, fnPositionY, true);

        self.node:setContentSize(cc.size(newWidth, self.node:getContentSize().height))
    elseif (self.type == UILayout.Type.VERTICAL) then
        local newHeight = self:getVerticalBaseHeight(self.node:getChildren());

        local fnPositionX = function (child) 
            return child:getPositionX();
        end

        self:doLayoutVertically(newHeight, false, fnPositionX, true);
        self.node:setContentSize(cc.size(self.node:getContentSize().width, newHeight))
    elseif (self.type == UILayout.Type.NONE) then
        if (self.resizeMode == UILayout.ResizeMode.CONTAINER) then
            self:doLayoutBasic();
        end
    elseif (self.type == UILayout.Type.GRID) then
        self:doLayoutGrid();
    end
end



return UILayoutEx