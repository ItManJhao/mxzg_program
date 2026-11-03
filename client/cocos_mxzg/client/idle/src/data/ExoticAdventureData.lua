--[[
* @Description: 异界冒险数据处理类
* @Author: 熊梦
* @Date: 2020-07-29 15:28:00
* ]]
local ExoticAdventureData = class("ExoticAdventureData")

function ExoticAdventureData:ctor()
	self.unlock_route = {}  	--解锁的航线
    self.not_route = 0 			--当前执行航线
    self.energy = 0 			--剩余体力值
    self.not_progress = 0 		--已航行里程（用于计算进度）
    self.end_time = 0 			--预计航行结束时间
    self.shop_end_time = 0 		--土著商店结束时间
	self.shop_list = {}			--商店商品数据
	self.status = 0				--结算状态,1为可结算。0为不可结算

	self.product_end_time = 0	--航线礼包结束时间
	self.product_buy = {}		--航线礼包限购次数
	self.product_id = 0 		--航线礼包id

	self.speed_buff = 0			--是否有速度加成，1是。0否。

	self.level = 01 			--舰队等级
    self.exp = 0 				--舰队经验
    self.nick = "" 				--舰队名字
    self.durability = 0 		--耐久度
    self.skill_num = 0 			--剩余科技点
	self.skill = {}				--科技信息
	
	self.item_list = {}			--背包材料
	self.goods_list = {}		--背包物资

	self.unlock_event = {}		-- 图鉴

	self.end_item_list = {}		-- 航行结束物品列表

	self.event_type = 0 		-- 探索的事件类型

	self.send_sailngend = false -- 是否发送了结束消息

	self.event = {}
end

-- 设置异界冒险信息
function ExoticAdventureData:setExoticAdventureInfo(data)
	self.unlock_route = data.unlock_route  			--解锁的航线
    self.not_route = data.not_route 				--当前执行航线
    self.energy = data.energy 						--剩余体力值
    self.not_progress = data.not_progress 			--已航行里程（用于计算进度）
    self.end_time = data.end_time 					--预计航行结束时间
	self.shop_end_time = data.shop_end_time 		--土著商店结束时间
	self.shop_list = data.shop_list					--商店商品数据
	self.status = data.status						--结算状态,1为可结算。0为不可结算
	self.product_end_time = data.product_end_time	--航线礼包结束时间
	self.product_buy = data.product_buy				--航线礼包限购次数
	self.product_id = data.product_id				--航线礼包id
	self.speed_buff = data.speed_buff				--是否有速度加成，1是。0否。

	-- 接收到数据更新一下界面
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.UPDATA)
	
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.START_SAILING)
end

-- 设置舰长室的舰队数据
function ExoticAdventureData:setExoticAdventureFleetInfo(data)
	self.level = data.level 			--舰队等级
    self.exp = data.exp 				--舰队经验
    self.nick = data.nick 				--舰队名字
    self.durability = data.durability 	--耐久度
    self.skill_num = data.skill_num 	--剩余科技点
	self.skill = data.skill				--科技信息
	
	-- 接收到数据更新一下界面
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.FLEET_UPDATA)
end

-- 刷新体力 航行 结束时间
function ExoticAdventureData:setSailingInfo(date)
	self.energy = date.energy 					--剩余体力值
    self.not_progress = date.not_progress 		--已航行里程（用于计算进度）
	self.end_time = date.end_time 				--预计航行结束时间

	-- 接收到数据更新一下界面
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.UPDATASAILINGINFO)
end

-- 请求舰长室信息
function ExoticAdventureData:sendFleet()
	local req = SpaceTimeAdventure_pb.GReqFleetInfo()
    NetManager:sendMessage(ProtocolID.GReqFleetInfo)
end

-- 请求异界冒险数据
function ExoticAdventureData:sendSpaceTimeAdventureInfo()
	local req = SpaceTimeAdventure_pb.GReqSpaceTimeAdventureInfo()
    NetManager:sendMessage(ProtocolID.GReqSpaceTimeAdventureInfo)
