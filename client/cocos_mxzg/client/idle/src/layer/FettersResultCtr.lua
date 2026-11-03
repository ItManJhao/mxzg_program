local FettersResultCtr = class("FettersResultCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FettersResultLayer = class("FettersResultLayer", require("src.comp.LuaLayerBase"))

function FettersResultLayer:onCreate()
	local fetters_ctr = FettersResultCtr:instance()
	local win_size = cc.Director:getInstance():getWinSize();
	local height = Maths.min(self:getContentSize().height, win_size.height);
	self:setScale(height / self:getContentSize().height);

	self.node_text:setLocalZOrder(1)
	self:addBlackBackground()

end

-----------------------------------------------------------------------------
function FettersResultCtr:onCreate()
	self:setCCBIPath("ccbi/FettersResultLayer.ccbi")
	self:setIsSingle(false)
end

function FettersResultCtr:getLayerClass()
	return FettersResultLayer
end

function FettersResultCtr:getFettersResultLayer()
	return self.layer
end

function FettersResultCtr:openWindow(layer_type, type, pre_level, now_level, vec_attr1, vec_attr2)
	if self:isOpened() then
		self:updata(layer_type, type, pre_level, now_level, vec_attr1, vec_attr2)
		return
	end

	self:loadLayer()
	self:open()
	self:initData(layer_type, type, pre_level, now_level, vec_attr1, vec_attr2)
end

function FettersResultCtr:updata(layer_type, type, pre_level, now_level, vec_attr1, vec_attr2)
	local layer = self.layer
	
	if pre_level == nil then
		layer.node_level:setVisible(false)
		return
	end

	layer.lbl_name:setString(ex.Tools:getLang(3000000 + type))
	layer.lbl_pre_level:setString(pre_level)
	layer.lbl_now_level:setString(now_level)
	local str_attr_fix = ""
	if layer_type == "uplevel" then
	elseif layer_type == "uplimit" then
		str_attr_fix = ex.Tools:getLang(41325)--ex.Tools:getLang(47449)
	elseif layer_type == "refine" then
	end

	vec_attr1 = vec_attr1 or {}
	vec_attr2 = vec_attr2 or {}
	for i=1,2 do
    	layer["node_attr"..i]:setVisible(false)
    end

    local index = 1
    for k,v in pairs(vec_attr1) do
    	layer["node_attr"..index]:setVisible(true)
		layer["lbl_name"..index]:setString(str_attr_fix .. ex.Tools:getLang(2150000 + k))
		layer["lbl_left"..index]:setString(ex.StringUtil.formatAttrStr(" "..ex.Tools:getLang(2160000 + k), "##" , v))
		index = index + 1
    end

	index = 1
    for k,v in pairs(vec_attr2) do
		layer["lbl_right"..index]:setString(ex.StringUtil.formatAttrStr(" "..ex.Tools:getLang(2160000 + k), "##" , v))
		index = index + 1
    end
end

function FettersResultCtr:initData(layer_type, type, pre_level, now_level, vec_attr1, vec_attr2)
	local layer = self.layer
	-- dump(vec_attr1)
	-- dump(vec_attr2)

	ex.Tools:setSpriteFrame(layer.spr_title, string.format("fetters-lang/spr-%s-1.png", layer_type))



	local skin = ex.Player.fetter_data:getSkin(type)
	local spine = sp.SkeletonAnimation:create("spine/"..skin..".json","spine/"..skin..".atlas", 1)
    spine:setScale(0.5)
    spine:setPosition(layer:getContentSize().width * 0.5, layer:getContentSize().height * 0.6)
    spine:setAnimation(0, "stand", true);
    layer:addChild(spine)

  self:updata(layer_type, type, pre_level, now_level, vec_attr1, vec_attr2)

end


return FettersResultCtr
