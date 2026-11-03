--
-- Author: windy
-- Date: 2018-07-03 10:13:05
--
local AsynNode = class("AsynNode", function ( ... )
								   		return cc.Node:create()
								   end)

-- require("app.common.TableEx")

function AsynNode:ctor()
   self.vec_image = {}
   self.is_loading = false
   self.callback = nil
   self.load_index = 0
   if self.onCreate then self:onCreate() end
end

function AsynNode:setAsynImageList(list)
	self.vec_image = list
end

function AsynNode:startAsynLoad()
	if (not self.vec_image) or table.nums(self.vec_image) == 0 then
		if self.callback then
			self:callback(0, 0, true)
		end
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()

	for k,v in pairs(self.vec_image) do
		if v.plist_name and v.rgb_type == 1 then
			-- cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888)
			sfc:addSpriteFrames(v.plist_name)
			-- cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888)
		end
	end

	self.load_index = 1
	self:asynLoad()
end

function AsynNode:asynLoad()
	local image_num = table.nums(self.vec_image)
	if self.load_index > image_num then
		return
	end

	local self_p = self
	local file_data = self.vec_image[self.load_index]
	self:analyzePlist(file_data)
	-- dump(file_data, "file_data")
	-- print("file_data", file_data)

	local asyn_call = function( ... )
			local params = {...}

			if tolua.isnull(self_p) then
				return
			end

			if file_data.plist_name then
				display.loadSpriteFrames(file_data.plist_name, file_data.image_name)
			end

			if self_p.callback then
				self_p.callback(self_p.load_index, image_num, self_p.load_index >= image_num)
			end

		    self_p.load_index = self_p.load_index + 1
		    self_p:asynLoad()
	end
	-- dump(file_data)
	display.loadImage(file_data.image_name, asyn_call)

	-- if file_data.plist_name then
	-- 	-- 底层没有实现该函数
	-- 	display.loadSpriteFrames(file_data.plist_name, file_data.image_name, asyn_call)
	-- else
	-- 	display.loadImage(file_data.image_name, asyn_call)
	-- end
end

function AsynNode:analyzePlist(data)
	local start_i = string.find(data.image_name, "%.")
	local file_name = string.sub(data.image_name, 1, start_i - 1)
	file_name = file_name..".plist"
	local is_exist = cc.FileUtils:getInstance():isFileExist(file_name)
	if is_exist then
		data.plist_name = file_name
	end
end

return AsynNode