end

-- 请求体力 航行 结束时间
function ExoticAdventureData:sendSailingInfo()
	local req = SpaceTimeAdventure_pb.GReqSailingInfo()
    NetManager:sendMessage(ProtocolID.GReqSailingInfo)
end


-- 请求结算数据
function ExoticAdventureData:sendSailingEnd()
--	if not self.send_sailngend then
		local req = SpaceTimeAdventure_pb.GReqSailingEnd()
		NetManager:sendMessage(ProtocolID.GReqSailingEnd)
		self.send_sailngend = true
--	end
end

-- 修改船昵称返回
function ExoticAdventureData:setNick(data)
	self.nick = data.name 				--舰队名字
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.UPDATA_NICK)
end

-- 修改船的耐久
function ExoticAdventureData:setDurability(data)
	self.durability = data.durability 	--舰队耐久
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.UPDATA_REPAIR)
end

-- 技能升级
function ExoticAdventureData:setSkill(data)
	self.skill_num = data.skill_num 
	for k,v in pairs(self.skill) do
		if v.skill_type == data.skill_info.skill_type then
			v.skill_level = data.skill_info.skill_level
			break
		end
	end
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.UPDATA_SKILL)
end

-- 开始航行
function ExoticAdventureData:startsailing(data)
	self.not_route = data.idx 
	-- 再请求航行数据
	self:sendSpaceTimeAdventureInfo()
end

-- 设置货仓数据
function ExoticAdventureData:setBackpack(data)
	self.item_list = data.item_list 
	self.goods_list = data.goods_list 
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.BACK_PACK)
end

-- 设置图鉴
function ExoticAdventureData:setIllustratedBooks(data)
	self.unlock_event = data.unlock_event 
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.ILLUSTRATED_BOOKS)
end

-- 更新图鉴
function ExoticAdventureData:updataIllustratedBooks(data)
	local existence = false
	for k,v in pairs(self.unlock_event) do
		if v == data.event_id then
			existence = true
			break
		end
	end
	if not existence then
		table.insert( self.unlock_event, data.event_id )
	end
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.UPDATA_ILLUSTRATED_BOOKS)
end

-- 航行结束物品数据
function ExoticAdventureData:setSailingEnd(data)
	self.end_item_list = data.item_list
	self.level = data.level;  --新的等级
    self.exp = data.exp; 	  --新的经验
	-- 再请求航行数据
	self:sendSpaceTimeAdventureInfo()
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.SAILING_END)
end

-- 更新航行进度
function ExoticAdventureData:updataSailingProgress(data)
	self.not_progress = data.not_progress 		--已航行里程（用于计算进度）
	self.end_time = data.end_time				--预计航行结束时间
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.UPDATA_SAILINGPROGRESS)
end

-- 探索事件
function ExoticAdventureData:setFleetExplore(data)
	self.event_type = data.event_type			-- 探索事件类型
	self.energy = data.energy					-- 剩余体力值
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.EVENT_EXPLORE)
end

-- 查看掠夺数据
function ExoticAdventureData:setEnemyInfo(data)
	self.service_id = data.service_id  --服务器id
	self.enemy_nick = data.enemy_nick  --敌人昵称
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.ENEMY_INFO)
end

-- 购买物品
function ExoticAdventureData:setShopInfo(data)
	self.shop_list = data.shop_list  	--商品数据
	self.shop_end_time = data.end_time  		--商店结束事件
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.SHOP,data.idx)
end

-- 购买礼包返回 刷新礼包数据
function ExoticAdventureData:setFleetGiftBuy(date)
	self.product_end_time = date.product_end_time 	--超值礼包结束时间
    self.product_id = date.product_id 				--超值礼包id
	self.product_buy = date.product_buy 			--超值礼包已购次数

	-- 接收到数据更新一下界面
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.UPDATAGIFT)
end

