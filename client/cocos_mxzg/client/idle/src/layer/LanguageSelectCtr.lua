local LanguageSelectCtr = class("LanguageSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local LanguageSelectLayer = class("LanguageSelectLayer", require("src.comp.EventLayerAdaptiveWidth"))

function LanguageSelectLayer:onCreate()
	self:addBlackBackground()

	local res_language, config_idx = require("src.native.Native").getLanguageAdapter()

	self.btn_confirm:setLabelText(ex.Tools:getLang(11))


	self.select_language = config_idx or 1
	for i,v in ipairs(cfg.languagetype.languagetype) do
		local lbl = self["lbl_language"..i]
		if lbl then
			lbl:setString(ex.Tools:getLang(v.text))
		end
	end
	
	local config = cfg.languagetype.languagetype[self.select_language]
	if config then
		if self["btn_language"..config.idx] then
			self["btn_language"..config.idx]:setChecked(true)
		end
	end

end

function LanguageSelectLayer:onSelectLanguage(tag)
	self.select_language = tag
end

function LanguageSelectLayer:onConfirm()
	ex.ConfirmCtr:openWindow(ex.Tools:getLang(3500), ex.Tools:getLang(84), function()
		cc.UserDefault:getInstance():setIntegerForKey("system_language", self.select_language)
		-- LanguageSelectCtr:instance():closeWindow(0, nil)
		self:runAction(cc.CallFunc:create(function()
			require("src.native.Native").resetSearchPath()
			require("src.native.Native").changeToLogoSceneCtr()
		end))
	end)
end

-----------------------------------------------------------------------------
function LanguageSelectCtr:onCreate()
	self:setCCBIPath("ccbi/LanguageSelectLayer.ccbi")
	self:setIsSingle(false)
end

function LanguageSelectCtr:getLayerClass()
	return LanguageSelectLayer
end

function LanguageSelectCtr:getLanguageSelectLayer()
	return self.layer
end

function LanguageSelectCtr:openWindow()
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
	self:open()
	self:initData()
end

function LanguageSelectCtr:initData()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))


end


return LanguageSelectCtr
