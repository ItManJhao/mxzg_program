--
-- Author: windy
-- Date: 2018-07-03 10:13:05
--
local AsynNodeEx = class("AsynNodeEx", function(...)
        return cc.Node:create()
    end
)

function AsynNodeEx:ctor()
    self.vec_image = {}
    self.is_loading = false
    self.callback = nil
    self.load_index = 0
    if self.onCreate then
        self:onCreate()
    end
end

function AsynNodeEx:setAsynImageList(list)
    self.vec_image = list
end

function AsynNodeEx:startAsynLoad()
    if (not self.vec_image) or table.nums(self.vec_image) == 0 then
        if self.callback then
            self:callback(0, 0, true)
        end
        return
    end

    self.load_index = 1
    self:asynLoad()
end

function AsynNodeEx:asynLoad()
    local image_num = table.nums(self.vec_image)
    if self.load_index > image_num then
        return
    end

    local self_p = self
    local file_data = self.vec_image[self.load_index]
    -- self:analyzePlist(file_data)
    local asyn_call = function(...)
        local params = {...}

        if tolua.isnull(self_p) then
            return
        end

        if file_data.pn then
            display.loadSpriteFrames(file_data.pn, file_data.tn)
        end

        if self_p.callback then
            self_p.callback(file_data.pn, file_data.tn, self_p.load_index, image_num)
        end

        self_p.load_index = self_p.load_index + 1
        self_p:asynLoad()
    end

    display.loadImage(file_data.tn, asyn_call)
end

return AsynNodeEx