------------------------------------事件返回------------------------------------------
-- 放弃事件
function ExoticAdventureData:setFleetQuitEvent(data)
	self.event[self.event_type] = {}
	self.event_type = 0
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.EVENT_LEAVE)
end

-- 舰队残骸
function ExoticAdventureData:setFleetEventOne(data)
	self.event[self.event_type] = {}
	local event_data = {}
	event_data.item_list = data.item_list
	table.insert(self.event[self.event_type],event_data)
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.EVENT_ONE)
end

-- 舰队残骸（怪物）
function ExoticAdventureData:setFleetEventTwo(data)
	self.event[self.event_type] = {}
	local event_data = {}
	event_data.report = data.report
	event_data.item_list = data.item_list
	event_data.buff = data.buff
	self.durability = data.durability
	table.insert(self.event[self.event_type],event_data)
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.EVENT_TWO)
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.UPDATA_SAILINGPROGRESS)
end

-- 其他舰队
function ExoticAdventureData:setFleetEventThree(data)
	self.event[self.event_type] = {}
	local event_data = {}
	event_data.report = data.report
	event_data.buff = data.buff
	event_data.item_list = data.item_list
	self.durability = data.durability
	table.insert(self.event[self.event_type],event_data)
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.EVENT_THREE)
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.UPDATA_SAILINGPROGRESS)
end

-- 隐藏航线
function ExoticAdventureData:setFleetEventFour(data)
	-- 暂时没发现具体的作用 但也保存一下
	self.event[self.event_type] = {}
	local event_data = {}
	event_data.route_id = data.route_id
	table.insert(self.event[self.event_type],event_data)
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.EVENT_FOUR)
end

-- 风暴降临
function ExoticAdventureData:setFleetEventFive(data)
	self.event[self.event_type] = {}
	local event_data = {}
	event_data.buff = data.buff
	self.durability = data.durability
	table.insert(self.event[self.event_type],event_data)
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.EVENT_FIVE)
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.UPDATA_SAILINGPROGRESS)
end

-- 土著商人
function ExoticAdventureData:setFleetEventSix(data)
	self.event[self.event_type] = {}
	local event_data = {}
	self.shop_end_time = data.end_time
	self.shop_list = data.shop_list
	table.insert(self.event[self.event_type],event_data)
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.EVENT_SIX)
end

-- 搁浅舰队
function ExoticAdventureData:setFleetEventSeven(data)
	self.event[self.event_type] = {}
	local event_data = {}
	event_data.buff = data.buff
	self.durability = data.durability
	table.insert(self.event[self.event_type],event_data)
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.EVENT_SEVEN)
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.UPDATA_SAILINGPROGRESS)
end

-- 天降宝箱
function ExoticAdventureData:setFleetEventEight(data)
	self.event[self.event_type] = {}
	local event_data = {}
	event_data.item_list = data.item_list
	table.insert(self.event[self.event_type],event_data)
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.EVENT_EIGHT)
end

-- 什么都没有发生
function ExoticAdventureData:setFleetEventNine(data)
	self.event[self.event_type] = {}
	local event_data = {}
	event_data.item_list = data.item_list
	table.insert(self.event[self.event_type],event_data)
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.EVENT_NINE)
end

-- 航线礼包
function ExoticAdventureData:setFleetEventTen(data)
	self.product_end_time = data.product_end_time	--航线礼包结束时间
	self.product_id = data.product_id				--航线礼包id
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.EVENT_TEN)
end

-- 疾风之力
function ExoticAdventureData:setFleetEventEleven(data)
	self.event[self.event_type] = {}
	local event_data = {}
	event_data.buff = data.buff
	self.durability = data.durability
	self.speed_buff = 1
	table.insert(self.event[self.event_type],event_data)
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.EVENT_LEVEN)
	ex.EventManager:fire(EVENT.EXOTICADVENTURE.UPDATA_SAILINGPROGRESS)
end

return ExoticAdventureData
