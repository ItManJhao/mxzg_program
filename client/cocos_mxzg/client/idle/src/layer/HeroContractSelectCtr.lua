local HeroContractSelectCtr = class("HeroContractSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroContractSelectLayer = class("HeroContractSelectLayer", require("src.comp.EventLayerAdaptiveWidth"))
local HeroContractSelectCell = class("HeroContractSelectCell", require("src.comp.LuaLayerBase"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")
local UIMenu = require("src.comp.menu.UIMenu")

function HeroContractSelectCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
end

function HeroContractSelectLayer:onCreate()

	self:addBlackBackground()
end

-----------------------------------------------------------------------------
function HeroContractSelectCtr:onCreate()
	self:setCCBIPath("ccbi/HeroContractSelectLayer.ccbi")
	self:setIsSingle(false)

	self._initData = nil
	self._contracts = {}
	self._selectedContractId = nil
	self._signedContractId = nil

	self._unlockHandlerId = ex.EventManager:add(EVENT.BATTLE_EVENT.UNLOCK_FORMATION, function(evt, data)
		require("src.layer.ShowContractImageCtr"):instance():openWindow()
		NetManager:sendMessage(ProtocolID.GReqQueryFormation)
		
		local contractInfo = self._contracts[data.unlockId]
		contractInfo.canUnlock = false
		contractInfo.unlock = true
		
		contractInfo.cell._unlockFlagSprite:setVisible(true)
		contractInfo.cell._lockedFlagSprite:setVisible(false)

		contractInfo.cell._typeLabel:setColor(cc.c4b(253, 228, 181, 255))
		contractInfo.cell._typeLabel:enableOutline(cc.c3b(87,56,29), 2)
		contractInfo.cell._unlockTag:setVisible(false)

		ex.Tools:addRedPoint(contractInfo.cell._redPointer, false, cc.p(0,0))

		if data.unlockId == self._selectedContractId then
			self.layer._btnEnsure:setVisible(true)
			self.layer._btnUnlock:setVisible(false)
			self.layer._btnActiveCondText:setVisible(false)
			self.layer._activeCondStaticText:setVisible(false)
		end
		
		ex.AudioManager:playEffect("music/item-get.mp3")
	end)
end

function HeroContractSelectCtr:getLayerClass()
	return HeroContractSelectLayer
end

function HeroContractSelectCtr:getHeroContractSelectLayer()
	return self.layer
end

function HeroContractSelectCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self._initData = data

	self:loadLayer()
	self:open()
	self:initData(data)
end

function HeroContractSelectCtr:initData(data)
	self.layer._btnClose:registerScriptTapHandler(handler(self, self.closeWindow))

	self.layer._btnEnsure:registerScriptTapHandler(function()
		for i,v in pairs(self._contracts) do
			local path = string.format('hero-select/contract-rider-%d.png', i)
			-- v.cell._riderIconSprite:setSpriteFrame(path)
			ex.Tools:setSpriteFrame(v.cell._riderIconSprite, path)
			v.cell._usingSprite:setVisible(false)
		end

		self._signedContractId = self._selectedContractId
		local path = string.format('hero-select/active-contract-rider-%d.png', self._selectedContractId)

		local contractInfo = self._contracts[self._selectedContractId]
		-- contractInfo.cell._riderIconSprite:setSpriteFrame(path)
		ex.Tools:setSpriteFrame(contractInfo.cell._riderIconSprite, path)
		contractInfo.cell._usingSprite:setVisible(true)

		if self._initData and formationId ~= 0 then
			self._initData.callback({
				formationId = self._signedContractId,
				formationList = contractInfo.formationList,
			})

			ex.AudioManager:playEffect("music/hero-up-level.mp3")

			local ani = ex.EffectCtr:playNormalEff(38, contractInfo.cell._riderIconSprite:getContentSize().width * 0.5, contractInfo.cell._riderIconSprite:getContentSize().height * 0.5 , nil, contractInfo.cell._riderIconSprite, 10)
			-- ani.anim:setOpacity(175)
		end
	end)

	self.layer._btnUnlock:registerScriptTapHandler(function()
		local selContractInfo = self._contracts[self._selectedContractId]
		
		if selContractInfo.canUnlock then
			local req = Battle_pb.GReqUnlockFormation()
			req.unlockId = selContractInfo.type
			NetManager:sendMessage(ProtocolID.GReqUnlockFormation, req)
		else
			ex.MessageView:add(ex.Tools:getLang(41324))
		end
	end)

	self:_initContractData(data)
end

function HeroContractSelectCtr:_initContractData(data)
	local signedFormationId = data.localSignedFormationId

	if data.lineUpData then
		if not signedFormationId then
			signedFormationId = data.lineUpData.formation_id
		end
	
		for i, heroId in ipairs(data.lineUpData.hero_list) do
			if heroId and heroId ~= 0 then
				local heroInfo = ex.Player.hero_data:getHeroDataById(heroId)
				local heroIcon = nil
				if heroInfo == nil then
					for i2,v2 in ipairs(data.friendsHeroList) do
						if heroId == v2.hero_id then
							heroIcon = UIMenuItemHero:createWithData(v2.hero_id, v2.hero_type, v2.elem, v2.level, v2.star)
							if v2.fashion_id ~= 0 and v2.fashion_id ~= nil then   -- 有皮肤
								heroIcon:setFashionShowForce(v2.fashion_id)
							end
						end
					end
				else
					local fashionId = ex.Player.hero_data.fashion:getWearByID(heroId)
					local heroType = heroInfo.hero_type
					heroIcon = UIMenuItemHero:createWithData(heroId, heroType, nil, heroInfo.level, heroInfo.star)
				end
				heroIcon:setScale(0.7)
				self.layer['_heroIconPointer' .. i]:removeAllChildren()
				self.layer['_heroIconPointer' .. i]:addChild(heroIcon)
			end
		end
	end

	self._contracts = {}
	self._selectedContractId = nil
	
	local unlockIdMap = {}
	for _, v in pairs(data.formationData.unlockIds or {}) do
		unlockIdMap[v] = true
	end

	local canUnlockIdMap = {}
	for _, v in pairs(data.formationData.canUnlockId or {}) do
		canUnlockIdMap[v] = true
	end

	self.layer._scrollView:getContainer():removeAllChildren()
	
	local scrollViewSize = self.layer._scrollView:getViewSize()
	local cellSize = HeroContractSelectCell:createWithCCBIFile("ccbi/HeroContractSelectCell.ccbi"):getContentSize()
	
	local formations, cellCount = self:_parseFormation()

	local height = cellCount * cellSize.height
	height = math.max(height, scrollViewSize.height)
	self.layer._scrollView:setContentSize(cc.size(scrollViewSize.width, height))
	self.layer._scrollView:setContentOffset(cc.p(0, -height+scrollViewSize.height))

	local isSelected = false

	for i, v in pairs(formations) do
		local cell = HeroContractSelectCell:createWithCCBIFile("ccbi/HeroContractSelectCell.ccbi")
		cell._menu:setSwallowsTouches(false)
		cell:setPosition(cc.p(0, height - cellSize.height * i))
		self.layer._scrollView:getContainer():addChild(cell)

		local contractInfo = {
			type = i,
			cell = cell,
			formationList = v.list,
		}
		self._contracts[i] = contractInfo

		if unlockIdMap[i] then -- 已解锁
			contractInfo.unlock = true
			-- cell._riderIconSprite:setSpriteFrame(string.format('hero-select/contract-rider-%d.png', i))
			ex.Tools:setSpriteFrame(cell._riderIconSprite, string.format('hero-select/contract-rider-%d.png', i))
			cell._unlockFlagSprite:setVisible(true)
			if signedFormationId == i then
				self._signedContractId = i
				-- cell._riderIconSprite:setSpriteFrame(string.format('hero-select/active-contract-rider-%d.png', i))
				ex.Tools:setSpriteFrame(cell._riderIconSprite, string.format('hero-select/active-contract-rider-%d.png', i))
				cell._usingSprite:setVisible(true)
			end
			cell._typeLabel:setColor(cc.c4b(253, 228, 181, 255))
			cell._typeLabel:enableOutline(cc.c3b(87,56,29), 2)
		elseif canUnlockIdMap[i] then -- 可以解锁
			contractInfo.canUnlock = true
			-- cell._riderIconSprite:setSpriteFrame(string.format('hero-select/contract-rider-%d.png', i))
			ex.Tools:setSpriteFrame(cell._riderIconSprite, string.format('hero-select/contract-rider-%d.png', i))
			cell._lockedFlagSprite:setVisible(true)
			cell._typeLabel:setColor(cc.c4b(38, 230, 237, 255))
			cell._typeLabel:enableOutline(cc.c3b(29,54,87), 2)
			cell._unlockTag:setVisible(true)
			ex.Tools:addRedPoint(cell._redPointer, true, cc.p(0,0))
		else -- 不能解锁
			-- cell._riderIconSprite:setSpriteFrame(string.format('hero-select/contract-rider-%d.png', i))
			ex.Tools:setSpriteFrame(cell._riderIconSprite, string.format('hero-select/contract-rider-%d.png', i))
			cell._lockedFlagSprite:setVisible(true)
			cell._unlockTag:setVisible(true)
			cell._typeLabel:setColor(cc.c4b(159,159,159,255))
			cell._typeLabel:enableOutline(cc.c3b(0,0,0), 2)
		end

		cell._typeLabel:setString(ex.Tools:getLang(v.cfg.describe))

		local selectCell = function(tag)
			if self._selectedContractId then
				local oldContractInfo = self._contracts[self._selectedContractId]
				oldContractInfo.cell._selectedSprite:setVisible(false)
			end

			self._selectedContractId = tag
			
			contractInfo.cell._selectedSprite:setVisible(true)

			-- self.layer._selectedTitleSprite:setSpriteFrame(string.format('hero-select-lang/contract%d.png', tag))
			ex.Tools:setSpriteFrame(self.layer._selectedTitleSprite, string.format('hero-select-lang/contract%d.png', tag))
			self.layer._btnActiveCondText:setString(ex.Tools:getLang(v.cfg.mission_name))
			self.layer._btnActiveCondText:setColor(cc.c4b(238, 253, 112, 255))
			
			for pos, info in pairs(v.list) do
				self.layer['_buffLabel' .. pos]:setString(info.abilityText)
			end

			if contractInfo.unlock then
				self.layer._btnEnsure:setVisible(true)
				self.layer._btnUnlock:setVisible(false)
				self.layer._activeCondStaticText:setVisible(false)
				self.layer._btnActiveCondText:setVisible(false)
				if signedFormationId == i then
				end
			elseif contractInfo.canUnlock then
				self.layer._btnEnsure:setVisible(false)
				self.layer._btnUnlock:setVisible(true)
				self.layer._activeCondStaticText:setVisible(true)
				self.layer._btnActiveCondText:setColor(cc.c4b(38, 230, 237, 255))
				self.layer._btnActiveCondText:setVisible(true)
			else
				self.layer._btnEnsure:setVisible(false)
				self.layer._btnUnlock:setVisible(true)
				self.layer._activeCondStaticText:setVisible(true)
				self.layer._btnActiveCondText:setColor(cc.c4b(238, 253, 112, 255))
				self.layer._btnActiveCondText:setVisible(true)
			end
		end

		cell._selectBtn:setTag(i)
		cell._selectBtn:setContentSize(cellSize)
		cell._selectBtn:registerScriptTapHandler(selectCell)

		if not isSelected and (signedFormationId == nil or signedFormationId == 0 or i == signedFormationId) then
			isSelected = true
			selectCell(i)
		end
	end
end

function HeroContractSelectCtr:_parseFormation()
	local resFormation = {}
	local count = 0
	for i,v in ipairs(cfg.formationaddition['formationaddition']) do
		local formationCfg = cfg.formation['formation']
		if not resFormation[v.type] then
			resFormation[v.type] = {
				cfg = formationCfg[v.type],
				list = {}
			}
			count = count + 1
		end

		resFormation[v.type].list[v.position] = {
			abilityText = ex.Tools:getAttrText(v.ability[1].attr, v.ability[1].value),
		}
	end

	return resFormation, count
end

return HeroContractSelectCtr
