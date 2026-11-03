local RedDotManager = class("RedDotManager", require("src.common.SingleInstance"))


function RedDotManager:ctor()
    self.root_node = {}
end

function RedDotManager:readRedDotFile(file)

    self.root_node = {}

    -- local tree_json = cc.FileUtils:getInstance():getStringFromFile(file)

    -- if tree_json == nil or tree_json == "" then
    --     return 
    -- end

    -- -- 预防报错
    -- local status, msg = xpcall(function()
    --     tree_json = json.decode(tree_json)
    -- end, __G__TRACKBACK__)

    -- if not status then print(msg) end

    local tree_json = nil

    -- 预防报错
    local status, msg = xpcall(function()
        tree_json = require("src.config.reddot")
    end, __G__TRACKBACK__)

    if not status then print(msg) end
    
    if tree_json == nil then
        return
    end
    local str_root_node = tree_json.root_node_id

    local main_node = nil

    -- 所有节点数据
    local vec_reddot_data = {}
    for i,v in ipairs(tree_json.list) do
        if v.node_id == str_root_node then
            main_node = v
        end

        v.vec_children = {}
        v.visible = false
        v.special_visible = false
        v.image_type = 1
        v.num = 0
        v.node = nil
        v.parent = nil
        table.insert(vec_reddot_data, v)
    end


    require("src.model.TableEx")

    -- 关联节点
    for i, v in ipairs(tree_json.list) do
        local iter_reddot_node = TableEx.findValueFunction(vec_reddot_data, function(node)
            return node.node_id == v.node_id
        end)

        if iter_reddot_node ~= nil and iter_reddot_node.children ~= nil then
            for ic,vc in ipairs(iter_reddot_node.children) do

                local iter_child_node = TableEx.findValueFunction(vec_reddot_data, function(node)
                    return node.node_id == vc
                end)

                -- 
                if iter_child_node ~= nil then
                    -- 设置父节点
                    iter_child_node.parent = iter_reddot_node
                    -- 插入子节点
                    table.insert(iter_reddot_node.vec_children, iter_child_node)
                end
            end
        end
    end

    if main_node then
        self.root_node = main_node
    end
end

-- 设置红点附着的节点
function RedDotManager:setStickNode(type, stick_node)
    local node = self:findNode(self.root_node, type)

    if node == nil then
        print("reddot_type not found", type)
        return
    end

    node.node = stick_node

    -- 删除已有红点
    if node.red_node ~= nil and tolua.isnull(node.red_node) == false  then
        node.red_node:removeFromParent()
        node.red_node = nil
    end
    
    node.red_node = nil

    local node_visible = node.visible and node or self:isChildVisible(node)
    if node_visible then
        self:setRedNodeVisible(node_visible.type, node_visible.visible, node_visible.num)
    end
end

-- 移除红点附着的节点
function RedDotManager:removeStickNode(type, stick_node)
    local node = self:findNode(self.root_node, type)
    if node == nil then
        return
    end

    if node.node == stick_node then
        node.node = nil
        node.red_node = nil
    end

    if node.visible then
        self:setRedNodeVisible(type, node.visible)
    end
end

function RedDotManager:getRedDotNode(type)
    return self:findNode(self.root_node, type)
end

-- 设置红点是否显示
function RedDotManager:setRedNodeVisible(type, visible, num)
    -- print("setRedNodeVisible", type, visible)

    -- DEBUG
    -- if type == RedDotType.ZCJ_DHZC_KFSK_TTZB and visible then
    --     local a  = 0 
    --     a = 2
    -- end

    local node = self:findNode(self.root_node, type)

    if node == nil then
        print("setRedNodeVisible.type not found", type)
        return
    end

    node.num = num or 0
    node.visible = visible or false
    self:setNodeVisible(node, visible, num)
end


-- 设置红点精灵是否显示,用于暂时隐藏红点精灵。不移除
function RedDotManager:setSpecialVisible(type, visible)
    local node = self:findNode(self.root_node, type)
    node.special_visible = visible == true and false or true
    if node.red_node ~= nil then
        node.red_node:setVisible(visible)
    end
