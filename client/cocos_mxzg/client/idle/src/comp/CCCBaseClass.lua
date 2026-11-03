
local CCCBaseClass = class("CCCBaseClass")

local res_manager = require("src.model.ResManager"):instance()
local AsynNodeEx = require("src.comp.AsynNodeEx")
local sfc = cc.SpriteFrameCache:getInstance()

local NT = {
    S9 = 1, -- 九宫格精灵
    S = 2, -- 精灵
    IS = 3, -- menu_item图片
    IMG = 4, -- 单张图片。非图集
}

function CCCBaseClass:ctor()
    self.loadRes = {}
    self.lyts = {}
end

function CCCBaseClass:onEventLayerEnter()
    self:resetLyt();
end

function CCCBaseClass:addLoadRes(type, node, file, texture, ext)
    local key = file or texture
    if self.loadRes[key] == nil then
        self.loadRes[key] = {}
        self.loadRes[key][0] = {tn = texture, pn = file}
    end
    table.insert(self.loadRes[key], {type = type, node = node, ext = ext})
end

function CCCBaseClass:startLoadRes()
    self.nodeAsynEx = AsynNodeEx:create()
    self:addChild(self.nodeAsynEx)

    local vec_image = {{tn = "ccbi-res/reload.png"}}
    for k, v in pairs(self.loadRes) do
        if v[0].tn ~= nil then
            table.insert(vec_image, {tn = v[0].tn, pn = v[0].pn})
        end

        if v[0].pn ~= nil then
            res_manager:addPlist({v[0].pn})
        end
    end

    self.nodeAsynEx:setAsynImageList(vec_image)
    self.nodeAsynEx.callback = handler(self, self.resLoadingDone)
    self.nodeAsynEx:startAsynLoad()
end

function CCCBaseClass:resLoadingDone(file, tn, num, max)

 
    local key = file or tn
    local data = self.loadRes[key]
    if not data then
        return
    end

    for i, v in ipairs(data) do
        if v.node and tolua.isnull(v.node) == false then
            if v.type == NT.S9 then
                local frame = sfc:getSpriteFrame(v.ext.frame)

                if frame then
                    local contentSize = v.node:getContentSize()
                    v.node:setSpriteFrame(frame, v.ext.capInsets)
                    
                    v.node:setInsetLeft(v.ext.capInsets.x)
                    v.node:setInsetTop(v.ext.capInsets.y)
                    v.node:setInsetRight(v.ext.capInsets.width)
                    v.node:setInsetBottom(v.ext.capInsets.height)

                    v.node:setPreferredSize(contentSize)
                end
            elseif v.type == NT.S then
                local frame = sfc:getSpriteFrame(v.ext)
                if frame then
                    v.node:setSpriteFrame(frame)
                end

                -- 精灵需要在资源加载完成后再刷新布局
                if v.node.lyt then
                    v.node.lyt:refreshLayout()
                end
            elseif v.type == NT.IS then
                if v.ext.spr1 then
                    local ns = sfc:getSpriteFrame(v.ext.spr1)
                    if ns then
                        v.node:setNormalSpriteFrame(ns)
                    end
                end

                if v.ext.spr2 then
                    local ss = sfc:getSpriteFrame(v.ext.spr2)
                    if ss then
                        v.node:setSelectedSpriteFrame(ss)
                    end    
                end

                if v.ext.spr3 then
                    local ds = sfc:getSpriteFrame(v.ext.spr3)
                    if ds then
                        v.node:setDisabledSpriteFrame(ds)
                    end
                end
            elseif v.type == NT.IMG then
                v.node:setTexture(key)

                -- 精灵需要在资源加载完成后再刷新布局
                if v.node.lyt then
                    v.node.lyt:refreshLayout()
                end
            end
        end
    end

    if num >= max then
        self:allResLoadDone()
    end
end

function CCCBaseClass:removeNodeLoadRes(node)
    for k,v in pairs(self.loadRes) do
        for kk,vv in ipairs(v) do
            if vv.node == node then
                vv.node = nil
            end
        end
    end
end

function CCCBaseClass:allResLoadDone()

end

function CCCBaseClass:removeImage()
    local vec_image = {}
    for k, v in pairs(self.loadRes) do
        if v[0].tn ~= nil then
            table.insert(vec_image, {image_name = v[0].tn, plist_name = v[0].pn, remove_type = v[0].pn ~= nil and 2 or 1})
        end
    end
    res_manager:removeImage(vec_image)
end

function CCCBaseClass:addLyt(lyt)
    table.insert(self.lyts, lyt)    
end

function CCCBaseClass:resetLyt()
    local num = table.nums(self.lyts)
    for i=num,1,-1 do
        self.lyts[i]:refreshLayout()
    end
    -- for i,v in ipairs(self.lyts) do
    --     v:refreshLayout();
    -- end
end

return CCCBaseClass