end

-- 在主节点下寻找对应类型的节点
function RedDotManager:findNode(node, type)
    for i,vn in ipairs(node.vec_children) do
        if vn.type == type then
            return vn
        else
            local tmp_node = self:findNode(vn, type)

            if tmp_node ~= nil then return tmp_node end
        end
    end
    return nil
end


function RedDotManager:setNodeVisible(node, visible)
    if node == nil then
        return nil
    end

    if visible == true then
        if node.red_node == nil and node.node and tolua.isnull(node.node) == false then
            if node.image_type == 1 then
                node.red_node = cc.Sprite:createWithSpriteFrameName("other/spr-reddot-1.png")
            else
                -- Label节点需要它
                node.red_node = cc.Sprite:create()
            end

            local is_visible = visible and not node.special_visible
            if cfg.reddotcondition.reddotcondition[node.type] then
                is_visible = is_visible and ex.Player.level >= cfg.reddotcondition.reddotcondition[node.type].condition_value
            end

            node.red_node:setVisible(is_visible)
            -- print("node.type", node.type)
            -- 绝对坐标
            if node.image_x > 3 or node.image_y > 3 then
                node.red_node:setPosition(node.x, node.y)
            else
                -- 相对坐标
                node.red_node:setPosition(node.node:getContentSize().width  * node.image_x,
                                          node.node:getContentSize().height * node.image_y)
            end
    
            node.node:addChild(node.red_node, 999)
        else
            if node.red_node and node.node and tolua.isnull(node.node) == false and tolua.isnull(node.red_node) == false and not node.red_node:isVisible() then
                local is_visible = visible and not node.special_visible
                if cfg.reddotcondition.reddotcondition[node.type] then
                    is_visible = is_visible and ex.Player.level >= cfg.reddotcondition.reddotcondition[node.type].condition_value
                end

                node.red_node:setVisible(is_visible)
            end
        end

        if node.red_node and node.node and tolua.isnull(node.node) == false then
            if node.num > 0 then
                -- 显示最大数为99
                if node.num > 99 then
                    node.num = 99
                end
                local lbl_num = node.red_node:getChildByTag(10000)
                local vec_child = node.red_node:getChildren()
                if lbl_num then
                    lbl_num:setString(string.format("%d", node.num))
                else
                    lbl_num = cc.Label:createWithTTF(string.format("%d", node.num), FONT_DEFAULT_NAME_BOLD, 13)
                    lbl_num:setPosition(node.red_node:getContentSize().width * 0.5,
                                            node.red_node:getContentSize().height * 0.5)
                    lbl_num:setTag(10000)
                    node.red_node:addChild(lbl_num)
                end
            else
                local lbl_num = node.red_node:getChildByTag(10000)
                if lbl_num then
                    lbl_num:removeFromParent()
                    lbl_num = nil
                end
            end
        end
    elseif (self:isChildVisible(node) or node.visible == true) == false then
        if not tolua.isnull(node.red_node) then
            node.red_node:removeFromParent()
            node.red_node = nil
        end
    end

    -- 更新父节点红点的num值
    if node.parent then
        local num = 0
        for i,v in ipairs(node.parent.vec_children) do
            if v.num > 0 then
                num = num + v.num
            end
        end

        node.parent.num = num
    end

    return self:setNodeVisible(node.parent, visible)
end


function RedDotManager:isReddotVisible(type)
    local node = self:findNode(self.root_node, type)
    if node == nil then
        return false
    end
    return node.visible == true or self:isChildVisible(node) ~= nil
end

function RedDotManager:isChildVisible(node)
    for i,v in ipairs(node.vec_children) do
        if v.visible then
            return v
        else
            local child = self:isChildVisible(v)
            if child then  return child end
        end
    end
end

function RedDotManager:refreshConditionRedDot()
    for k, v in pairs(cfg.reddotcondition.reddotcondition) do
        if ex.Player.level >= v.condition_value then
            local node = self:findNode(self.root_node, v.idx)

            if node then
                self:setNodeVisible(node, node.visible or false, node.num or 0)
            end
        end
    end
end

return RedDotManager