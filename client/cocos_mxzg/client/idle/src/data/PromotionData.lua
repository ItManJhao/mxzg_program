local PromotionData = class("PromotionData")

local promotionPros = {
    gReqScanBuyInfo = {id = 15, reqProtoId = ProtocolID.GReqScanBuyInfo},
    gReqExchangeList = {id = 16, reqProtoId = ProtocolID.GReqExchangeList},
    gReqLimitedtimeRechargeReward = {id = 17, reqProtoId = ProtocolID.GReqLimitedtimeRechargeReward},
    --gReqScanBuyInfo = {id = 18, reqProtoId = ProtocolID.GReqScanBuyInfo},

    -- add 熊梦
    -- 七日活动
    gReqSevenDayTargetList = {id = 18, reqProtoId = ProtocolID.GReqSevenDayTargetList},
    gReqLevelUpGiftList = {id = 19, reqProtoId = ProtocolID.GReqLevelUpGiftList},
    gReqDailyGiftData = {id = 20, reqProtoId = ProtocolID.GReqDailyGiftData},
    gReqDailyChargeData = {id = 21, reqProtoId = ProtocolID.GReqDailyChargeData},
    gReqDailyTotalChargeData = {id = 22, reqProtoId = ProtocolID.GReqDailyTotalChargeData},
    gReqMonthGiftData = {id = 23, reqProtoId = ProtocolID.GReqMonthGiftData},
    gReqWeeklyGiftData = {id = 24, reqProtoId = ProtocolID.GReqWeeklyGiftData},
    gReqBuyGoldCountData = {id = 25, reqProtoId = ProtocolID.GReqBuyGoldCountData},
    gReqSpeedFightCountData = {id = 26, reqProtoId = ProtocolID.GReqSpeedFightCountData},
    gReqAdventureCountData = {id = 27, reqProtoId = ProtocolID.GReqAdventureCountData},
    gReqTavernCountData = {id = 28, reqProtoId = ProtocolID.GReqTavernCountData},
    -- gReqScanBuyInfo = {id = 29, reqProtoId = ProtocolID.GReqScanBuyInfo},
    -- gReqScanBuyInfo = {id = 30, reqProtoId = ProtocolID.GReqScanBuyInfo},
    gReqPvpwinList = {id = 31, reqProtoId = ProtocolID.GReqPvpwinList},
    gReqPubArriveInfo = {id = 32, reqProtoId = ProtocolID.GReqPubArriveInfo},
    gReqMarkHeroList = {id = 33, reqProtoId = ProtocolID.GReqMarkHeroList},
    gReqZhuShenData = {id = 34, reqProtoId = ProtocolID.GReqZhuShenData},
    -- gReqScanBuyInfo = {id = 35, reqProtoId = ProtocolID.GReqScanBuyInfo},
    gReqBlessingPoolLists = {id = 37, reqProtoId = ProtocolID.GReqBlessingPoolLists},
    gReqAstrologyTaskInfo = {id = 38, reqProtoId = ProtocolID.GReqAstrologyTaskInfo},
    gReqOverValueData = {id = 39, reqProtoId = ProtocolID.GReqOverValueData},
    gReqSummonList = {id = 40, reqProtoId = ProtocolID.GReqSummonList},
    gReqProphecyList = {id = 41, reqProtoId = ProtocolID.GReqProphecyList},
    gReqPromotionSacrificeShop = {id = 42, reqProtoId = ProtocolID.GReqPromotionSacrificeShop},
    gReqSummonCrystalInfo = {id = 43, reqProtoId = ProtocolID.GReqSummonCrystalInfo},
    gReqColorfulShopData = {id = 44, reqProtoId = ProtocolID.GReqColourfulShopData},
    gReqLoginGiftData = {id = 45, reqProtoId = ProtocolID.GReqLoginGiftData},
    gReqExchangeShopData = {id = 46, reqProtoId = ProtocolID.GReqExchangeShopData},
    gReqFestivalOvervalueGift = {id = 50, reqProtoId = ProtocolID.GReqFestivalOvervalueGift},
    -- gReqRechargeWeekList = {id = 48, reqProtoId = ProtocolID.GReqRechargeWeekList},

    gReqFestivalLoginInfo = {id = 51, reqProtoId = ProtocolID.GReqFestivalLoginInfo},
    gReqFlashSaleData = {id = 54, reqProtoId = ProtocolID.GReqFlashSaleData},
    gReqFashionBuyData = {id = 56, reqProtoId = ProtocolID.GReqFashionBuyData},
    gReqEveryDayLoginPromotion = {id = 57, reqProtoId = ProtocolID.GReqEveryDayLoginPromotion},
    gReqHighWeeksCardsInfo = {id = 58, reqProtoId = ProtocolID.GReqHighWeeksCardsInfo},
    gReqSummonWeeksCardsInfo = {id = 59, reqProtoId = ProtocolID.GReqSummonWeeksCardsInfo},
    gReqThreeDayTaskData = {id = 61, reqProtoId = ProtocolID.GReqThreeDayTaskData},
    gReqCustomizedData = {id = 62, reqProtoId = ProtocolID.GReqCustomRewardData},
    gReqElfWeeksCardInfo = {id = 63, reqProtoId = ProtocolID.GReqElfWeeksCardInfo},
    gReqDragonBoatTaskInfo = {id = 64, reqProtoId = ProtocolID.GReqDragonBoatTaskInfo},
    GReqHeroRollingData = {id = 65, reqProtoId = ProtocolID.GReqHeroRollingData},
    GReqSpaceTimeTreasureInfo = {id = 68, reqProtoId = ProtocolID.GReqSpaceTimeTreasureInfo},

    --周向阳   超值赠礼
    GReqRechargeGiftInfo = {id = 69, reqProtoId = ProtocolID.GReqRechargeGiftInfo},
    GReqGetDataInfo = {id = 70, reqProtoId = ProtocolID.GReqGetDataInfo},
    GReqQiShenQiInfo = {id = 71, reqProtoId = ProtocolID.GReqQiShenQiInfo},
    GReqZSJTInfo = {id = 72, reqProtoId = ProtocolID.GReqZSJTInfo},

    --中秋活动
    GReqMidLotteryGetDataInfo = {id = 74, reqProtoId = ProtocolID.GReqMidLotteryGetDataInfo},
    GReqMidFoodInfo = {id = 75, reqProtoId = ProtocolID.GReqMidFoodInfo},
        
    -- 皮肤活动
    GReqMidFashionGetDataInfo = {id = 76, reqProtoId = ProtocolID.GReqMidFashionGetDataInfo},

    -- 赏月任务
    GReqMidMissionGetDataInfo = {id = 77, reqProtoId = ProtocolID.GReqMidMissionGetDataInfo},

    -- 惊喜扭蛋
    GReqHalloweenLotteryGetDataInfo = {id = 78, reqProtoId = ProtocolID.GReqHalloweenLotteryGetDataInfo},
    -- 鬼怪巡游会
    GReqHalloweenGiftInfo = {id = 79, reqProtoId = ProtocolID.GReqHalloweenGiftInfo},
    -- 万圣任务
    GReqHalloweenMissionGetDataInfo = {id = 80, reqProtoId = ProtocolID.GReqHalloweenMissionGetDataInfo},

    -- 超低折扣
    gReqBlackFiveMissionGetDataInfo = {id = 81, reqProtoId = ProtocolID.GReqBlackFiveMissionGetDataInfo},
    -- 血拼黑五
    gReqBlackFiveGiftInfo = {id = 82, reqProtoId = ProtocolID.GReqBlackFiveGiftInfo},
    -- 黑色通缉
    GReqBlackFiveLotteryGetDataInfo = {id = 83, reqProtoId = ProtocolID.GReqBlackFiveLotteryGetDataInfo},
    -- 英雄排行榜
    gReqDeliverCountRank = {id = 92, reqProtoId = ProtocolID.GReqDeliverCountRank},
    gReqDeliverFlowerGetData = {id = 92, reqProtoId = ProtocolID.GReqDeliverFlowerGetData},

    -- 三日累充
    gReqThreeDay = {id = 84, reqProtoId = ProtocolID.GReqThreeDay},

    -- 圣诞活动 圣诞连线
    gReqChristmasMissionGetDataInfo = {id = 85, reqProtoId = ProtocolID.GReqChristmasMissionGetDataInfo},
    -- 圣诞活动 约会圣诞
    gReqChristmasGiftInfo = {id = 86, reqProtoId = ProtocolID.GReqChristmasGiftInfo},
    -- 圣诞活动 嗨翻圣诞
    gReqChristmasLotteryGetDataInfo = {id = 87, reqProtoId = ProtocolID.GReqChristmasLotteryGetDataInfo},
    -- 圣诞活动 圣诞礼盒
    gReqChristmasScoreInfo = {id = 88, reqProtoId = ProtocolID.GReqChristmasScoreInfo},
    -- 圣诞活动 感谢信
    gReqChristmasNote = {id = 89, reqProtoId = ProtocolID.GReqChristmasNote},
    
    --战队降临
    gResTPermitList = {id = 90, reqProtoId = ProtocolID.GResTPermitList},
    -- 春节活动 惊喜盲盒
    gReqSpringFestivalGetDataInfo = {id = 91, reqProtoId = ProtocolID.GReqSpringFestivalGetDataInfo},
    

    -- 春日活动
    -- 活动一：春日踏青
    gReqSpringOutingGrid = {id = 93, reqProtoId = ProtocolID.GReqSpringOutingGrid},
    -- 活动二：制作彩蛋 
    gReqMakeEggScoreInfo = {id = 94, reqProtoId = ProtocolID.GReqMakeEggScoreInfo},
    -- 活动三：春游记
    gReqSpringOutingGiftInfo = {id = 95, reqProtoId = ProtocolID.GReqSpringOutingGiftInfo},
    -- 活动四：出游寻春
    gReqSpringOutingMissionGetDataInfo = {id = 96, reqProtoId = ProtocolID.GReqSpringOutingMissionGetDataInfo},

    -- 圣诞活动 五一抽奖
    gReqLaborDayLuckDrawGetDataInfo = {id = 97, reqProtoId = ProtocolID.GReqLaborDayLuckDrawGetDataInfo},
}

-- 活动配置名字字典（用于拉去活动配置使用，此处的value为活动配置名字）
local ServerPromotionNameMap = {
    [promotionPros.gReqBlessingPoolLists.id] = "promotionwishpool",
    [promotionPros.gReqAstrologyTaskInfo.id] = "promotionastrology",
    [promotionPros.gReqOverValueData.id] = "promotionovervaluegift",
    [promotionPros.gReqSummonList.id] = "promotionsummontimes",
    [promotionPros.gReqProphecyList.id] = "promotionprophecytimes",
    [promotionPros.gReqPromotionSacrificeShop.id] = "promotionsacrificeshop",
    [promotionPros.gReqSummonCrystalInfo.id] = "promotionsummontarget",
    [promotionPros.gReqColorfulShopData.id] = "promotioncolourfulshops",
    [promotionPros.gReqLoginGiftData.id] = "promotionlogingift",
    [promotionPros.gReqExchangeShopData.id] = "promotionexchangeshop",
    [promotionPros.gReqFestivalOvervalueGift.id] = "festivalovervaluegift",
    -- [promotionPros.gReqRechargeWeekList.id] = "promotionweeklytotalrecharge",

    [promotionPros.gReqFestivalLoginInfo.id] = "festivanew7daylogin",
    [promotionPros.gReqFashionBuyData.id] = "fashionbuy",
    [promotionPros.gReqEveryDayLoginPromotion.id] = "promotioneverydaylogin",
    [promotionPros.gReqHighWeeksCardsInfo.id] = "promotionhighweekscard",
    [promotionPros.gReqSummonWeeksCardsInfo.id] = "promotionsummonweekscard",
    [promotionPros.gReqThreeDayTaskData.id] = "promotion3daytaskreward",
    [promotionPros.gReqCustomizedData.id] = "customreward",
    [promotionPros.gReqElfWeeksCardInfo.id] = "promotionelfweekscard",
    [promotionPros.GReqHeroRollingData.id] = "promotionnewherolotter",
    [promotionPros.gReqDragonBoatTaskInfo.id] = "promotioneldragonboatprop",
    [promotionPros.GReqSpaceTimeTreasureInfo.id] = "promotimetreasureinfo",
    [promotionPros.GReqGetDataInfo.id] = "promotion070reward",
    [promotionPros.GReqQiShenQiInfo.id] = "promotion071QSQ",
    [promotionPros.GReqZSJTInfo.id] = "promotion072reward",
    [promotionPros.GReqMidLotteryGetDataInfo.id] = "promotion074lotteryreward",
    [promotionPros.GReqHalloweenLotteryGetDataInfo.id] = "promotion078lotteryreward",
    [promotionPros.GReqMidFoodInfo.id] = "promotion075midfood",
    [promotionPros.GReqMidFashionGetDataInfo.id] = "promotionskindatainfo",
    [promotionPros.GReqHalloweenGiftInfo.id] = "promotion079",
    [promotionPros.gReqBlackFiveMissionGetDataInfo.id] = "promotion081reward",
    [promotionPros.gReqBlackFiveGiftInfo.id] = "promotion082XPHW",
    [promotionPros.GReqBlackFiveLotteryGetDataInfo.id] = "promotion083lotteryreward",
    [promotionPros.gReqThreeDay.id] = "promotion084reward",
    [promotionPros.gReqChristmasMissionGetDataInfo.id] = "promotion085missionboxreward",
    [promotionPros.gReqChristmasGiftInfo.id] = "promotion086gift",
    [promotionPros.gReqChristmasLotteryGetDataInfo.id] = "promotion087lotteryreward",
    [promotionPros.gReqChristmasScoreInfo.id] = "promotion088randomreward",
    [promotionPros.gResTPermitList.id] = "promotion090trafficpermitgift",
    [promotionPros.gReqSpringFestivalGetDataInfo.id] = "promotion091Gashaponlotteryreward",
    [promotionPros.gReqDeliverFlowerGetData.id] = "promotion092config",
    [promotionPros.gReqSpringOutingGrid.id] = "promotion093randomreward",
    [promotionPros.gReqMakeEggScoreInfo.id] = "promotion094randomreward",
    [promotionPros.gReqSpringOutingGiftInfo.id] = "promotion095gift",
    [promotionPros.gReqSpringOutingMissionGetDataInfo.id] = "promotion096missionboxreward",
    -- 圣诞活动 五一抽奖
    [promotionPros.gReqLaborDayLuckDrawGetDataInfo.id] = "promotion097labordayreward",
}

function PromotionData:ctor()
    -- promotionpage配置缓存
    self.promotion_page_table = cfg.promotionpage.promotionpage

    self.server_promotion_name_map = ServerPromotionNameMap

    self.new_year_data = require("src.data.NewYearData"):new() --新春活动
    self.prom_war_order_data = require("src.data.PromWarOrderData"):new() --(运营活动类似战令id 90)
    self.customized_data = require("src.data.promotion.CustomizedData"):new() --私人订制活动
    self.magic_butterfly_data = require("src.data.promotion.MagicButterflyData"):new() --魔蝶
    self.luck_fish_data = require("src.data.promotion.LuckFishData"):new() --锦鲤
    self.shenyu_data = require("src.data.promotion.ShenYuData"):new() --神谕
    self.zhongqiu_data = require("src.data.promotion.ShangYueData"):new() --中秋

    -- 是否已经购买成长基金
    self.is_buy_foundation = false

    -- 签到数据[count,days,is_sign]
    self.sign_in = {}
    self.sign_in.count = 0
    self.sign_in.days = 0
    self.sign_in.is_sign = 0
    self.sign_in.month = 0
    self.sign_in.newServer = 0
    self.sign_in.charged = 0

    -- 每周福利数据[{idx,rmb,goods,hasNum}]
    self.week_gift = {}
    self.week_gift.list = {}
    self.week_gift.stime = 0
    self.week_gift.etime = 0
    self.week_gift.ctime = 0
    -- 超值礼包数据[{idx,rmb,goods,hasNum}]
    self.super_gift = {}
    self.super_gift.list = {}
    self.super_gift.start_time = 0
    self.super_gift.end_time = 0
    self.super_gift.ctime = 0

    -- 每日福利数据[{idx,rmb,goods,hasNum}]
    self.daily_welfare = {}

    -- 每月福利数据[{idx,rmb,goods,hasNum}]
    self.mouth_welfare = {}
    self.mouth_welfare.list = {}
    self.mouth_welfare.stime = 0
    self.mouth_welfare.etime = 0
    self.mouth_welfare.ctime = 0

    ---等级升级礼包数据
    self.level_up_data = {}
    self.level_up_data.etime = 0
    self.level_up_data.list = {}
    self.level_up_data.stime = 0
    self.level_up_data.ctime = 0

    self.invitation = {}
    self.invitation.role_list = {}
    self.invitation.gift_list = {}
    self.invitation.code = ""
    self.invitation.status = 0

    self.limit_shop_data = {}
    self.limit_shop_data.stime = 0
    self.limit_shop_data.etime = 0
    self.limit_shop_data.ctime = 0

    ----先知召唤
    self.prophecy_data = {}
    self.prophecy_data.list = {}

    ---好胜者-
    self.pvp_wins_data = {}
    self.pvp_wins_data.stime = 0
    self.pvp_wins_data.etime = 0
    self.pvp_wins_data.ctime = 0
    self.pvp_wins_data.list = {}

    self.mark_hero_data = {}
    self.mark_hero_data.stime = 0
    self.mark_hero_data.etime = 0
    self.mark_hero_data.ctime = 0
    self.mark_hero_data.nvalue = 0
    self.mark_hero_data.list = {}

    -------召唤达标
    self.summon_times_data = {}
    self.summon_times_data.nvalue = 0
    self.summon_times_data.round = 0
    self.summon_times_data.list = {}

    -------召唤吃达标
    self.blessing_pool_data = {}
    self.blessing_pool_data.nvalue = 0
    self.blessing_pool_data.round = 0
    self.blessing_pool_data.list = {}

    -----点金
    self.buy_gold_data = {}
    self.buy_gold_data.stime = 0
    self.buy_gold_data.etime = 0
    self.buy_gold_data.ctime = 0
    self.buy_gold_data.num = 0
    self.buy_gold_data.list = {}
    self.buy_gold_data.listRank = {}
    self.buy_gold_data.myRank = 1

    ---活动限时兑换礼包
    self.time_exchange_data = {}
    self.time_exchange_data.stime = 0
    self.time_exchange_data.etime = 0
    self.time_exchange_data.ctime = 0
    self.time_exchange_data.list = {}
    self.time_exchange_data.change_list = {}
    self.time_exchange_data.nvalue = 0

    self.adventure_data = {}
    self.adventure_data.stime = 0
    self.adventure_data.etime = 0
    self.adventure_data.ctime = 0
    self.adventure_data.nvalue = 0
    self.adventure_data.list = {}
    self.adventure_data.listRank = {}
    self.adventure_data.myRank = 0

    self.pve_monster_data = {}
    self.pve_monster_data.stime = 0
    self.pve_monster_data.etime = 0
    self.pve_monster_data.ctime = 0
    self.pve_monster_data.data = {}
    self.pve_monster_data.reward = {}

    ----------------------英雄祭坛------
    self.alter_hero_data = {}
    self.alter_hero_data.list = {}

    self.tavern_weekly_data = {}
    self.tavern_weekly_data.stime = 0
    self.tavern_weekly_data.etime = 0
    self.tavern_weekly_data.ctime = 0
    self.tavern_weekly_data.nvalue = 0
    self.tavern_weekly_data.list = {}
    self.tavern_weekly_data.listRank = {}
    self.tavern_weekly_data.myRank = 0

    self.speed_fight_data = {}
    self.speed_fight_data.stime = 0
    self.speed_fight_data.etime = 0
    self.speed_fight_data.ctime = 0
    self.speed_fight_data.nvalue = 0
    self.speed_fight_data.list = {}
    self.speed_fight_data.listRank = {}
    self.speed_fight_data.myRank = 0

    -- 积天豪礼[days,completed,is_award]
    self.recharge_days = {}
    self.recharge_days.days = 0
    self.recharge_days.completed = 0
    self.recharge_days.is_award = false
    self.recharge_days.data = {}
    -- 周累计充值[completed,{idx,is_award}
    self.recharge_week = {}
    self.recharge_week.completed = 0
    self.recharge_week.item = {}

    -- 月卡 [{card_type,completed,gain_days,over_time,is_gain}]
    self.month_card = {}

    -- 限时英雄升级礼包[{gift_id,idx,last_time}]
    self.limit_gift = {}

    -- 每日首充[is_award,completed]
    self.daily_first_recharge = {}

    -- 超值首充 6元 100元 [completed,{type,idx,state}]
    self.recharge_first = {}
    self.recharge_first.completed = 0
    self.recharge_first.award = {}

    --周向阳
    --超值赠礼
    self.supre_gift_data = {}

    -- 月度回馈(计划) [{invest_type,receive_day,reach_day,is_today_got}]
    self.month_invest = {}
    self.month_invest_start_time = 0
    self.month_invest_end_time = 0
    self.month_invest_status = 0

    -- 成长基金领取情况.  [idx]
    self.foundation_list = {}

    -- VIP奖励购买情况.  [idx]
    self.vip_list = {}

    -- vip月卡领取
    self.vip_reward = false

    -- 每日限购礼包购买情况 [{idx,num,time}]
    self.day_limit_list = {}

    -- 是否已经领取每日奖励
    self.day_limit_reward = 0

    -- 特权礼包数据
    self.privilege_gift_data = {}
    self.privilege_gift_list = {}

    -- 新服限购
    self.new_server_limit_end_time = 0 -- 结束时间
    self.new_server_limit_list = {} -- 数据列表

    -- 每日累充
    self.daily_total_recharge_list = {}
    self.daily_total_recharge_money = 0
    -- 中秋特惠
    self.mid_autumn_info_timer = nil
    self.mid_autumn_info = {}

    -- 召唤水晶
    self.summon_crystal_info = {}

    -- 占星阵任务
    self.astrology_task_info = {}

    -- 酒馆达标
    self.pub_arrive_info = {}
    self.pub_arrive_info.end_time = 0
    self.pub_arrive_info.begin_time = 0
    self.pub_arrive_info.clear_time = 0
    -- 成长礼包
    self.growUpList = {}
    self.growUpRed = {}

    -- 通用活动数据
    self.CommonActivityData = {}
    self.act_adv_note_promotion_id = 29
    self.act_mystery_box_promotion_id = 30
    self.act_happy_month_promotion_id = 35
    -- 七彩华章
    self.ColorfulShopData = {}
    -- 登录有礼
    self.LoginGiftData = {}
    -- 碎片进化
    self.ExchangeShopData = {}

    self.running_promotion_data = {}

    self.save_festivanew_data = {}
    self.save_festivanew_data.list = {}
    self.save_festivanew_data.now_day = 0

    -- 节日豪礼
    self.festival_overvalue_gift = {}

    -- 超值养成礼
    self.is_develop_gift_dirty = false
    self.develop_gift = {}

    -- 限时抢购
    self.limit_buy_data = {}

    self.save_select_time_limit_type = 0

    -- 周末礼包
    self.weekend_gift_promotion_id = 55
    self.weekend_gift_data = {}
    self.weekend_gift_data.begin_time = 0
    self.weekend_gift_data.end_time = 0
    self.weekend_gift_data.reward_status = {}

    -- 购买皮肤
    self.buy_skin_reward_list = {}

    -- 召唤周卡
    self.summon_week_card_data = {}
    -- 超级召唤周卡
    self.super_summon_week_card_data = {}

    -- 一元礼包
    self.three_day_gift_data = {}

    self.promotion7daytargetpoint_value = {}
    self.promotion7daytarget_value = {}
    self.promotion7daytargeticon_value = {}

    -- 98元充值奖励[days,completed,is_award]
    self.recharge_reward = {}
    self.recharge_reward.days = 0
    self.recharge_reward.completed = 0
    self.recharge_reward.is_award = false
    self.recharge_reward.data = {}

    -- 龙舟活动
    -- 界面一的宝箱进度条数据
    self.promotiondragonboattaskinfo_value = {}

    -- 奇珍异宝
    self.promotion_timetreasureinfo = {}

    -- 功能预告
    self.promotion66_receive_time = 0
    self.promotion66_config = nil
    self.promotion66_start_time = 0
    self.promotion66_end_time = 0

    -- 梦境秘宝
    self.promotion70_mission = {}
    self.promotion70_game_info = nil
    self.promotion70_rewards = {}
    self.promotion70_choose_rewards = nil

    -- 七神器
    self.promotion71_buy_record = {}
    self.promotion71_is_get_info = false

    -- 储值重置
    self.promotion73_is_reset = false

    -- 赏月任务
    self.promotion77_mission = {}
    self.promotion77_mission_box_reward_record = {}
    self.promotion77_open_day = 0

    -- 惊喜扭蛋
    self.promotion78_data = {}
    -- 鬼怪巡游会
    self.promotion79_buy_record = {}
    self.promotion79_is_get_info = false

    -- 万圣任务
    self.promotion80_mission = {}
    self.promotion80_mission_box_reward_record = {}
    self.promotion80_open_day = 0

    -- 黑色星期五
    self.promotion81_mission = {}
    self.promotion81_mission_box_reward_record = {}
    self.promotion92_data = {}

    -- 圣诞活动 圣诞连线
    self.promotion85_mission = {}
    self.promotion85_mission_box_reward_record = {}
    self.promotion85_open_day = 0
    -- 圣诞活动-约会圣诞
    self.promotion86_buy_record = {}
    self.promotion86_is_get_info = false
    --惊喜盲盒数据
    self.promotion91_blind_box_reward = nil
    self.promotion91_break_egg_data = nil

    -- 春日活动
    self.promotion96_mission = {}
    self.promotion96_mission_box_reward_record = {}
    self.promotion96_open_day = 0
    self.promotion95_buy_record = {}
    self.promotion95_is_get_info = false

    --五一活动
    self.promotion097Info = {}

    self:addEventTemp(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM,handler(self,self.checkExchangeShopRedDot)) 
   
end

function PromotionData:addEventTemp(event,listener)
    if not self.eventList then self.eventList = {} end
    table.insert(self.eventList,ex.EventManager:add(event,listener))
end

function PromotionData:saveSelectTimeLimitType(num)
    self.save_select_time_limit_type = num
end

-- 整体 更新活动 函数
function PromotionData:nextDayRefreshPromotion()
    self:reqRunningPromotion()
end

-----------------------ProtocolID.GReqRunningPromotion---20101-----------统一活动协议-
function PromotionData:reqRunningPromotion()
    NetManager:sendMessage(ProtocolID.GReqRunningPromotion)
end

function PromotionData:setRunningPromotionData(data)
    self.running_promotion_data = {}

    for i, v in ipairs(data) do
        local model = {}
        model.id = v.id
        model.start_time = v.start_time
        model.end_time = v.end_time
        model.clear_time = v.clear_time
        model.turns = v.turns

        self:addOrUpdateRunningPromotionData(model)
    end

    for k, v in pairs(self.running_promotion_data) do
        for kp, vp in pairs(promotionPros) do
            if vp.id == v.id then
                NetManager:sendMessage(vp.reqProtoId)
            end
        end

        -- 储值重置特殊处理
        if v.id == 73 then
            local cur_time = ex.Game:getServerTime()
            if v.start_time and v.start_time < cur_time and not self.promotion73_is_reset then
                NetManager:sendMessage(ProtocolID.GReqShopRechargeCheck)
                self.promotion73_is_reset = true
            end
        end
    end

    -- 刷新大厅  add 熊梦
    -- 因为七日目标活动按钮是独立显示在大厅的 需要判断按钮的isVisible
    -- 当进入大厅的时候活动消息还未发送过来 所以要在接收到消息后刷新一次大厅按钮
    if ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAINCITY_LAYER then
        local layer = ex.MainSceneCtr:getCurLayer()
        layer:refreshBtnStatus()
    end
end

function PromotionData:addOrUpdateRunningPromotionData(data)
    if data == nil or data.id == nil then
        return
    end

    self.running_promotion_data[data.id] = data
end

function PromotionData:getTimeIsOpen(type)
    if self.running_promotion_data[type] then
        if self.running_promotion_data[type].start_time < ex.Game:getServerTime() and ex.Game:getServerTime() < self.running_promotion_data[type].clear_time then
            return true
        end
    end
    return false
end

function PromotionData:getPromotionTurns(type)
    if self.running_promotion_data[type] then
        return self.running_promotion_data[type].turns
    end
    return 0
end

function PromotionData:getPromotionDatas(type)
    if self.running_promotion_data[type] then
        return self.running_promotion_data[type]
    end
    return nil
end

-- 检测当前类型下活动开启情况
function PromotionData:checkActLimitTimeActivityIsOpen(layer_type)
    local vec_idx = ex.Player.promotion_data:getPromotionByType(layer_type)

    local isShow = false

    for i, v in ipairs(vec_idx) do
        local config = cfg.promotionpage.promotionpage[v.idx]
        if config then
            if v.checkopen ~= "" and self[v.checkopen] and self[v.checkopen](self) then
                isShow = true
            end
        end
    end
    return isShow
end

function PromotionData:saveEveryDayLogin(data)
    self.every_day_login = {}
    self.every_day_login.day_turns = data.day_turns
    self.every_day_login.task_list = data.task_list
    self.every_day_login.idx = data.idx

    self.every_day_login.list = {}

    for i, v in ipairs(cfg.promotioneverydaylogin.promotioneverydaylogin) do
        if self.every_day_login.day_turns == v.turns then
            local now_task = clone(v)
            now_task.is_obtain = 0
            for si, sv in ipairs(self.every_day_login.idx) do
                if v.idx == sv then
                    now_task.is_obtain = 1
                end
            end
            now_task.task_value = 0
            for ti, tv in ipairs(self.every_day_login.task_list) do
                if v.idx == tv.key then
                    now_task.task_value = tv.value
                end
            end

            now_task.jump_info_table = json.decode(now_task.jump_info)
            now_task.task_table = json.decode(now_task.task)

            now_task.is_end = 0
            if now_task.task_value >= now_task.task_table.target then
                now_task.is_end = 1
            end

            table.insert(self.every_day_login.list, now_task)
        end
    end
    self:checkEveryDayLoginRedDot()
end

function PromotionData:saveEveryDayLoginReward(data)
end

function PromotionData:updateEveryDayLoginTarget(data)
    for di, dv in pairs(data) do
        if self.every_day_login == nil then
            self.every_day_login = {}
        end
        if self.every_day_login.list == nil then
            self.every_day_login.list = {}
        end

        for i, v in ipairs(self.every_day_login.list) do
            if v.idx == dv.key then
                self.every_day_login.list[i].task_value = dv.value
                if dv.value >= v.task_table.target then
                    self.every_day_login.list[i].is_end = 1
                end
            end
        end
    end
    self:checkEveryDayLoginRedDot()
end

function PromotionData:changeEveryDayLoginData(idx)
    for i, v in ipairs(self.every_day_login.list) do
        if v.idx == idx then
            self.every_day_login.list[i].is_obtain = 1
        end
    end

    self:checkEveryDayLoginRedDot()
end

function PromotionData:gReqEveryDayLoginReward(idx)
    self:changeEveryDayLoginData(idx)

    local req = Promotion057_pb.GReqEveryDayLoginReward()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqEveryDayLoginReward, req)
end

function PromotionData:getEveryDayLoginData()
    return self.every_day_login
end

function PromotionData:checkEveryDayLoginRedDot()
    local show_red = false
    for i, v in ipairs(self.every_day_login.list) do
        if v.is_end == 1 and v.is_obtain == 0 then
            show_red = true
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_PFHD_MRDL, show_red)
    -- xianshi

    ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)
    return show_red
end

function PromotionData:checkEveryDayLoginIsOpen()
    local promotion_data = self.running_promotion_data[promotionPros.gReqEveryDayLoginPromotion.id]
    if not promotion_data then
        return false
    end
    if promotion_data.start_time <= ex.Game:getServerTime() and ex.Game:getServerTime() <= promotion_data.clear_time then
        return true
    end
    return false
end

-------------------------PVE 诸神之战--------------------------------

function PromotionData:sendGReqZhuShenData()
    NetManager:sendMessage(ProtocolID.GReqZhuShenData)
end

function PromotionData:checkPveMonsterIsOpen()
    return self:getTimeIsOpen(promotionPros.gReqZhuShenData.id)
end

function PromotionData:setPveMonsterList(type, level, hp)
    if self.pve_monster_data.data[type] then
        if self.pve_monster_data.data[type][level] then
            if hp > 0 then
                self.pve_monster_data.data[type][level].hp = hp
                self.pve_monster_data.data[type][level].is_success = false
            else
                self.pve_monster_data.data[type][level].hp = 0
                self.pve_monster_data.data[type][level].is_success = true
            end
        end
    end
end

function PromotionData:setNextPveMonster(type, level)
    if (level + 1) <= #self.pve_monster_data.data[type] then
        self.pve_monster_data.data[type][level + 1].hp = 10000
        self.pve_monster_data.data[type][level + 1].is_success = false
    end
end

function PromotionData:getPromotionPveMonsterDatas()
    return self.running_promotion_data[promotionPros.gReqZhuShenData.id]
end

function PromotionData:clearMonsterList()
    self.pve_monster_data = {}
    self.pve_monster_data.stime = 0
    self.pve_monster_data.etime = 0
    self.pve_monster_data.ctime = 0

    self.pve_monster_data.data = {}
    self.pve_monster_data.reward = {}

    local now_data = self:getPromotionPveMonsterDatas()
    for k, v in pairs(cfg.promotionpve.promotionpve) do
        if now_data.turns == v.turns and v.hero_type ~= 0 then
            local data = {}
            data.hp = v.hp
            data.atk_multiple = v.atk_multiple
            data.hero_type = v.hero_type
            data.hero_level = v.hero_level
            data.hero_star = v.hero_star
            if not self.pve_monster_data.data[v.mission_type] then
                self.pve_monster_data.data[v.mission_type] = {}
            end
            if not self.pve_monster_data.data[v.mission_type][v.mission_id] then
                self.pve_monster_data.data[v.mission_type][v.mission_id] = {}
            end
            self.pve_monster_data.data[v.mission_type][v.mission_id][v.pos] = data
            self.pve_monster_data.data[v.mission_type][v.mission_id].is_success = true
            self.pve_monster_data.data[v.mission_type][v.mission_id].hp = 0
        end
    end

    for k, v in pairs(cfg.promotionpvereward.promotionpvereward) do
        if now_data.turns == v.turns then
            if not self.pve_monster_data.reward[v.mission_type] then
                self.pve_monster_data.reward[v.mission_type] = {}
            end
            if not self.pve_monster_data.reward[v.mission_type][v.mission_id] then
                self.pve_monster_data.reward[v.mission_type][v.mission_id] = {}
            end
            local data = {}
            data.reward = v.final_reward
            data.name_lang = v.name_lang
            data.battle_type = v.battle_type

            self.pve_monster_data.reward[v.mission_type][v.mission_id] = data
        end
    end
end

function PromotionData:setPveMonsterTimes()
    local now_data = self:getPromotionPveMonsterDatas()
    self.pve_monster_data.stime = now_data.start_time
    self.pve_monster_data.etime = now_data.end_time
    self.pve_monster_data.ctime = now_data.clear_time
end

function PromotionData:checkMissionSuccess(mission_type)
    local flag = true
    for k, v in pairs(self.pve_monster_data.data[mission_type]) do
        if v.is_success == false then
            flag = false
            break
        end
    end
    return flag
end

function PromotionData:getMissionFromid(mission_type)
    local data = {}
    local key = 0
    for k, v in pairs(self.pve_monster_data.data[mission_type]) do
        if v.is_success == false then
            data = v
            key = k
            break
        end
    end
    return data, key
end

function PromotionData:getMissionForReward(type, index)
    return self.pve_monster_data.reward[type][index]
end

function PromotionData:reqBuyItem(count)
    local req = Promotion034_pb.GReqBuyItem()
    req.count = count
    NetManager:sendMessage(ProtocolID.GReqBuyItem, req)
end

function PromotionData:getBattleType(type)
    for k, v in pairs(cfg.battletype.battletype) do
        if v.type == type then
            return v
        end
    end
end

-------------------------签到--------------------------------

function PromotionData:reqSignInList()
    NetManager:sendMessage(ProtocolID.GReqSignInList)
end

function PromotionData:clearSignIn(count)
    self.sign_in.count = count
    self.sign_in.days = 0
    self.sign_in.is_sign = 0
    self.sign_in.month = 0
    self.sign_in.newServer = 0
    self.sign_in.charged = 0
end

function PromotionData:setSignIn(data)
    self.sign_in.days = data.days
    self.sign_in.is_sign = data.isSignIn
    self.sign_in.month = data.month
    self.sign_in.newServer = data.newServer
    self.sign_in.charged = data.charged
end

function PromotionData:clearLevelUpData()
    self.level_up_data = {}
    self.level_up_data.etime = 0
    self.level_up_data.stime = 0
    self.level_up_data.ctime = 0

    self.level_up_data.list = {}

    self.level_up_data.list = self:getMainLevelData()
end

function PromotionData:getMainLevelData()
    local level_data = {}
    local now_data = self:getPromotionLevelUpDatas()
    for k, v in pairs(cfg.promotionmainlevelreward.levelup) do
        if now_data.turns == v.turns then
            local data = {}
            data.idx = v.idx
            data.main_level = v.main_level
            data.reward = v.reward
            data.total_num = v.total_num
            data.is_obtain = 0
            data.hasNum = 0
            table.insert(level_data, data)
        end
    end

    local function sor(a, b)
        return a.main_level < b.main_level
    end
    table.sort(level_data, sor)
    return level_data
end

function PromotionData:setLevelUpETime(sTime, eTime, cTime)
    local data = self:getPromotionLevelUpDatas()
    self.level_up_data.stime = data.start_time
    self.level_up_data.etime = data.end_time
    self.level_up_data.ctime = data.clear_time
end

function PromotionData:getPromotionLevelUpDatas()
    return self.running_promotion_data[promotionPros.gReqLevelUpGiftList.id]
end

function PromotionData:getFestivalOvervalueGift()
    return self.running_promotion_data[promotionPros.gReqFestivalOvervalueGift.id]
end

function PromotionData:checkLevelUpIsOpen()
    if self.level_up_data.stime <= ex.Game:getServerTime() and ex.Game:getServerTime() <= self.level_up_data.ctime then
        return true
    end
    return false
end

function PromotionData:gReqLevelUpGiftList()
    NetManager:sendMessage(ProtocolID.GReqLevelUpGiftList)
end

function PromotionData:setLevelUpData(idx, value, is_obtain)
    for _, v in pairs(self.level_up_data.list) do
        if v.idx == idx then
            v.hasNum = value
            v.is_obtain = is_obtain
            return
        end
    end
end

function PromotionData:setSubLevelUpData(idx, is_obtain)
    for _, v in pairs(self.level_up_data.list) do
        if v.idx == idx then
            v.hasNum = v.hasNum - 1
            v.is_obtain = is_obtain
            return
        end
    end
end

function PromotionData:gReqLevelUpGift(idx)
    local req = Promotion019_pb.GReqLevelUpGift()
    req.gift_id = idx
    NetManager:sendMessage(ProtocolID.GReqLevelUpGift, req)
end

--------------------------英雄兑换----------------------------
function PromotionData:clearAlterHeroList()
    self.alter_hero_data = {}
    self.alter_hero_data.list = {}

    if cfg.promotionsacrificeshop ~= nil then
        for k, v in pairs(cfg.promotionsacrificeshop.promotionsacrificeshop) do
            local data = {}
            data.idx = v.idx
            data.chance = v.chance
            data.item_type = v.item_type
            data.need_item = v.need_item
            data.buy_limit = v.buy_limit
            data.hasNum = 0
            table.insert(self.alter_hero_data.list, data)
        end
    end
end

function PromotionData:setAlterHeroData(idx, value)
    for k, v in pairs(self.alter_hero_data.list) do
        if v.idx == idx then
            v.hasNum = value
        end
    end
end

function PromotionData:getAlterHeroListData()
    return self.alter_hero_data.list
end

function PromotionData:checkAlterHeroIsOpen()
    if cfg.promotionsacrificeshop == nil then
        print(">>>>>PromotionData:checkAlterHeroIsOpen not exist config!")
        return false
    end

    return self:getTimeIsOpen(promotionPros.gReqPromotionSacrificeShop.id)
end

function PromotionData:reqAlterHeroList()
    NetManager:sendMessage(ProtocolID.GReqPromotionSacrificeShop)
end

--------------------------快速战斗之路----------------------------
function PromotionData:clearSpeedFightList()
    self.speed_fight_data = {}
    self.speed_fight_data.stime = 0
    self.speed_fight_data.etime = 0
    self.speed_fight_data.ctime = 0
    self.speed_fight_data.nvalue = 0
    self.speed_fight_data.list = {}
    self.speed_fight_data.listRank = {}
    self.speed_fight_data.myRank = 0

    local now_data = self:getPromotionSpeedFightDatas()
    for k, v in pairs(cfg.promotionspeedfight.promotionspeedfight) do
        if now_data.turns == v.turns then
            local data = {}
            data.idx = v.idx
            data.count = v.speed_fight_times
            data.reward = v.reward
            data.is_obtain = 0
            table.insert(self.speed_fight_data.list, data)
        end
    end
end

function PromotionData:setSpeedFightTime(num)
    local now_data = self:getPromotionSpeedFightDatas()
    self.speed_fight_data.stime = now_data.start_time
    self.speed_fight_data.etime = now_data.end_time
    self.speed_fight_data.ctime = now_data.clear_time
    self.speed_fight_data.nvalue = num
end

function PromotionData:getPromotionSpeedFightDatas()
    return self.running_promotion_data[promotionPros.gReqSpeedFightCountData.id]
end

function PromotionData:getSpeedFightListTime()
    return self:getTimeIsOpen(promotionPros.gReqSpeedFightCountData.id)
end

function PromotionData:setSpeedFightData(idx, value)
    for k, v in pairs(self.speed_fight_data.list) do
        if v.idx == idx then
            v.is_obtain = 1
        end
    end
end

function PromotionData:checkSpeedFightIsOpen()
    if self.speed_fight_data.stime <= ex.Game:getServerTime() and ex.Game:getServerTime() <= self.speed_fight_data.ctime then
        return true
    end
    return false
end

function PromotionData:setSpeedFightRankData(data, myRank)
    local rank_data = {}
    for i, v in ipairs(data) do
        local now_data = {}
        now_data.player_id = v.player_id
        now_data.name = v.name
        now_data.clan_id = v.clan_id
        now_data.clan_name = v.clan_name
        now_data.clan_icon_id = v.clan_icon_id
        now_data.level = v.level
        now_data.head_id = v.head_id
        now_data.border_id = v.border_id
        now_data.complete_time = v.complete_time
        now_data.count = v.score
        now_data.server_id = v.server_id
        now_data.combat_num = v.combat_num
        now_data.rank = v.rank
        table.insert(rank_data, now_data)
    end

    self.speed_fight_data.listRank = rank_data
    self.speed_fight_data.myRank = myRank
end

function PromotionData:reqSpeedFightList()
    NetManager:sendMessage(ProtocolID.GReqSpeedFightCountData)
end

function PromotionData:reqSpeedFightRankList()
    NetManager:sendMessage(ProtocolID.GReqScanSpeedFightRank)
end

function PromotionData:reqSpeedFightGift(idx)
    local req = Promotion026_pb.GReqGetSpeedFightReward()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqGetSpeedFightReward, req)
end

--------------------------酒馆常客----------------------------
function PromotionData:clearTavernWeeklyList()
    self.tavern_weekly_data = {}
    self.tavern_weekly_data.stime = 0
    self.tavern_weekly_data.etime = 0
    self.tavern_weekly_data.ctime = 0
    self.tavern_weekly_data.nvalue = 0
    self.tavern_weekly_data.list = {}
    self.tavern_weekly_data.listRank = {}
    self.tavern_weekly_data.myRank = 0

    local now_data = self:getPromotionTavernWeeklyDatas()

    for k, v in pairs(cfg.promotiontavernweekly.promotiontavernweekly) do
        if now_data.turns == v.turns then
            local data = {}
            data.idx = v.idx
            data.count = v.tavern_finish_times
            data.reward = v.reward
            data.jump_info = v.jump_info
            data.is_obtain = 0
            table.insert(self.tavern_weekly_data.list, data)
        end
    end
end

function PromotionData:setTavernWeeklyTime(num)
    local now_data = self:getPromotionTavernWeeklyDatas()
    self.tavern_weekly_data.stime = now_data.start_time
    self.tavern_weekly_data.etime = now_data.end_time
    self.tavern_weekly_data.ctime = now_data.clear_time
    self.tavern_weekly_data.nvalue = num
end

function PromotionData:getPromotionTavernWeeklyDatas()
    return self.running_promotion_data[promotionPros.gReqTavernCountData.id]
end

function PromotionData:getTavernWeeklyListTime()
    return self:getTimeIsOpen(promotionPros.gReqTavernCountData.id)
end

function PromotionData:setTavernWeeklyData(idx, value)
    for k, v in pairs(self.tavern_weekly_data.list) do
        if v.idx == idx then
            v.is_obtain = 1
        end
    end
end

function PromotionData:checkTavernWeeklyIsOpen()
    if self.tavern_weekly_data.stime <= ex.Game:getServerTime() and ex.Game:getServerTime() <= self.tavern_weekly_data.ctime then
        return true
    end
    return false
end

function PromotionData:setTavernWeeklyRankData(data, myRank)
    local rank_data = {}
    for i, v in ipairs(data) do
        local now_data = {}
        now_data.player_id = v.player_id
        now_data.name = v.name
        now_data.clan_id = v.clan_id
        now_data.clan_name = v.clan_name
        now_data.clan_icon_id = v.clan_icon_id
        now_data.level = v.level
        now_data.head_id = v.head_id
        now_data.border_id = v.border_id
        now_data.complete_time = v.complete_time
        now_data.count = v.score
        now_data.server_id = v.server_id
        now_data.combat_num = v.combat_num
        now_data.rank = v.rank
        table.insert(rank_data, now_data)
    end

    self.tavern_weekly_data.listRank = rank_data
    self.tavern_weekly_data.myRank = myRank
end

function PromotionData:reqTavernWeeklyList()
    NetManager:sendMessage(ProtocolID.GReqTavernCountData)
end

function PromotionData:reqTavernWeeklyRankList()
    NetManager:sendMessage(ProtocolID.GReqScanTavernRank)
end

function PromotionData:reqTavernWeeklyGift(idx)
    local req = Promotion028_pb.GReqGetTavernReward()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqGetTavernReward, req)
end

--------------------------试炼之路----------------------------
function PromotionData:clearAdventureList()
    self.adventure_data = {}
    self.adventure_data.stime = 0
    self.adventure_data.etime = 0
    self.adventure_data.ctime = 0
    self.adventure_data.nvalue = 0
    self.adventure_data.list = {}
    self.adventure_data.listRank = {}
    self.adventure_data.myRank = 0

    local now_data = self:getPromotionAdventureDatas()

    for k, v in pairs(cfg.promotionadventure.promotionadventure) do
        if now_data.turns == v.turns then
            local data = {}
            data.idx = v.idx
            data.count = v.win_times
            data.reward = v.reward
            data.jump_info = v.jump_info
            data.is_obtain = 0
            table.insert(self.adventure_data.list, data)
        end
    end
end

function PromotionData:setAdventureTime(num)
    local now_data = self:getPromotionAdventureDatas()
    self.adventure_data.stime = now_data.start_time
    self.adventure_data.etime = now_data.end_time
    self.adventure_data.ctime = now_data.clear_time
    self.adventure_data.nvalue = num
end

function PromotionData:getPromotionAdventureDatas()
    return self.running_promotion_data[promotionPros.gReqAdventureCountData.id]
end

function PromotionData:getAdventureListListTime()
    return self:getTimeIsOpen(promotionPros.gReqAdventureCountData.id)
end

function PromotionData:setAdventureData(idx, value)
    for k, v in pairs(self.adventure_data.list) do
        if v.idx == idx then
            v.is_obtain = 1
        end
    end
end

function PromotionData:checkAdventureIsOpen()
    if self.adventure_data.stime <= ex.Game:getServerTime() and ex.Game:getServerTime() <= self.adventure_data.ctime then
        return true
    end
    return false
end

function PromotionData:setAdventureRankData(data, myRank)
    local rank_data = {}
    for i, v in ipairs(data) do
        local now_data = {}
        now_data.player_id = v.player_id
        now_data.name = v.name
        now_data.clan_id = v.clan_id
        now_data.clan_name = v.clan_name
        now_data.clan_icon_id = v.clan_icon_id
        now_data.level = v.level
        now_data.head_id = v.head_id
        now_data.border_id = v.border_id
        now_data.complete_time = v.complete_time
        now_data.count = v.score
        now_data.server_id = v.server_id
        now_data.combat_num = v.combat_num
        now_data.rank = v.rank
        table.insert(rank_data, now_data)
    end

    self.adventure_data.listRank = rank_data
    self.adventure_data.myRank = myRank
end

function PromotionData:reqAdventureList()
    NetManager:sendMessage(ProtocolID.GReqAdventureCountData)
end

function PromotionData:reqAdventureRankList()
    NetManager:sendMessage(ProtocolID.GReqScanAdventureRank)
end

function PromotionData:reqAdventureGift(idx)
    local req = Promotion027_pb.GReqGetAdventureReward()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqGetAdventureReward, req)
end

--------------------------点金活动----------------------------
function PromotionData:clearBuyGoldList()
    self.buy_gold_data = {}
    self.buy_gold_data.stime = 0
    self.buy_gold_data.etime = 0
    self.buy_gold_data.ctime = 0
    self.buy_gold_data.num = 0
    self.buy_gold_data.list = {}
    self.buy_gold_data.listRank = {}
    self.buy_gold_data.myRank = 0

    local now_data = self:getPromotionBuyGoldDatas()

    for k, v in pairs(cfg.promotionbuygold.promotionbuygold) do
        if now_data.turns == v.turns then
            local data = {}
            data.idx = v.idx
            data.count = v.buy_gold_times
            data.reward = v.reward
            data.is_obtain = 0
            table.insert(self.buy_gold_data.list, data)
        end
    end
    self:reqBuyGoldRankList()
end

function PromotionData:setBuyGoldTime(num)
    local now_data = self:getPromotionBuyGoldDatas()
    self.buy_gold_data.stime = now_data.start_time
    self.buy_gold_data.etime = now_data.end_time
    self.buy_gold_data.ctime = now_data.clear_time
    self.buy_gold_data.num = num
end

function PromotionData:setBuyGoldData(idx, value)
    for k, v in pairs(self.buy_gold_data.list) do
        if v.idx == idx then
            v.is_obtain = 1
        end
    end
end

function PromotionData:checkBuyGoldIsOpen()
    if self.buy_gold_data.stime <= ex.Game:getServerTime() and ex.Game:getServerTime() <= self.buy_gold_data.ctime then
        return true
    end
    return false
end

function PromotionData:setBuyGoldRankData(data, myRank)
    local rank_data = {}
    for i, v in ipairs(data) do
        local now_data = {}
        now_data.player_id = v.player_id
        now_data.name = v.name
        now_data.clan_id = v.clan_id
        now_data.clan_name = v.clan_name
        now_data.clan_icon_id = v.clan_icon_id
        now_data.level = v.level
        now_data.head_id = v.head_id
        now_data.border_id = v.border_id
        now_data.complete_time = v.complete_time
        now_data.count = v.score
        now_data.server_id = v.server_id
        now_data.combat_num = v.combat_num
        now_data.rank = v.rank
        table.insert(rank_data, now_data)
    end

    self.buy_gold_data.listRank = rank_data
    self.buy_gold_data.myRank = myRank
end

function PromotionData:getPromotionBuyGoldDatas()
    return self.running_promotion_data[promotionPros.gReqBuyGoldCountData.id]
end

function PromotionData:getbuyGoldListTime()
    return self:getTimeIsOpen(promotionPros.gReqBuyGoldCountData.id)
end

function PromotionData:reqBuyGoldList()
    NetManager:sendMessage(ProtocolID.GReqBuyGoldCountData)
end

function PromotionData:reqBuyGoldRankList()
    NetManager:sendMessage(ProtocolID.GReqScanBuyGoldRank)
end

function PromotionData:reqBuyGoldGift(idx)
    local req = Promotion025_pb.GReqGetBuyGoldReward()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqGetBuyGoldReward, req)
end

-------------------------先知召唤--------------------------------
function PromotionData:clearProphecyData()
    self.prophecy_data = {}
    self.prophecy_data.nvalue = 0
    self.prophecy_data.list = {}

    if cfg.promotionprophecytimes ~= nil then
        for k, v in pairs(cfg.promotionprophecytimes.promotionprophecytimes) do
            local data = {}
            data.idx = v.idx
            data.count = v.play_times
            data.reward = v.reward
            data.is_obtain = 0
            table.insert(self.prophecy_data.list, data)
        end
    end
end

function PromotionData:setProphecyData(idx, value)
    for k, v in pairs(self.prophecy_data.list) do
        if v.idx == idx then
            v.is_obtain = value
        end
    end
end

function PromotionData:saveProphecyTime(nvalue, round)
    self.prophecy_data.nvalue = nvalue
    self.prophecy_data.round = round
end

function PromotionData:checkProphecytimesIsOpen()
    if cfg.promotionprophecytimes == nil then
        print(">>>>>PromotionData:checkProphecytimesIsOpen not exist config!")
        return false
    end

    return self:getTimeIsOpen(promotionPros.gReqProphecyList.id)
end

function PromotionData:reqProphecyGift(idx)
    local req = Promotion041_pb.GReqProphecyTimesGift()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqProphecyTimesGift, req)
end

function PromotionData:reqProphecyLists()
    NetManager:sendMessage(ProtocolID.GReqProphecyList)
end

-------------------------好胜者--------------------------------

function PromotionData:clearPvpWinsData()
    self.pvp_wins_data = {}
    self.pvp_wins_data.stime = 0
    self.pvp_wins_data.etime = 0
    self.pvp_wins_data.ctime = 0
    self.pvp_wins_data.nvalue = 0
    self.pvp_wins_data.list = {}

    local now_data = self:getPromotionPvpWinsDatas()
    for k, v in pairs(cfg.promotionpvpwins.promotionpvpwins) do
        if now_data.turns == v.turns then
            local data = {}
            data.idx = v.idx
            data.count = v.pvp_win_times
            data.reward = v.reward
            data.is_obtain = 0
            table.insert(self.pvp_wins_data.list, data)
        end
    end
end

function PromotionData:getPvpwinsListTime()
    return self:getTimeIsOpen(promotionPros.gReqPvpwinList.id)
end

function PromotionData:setPvpWinsData(idx, value)
    for k, v in pairs(self.pvp_wins_data.list) do
        if v.idx == idx then
            v.is_obtain = value
        end
    end
end

function PromotionData:savePvpWinsTime(nvalue)
    self.pvp_wins_data.nvalue = nvalue
    local data = self:getPromotionPvpWinsDatas()
    self.pvp_wins_data.stime = data.start_time
    self.pvp_wins_data.etime = data.end_time
    self.pvp_wins_data.ctime = data.clear_time
end

function PromotionData:getPromotionPvpWinsDatas()
    return self.running_promotion_data[promotionPros.gReqPvpwinList.id]
end

function PromotionData:checkPvpwinsIsOpen()
    if self.pvp_wins_data.stime <= ex.Game:getServerTime() and ex.Game:getServerTime() <= self.pvp_wins_data.ctime then
        return true
    end
    return false
end

function PromotionData:reqPvpWinsLists()
    -- 	local req = cpp.ByteArray:create()
    -- 	req:writeInt(ProtocolID.GReqPvpwinList)
    -- 	cpp.NetManager:instance():sendByteArray(req)

    NetManager:sendMessage(ProtocolID.GReqPvpwinList)
end

function PromotionData:reqPvpWinsGift(idx)
    -- local req = cpp.ByteArray:create()
    -- req:writeInt(ProtocolID.GReqPvpwinTimesGift)
    -- req:writeInt(idx)
    -- cpp.NetManager:instance():sendByteArray(req)

    local req = Promotion031_pb.GReqPvpwinTimesGift()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqPvpwinTimesGift, req)
end

-------------------------合成任务--------------------------------
function PromotionData:clearMarkHeroData()
    self.mark_hero_data = {}
    self.mark_hero_data.stime = 0
    self.mark_hero_data.etime = 0
    self.mark_hero_data.ctime = 0
    self.mark_hero_data.nvalue = 0
    self.mark_hero_data.list = {}

    local now_data = self:getPromotionMarkHeroDatas()
    for k, v in pairs(cfg.promotioncombine.promotioncombine) do
        if now_data.turns == v.turns then
            local data = {}
            data.idx = v.idx
            data.count = v.reward_limit
            data.reward = v.reward
            data.star = v.star
            data.hasNum = 0
            data.cnt = 0
            table.insert(self.mark_hero_data.list, data)
        end
    end
end

function PromotionData:setMarkHeroData(idx, value, cnt)
    for k, v in pairs(self.mark_hero_data.list) do
        if v.idx == idx then
            v.hasNum = value
            v.cnt = cnt
        end
    end
end

function PromotionData:saveMarkHeroTime()
    local now_data = self:getPromotionMarkHeroDatas()
    self.mark_hero_data.stime = now_data.start_time
    self.mark_hero_data.etime = now_data.end_time
    self.mark_hero_data.ctime = now_data.clear_time
end

function PromotionData:getPromotionMarkHeroDatas()
    return self.running_promotion_data[promotionPros.gReqMarkHeroList.id]
end

function PromotionData:getMarkHeroListTime()
    return self:getTimeIsOpen(promotionPros.gReqMarkHeroList.id)
end

function PromotionData:checkMakeHeroIsOpen()
    if self.mark_hero_data.stime <= ex.Game:getServerTime() and ex.Game:getServerTime() <= self.mark_hero_data.ctime then
        return true
    end
    return false
end

function PromotionData:reqMarkHeroLists()
    NetManager:sendMessage(ProtocolID.GReqMarkHeroList)
end

function PromotionData:reqMarkHeroGift(idx)
    local req = Promotion033_pb.GReqMarkHeroGift()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqMarkHeroGift, req)
end

---------------

-------------------------许愿池达标--------------------------------
function PromotionData:clearBlessingPoolData()
    self.blessing_pool_data = {}
    self.blessing_pool_data.nvalue = 0
    self.blessing_pool_data.round = 0
    self.blessing_pool_data.list = {}

    if cfg.promotionwishpool ~= nil then
        for k, v in pairs(cfg.promotionwishpool.promotionwishpool) do
            local data = {}
            data.idx = v.idx
            data.count = v.times
            data.reward = v.reward
            data.is_obtain = 0
            table.insert(self.blessing_pool_data.list, data)
        end
    end
end

function PromotionData:setBlessingPoolData(idx, value)
    for k, v in pairs(self.blessing_pool_data.list) do
        if v.idx == idx then
            v.is_obtain = value
        end
    end
end

function PromotionData:checkIsNextRoundBlessingPool()
    for i, v in ipairs(self.blessing_pool_data.list) do
        if v.is_obtain == 0 then -- 有未领取的
            return
        end
    end

    -- 都领了，则重新请求数据
    self:reqBlessingPoolLists()
end

function PromotionData:saveBlessingPoolTime(nvalue, round)
    self.blessing_pool_data.nvalue = nvalue
    self.blessing_pool_data.round = round
end

function PromotionData:checkBlessingPoolIsOpen()
    if cfg.promotionwishpool == nil then
        print(">>>>>PromotionData:checkBlessingPoolIsOpen not exist config!!!")
        return false
    end

    return self:getTimeIsOpen(promotionPros.gReqBlessingPoolLists.id)
end

function PromotionData:reqBlessingPoolLists()
    NetManager:sendMessage(ProtocolID.GReqBlessingPoolLists)
end

function PromotionData:reqBlessingPoolGift(idx)
    local req = Promotion037_pb.GReqBlessingPoolGift()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqBlessingPoolGift, req)
end

-------------------------召唤达标--------------------------------
function PromotionData:clearSummonTimesData()
    self.summon_times_data = {}
    self.summon_times_data.nvalue = 0
    self.summon_times_data.round = 0
    self.summon_times_data.list = {}

    if cfg.promotionsummontimes ~= nil then
        for k, v in pairs(cfg.promotionsummontimes.promotionsummontimes) do
            local data = {}
            data.idx = v.idx
            data.count = v.summon_times
            data.reward = v.reward
            data.is_obtain = 0
            table.insert(self.summon_times_data.list, data)
        end
    end
end

function PromotionData:setSummonTimesData(idx, value)
    for k, v in pairs(self.summon_times_data.list) do
        if v.idx == idx then
            v.is_obtain = value
        end
    end
end

function PromotionData:saveSummonTimesTime(nvalue, round)
    self.summon_times_data.nvalue = nvalue
    self.summon_times_data.round = round
end

function PromotionData:checkSummontimesIsOpen()
    if cfg.promotionsummontimes == nil then
        print(">>>>>PromotionData:checkSummontimesIsOpen not exist config!")
        return false
    end

    return self:getTimeIsOpen(promotionPros.gReqSummonList.id)
end

function PromotionData:reqSummonTimesLists()
    NetManager:sendMessage(ProtocolID.GReqSummonList)
end

function PromotionData:reqSummonTimesGift(idx)
    local req = Promotion040_pb.GReqSummonTimesGift()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqSummonTimesGift, req)
end

function PromotionData:checkIsNextRoundSummonTimes()
    for i, v in ipairs(self.summon_times_data.list) do
        if v.is_obtain == 0 then -- 有未领取的
            return
        end
    end

    -- 都领了，则重新请求数据
    self:reqSummonTimesLists()
end

-------------------------活动限时兑换礼包--------------------------------
function PromotionData:cleartimeExchangeData()
    self.time_exchange_data = {}
    self.time_exchange_data.stime = 0
    self.time_exchange_data.etime = 0
    self.time_exchange_data.ctime = 0

    self.time_exchange_data.stime1 = 0
    self.time_exchange_data.etime1 = 0
    self.time_exchange_data.ctime1 = 0

    self.time_exchange_data.list = {}
    self.time_exchange_data.change_list = {}
    self.time_exchange_data.nvalue = 0

    local now_data = self:getPromotionExchangeListDatas()

    for k, v in pairs(cfg.promotiondragonmarkshops.promotiondragonmarkshops) do
        if now_data.turns == v.turns then
            local data = {}
            data.index = v.idx

            data.goods = {}
            data.goods.item_type = v.item[1].item_type
            data.goods.item_num = v.item[1].item_num

            data.need = {}
            data.need.item_type = v.cost[1].item_type
            data.need.item_num = v.cost[1].item_num

            data.limit = {}
            data.limit.count = v.limit
            data.limit.times = 0 --

            data.seting = {}
            data.seting.mark_icon = v.mark_icon
            data.seting.show_mark = v.show_mark

            table.insert(self.time_exchange_data.list, data)
        end
    end

    local now_data = self:getPromotionLimitedtimeRechargeRewardDatas()
    if not now_data then return end 
    for k, v in pairs(cfg.promotiondragonmarktotalcharge.promotiondragonmarktotalcharge) do
        if now_data.turns == v.turns then
            local data = {}
            data.idx = v.idx
            data.count = v.rmb
            data.reward = v.reward
            data.is_obtain = 0
            table.insert(self.time_exchange_data.change_list, data)
        end
    end
end

function PromotionData:setTimeExchange(nvalue)
    local data = self:getPromotionLimitedtimeRechargeRewardDatas()
    self.time_exchange_data.stime1 = data.start_time
    self.time_exchange_data.etime1 = data.end_time
    self.time_exchange_data.ctime1 = data.clear_time
    self.time_exchange_data.nvalue = nvalue
end

function PromotionData:getPromotionLimitedtimeRechargeRewardDatas()
    return self.running_promotion_data[promotionPros.gReqLimitedtimeRechargeReward.id]
end

function PromotionData:checkPromotionLimitedtimeRechargeRewardIsOpen()
    return self:getTimeIsOpen(promotionPros.gReqLimitedtimeRechargeReward.id)
end

function PromotionData:setTimeExchangeTime()
    local data = self:getPromotionExchangeListDatas()
    self.time_exchange_data.stime = data.start_time
    self.time_exchange_data.etime = data.end_time
    self.time_exchange_data.ctime = data.clear_time
end

function PromotionData:getPromotionExchangeListDatas()
    return self.running_promotion_data[promotionPros.gReqExchangeList.id]
end

function PromotionData:setTimeExchangeData(index, value)
    for k, v in pairs(self.time_exchange_data.list) do
        if v.index == index then
            v.limit.times = value
        end
    end
end

function PromotionData:buyShopTimeExchangeItem(index)
    for k, v in pairs(self.time_exchange_data.list) do
        if v.index == index then
            v.limit.times = v.limit.times + 1
        end
    end
end

function PromotionData:SetExchangeList(index, value)
    for k, v in pairs(self.time_exchange_data.change_list) do
        if v.idx == index then
            v.is_obtain = value
        end
    end
end

function PromotionData:reqExchangeGift(idx)
    local req = Promotion017_pb.GReqPropomtionLimitedtimeReward()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqPropomtionLimitedtimeReward, req)
end

function PromotionData:checkExchangeIsOpen()
    if self.time_exchange_data.stime <= ex.Game:getServerTime() and ex.Game:getServerTime() <= self.time_exchange_data.ctime then
        return true
    end
    return false
end

function PromotionData:checkExchangeLimitIsOpen()
    if self.time_exchange_data.stime <= ex.Game:getServerTime() and ex.Game:getServerTime() <= self.time_exchange_data.ctime then
        return true
    end
    return false
end

function PromotionData:clearInvitationList()
    self.invitation = {}
    self.invitation.role_list = {}
    self.invitation.gift_list = {}
    self.invitation.status = 0
    self.invitation.code = ""

    for k, v in pairs(cfg.promotioninvite.promotioninvite) do
        local data = {}
        data.idx = v.idx
        data.type = v.type
        data.num = v.num
        data.reward = v.reward
        data.gain_limit = v.gain_limit
        data.now_limit = 0
        data.max_limit = 0
        table.insert(self.invitation.gift_list, data)
    end
end

function PromotionData:setInvitationList(role_list, code, status)
    self.invitation.role_list = {}
    self.invitation.role_list = role_list
    self.invitation.code = code
    self.invitation.status = status
end

function PromotionData:setInvitationStatus(status)
    self.invitation.status = status
end

function PromotionData:setInvitationGidtList(idx, had_Reward_count, max_Reward_count)
    for k, v in pairs(self.invitation.gift_list) do
        if v.idx == idx then
            v.now_limit = had_Reward_count
            v.max_limit = max_Reward_count
        end
    end
end

function PromotionData:reqInvitationList()
    NetManager:sendMessage(ProtocolID.GReqInvitationList)
end

function PromotionData:reqInvitationGift(idx)
    local req = InviteGift_pb.GReqInviteReward()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqInviteReward, req)
end

function PromotionData:reqUseInvitationCode(code)
    local req = InviteGift_pb.GReqInviteUseCode()
    req.use_code = code
    NetManager:sendMessage(ProtocolID.GReqInviteUseCode, req)
end

--------------------------promotionweeklygift-----------
function PromotionData:changeListItem(list, idx, turns)
    for k, v in pairs(list) do
        if v.production_id == idx and v.turns == turns then
            return v
        end
    end
    return nil
end

-------------------------每周福利--------------------------------
function PromotionData:clearWeekGift()
    self.week_gift = {}
    self.week_gift.list = {}
    self.week_gift.stime = 0
    self.week_gift.etime = 0
    self.week_gift.ctime = 0

    local now_week_data = self:getPromotionWeekGiftDatas()
    self.week_gift.stime = now_week_data.start_time
    self.week_gift.etime = now_week_data.end_time
    self.week_gift.ctime = now_week_data.clear_time

    for _, v in pairs(cfg.promotionweeklygift.promotionweeklygift) do
        if now_week_data.turns == v.turns and (v.appear_level == nil or v.appear_level <= ex.Player.level) then
            local data = {}

            data.idx = v.idx
            data.production_id = v.production_id
            data.goods = v.gift_reward
            data.hasNum = v.buy_limit

            --替换物品
            local buy_gem_config = cfg.buygem.buygem[data.production_id]
            data.rmb = buy_gem_config.rmb

            table.insert(self.week_gift.list, data)
        end
    end
end

function PromotionData:checkWeekChecIsOpen()
    return self:getTimeIsOpen(promotionPros.gReqWeeklyGiftData.id)
end

function PromotionData:getPromotionWeekGiftDatas()
    return self.running_promotion_data[promotionPros.gReqWeeklyGiftData.id]
end

function PromotionData:subWeekGiftNum(idx, buyCount)
    local now_data = self:getPromotionWeekGiftDatas()

    local change_data = self:changeListItem(cfg.promotionweeklygift.promotionweeklygift, idx, now_data.turns)
    self:setWeekGiftNumData(change_data.idx, buyCount)
end

function PromotionData:setWeekGiftNumData(idx, buyCount)
    for _, v in pairs(self.week_gift.list) do
        if v.idx == idx then
            v.hasNum = v.hasNum - buyCount
            return
        end
    end
end

function PromotionData:setWeekGiftNum(idx, buyCount)
    for _, v in pairs(self.super_gift) do
        if v.idx == idx then
            v.hasNum = v.hasNum - buyCount
            return
        end
    end
end

------------------------------超值礼包---------------------------
function PromotionData:setOverValueData(tab)
    self.super_gift = tab
end

function PromotionData:getTimesOverValueForIdx(idx)
    if idx == nil then
        return 0
    end

    for i, v in ipairs(self.super_gift.list) do
        if v.idx == idx then
            return v.buy_times
        end
    end

    return 0
end

function PromotionData:canBuyOverValueForIdx(idx)
    if idx == nil then
        return 0
    end

    local buy_times = self:getTimesOverValueForIdx(idx)

    for k, v in pairs(cfg.promotionovervaluegift.promotionovervaluegift) do
        if v.idx == idx then
            return buy_times < v.buy_limit
        end
    end

    return false
end

function PromotionData:checkOverValueIsOpen()
    if cfg.promotionovervaluegift == nil then
        print(">>>>>PromotionData:checkOverValueIsOpen not exist config!")
        return false
    end

    if self.super_gift == nil or next(self.super_gift) == nil then
        return false
    end

    return self:getTimeIsOpen(promotionPros.gReqOverValueData.id)
end

-------------------------积天豪礼--------------------------------
function PromotionData:reqRechargeDays()
    NetManager:sendMessage(ProtocolID.GReqRechargeDaysList)
end

function PromotionData:setRechargeDays(server_data, recharge_day)
    self.recharge_days.data = {}
    self.recharge_days.days = recharge_day
    for i, v in ipairs(cfg.promotionrechargedays.recharge) do
        local ndata = {}
        ndata.day = v.day
        ndata.item = v.item
        ndata.has_reward = 0
        ndata.money = 0
        for sk, sv in pairs(server_data) do
            if ndata.day == sv.day then
                ndata.has_reward = sv.has_reward
                ndata.money = sv.money
            end
        end
        table.insert(self.recharge_days.data, ndata)
    end
end

function PromotionData:reqRechargeDaysReward(day)
    for k, v in pairs(self.recharge_days.data) do
        if v.day == day then
            v.has_reward = 1
        end
    end

    local req = Promotion049_pb.GReqRechargeDaysReward()
    req.day = day
    NetManager:sendMessage(ProtocolID.GReqRechargeDaysReward, req)

    self:checkRechargeDaysAwardRedDot()
end

function PromotionData:getRechargeDaysByDay(day)
end

function PromotionData:rechargeDaysAward(days)
end

-------------------------限时兑换--------------------------------
function PromotionData:reqTimeExchange()
    NetManager:sendMessage(ProtocolID.GReqExchangeList)
end

function PromotionData:reqTimeExchangeLimit()
    NetManager:sendMessage(ProtocolID.GReqLimitedtimeRechargeReward)
end

-------------------------圣诞活动--------------------------------
function PromotionData:setFestivalLoginInfo(oridata)
    local config_data = {}
    for k, v in pairs(cfg.festivanew7daylogin.festivanew7daylogin) do
        local data = {}
        data.day = v.day
        data.item = v.item
        data.lan = v.lan
        data.idx = v.idx
        data.is_gain = 0

        for ki, vi in pairs(oridata.list) do
            if vi == data.day then
                data.is_gain = 1
                break
            end
        end

        table.insert(config_data, data)
    end
    self.save_festivanew_data.list = config_data
    self.save_festivanew_data.now_day = oridata.day
end

function PromotionData:getPromotionfestivanewDatas()
    return self.running_promotion_data[promotionPros.gReqFestivalLoginInfo.id]
end

function PromotionData:setFestivalLoginDays(data)
    self.save_festivanew_data.now_day = data
    -- 发送通知
end

function PromotionData:checkFestivalLoginDayISGain(idx)
    local config = self.save_festivanew_data.list[idx]
    return config.is_gain
end

function PromotionData:checkFestivalLoginDayISOpen()
    return self:getTimeIsOpen(promotionPros.gReqFestivalLoginInfo.id)
end

function PromotionData:gReqFestivalLoginInfo()
    NetManager:sendMessage(ProtocolID.GReqFestivalLoginInfo)
end

function PromotionData:gReqFestivalLoginReward(day)
    local req = Promotion051_pb.GReqFestivalLoginReward()
    req.day = day
    NetManager:sendMessage(ProtocolID.GReqFestivalLoginReward, req)
end

-------------------------周充值累计--------------------------------
function PromotionData:reqRechargeWeek()
    -- 周累计充值
    -- NetManager:sendMessage(ProtocolID.GReqRechargeWeekList)
end

function PromotionData:clearRechargeWeek(completed)
    self.recharge_week.completed = completed
    self.recharge_week.item = {}
    for _, v in pairs(cfg.promotionweeklytotalrecharge.week) do
        local data = {}
        data.idx = v.idx
        data.is_award = false
        table.insert(self.recharge_week.item, data)
    end
end

function PromotionData:setRechargeWeekIsAward(idx, is_award)
    for _, v in pairs(self.recharge_week.item) do
        if v.idx == idx then
            v.is_award = is_award
            return
        end
    end
end

function PromotionData:getRechargeWeekIsAward(idx)
    for _, v in pairs(self.recharge_week.item) do
        if v.idx == idx then
            return v.is_award
        end
    end
    return false
end

-------------------------月卡--------------------------------
function PromotionData:reqMonthCard()
    -- 月卡数据
    NetManager:sendMessage(ProtocolID.GReqMonthCardList)
end

function PromotionData:clearMonthCard()
    self.month_card = {}
end

function PromotionData:addMonthCardData(data)
    table.insert(self.month_card, data)
    ex.EventManager:fire(EVENT.MAIN_PROMOTION_CARD.ADD_MONTH_CARD)
end

function PromotionData:getMonthCardData(card_type)
    for _, v in pairs(self.month_card) do
        if v.card_type == card_type then
            return v
        end
    end
    return nil
end

function PromotionData:gainMonthCard(card_type)
    for _, v in pairs(self.month_card) do
        if v.card_type == card_type then
            v.is_gain = true
            v.gain_days = v.gain_days + 1
            return
        end
    end
end

function PromotionData:hasSuperCard()
    local config = cfg.promotioncard.card[2]
    local card_data = self:getMonthCardData(config.type)
    if card_data then
        return card_data.over_time > ex.Game:getServerTime()
    end

    return false
end

function PromotionData:isRewardSuperCard()
    local config = cfg.promotioncard.card[2]
    local card_data = self:getMonthCardData(config.type)
    if card_data then
        return card_data.is_gain_vip
    end
    return false
end

function PromotionData:rewardSuperCard()
    local config = cfg.promotioncard.card[2]
    local card_data = self:getMonthCardData(config.type)
    if card_data then
        card_data.is_gain_vip = true
    end

    self:checkVipRedDot()
end

-------------------------限时英雄升级礼包----------------------------
function PromotionData:reqLimitGift()
    -- 限时礼包
    -- local req_limit_gift = cpp.ByteArray:create()
    -- req_limit_gift:writeInt(ProtocolID.GReqLimitGiftList)
    -- cpp.NetManager:instance():sendByteArray(req_limit_gift)
    NetManager:sendMessage(ProtocolID.GReqLimitGiftList)
end

function PromotionData:clearLimitGift()
    self.limit_gift = {}
end

function PromotionData:addLimitGiftData(data)
    local gift_data = self:getLimitGiftById(data.gift_id)

    if gift_data == nil then
        table.insert(self.limit_gift, data)
    else
        -- 已有数据则更新数据
        gift_data.idx = data.idx
        gift_data.num = data.num
        gift_data.last_time = data.last_time
    end
end

function PromotionData:subLimitGiftOneById(gift_id)
    local data = self:getLimitGiftById(gift_id)
    if data ~= nil then
        if data.num <= 1 then
            local idx = 0
            for i, v in pairs(self.limit_gift) do
                if v.gift_id == gift_id then
                    idx = i
                    break
                end
            end

            table.remove(self.limit_gift, idx)
        else
            data.num = data.num - 1
        end
    end
end

function PromotionData:checkLimitGift()
    if table.nums(self.limit_gift) == 0 then
        return
    end

    for i, v in ipairs(self.limit_gift) do
        repeat
            if v.last_time - ex.Game:getServerTime() <= 0 then
                table.remove(self.limit_gift, i)
                break
            end
        until true
    end

    -- 排序
    local sort_idx = function(a, b)
        local config_a = cfg.buygem.buygem[a.idx]
        local config_b = cfg.buygem.buygem[b.idx]
        if (not config_a) or (not config_b) then
            return false
        end

        return config_a.idx + config_a.sort * 10000000 < config_b.idx + config_b.sort * 10000000
    end
    table.sort(self.limit_gift, sort_idx)
end

function PromotionData:sortLimitGift()
    table.sort(
        self.limit_gift,
        function(a, b)
            return a.last_time > b.last_time
        end
    )
end

function PromotionData:getLimitGiftById(gift_id)
    for _, v in pairs(self.limit_gift) do
        if v.gift_id == gift_id then
            return v
        end
    end
    return nil
end

function PromotionData:startLimitGiftTimer()
    if self.limit_gift_timer then
        ex.Timer:removeTimerById(self.limit_gift_timer)
        self.limit_gift_timer = nil
    end
    self.limit_gift_timer = ex.Timer:addTimer(1000, handler(self, self.changeLimitGiftTime), true)
end

function PromotionData:changeLimitGiftTime()
    if table.nums(self.limit_gift) > 0 then
        local time = self.limit_gift[1].last_time - ex.Game:getServerTime()
        if time <= 0 then
            local data = {}
            for i, v in ipairs(self.limit_gift) do
                if v.last_time - ex.Game:getServerTime() > 0 then
                    table.insert(data, v)
                end
            end
            self.limit_gift = data
        end
    else
        if self.limit_gift_timer then
            ex.Timer:removeTimerById(self.limit_gift_timer)
            self.limit_gift_timer = nil
        end
        ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END, "act_limit_gift")
    end
end

function PromotionData:limitGiftIsOpen()
    -- 判断是否解锁
    local is_unlock, is_show = ex.Tools:getMainCityBtnStatus("act_limit_gift")
    if not is_unlock or not is_show then
        return false
    end

    -- 是否有数据
    if not self.limit_gift or #self.limit_gift <= 0 then
        return false
    end

    -- 是否在有效期内
    for i, v in ipairs(self.limit_gift) do
        local config = cfg.buygem.buygem[v.idx]
        if config ~= nil and config.kind ~= 22 then
            if v.last_time > ex.Game:getServerTime() and v.num > 0 then
                return true
            end
        end
    end

    return false
end

-- 是否有指定星养成礼
function PromotionData:isExistStarGiftForStar(star)
    star = star or -1 -- -1为任何显示礼包礼包
    -- 判断是否解锁
    local is_unlock, is_show = ex.Tools:getMainCityBtnStatus("act_limit_gift")
    if not is_unlock or not is_show then
        return false
    end

    -- 是否有数据
    if not self.limit_gift or #self.limit_gift <= 0 then
        return false
    end

    local is_exist = function(star, idx)
        for k, v in pairs(cfg.promotionlimitedset.promotionlimitedset) do
            if v.idx == idx and (star == -1 or v.star == star) then
                return true
            end
        end
        return false
    end

    for i, v in ipairs(self.limit_gift) do
        if is_exist(star, v.idx) and v.last_time > ex.Game:getServerTime() and v.num > 0 then
            return true
        end
    end

    return false
end

-------------------------每日首充---------------------------
function PromotionData:reqDailyFirstRecharge()
    NetManager:sendMessage(ProtocolID.GReqDailyChargeData)
end

function PromotionData:cleanDailyFirstRecharge()
    self.daily_first_recharge = {}
end

function PromotionData:setDailyFirstRecharge(recharge_type, status, money)
    --print("-setDailyFirstRechargesetDailyFirstRechargesetDailyFirstRechargesetDailyFirstRecharge=", is_award, completed)
    local data = self:getDailyFirstRechargeDataByType(recharge_type)
    if data == nil then
        data = {}
        table.insert(self.daily_first_recharge, data)
    end

    data.type = recharge_type or data.type
    data.status = status or data.status
    data.money = money or data.money
end

function PromotionData:getDailyFirstRechargeDataByType(recharge_type)
    for i, v in ipairs(self.daily_first_recharge) do
        if v.type == recharge_type then
            return v
        end
    end

    return nil
end

function PromotionData:getDailyFirstRechargeNeedGem(recharge_type)
    local turns = self:getPromotionTurns(promotionPros.gReqDailyChargeData.id)
    local config = cfg.promotiondailyfirstrecharge.getConfigByTurnsAndType(turns, recharge_type)
    if config == nil then
        return 0
    end

    local data = self:getDailyFirstRechargeDataByType(recharge_type) or {money = 0}
    return ex.Tools:Money2GemNumber(config.rmb) - ex.Tools:Money2GemNumber(data.money)
end

function PromotionData:getDailyFirstRechargeNeedMoney(recharge_type)
    local turns = self:getPromotionTurns(promotionPros.gReqDailyChargeData.id)
    local config = cfg.promotiondailyfirstrecharge.getConfigByTurnsAndType(turns, recharge_type)
    if config == nil then
        return 0
    end

    local data = self:getDailyFirstRechargeDataByType(recharge_type) or {money = 0}
    return config.rmb - data.money
    -- return ex.Tools:Money2GemNumber(config.rmb) - ex.Tools:Money2GemNumber(data.money)
end

function PromotionData:checkDailyFirstRechargeIsOpen()
    if not self:getTimeIsOpen(promotionPros.gReqDailyChargeData.id) then
        return false
    end

    local types = {1, 2, 3}

    for i, v in ipairs(types) do
        local data = self:getDailyFirstRechargeDataByType(v)
        if data == nil or data.status == 0 then
            return true
        end
    end

    return false
end

function PromotionData:checkDailyFirstRechargeRedDot()
    local types = {1, 2, 3}

    for i, v in ipairs(types) do
        local data = self:getDailyFirstRechargeDataByType(v)
        local need_gem = self:getDailyFirstRechargeNeedGem(v)
        if data ~= nil and data.status == 0 and need_gem <= 0 then
            ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCMRSC, true)
            return true
        end
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCMRSC, false)
    return false
end

-------------------------超值首充---------------------------
function PromotionData:clearRechargeFirst(completed)
    self.recharge_first.completed = completed
    self.recharge_first.award = {}
    self.recharge_first.type_gain = {}
end

function PromotionData:addRechargeFirstData(server_data, is_day_can)
    local award_list = {}
    for k, v in pairs(cfg.promotionfirstrecharge.promotionfirstrecharge) do
        local data = {}
        data.idx = v.idx
        data.product_id = v.product_id
        data.type = v.type
        data.day = v.day
        data.reward = v.reward
        data.is_obtain = 0
        for sk, sv in pairs(server_data) do
            if data.idx == sv then
                data.is_obtain = 1
            end
        end
        table.insert(self.recharge_first.award, data)
    end

    for k, v in pairs(is_day_can) do
        self.recharge_first.type_gain[v.type] = v.is_gain
    end
end

function PromotionData:getRechargeFirstReward(type)
    return cfg.promotionfirstrechargereward.promotionfirstrechargereward[type]
end

function PromotionData:isBoughtRechargeFirstForType(type)
    local need_rmb = cfg.promotionfirstrechargereward.getChargeNumByType(type)
    return need_rmb <= self.recharge_first.completed
end

function PromotionData:isRechargeFirstOver()
    -- -- 如果全部领完了，就不显示了
    for k, v in pairs(self.recharge_first.award) do
        if v.is_obtain == 0 then
            return false
        end
    end
    return true
end

function PromotionData:hasRechargeFirstAward(tp)
    if not tp then
        for k, v in pairs(cfg.promotionfirstrechargereward.promotionfirstrechargereward) do
            if self.recharge_first.type_gain[v.idx] == 0 then
                return true
            end
        end
    else
        if self.recharge_first.type_gain[tp] == 0 then
            return true
        end
    end
    return false
end

function PromotionData:getRechargeFirstType(type)
    local data = {}
    for k, v in pairs(self.recharge_first.award) do
        if type == v.type then
            data[v.day] = v
        end
    end
    return data
end

function PromotionData:reqRechargeFirst()
    NetManager:sendMessage(ProtocolID.GReqFirstRecharge)
end

--[[
    周向阳
    time:2020-08-10 20:49:41
]]---------------------------------超值赠礼---------------------------------

function PromotionData:reqGetSupreGiftData()
    NetManager:sendMessage(ProtocolID.GReqRechargeGiftInfo)
end

function PromotionData:getSupreGiftRewardData( data )
    self.supre_gift_data.reward_ids = data  
end

function PromotionData:getSupreGiftData(data)
    self.supre_gift_data = data or {}
    self:checkSupreGiftRedDot()
end

--充值的金钱数量
function PromotionData:rechargeNum() 
    return self.supre_gift_data.recharge
end

--是否有充值
function PromotionData:isBuySupreGiftForType(cur_type)
    local recharge = cfg.promotionrechargegift.promotionrechargergift
    for i,v in ipairs(recharge) do
       if v.type == cur_type then
            return self.supre_gift_data.recharge >= v.recharge
       end 
    end
end

--判断是否有奖励可领取
function PromotionData:hasSupreGiftAward(cur_type)

    if self.supre_gift_data.reward_list == nil then
        return false
    end

    local table_first = {}
    local table_100 = {}
    
    local reward = cfg.promotionrechargegift.promotionrechargergift

    for i,v in ipairs(self.supre_gift_data.reward_list) do
        if v.idx == reward[i].idx then
            if reward[i].type == 0 then
                table.insert( table_first, i, v )   
            elseif reward[i].type == 1 then
                table.insert( table_100, i, v )
            end
        end
        if cur_type == 0 then
            for i,v in ipairs(table_first) do
                if v.status == 0 then
                    return true
                end           
            end        
        elseif cur_type == 1 then
            for i,v in pairs(table_100) do
                if v.status == 0 then
                    return true
                end         
            end  
        end
    end
    return false   
end
--判断是否开启活动
function PromotionData:checkSupreGiftIsOpen()  
    local isopen = false
    if self.supre_gift_data.open_time == nil then
        return isopen
    end
    if self.supre_gift_data.open_time <= ex.Game:getServerTime() then
        isopen = true
    end
    return isopen
end

--获取 显示已领取 的状态
function PromotionData:getSprGeted()
    local reward_ids = self.supre_gift_data.reward_ids or {}
    return reward_ids
end

--每个档次的领取状态
function PromotionData:typeList()
    local type_list = self.supre_gift_data.type_list or {}
    return type_list
end

--红点显示
function PromotionData:checkSupreGiftRedDot(  )
    local reddot_manager = ex.RedDotManager
    local red0 = self:hasSupreGiftAward(0)
    local red1 = self:hasSupreGiftAward(1)
    if red0 or red1 then   
        reddot_manager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CZZL, true)
    else
        reddot_manager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CZZL, false)
    end
end


------------------------月度回馈(计划)-------------------------------
function PromotionData:reqMonthInvest()
    -- 发送领取协议
    NetManager:sendMessage(ProtocolID.GReqInvestList)
end

function PromotionData:clearMonthInvest()
    self.month_invest = {}
end

function PromotionData:setMonthInvestTimeInfo(start_time, end_time, status)
    self.month_invest_start_time = start_time
    self.month_invest_end_time = end_time
    self.month_invest_status = status

    local cur_time = ex.Game:getServerTime()
    if self.month_invest_start_time > cur_time then
        ex.Timer:addTimer(
            1000 * (self.month_invest_start_time - cur_time + 1),
            function()
                ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END, "act_month_invest", false)
            end
        )
    end

    if self.month_invest_start_time < cur_time and self.month_invest_end_time > cur_time then
        ex.Timer:addTimer(
            1000 * (self.month_invest_end_time - cur_time + 1),
            function()
                ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END, "act_month_invest", false)
            end
        )
    end
end

function PromotionData:monthInvestIsOpen()
    if self.month_invest_start_time == nil or self.month_invest_end_time == nil then
        return false
    end

    local cur_time = ex.Game:getServerTime()
    return self.month_invest_start_time < cur_time and self.month_invest_end_time > cur_time
end

function PromotionData:addMonthInvest(data)
    table.insert(self.month_invest, data)
end

function PromotionData:setMonthInvest(data)
    for _, v in pairs(self.month_invest) do
        if v.invest_type == data.invest_type then
            v.receive_day = data.receive_day
            v.reach_day = data.reach_day
            v.is_today_got = data.is_today_got
            return
        end
    end
end

function PromotionData:getMonthInvest(invest_type)
    for _, v in pairs(self.month_invest) do
        if v.invest_type == invest_type then
            return v
        end
    end

    return nil
end

-------------------------现有活动配置--------------------------------
function PromotionData:getPromotionByType(type)
    local vec_result = {}
    for k, v in pairs(self.promotion_page_table) do
        if v.type == type then
            table.insert(vec_result, v)
        end
    end

    table.sort(
        vec_result,
        function(a, b)
            return a.order < b.order
        end
    )
    return vec_result
end

function PromotionData:getPromotionConfigByIdx(idx)
    for k, v in pairs(self.promotion_page_table) do
        if v.idx == idx then
            return v
        end
    end

    return nil
end

function PromotionData:getPromotionRewardStatus(index)
    for i, v in ipairs(self.foundation_list) do
        if v == index then
            return true
        end
    end
    return false
end

function PromotionData:getDayLimitNum(idx)
    -- local now_day = ex.Game:getServerTime()
    -- now_day = Maths.getDays(now_day)

    -- for i,v in ipairs(self.day_limit_list) do
    -- 	if v.idx == idx then
    -- 		local buy_day = Maths.getDays(v.time)
    -- 		-- 与上次购买的时候不是同一天
    -- 		if now_day ~= buy_day then
    -- 			break
    -- 		end
    -- 		return v.num
    -- 	end
    -- end

    for i, v in ipairs(self.day_limit_list) do
        if v.idx == idx then
            return v.num
        end
    end

    return 0
end

function PromotionData:addDayLimitNum(ori_idx)
    -- 找出轮次，在找出对应的IDx
    local now_data = self:getPromotionDayLimitDatas()
    local change_data = self:changeListItem(cfg.promotiondailygift.promotiondailygift, ori_idx, now_data.turns)
    local idx = change_data.idx

    local now_time = ex.Game:getServerTime()
    local data =
        TableEx.findValueFunction(
        self.day_limit_list,
        function(value)
            if value.idx == idx then
                return true
            end
        end
    )

    if data then
        data.num = data.num + 1
        data.time = now_time
    else
        data = {idx = idx, num = 1, time = now_time}
        table.insert(self.day_limit_list, data)
    end
end

function PromotionData:getDayLimitStatus(idx)
    local num = self:getDayLimitNum(idx)

    local config = cfg.promotiondailygift.promotiondailygift[idx]
    -- 需要拿到更新数据

    if config and num < config.buy_limit then
        return true
    end
    return false
end

--   判断开始结束

function PromotionData:checkLimitIsOpen()
    return self:getTimeIsOpen(promotionPros.gReqDailyGiftData.id)
end

function PromotionData:getRechargeList()
    local now_data = self:getPromotionDayLimitDatas()

    local list_data = {}

    -- 获取我当前的轮次
    local now_data = self:getPromotionDayLimitDatas()
    local list_data = {}

    for k, v in pairs(cfg.promotiondailygift.promotiondailygift) do
        if v.turns == now_data.turns then
            local data = {}
            local buygem_data = cfg.buygem.buygem[v.production_id]

            data.tag_language = buygem_data.tag_language
            data.item_language = buygem_data.item_language
            data.rmb = buygem_data.rmb
            data.id = buygem_data.code
            data.icon = buygem_data.icon
            data.vip_require = buygem_data.vip_require

            data.goods = v.gift_reward
            data.limit_times = v.buy_limit
            data.idx = v.idx
            data.production_id = v.production_id

            table.insert(list_data, data)
        end
    end
    return list_data
end

function PromotionData:getChangeLimitData(list)
    -- 获取我当前的轮次
    local now_data = self:getPromotionDayLimitDatas()
    local list_data = {}

    for i, v in ipairs(cfg.promotiondailygift.promotiondailygift) do
        if now_data.turns == v.turns then
            local data = {}
            data.goods = v.gift_reward
            data.limit_times = v.buy_limit
            data.idx = v.idx
            data.production_id = v.production_id

            local buy_gem_data = cfg.buygem.buygem[data.production_id]

            data.tag_language = buy_gem_data.tag_language
            data.item_language = buy_gem_data.item_language
            data.rmb = buy_gem_data.rmb
            data.id = buy_gem_data.code
            data.icon = buy_gem_data.icon
            data.vip_require = buy_gem_data.vip_require

            table.insert(list_data, data)
        end
    end

    return list_data
end

function PromotionData:getPromotionDayLimitDatas()
    return self.running_promotion_data[promotionPros.gReqDailyGiftData.id]
end

function PromotionData:dailyTotalChargeData(list, money)
end

-------------------------活动红点检测--------------------------------
function PromotionData:checkAllRedDot()
    ex.Tools:try(
        function()
            self:checkSignInRedDot()
            self:checkMonthCardRedDot()
            self:checkSuperMonthCardRedDot()
            self:checkRechargeDaysAwardRedDot()
            self:checkRechargeAwardRedDot()
            self:checkLevelUpAwardRedDot()

            self:checkBuyGoldRedDot()
            self:checkProphecytimesRedDot()
            self:checkPvpwinsRedDot()
            self:checkSummontimesRedDot()
            self:checkExchangeRedDot()
            self:checkLTADailyRechargeGiftRedDot()
            self:checkBlessingPoolRedDot()
            self:checkMakeHeroRedDot()
            self:checkSummonCrystalRedDot()
            self:checkPubArriveRedDot()

            self:checkAdventureRedDot()
            self:checkSpeedFightRedDot()
            self:checkTavernWeeklyRedDot()

            self:checkDailyFirstRechargeRedDot()

            self:checkInvitationGiftRedDot()

            self:checkRCGGrowthRedDot()

            self:checkfestivanewRedDot()
            self:checkPrivilegeGiftRedDot()
            self:checkRechargeAward2RedDot()
            self:checkClergyPrivilegeRedDot()
        end
    )
end

function PromotionData:checkfestivanewRedDot()
    if self:getTimeIsOpen(promotionPros.gReqFestivalLoginInfo.id) then
        local gain_nums = 0
        for k, v in pairs(self.save_festivanew_data.list) do
            if v.is_gain == 1 then
                gain_nums = gain_nums + 1
            end
        end

        if gain_nums < self.save_festivanew_data.now_day then
            ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDQR, true)
            return
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDQR, false)
end

function PromotionData:checkRCGGrowthRedDot()
    if self.is_buy_foundation then
        for i, v in ipairs(cfg.promotionfoundation.promotionfoundation) do
            if ex.Player.level >= v.level and self:getPromotionRewardStatus(v.idx) == false then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HD_CZLB, true)
                return
            end
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HD_CZLB, false)
    return false
end

function PromotionData:checkInvitationGiftRedDot()
    for k, v in pairs(self.invitation.gift_list) do
        if v.now_limit < v.gain_limit and v.now_limit < v.max_limit then
            ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HD_YQYL, true)
            return true
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HD_YQYL, false)
    return false
end

function PromotionData:checkSignInRedDot()
    -- 签到 红点
    local show_red = false
    if self.sign_in.is_sign < 1 then
        show_red = true
    elseif self.sign_in.is_sign == 1 then
        if self.sign_in.charged > 0 then
            show_red = true
        end
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HD_QD, show_red)
end

function PromotionData:checkMonthCardRedDot()
    -- 月卡 红点
    local card_data = self:getMonthCardData(1)
    if card_data then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HD_YK, card_data.over_time > ex.Game:getServerTime() and card_data.is_gain == false)
    end
end

function PromotionData:checkSuperMonthCardRedDot()
    -- 至尊月卡 红点
    local card_data = self:getMonthCardData(2)
    if card_data then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HD_ZZYK, card_data.over_time > ex.Game:getServerTime() and card_data.is_gain == false)
    end
end

function PromotionData:checkRechargeDaysAwardRedDot()
    -- 积天豪礼 红点
    -- local completed = self.recharge_days.completed
    -- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HD_JTHL,
    -- 	completed >= need and self.recharge_days.is_award == false)
    -- ndata.has_reward = 0
    -- ndata.money = 0

    local need = ex.Tools:getSysCfg("recharge_days_at_least_rmb")
    local show = false
    for k, v in pairs(self.recharge_days.data) do
        if v.money >= need and v.has_reward == 0 then
            show = true
            break
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HD_JTHL, show)
end

function PromotionData:checkRechargeAwardRedDot()
    -- 周累计充值 红点
    if cfg.promotionweeklytotalrecharge ~= nil then
        local completed = self.recharge_week.completed
        for _, v in pairs(cfg.promotionweeklytotalrecharge.week) do
            if completed >= v.rmb and self:getRechargeWeekIsAward(v.idx) == false then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_LJCZ, true)
                return
            end
        end

        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_LJCZ, false)
    end
end

function PromotionData:checkBuyGoldRedDot()
    -- 点金
    if self:checkBuyGoldIsOpen() then
        for _, v in pairs(self.buy_gold_data.list) do
            if self.buy_gold_data.num >= v.count and v.is_obtain == 0 then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_DJ, true)
                return
            end
        end
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_DJ, false)
    end
end

function PromotionData:checkProphecytimesRedDot()
    -- 先知
    if self:checkProphecytimesIsOpen() then
        for _, v in pairs(self.prophecy_data.list) do
            if self.prophecy_data.nvalue >= v.count and v.is_obtain == 0 then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_ZHZ, true)
                return
            end
        end
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_ZHZ, false)
    end
end
function PromotionData:checkPvpwinsRedDot()
    -- 竞技者
    if self:checkPvpwinsIsOpen() then
        for _, v in pairs(self.pvp_wins_data.list) do
            if self.pvp_wins_data.nvalue >= v.count and v.is_obtain == 0 then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KHSK_JJZD, true)
                return
            end
        end
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KHSK_JJZD, false)
    end
end
function PromotionData:checkSummontimesRedDot()
    -- 召唤着
    if self:checkSummontimesIsOpen() then
        for _, v in pairs(self.summon_times_data.list) do
            if self.summon_times_data.nvalue >= v.count and v.is_obtain == 0 then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_ZHDB, true)
                return
            end
        end
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_ZHDB, false)
    end
end

--
function PromotionData:checkBlessingPoolRedDot()
    -- 召唤着
    if self:checkBlessingPoolIsOpen() then
        for _, v in pairs(self.blessing_pool_data.list) do
            if self.blessing_pool_data.nvalue >= v.count and v.is_obtain == 0 then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_ZHCHD, true)
                return
            end
        end
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_ZHCHD, false)
    end
end

function PromotionData:checkMakeHeroRedDot()
    -- 召唤着
    if self:checkMakeHeroIsOpen() then
        for _, v in pairs(self.mark_hero_data.list) do
            if v.cnt < v.hasNum and v.cnt < v.count then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KHSK_HCJX, true)
                return
            end
        end
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KHSK_HCJX, false)
    end
end

function PromotionData:checkAdventureRedDot()
    if self:checkAdventureIsOpen() then
        for _, v in pairs(self.adventure_data.list) do
            if self.adventure_data.nvalue >= v.count and v.is_obtain == 0 then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_SLZL, true)
                return
            end
        end
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_SLZL, false)
    end
end

function PromotionData:checkSpeedFightRedDot()
    if self:checkSpeedFightIsOpen() then
        for _, v in pairs(self.speed_fight_data.list) do
            if self.speed_fight_data.nvalue >= v.count and v.is_obtain == 0 then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_SZZW, true)
                return
            end
        end
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_SZZW, false)
    end
end

function PromotionData:checkTavernWeeklyRedDot()
    if self:checkTavernWeeklyIsOpen() then
        for _, v in pairs(self.tavern_weekly_data.list) do
            if self.tavern_weekly_data.nvalue >= v.count and v.is_obtain == 0 then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_JGCK, true)
                return
            end
        end
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_JGCK, false)
    end
end

function PromotionData:checkLevelUpAwardRedDot()
    -- 等级礼包红点
    if self:checkLevelUpIsOpen() then
        for _, v in pairs(self.level_up_data.list) do
            if ex.Player.level >= v.main_level and v.is_obtain == 0 then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_DJJL, true)
                return
            end
        end
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_DJJL, false)
    end
end

function PromotionData:checkExchangeRedDot()
    -- if  self:checkExchangeLimitIsOpen() then
    -- 	for _,v in pairs(self.time_exchange_data.change_list) do
    -- 		if self.time_exchange_data.nvalue >= v.count and v.is_obtain == 0 then
    -- 			ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_HDXSLC, true)
    -- 			return
    -- 		end
    -- 	end
    -- 	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_HDXSLC, false)
    -- end
end

function PromotionData:checkLTADailyRechargeGiftRedDot()
    if self:checkDailyRechargeGiftIsOpen() == false then
        return
    end

    local reset_time = GetTodayRemainTime()

    if reset_time > 0 then
        local day = cc.exports.GetAfterDaysForTime(ex.Player.server_create_time)
        local data_list = self:getDailyTotalRechargeList(day)

        if data_list then
            for i, v in ipairs(data_list) do
                -- v.idx, v.reward, v.rmb
                local data = self:getDailyTotalRechargeData(v.idx)
                local today_recharge = self:getDailyFirstRechargeDataByType(1)
                if today_recharge ~= nil and today_recharge.money >= v.rmb and data == false then
                    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_MRLC, true)
                    return
                end
            end
        end
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_MRLC, false)
end

function PromotionData:checkVipRedDot()
    local has_super_card_reward = self:hasSuperCard() and self:isRewardSuperCard() == false
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CZ_HYTQ_ZZMRJL, has_super_card_reward)
end

function PromotionData:checkLimitRedDot()
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CZ_XSLB_MRJL, self.day_limit_reward == 0)
end

function PromotionData:checkPrivilegeGiftRedDot()
    if ex.Player.god_equip_data.buy_status == 1 and ex.Player.god_equip_data.get_day == 0 then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CZ_HYTQ_TQLM, true)
        return
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CZ_HYTQ_TQLM, false)
end

-- 检测神职特权红点
function PromotionData:checkClergyPrivilegeRedDot()
    local sort_list = cfg.clergyprivilege.getSortConfigs()
    local can_active = false
    for i, v in ipairs(sort_list) do
        if ex.Player.clergy_level < v.clergy_level and ex.Player.clergy_exp >= v.unlock_need_exp then
            can_active = true
        end
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CZ_SZTQ_JH, can_active)
end

function PromotionData:checkMonthInvesRedDot(invest_type)
    local reddot = 0
    if invest_type == 21 then
        reddot = RedDotType.ZCJ_DHZC_YDFK_PTYJJ
    elseif invest_type == 22 then
        reddot = RedDotType.ZCJ_DHZC_YDFK_GJYJJ
    end

    local invest = self:getMonthInvest(invest_type)
    ex.RedDotManager:setRedNodeVisible(reddot, invest and invest.receive_day <= invest.reach_day and not invest.is_today_got)
end

function PromotionData:checkSummonCrystalRedDot()
    if self:checkSummonCrystalIsOpen() then
        for _, v in pairs(self.summon_crystal_info.list) do
            if cfg.promotionsummontarget.promotionsummontarget[v.idx] ~= nil then
                if not v.is_bought and v.progress >= cfg.promotionsummontarget.promotionsummontarget[v.idx].num then
                    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_ZHSJ, true)
                    return
                end
            end
        end
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_ZHSJ, false)
    end
end

function PromotionData:checkPubArriveRedDot()
    if self:checkPubArriveIsOpen() then
        for _, v in pairs(self.pub_arrive_info.list) do
            if cfg.promotiontavern.promotiontavern[v.idx] ~= nil then
                if v.is_bought == 0 and v.progress >= cfg.promotiontavern.promotiontavern[v.idx].num then
                    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KHSK_JGDB, true)
                    return
                end
            end
        end
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KHSK_JGDB, false)
    end
end

function PromotionData:checkAdvNoteRedDot()
    if self:isExistCanGetRewardForAdvNote() then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_MXRJ, true)
    else
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_MXRJ, false)
    end
end

function PromotionData:checkMysteryBoxRedDot()
    if self:isExistCanGetRewardForMysteryBox() then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SMMH, true)
    else
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SMMH, false)
    end
end

function PromotionData:checkLoginGiftRedDot()
    if self:isExistCanGetRewardForLoginGift() then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_DLYL, true)
    else
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_DLYL, false)
    end
end

function PromotionData:checkRechargeAward2RedDot()
    local need = ex.Tools:getSysCfg("higher_recharge_days_at_least_rmb")
    local show = false
    for k, v in pairs(self.recharge_reward.data) do
        if v.money >= need and v.has_reward == 0 then
            show = true
            break
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HD_LCFL, show)
end

function PromotionData:clear()
    if self.limit_gift_timer then
        ex.Timer:removeTimerById(self.limit_gift_timer)
        self.limit_gift_timer = nil
    end
    self.magic_butterfly_data:clear()
    self.customized_data:clean()
    self.luck_fish_data:clean()
    self.zhongqiu_data:clear()

    if self.eventList then
        for k,v in pairs(self.eventList) do
            ex.EventManager:remove(v)
        end
        self.eventList = nil
    end
end

function PromotionData:reqPrivilegeGift()
    NetManager:sendMessage(ProtocolID.GReqPrivilegeGiftAddOrUpdate)
end

function PromotionData:addOrUpdatePrivilegeGift(list)
    self.privilege_gift_data = list

    self:updatePrivilegeGiftDatas()
    ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.PRIVILEGE_GIFT)
end

function PromotionData:getPrivilegeGiftDatas()
    self:updatePrivilegeGiftDatas()
    return self.privilege_gift_list
end

function PromotionData:updatePrivilegeGiftDatas()
    local gift_list = self.privilege_gift_list

    self.privilege_gift_list = {}
    for k, v in pairs(cfg.promotionprivilegegift.promotionprivilegegift) do
        local data = {}
        data.idx = v.idx
        data.buy_type = v.buy_type
        data.cost_gem = v.cost_gem
        data.production_id = v.production_id
        data.item = v.item
        data.limit_day = v.limit_day
        data.limit_num = v.limit_num
        data.icon = v.icon
        data.limit_language = v.limit_language
        data.tag_language = v.tag_language
        data.item_language = v.item_language
        data.rank = v.rank

        local privilege_data =
            TableEx.findValueFunction(
            gift_list,
            function(value)
                return value.idx == data.idx
            end
        )

        if privilege_data then
            data.end_time = privilege_data.end_time
            data.buy_count = privilege_data.buy_count
        else
            data.end_time = -1
            data.buy_count = 0
        end

        data.buyGem_config = nil
        if data.buy_type == 1 then
            data.buyGem_config = cfg.buygem.buygem[data.production_id]
        end

        for _, lv in ipairs(self.privilege_gift_data) do
            if data.idx == lv.idx then
                data.end_time = lv.end_time
                data.buy_count = lv.buy_count
            end
        end

        -- 在界面中筛选等级
        if v.show_level <= ex.Player.level then
            table.insert(self.privilege_gift_list, data)
        end
    end
end

function PromotionData:getPrivilegeGiftByIdx(idx)
    for k, v in pairs(self.privilege_gift_list) do
        if v.idx == idx then
            return v
        end
    end
    return nil
end

function PromotionData:updatePrivilegeGift(data)
    -- --接手购买
    -- self.privilege_gift_list[data.idx].end_time = data.end_time
    -- self.privilege_gift_list[data.idx].buy_count = data.buy_count

    for k, v in pairs(self.privilege_gift_list) do
        if v.idx == data.idx then
            v.end_time = data.end_time
            v.buy_count = data.buy_count
        end
    end

    -- dump(self.privilege_gift_list, "self.privilege_gift_list")
end

-- 是否存在快速作战特权
function PromotionData:isExistSpeedBattlePrivilege()
    local buy_data = self:getPrivilegeGiftByIdx(100200)
    if buy_data == nil or buy_data.end_time < ex.Game:getServerTime() then
        return false
    else
        return true
    end
end

function PromotionData:isSpeedBattlePrivilege(idx)
    return idx == 100200
end

function PromotionData:isAdvExpPrivilege(idx)
    return idx == 100400 or idx == 100610
end

function PromotionData:isShowChaoZhiPrivilege(idx)
    return idx == 100700 or idx == 100800
end

function PromotionData:isShowBiMaiPrivilege(idx)
    return idx == 100610 or idx == 100620
end

function PromotionData:buyPrivilegeGiftByIdx(idx)
    local req = Promotion010_pb.GReqPrivilegeGiftBuy()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqPrivilegeGiftBuy, req)
end

-------------------------每月福利--------------------------------
function PromotionData:reqMouthWelfare()
    NetManager:sendMessage(ProtocolID.GReqMonthGiftData)
end

function PromotionData:clearMouthWelfare()
    self.mouth_welfare = {}
    self.mouth_welfare.list = {}
    self.mouth_welfare.stime = 0
    self.mouth_welfare.etime = 0
    self.mouth_welfare.ctime = 0

    local now_data = self.running_promotion_data[promotionPros.gReqMonthGiftData.id]
    if now_data ~= nil then
        self.mouth_welfare.stime = now_data.start_time
        self.mouth_welfare.etime = now_data.end_time
        self.mouth_welfare.ctime = now_data.clear_time
    end

    local mouth_config = ex.Player.shop_data:getRechargeList(RechargeKindType.MOUTH_WELFARE)
    for _, v in pairs(cfg.promotionmonthgift.promotionmonthgift) do
        if now_data.turns == v.turns then
            local data = {}

            data.goods = v.gift_reward
            data.hasNum = v.buy_limit
            data.idx = v.idx
            data.production_id = v.production_id
            data.discount = v.discount

            local change_data = cfg.buygem.buygem[data.production_id]
            data.rmb = change_data.rmb

            table.insert(self.mouth_welfare.list, data)
        end
    end
end

function PromotionData:checkMouthWelfareIsOpen()
    return self:getTimeIsOpen(promotionPros.gReqMonthGiftData.id)
end

function PromotionData:subMouthWelfareData(idx, buyCount)
end

function PromotionData:setMouthWelfareNum(idx, buyCount)
    for _, v in pairs(self.mouth_welfare.list) do
        if v.idx == idx then
            v.hasNum = v.hasNum - buyCount
            return
        end
    end
end

-------------------------每日福利--------------------------------
function PromotionData:reqDailyWelfare()
    NetManager:sendMessage(ProtocolID.GReqDailyWelfareList)
end

function PromotionData:clearDailyWelfare()
    self.daily_welfare = {}

    local daily_config = ex.Player.shop_data:getRechargeList(RechargeKindType.DAILY_WELFARE)
    for _, v in pairs(daily_config) do
        local data = {}
        data.idx = v.idx
        data.id = v.id
        data.rmb = v.rmb
        data.goods = v.item
        data.hasNum = v.limit_times
        table.insert(self.daily_welfare, data)
    end
end

function PromotionData:setDailyWelfareNum(idx, buyCount)
    for _, v in pairs(self.daily_welfare) do
        if v.idx == idx then
            v.hasNum = v.hasNum - buyCount
            return
        end
    end
end

-------------------------新服限购--------------------------------
function PromotionData:reqNewServerLimit()
    --NetManager:sendMessage(ProtocolID.GReqBuyServerLimitInfo)
    NetManager:sendMessage(ProtocolID.GReqScanBuyInfo)
end

function PromotionData:getPromotionNewServerLimitISOpen()
    return self:getTimeIsOpen(promotionPros.gReqScanBuyInfo.id)
end

function PromotionData:getPromotionNewServerLimitData()
    return self.running_promotion_data[promotionPros.gReqScanBuyInfo.id]
end

function PromotionData:getNewServerListData()
    return self.new_server_limit_list
end

function PromotionData:addOrUpdateNewServerLimitList(list)
    local now_data = self:getPromotionNewServerLimitData()
    self.new_server_limit_end_time = now_data.end_time

    -- 重新整理数据
    for k, v in pairs(cfg.promotionnewseverlimitgift.promotionnewseverlimitgift) do
        if v.turns == now_data.turns then
            local data = {}
            data.idx = v.idx
            data.production_id = v.production_id
            data.item = v.gift_reward
            data.limit_times = v.buy_limit
            data.bought_num = 0

            data.tag_language = v.name_lang
            data.item_language = v.tips_lang

            local buy_gem_data = cfg.buygem.buygem[data.production_id]

            data.original_cost = buy_gem_data.original_cost
            data.rmb = buy_gem_data.rmb

            for _, lv in ipairs(list) do
                if data.idx == lv.key then
                    data.bought_num = lv.value
                end
            end
            self.new_server_limit_list[data.idx] = data
        end
    end

    -- for _,v in ipairs(list) do
    -- 	local data = {}
    -- 	data.idx = v.key
    -- 	data.bought_num = v.value

    -- 	self.new_server_limit_list[data.idx] = data
    -- end

    local nslc = require("src.layer.promotion.NewServerLimitCtr"):instance()
    if nslc:isOpened() then
        -- 重新刷新界面
        nslc:initData()
    end
end

function PromotionData:getNewServerLimit(idx)
    return self.new_server_limit_list[idx]
end

------------------------------每日累充---------------------------
function PromotionData:reqDailyTotalRechargeList()
    if not self:getTimeIsOpen(promotionPros.gReqDailyTotalChargeData.id) then
        return
    end

    NetManager:sendMessage(ProtocolID.GReqDailyTotalChargeData)
end

function PromotionData:updateDailyTotalRechargeList(data, money)
    self.daily_total_recharge_list = data
    self.daily_total_recharge_money = money
    ex.EventManager:fire(EVENT.DAILY_TOTAL_RECHARGE.REFRESH)

    ex.Player.promotion_data:checkLTADailyRechargeGiftRedDot()
end

function PromotionData:reqDailyTotalRechargeGet(idx)
    local req = Promotion022_pb.GReqDailyTotalChargeReward()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqDailyTotalChargeReward, req)
end

function PromotionData:getDailyTotalRechargeList(day)
    local list = {}
    local temp_day = 0

    local now_data = self:getPromotionDailyTotalRechargeData()
    for i, v in pairs(cfg.promotiondailytotalrecharge.promotiondailytotalrecharge) do
        if now_data.turns == v.turns then
            table.insert(list, v)
        end
    end

    return list
end

function PromotionData:getPromotionDailyTotalRechargeData()
    return self.running_promotion_data[promotionPros.gReqDailyTotalChargeData.id]
end

function PromotionData:checkDailyRechargeGiftIsOpen()
    return self:getTimeIsOpen(promotionPros.gReqDailyTotalChargeData.id)
end

function PromotionData:getDailyTotalRechargeData(idx)
    -- for k, v in pairs(self.daily_total_recharge_list) do
    -- 	if v.idx == idx then
    -- 		return v
    -- 	end
    -- end

    for i, v in ipairs(self.daily_total_recharge_list) do
        if v == idx then
            return true
        end
    end

    return false
end

------------------------------中秋特惠---------------------------
function PromotionData:setMidAutumnInfo(data)
    self.mid_autumn_info = data

    local cur_time = ex.Game:getServerTime()
    if self.mid_autumn_info.begin_time - 86400 < cur_time and self.mid_autumn_info.end_time > cur_time then
        self.mid_autumn_info_timer = ex.Timer:addTimer(1000, handler(self, self.refreshMidAutumnState), true)
    end
end

function PromotionData:refreshMidAutumnState()
    local cur_time = ex.Game:getServerTime()

    if math.abs(cur_time - self.mid_autumn_info.begin_time) < 4 or math.abs(cur_time - self.mid_autumn_info.end_time) < 4 then
        ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END, "act_mid_autumn")
    end

    if self.mid_autumn_info.end_time + 4 < cur_time then
        if self.mid_autumn_info_timer then
            ex.Timer:removeTimerById(self.mid_autumn_info_timer)
            self.mid_autumn_info_timer = nil
        end
    end
end

------------------------------召唤水晶---------------------------
function PromotionData:setSummonCrystalInfo(data)
    self.summon_crystal_info = data
end

function PromotionData:getSummonCrystalDataForIdx(idx)
    for k, v in pairs(self.summon_crystal_info.list) do
        if v.idx == idx then
            return v
        end
    end

    return nil
end

function PromotionData:checkSummonCrystalIsOpen()
    if cfg.promotionsummontarget == nil then
        print(">>>>>PromotionData:checkSummonCrystalIsOpen not exist config!")
        return false
    end

    if self.summon_crystal_info == nil or next(self.summon_crystal_info) == nil then
        return false
    end

    return self:getTimeIsOpen(promotionPros.gReqSummonCrystalInfo.id)
end

------------------------------占星阵任务---------------------------
function PromotionData:reqAstrologyTaskInfo()
    NetManager:sendMessage(ProtocolID.GReqAstrologyTaskInfo)
end

function PromotionData:setAstrologyTaskInfo(data)
    self.astrology_task_info = data

    ex.EventManager.fire(EVENT.MAIN_CITY_PROMOTION.REFRESH_ASTROLOGY_STATUS)
end

function PromotionData:getAstrologyTaskDataForIdx(idx)
    for k, v in pairs(self.astrology_task_info.list) do
        if v.idx == idx then
            return v
        end
    end

    return nil
end

function PromotionData:handleAstrologyTaskSubmit(data)
    if not data.is_over then
        -- 如果任务兑换未完成，则刷新数据
        self:reqAstrologyTaskInfo()
        require("src.layer.promotion.PROMAstrologyAcceptTaskCtrl"):instance():handleSubmit(data.idx, data.is_over)
        return
    end

    for k, v in ipairs(self.astrology_task_info.list) do
        if v.idx == data.idx then
            v.is_over = data.is_over
        end
    end

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.REFRESH_ASTROLOGY_STATUS)
    require("src.layer.promotion.PROMAstrologyAcceptTaskCtrl"):instance():handleSubmit(data.idx, data.is_over)
end

function PromotionData:checkAstrologyTaskIsOpen()
    if cfg.promotionastrology == nil then
        print(">>>>>PromotionData:checkAstrologyTaskIsOpen not exist config!!!")
        return false
    end
    if self.astrology_task_info == nil or next(self.astrology_task_info) == nil then
        return false
    end

    return self:getTimeIsOpen(promotionPros.gReqAstrologyTaskInfo.id)
end

------------------------------酒馆达标---------------------------
function PromotionData:reqPubArriveInfo()
    NetManager:sendMessage(ProtocolID.GReqPubArriveInfo)
end

function PromotionData:setPubArriveInfo(data)
    self.pub_arrive_info.list = data.list
    self.pub_arrive_info.begin_time = self.running_promotion_data[promotionPros.gReqPubArriveInfo.id].start_time
    self.pub_arrive_info.end_time = self.running_promotion_data[promotionPros.gReqPubArriveInfo.id].end_time
    self.pub_arrive_info.clear_time = self.running_promotion_data[promotionPros.gReqPubArriveInfo.id].clear_time

    -- ex.EventManager:fire()
end

function PromotionData:getPubArriveTimesIsOpen()
    return self:getTimeIsOpen(promotionPros.gReqPubArriveInfo.id)
end

function PromotionData:getPubArriveTimesInfo()
    return self.running_promotion_data[promotionPros.gReqPubArriveInfo.id]
end

function PromotionData:getPubArriveDataForIdx(idx)
    for k, v in pairs(self.pub_arrive_info.list) do
        if v.idx == idx then
            return v
        end
    end

    return nil
end

function PromotionData:checkPubArriveIsOpen()
    if self.pub_arrive_info == nil or next(self.pub_arrive_info) == nil then
        return false
    end

    local cur_time = ex.Game:getServerTime()
    return cur_time >= self.pub_arrive_info.begin_time and cur_time <= self.pub_arrive_info.clear_time
end

--------------------------成长礼包-----------------
function PromotionData:setGrowUpList(data)
    -- self.growUpList = data.list
    for k, v in ipairs(data.list) do
        if v.key > 0 then
            self.growUpList[v.key] = v.value
        end
    end
end

function PromotionData:getGrowUpByLevel(level)
    -- body
    return self.growUpList[level]
end

--------------------------通用活动数据-----------------
function PromotionData:reqServerActicityConfig(id_list, is_hotfix)
    is_hotfix = is_hotfix or 0
    local ids = id_list or {}
    if #ids <= 0 then
        for k, v in pairs(ServerPromotionNameMap) do
            table.insert(ids, k)
        end
    end
    -- dump(ids, ex.Tools:getLang(47271))
    local req = PromotionNew_pb.GReqActivityConfig()
    for k, v in ipairs(ids) do
        table.insert(req.ids, v)
    end
    req.is_hotfix = tonumber(is_hotfix)
    -- print(">>>>>is_hotfix:"..req.is_hotfix)
    NetManager:sendMessage(ProtocolID.GResActivityConfig, req)
end

function PromotionData:reqServerActicityData(id_list)
    local ids = id_list

    if ids == nil or type(ids) ~= "table" then
        return
    end

    for k, v in pairs(ids) do
        for kp, vp in pairs(promotionPros) do
            if vp.id == v then
                -- print(">>>>>重新请求数据,promotion_id:"..vp.reqProtoId)
                NetManager:sendMessage(vp.reqProtoId)
            end
        end
    end
end

function PromotionData:HandleActivityTimer(activity_id)
    if activity_id == self.act_happy_month_promotion_id then
        ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END, "act_happy_month")
    else
        ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END, "act_limit_time_activity")
    end
end

function PromotionData:EndActivityAndUpdateTimer(activity_id)
    self:HandleActivityTimer(activity_id)

    self:reqCommonActivityData(activity_id)
end

function PromotionData:AddActivityTimer(start_time, clear_time, activity_id)
    local cur_time = ex.Game:getServerTime()
    if start_time > cur_time then
        local remain_time = start_time - cur_time
        ex.Timer:addTimer(remain_time * 1000, handler(self, self.HandleActivityTimer), false, activity_id)
    end
    if clear_time > cur_time then
        local remain_time = clear_time - cur_time
        ex.Timer:addTimer(remain_time * 1000, handler(self, self.EndActivityAndUpdateTimer), false, activity_id)
    end

    if start_time <= cur_time and cur_time < clear_time then
        self:HandleActivityTimer(activity_id)
    end
end

function PromotionData:checkCommonActivityRedDot(activity_id)
    if activity_id == self.act_happy_month_promotion_id then
        self:checkHappyMonthRedDot()
    elseif activity_id == self.act_mystery_box_promotion_id then
        -- self:checkMysteryBoxRedDot()
    elseif activity_id == self.act_adv_note_promotion_id then
    -- self:checkAdvNoteRedDot()
    end
end

function PromotionData:reqCommonActivityData(...)
    local ids = {...}

    local req_data = Task4_pb.GReqActivityInfo()
    for i, v in ipairs(ids) do
        if type(v) == "number" then
            table.insert(req_data.idxs, v)
        elseif type(v) == "table" then
            for _, v2 in ipairs(v) do
                table.insert(req_data.idxs, v2)
            end
        end
    end

    if #req_data.idxs > 0 then
        NetManager:sendMessage(ProtocolID.GReqActivityInfo, req_data)
    end
end

function PromotionData:setCommonActivityData(data, is_clear)
    local activity_data = self:getCommonActivityDataForID(data.id) or {}
    if is_clear then
        activity_data = data
    else
        activity_data.id = data.id or activity_data.id
        activity_data.start_time = data.start_time or activity_data.start_time
        activity_data.end_time = data.end_time or activity_data.end_time
        activity_data.clear_time = data.clear_time or activity_data.clear_time
        activity_data.turns = data.turns or activity_data.turns
        activity_data.ext_info = data.ext_info or activity_data.ext_info

        activity_data.list = activity_data.list or {}

        if data.list ~= nil then
            for i, v in ipairs(data.list) do
                self:setCommonActivityItemData(activity_data.id, v)
            end
        end
    end
    -- dump(data, "PromotionData:setCommonActivityData", 5)
    self:AddActivityTimer(activity_data.start_time, activity_data.clear_time, activity_data.id)

    self.CommonActivityData["D" .. activity_data.id] = activity_data

    self:checkCommonActivityRedDot(activity_data.id)
end

function PromotionData:setCommonActivityItemData(id, item_table)
    if id == nil or item_table == nil then
        return
    end

    local activity_data = self:getCommonActivityDataForID(id)
    if activity_data == nil then
        return
    end

    local pop_func = function(idx)
        if activity_data.list == nil then
            activity_data.list = {}
            return 1, {}
        end

        for i, v in ipairs(activity_data.list) do
            if v.idx == idx then
                local t = table.remove(activity_data.list, i)
                return i, t
            end
        end
        return #activity_data.list + 1, {}
    end

    local item_idx, item_data = pop_func(item_table.idx)
    item_data.idx = item_table.idx or item_data.idx
    item_data.progress = item_table.progress or item_data.progress
    item_data.is_got = item_table.is_got == 1 or item_data.is_got
    item_data.ext_info = item_table.ext_info or item_data.ext_info

    table.insert(activity_data.list, item_idx, item_data)
end

function PromotionData:getCommonActivityDataForID(id_for_server)
    return self.CommonActivityData["D" .. id_for_server] or {}
end

function PromotionData:isHappyMonthPrivilege(id_for_server)
    id_for_server = id_for_server or self.act_happy_month_promotion_id
    local data = self:getCommonActivityDataForID(id_for_server)

    if data ~= nil then
        return data.ext_info.buy_privilege or false
    end

    return false
end

function PromotionData:isHappyMonthItemGetPrivilege(idx)
    local data = self:getCommonActivityDataForID(self.act_happy_month_promotion_id)
    for i, v in ipairs(data.list) do
        if v.idx == idx then
            return v.ext_info.get_privilege or false
        end
    end

    return false
end

function PromotionData:setHappyMonthBuyStatus(is_bought)
    local data = self:getCommonActivityDataForID(self.act_happy_month_promotion_id)
    if data ~= nil then
        data.ext_info.buy_privilege = is_bought
    end

    if is_bought then
        ex.MessageView:add(ex.Tools:getLang(52498))
    end

    -- 发送UI刷新事件
    ex.EventManager:fire(EVENT.COMMON_ACTIVITY_EVENT.REFRESH)

    self:checkCommonActivityRedDot(self.act_happy_month_promotion_id)
end

function PromotionData:getCommonActivityExtInfoTable(id)
    local activity_data = self:getCommonActivityDataForID(id)

    if activity_data ~= nil then
        return activity_data.ext_info
    end

    return {}
end

function PromotionData:checkCommonActivityIsOpen(id)
    if id == nil then
        return false
    end

    local data = self:getCommonActivityDataForID(id)
    if data == nil or next(data) == nil then
        return false
    end

    local cur_time = ex.Game:getServerTime()
    return cur_time >= data.start_time and cur_time <= data.clear_time
end

function PromotionData:checkHappyMonthRedDot()
    local data = self:getCommonActivityDataForID(self.act_happy_month_promotion_id)

    if data == nil then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KHSK_KHSK, false)
        return false
    end

    local getData = function(idx)
        for k, v in pairs(data.list) do
            if v.idx == idx then
                return v
            end
        end

        return nil
    end

    for _, v in pairs(cfg.promotionhappymonth.promotionhappymonth) do
        if v.turns == data.turns then
            local unit = getData(v.idx)
            if unit ~= nil and unit.progress >= v.target_num then
                if not unit.is_got or (self:isHappyMonthPrivilege() and not self:isHappyMonthItemGetPrivilege(v.idx)) then
                    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KHSK_KHSK, true)
                    return true
                end
            end
        -- if (unit ~= nil and not unit.is_got and unit.progress >= v.target_num) or (self:isHappyMonthPrivilege() and not self:isHappyMonthItemGetPrivilege(v.idx)) then
        -- 	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KHSK_KHSK, true)
        -- 	return true
        -- end
        end
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KHSK_KHSK, false)
    return false
end

--------------------------冒险日记-----------------
function PromotionData:setAdventureExp(idx, exp)
    if idx == nil then
        return
    end

    local activity_data = self:getCommonActivityDataForID(self.act_adv_note_promotion_id)

    if activity_data ~= nil then
        if activity_data.ext_info.exp ~= exp then
            local change_value = exp - activity_data.ext_info.exp
            activity_data.ext_info.exp = exp
            ex.MessageView:add(string.format(ex.Tools:getLang(52513), change_value))
        end
    else
        print(">>>>>PromotionData:setAdventureExp not exist activity_data!")
    end
end

function PromotionData:setAdventureNoteRechargeGet(idx)
    local activity_data = self:getCommonActivityDataForID(self.act_adv_note_promotion_id)

    if activity_data ~= nil then
        table.insert(activity_data.ext_info.idx_recharge_reward, idx)
    end
end

function PromotionData:setAdventureNoteAdvGet(idx)
    local activity_data = self:getCommonActivityDataForID(self.act_adv_note_promotion_id)

    if activity_data ~= nil then
        table.insert(activity_data.ext_info.lv_rewards, idx)
    end
end

function PromotionData:setAdventureNoteRechargeUpdate(total_recharge)
    local activity_data = self:getCommonActivityDataForID(self.act_adv_note_promotion_id)

    if activity_data ~= nil then
        activity_data.ext_info.total_recharge = total_recharge
    end
end

function PromotionData:getConfigExpLevelForAdvNote(exp)
    local activity_data = self:getCommonActivityDataForID(self.act_adv_note_promotion_id)

    local is_got = function(idx)
        if activity_data ~= nil then
            for i, v in ipairs(activity_data.ext_info.lv_rewards) do
                if v == idx then
                    return true
                end
            end
        end

        return false
    end

    local config_table = cfg.promotionadventurenoteslevelreward.promotionadventurenoteslevelreward
    local level, config, last_config, can_get = 0, nil, nil, false
    if activity_data == nil then
        return can_get, level, config
    end

    for i, v in ipairs(config_table) do
        if activity_data.turns == v.turns then
            if exp >= v.exp_need and not is_got(v.level) then
                can_get = true
            end

            if v.exp_need > exp then
                config = v
                break
            end
            level = v.level_up
            last_config = v
        end
    end

    if config == nil then -- 超过最高级
        config = last_config
    end

    return can_get, level, config
end

function PromotionData:getConfigRechargeForAdvNote()
    local activity_data = self:getCommonActivityDataForID(self.act_adv_note_promotion_id)

    local is_got = function(idx)
        if activity_data ~= nil then
            for i, v in ipairs(activity_data.ext_info.idx_recharge_reward) do
                if v == idx then
                    return true
                end
            end
        end

        return false
    end

    local config_table = cfg.promotionadventurenotesrechargereward.promotionadventurenotesrechargereward
    local idx, config, last_config, can_get = 1, nil, nil, false
    if activity_data == nil then
        return can_get, false, config
    end

    for i, v in ipairs(config_table) do
        if activity_data.turns == v.turns then
            if activity_data.ext_info.total_recharge >= v.recharge_need and not is_got(v.idx) then
                can_get = true
            end

            if v.recharge_need > activity_data.ext_info.total_recharge or not is_got(v.idx) then
                idx = v.idx
                config = v
                break
            end

            last_config = v
        end
    end

    if config == nil then
        idx = last_config.idx
        config = last_config
    end

    return can_get, is_got(idx), config
end

function PromotionData:isExistCanGetRewardForAdvNote()
    if not self:checkCommonActivityIsOpen(self.act_adv_note_promotion_id) then
        return false
    end

    local activity_data = self:getCommonActivityDataForID(self.act_adv_note_promotion_id)

    if activity_data == nil or not self:checkCommonActivityIsOpen(ex.Player.promotion_data.act_adv_note_promotion_id) then
        return false
    end

    -- 检查登记奖励
    local can_get, _, _ = self:getConfigExpLevelForAdvNote(activity_data.ext_info.exp)
    if can_get then
        return true
    end

    can_get, _, _ = self:getConfigRechargeForAdvNote()
    if can_get then
        return true
    end

    local getData = function(idx)
        for i, v in ipairs(activity_data.list) do
            if v.idx == idx then
                return v
            end
        end
        return {idx = idx, progress = 0, is_got = false, ext_info = ""} -- 没有数据就返回默认的。
    end

    for i, v in ipairs(cfg.promotionadventurenotes.promotionadventurenotes) do
        if v.turns == activity_data.turns and v.day == activity_data.ext_info.curr_day then
            local data = getData(v.idx)
            if not data.is_got and data.progress >= v.mission.target then
                return true
            end
        end
    end

    return false
end

--------------------------神秘魔盒---------------------
function PromotionData:setMysteryBoxExp(idx, exp)
    if idx == nil then
        return
    end

    local activity_data = self:getCommonActivityDataForID(self.act_mystery_box_promotion_id)

    if activity_data ~= nil then
        if activity_data.ext_info.exp ~= exp then
            local change_value = exp - activity_data.ext_info.exp
            activity_data.ext_info.exp = exp
            ex.MessageView:add(string.format(ex.Tools:getLang(52613), change_value))
        end
    else
        print(">>>>>PromotionData:setMysteryBoxExp not exist activity_data!")
    end
end

function PromotionData:setMysteryBoxRechargeGet(idx)
    local activity_data = self:getCommonActivityDataForID(self.act_mystery_box_promotion_id)

    if activity_data ~= nil then
        table.insert(activity_data.ext_info.idx_recharge_reward, idx)
    end
end

function PromotionData:setMysteryBoxExpGet(idx)
    local activity_data = self:getCommonActivityDataForID(self.act_mystery_box_promotion_id)

    if activity_data ~= nil then
        table.insert(activity_data.ext_info.lv_rewards, idx)
    end
end

function PromotionData:setMysteryBoxRechargeUpdate(total_recharge)
    local activity_data = self:getCommonActivityDataForID(self.act_mystery_box_promotion_id)

    if activity_data ~= nil then
        activity_data.ext_info.total_recharge = total_recharge
    end
end

function PromotionData:getConfigExpLevelForMysteryBox(exp)
    local activity_data = self:getCommonActivityDataForID(self.act_mystery_box_promotion_id)

    local is_got = function(idx)
        if activity_data ~= nil then
            for i, v in ipairs(activity_data.ext_info.lv_rewards) do
                if v == idx then
                    return true
                end
            end
        end

        return false
    end

    local config_table = cfg.promotionmysteryboxlevelreward.promotionmysteryboxlevelreward
    local level, config, last_config, can_get = 0, nil, nil, false
    if activity_data == nil then
        return can_get, level, config
    end

    for i, v in ipairs(config_table) do
        if activity_data.turns == v.turns then
            if exp >= v.exp_need and not is_got(v.level) then
                can_get = true
            end

            if v.exp_need > exp then
                config = v
                break
            end
            level = v.level
            last_config = v
        end
    end

    if config == nil then -- 超过最高级
        config = last_config
    end

    return can_get, level, config
end

function PromotionData:getConfigRechargeForMysteryBox()
    local activity_data = self:getCommonActivityDataForID(self.act_mystery_box_promotion_id)

    local is_got = function(idx)
        if activity_data ~= nil then
            for i, v in ipairs(activity_data.ext_info.idx_recharge_reward) do
                if v == idx then
                    return true
                end
            end
        end

        return false
    end

    local config_table = cfg.promotionmysteryboxrechargereward.promotionmysteryboxrechargereward
    local idx, config, last_config, can_get = 1, nil, nil, false
    if activity_data == nil then
        return can_get, false, config
    end

    for i, v in ipairs(config_table) do
        if activity_data.turns == v.turns then
            if activity_data.ext_info.total_recharge >= v.recharge_need and not is_got(v.idx) then
                can_get = true
            end

            if v.recharge_need > activity_data.ext_info.total_recharge or not is_got(v.idx) then
                idx = v.idx
                config = v
                break
            end

            last_config = v
        end
    end

    if config == nil then
        idx = last_config.idx
        config = last_config
    end

    return can_get, is_got(idx), config
end

function PromotionData:isExistCanGetRewardForMysteryBox()
    if not self:checkCommonActivityIsOpen(self.act_mystery_box_promotion_id) then
        return false
    end

    local activity_data = self:getCommonActivityDataForID(self.act_mystery_box_promotion_id)

    if activity_data == nil or not self:checkCommonActivityIsOpen(ex.Player.promotion_data.act_mystery_box_promotion_id) then
        return false
    end

    -- 检查登记奖励
    local can_get, _, _ = self:getConfigExpLevelForMysteryBox(activity_data.ext_info.exp)
    if can_get then
        return true
    end

    can_get, _, _ = self:getConfigRechargeForMysteryBox()
    if can_get then
        return true
    end

    local getData = function(idx)
        for i, v in ipairs(activity_data.list) do
            if v.idx == idx then
                return v
            end
        end
        return {idx = idx, progress = 0, is_got = false, ext_info = ""} -- 没有数据就返回默认的。
    end

    for i, v in ipairs(cfg.promotionmysterybox.promotionmysterybox) do
        if v.turns == activity_data.turns and v.day == activity_data.ext_info.curr_day then
            local data = getData(v.idx)
            if not data.is_got and data.progress >= v.mission.target then
                return true
            end
        end
    end

    return false
end

--------------------------七彩华章---------------------
function PromotionData:setColorfulShopTable(data)
    self.ColorfulShopData = data
end

function PromotionData:ColorfulShopBoughtOne(data)
    for i, v in ipairs(self.ColorfulShopData) do
        if v.idx == data.idx then
            v.bought_num = v.bought_num + data.bought_num
            return
        end
    end

    table.insert(self.ColorfulShopData, data)
end

function PromotionData:getColorfulConfig()
    if cfg.promotioncolourfulshops == nil then
        return {}
    end

    local result = {}
    for k, v in pairs(cfg.promotioncolourfulshops.promotioncolourfulshops) do
        table.insert(result, v)
    end

    return result
end

function PromotionData:getColorfulBoughtTimes(idx)
    for i, v in ipairs(self.ColorfulShopData) do
        if v.idx == idx then
            return v.bought_num
        end
    end

    return 0
end

function PromotionData:checkColorfulIsOpen()
    if cfg.promotioncolourfulshops == nil then
        print(">>>>>PromotionData:checkColorfulIsOpen not exist config!")
        return false
    end

    return self:getTimeIsOpen(promotionPros.gReqColorfulShopData.id)
end

--------------------------登录有礼---------------------
function PromotionData:setLoginGiftTable(data)
    self.LoginGiftData = data
end

function PromotionData:LoginGiftBoughtOne(idx)
    table.insert(self.LoginGiftData.reward_ids, idx)
end

function PromotionData:getLoginGiftConfig()
    if cfg.promotionlogingift == nil then
        return {}
    end

    local result = {}
    for k, v in pairs(cfg.promotionlogingift.promotionlogingift) do
        table.insert(result, v)
    end

    return result
end

function PromotionData:currLoginGiftDays()
    return self.LoginGiftData.days
end

function PromotionData:isGotLoginGiftForIdx(idx)
    for i, v in ipairs(self.LoginGiftData.reward_ids) do
        if v == idx then
            return true
        end
    end

    return false
end

function PromotionData:checkLoginGiftIsOpen()
    if cfg.promotionlogingift == nil then
        print(">>>>>PromotionData:checkLoginGiftIsOpen not exist config!")
        return false
    end

    return self:getTimeIsOpen(promotionPros.gReqLoginGiftData.id)
end

function PromotionData:isExistCanGetRewardForLoginGift()
    if not self:checkLoginGiftIsOpen() then
        return false
    end

    local confit_table = self:getLoginGiftConfig()
    for k, v in pairs(confit_table) do
        if not self:isGotLoginGiftForIdx(v.idx) and self.LoginGiftData.days >= v.need_login_day then
            return true
        end
    end

    return false
end

--------------------------碎片进化---------------------
function PromotionData:setExchangeShopTable(data)
    self.ExchangeShopData = data
    self:checkExchangeShopRedDot()
end

function PromotionData:ExchangeShopBoughtOne(data)
    for i, v in ipairs(self.ExchangeShopData) do
        if v.idx == data.idx then
            v.bought_num = v.bought_num + data.bought_num
            return
        end
    end

    table.insert(self.ExchangeShopData, data)
    self:checkExchangeShopRedDot()
end

function PromotionData:getExchangeShopConfig()
    if cfg.promotionexchangeshop == nil then
        return {}
    end

    local result = {}
    for k, v in pairs(cfg.promotionexchangeshop.promotionexchangeshop) do
        table.insert(result, v)
    end

    return result
end

function PromotionData:getExchangeShopBoughtTimes(idx)
    for i, v in ipairs(self.ExchangeShopData) do
        if v.idx == idx then
            return v.bought_num
        end
    end

    return 0
end

function PromotionData:checkExchangeShopIsOpen()
    if cfg.promotionexchangeshop == nil then
        print(">>>>>PromotionData:checkExchangeShopIsOpen not exist config!")
        return false
    end

    return self:getTimeIsOpen(promotionPros.gReqExchangeShopData.id)
end

-- 碎片进化红点
function PromotionData:checkExchangeShopRedDot()
    if not self:checkExchangeShopIsOpen() then return end

    local is_visible = false

    local data = {}
    local config_table = self:getExchangeShopConfig()
    for k, v in pairs(config_table) do
        table.insert(data, {
            bought_num = self:getExchangeShopBoughtTimes(v.idx),
            config = v
        })
    end

    for i,v in ipairs(data) do
        local is_got = v.bought_num >= v.config.limit 
        local item_show = true
        for index,value in ipairs(v.config.need_item) do
            local temp = ex.Player:getItemNum(value.item_type)
            if temp < value.item_num then
                item_show = false
                break
            end
        end
        if not is_got and v.config.show_red_dot == 1 and item_show then
            is_visible = true
            break
        end 
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_PFHD_HZJH, is_visible)
end

--------------------------节日豪礼---------------------
function PromotionData:checkFestivalOvervalueGiftReddot()
    -- 活动没开启
    if self:checkFestivalOvervalueGiftIsOpen() ~= true then
        return
    end

    -- local is_visible_buy1 = false
    -- local is_visible_buy2 = false
    -- local is_visible_reward = false
    -- -- 每天只提示一次

    -- -- 判断是否购买了超值礼包，或豪华礼包
    -- local is_buy1 = ex.Player.promotion_data:isBuyFestivalOvervalueGift(cfg.festivalovervaluegift.festivalovervaluegift[1].idx)
    -- local is_buy2 = ex.Player.promotion_data:isBuyFestivalOvervalueGift(cfg.festivalovervaluegift.festivalovervaluegift[2].idx)

    -- if is_buy1 == false then
    -- 	 ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_JRHL_CZL, ex.Tools:checkReddotStatusOnceDay(RedDotType.ZCJ_DHZC_JRHL_CZL, true))
    -- end

    local is_visible = false
    is_visible =
        ex.Player.promotion_data:isBuyFestivalOvervalueGift(cfg.festivalovervaluegift.festivalovervaluegift[1].idx) and
        ex.Player.promotion_data.festival_overvalue_gift.receive_day < ex.Player.promotion_data.festival_overvalue_gift.day
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_JRHL_CZL_LQJL, is_visible)
end

function PromotionData:reqFestivalOvervalueGift()
    NetManager:sendMessage(ProtocolID.GReqFestivalOvervalueGift)
end

function PromotionData:isBuyFestivalOvervalueGift(idx)
    for k, v in pairs(ex.Player.promotion_data.festival_overvalue_gift.idx) do
        if v == idx then
            return true
        end
    end
    return false
end

function PromotionData:getFestivalOvervalueGiftTimeData()
    return self:getPromotionDatas(promotionPros.gReqFestivalOvervalueGift.id)
end

function PromotionData:checkFestivalOvervalueGiftIsOpen()
    -- return true
    return table.nums(ex.Player.promotion_data.festival_overvalue_gift) > 0 and cfg.festivalovervaluegift  and table.nums(cfg.festivalovervaluegift.festivalovervaluegift) > 0 and self:getTimeIsOpen(promotionPros.gReqFestivalOvervalueGift.id)
end

--------------------------超值养成礼---------------------
function PromotionData:reqDevelopGiftData()
    self.is_develop_gift_dirty = true
    NetManager:sendMessage(ProtocolID.GReqDevelopGiftList)
end

function PromotionData:refreshDevelopGiftData(data)
    self.is_develop_gift_dirty = false
    self.develop_gift = data or {}

    self:checkDevelopGiftRedDot()

    -- 添加定时器，用来维持红点
    if self.develop_gift.refresh_date_time ~= nil then
        local remain_time = self.develop_gift.refresh_date_time - ex.Game:getServerTime() + 2 -- 延迟2秒查询
        if remain_time > 0 then
            ex.Timer:addTimer(
                remain_time * 1000,
                function()
                    self:reqDevelopGiftData()
                end,
                false
            )
        end
    end
end

function PromotionData:addDevelopGiftItem(data)
    local i = 1
    while i <= #self.develop_gift.data do
        if data.type == self.develop_gift.data[i].type then
            table.remove(self.develop_gift.data, i)
        else
            i = i + 1
        end
    end

    table.insert(self.develop_gift.data, data)

    self:checkDevelopGiftRedDot()
end

function PromotionData:reqDevelopGiftBuy(type, level)
    local req = Promotion052_pb.GReqBuyDevelopGift()
    req.type = type
    req.level = level

    NetManager:sendMessage(ProtocolID.GReqBuyDevelopGift, req)
end

--[[
    func: 是否已经购买某个超值养成礼
    author:徐东浩
    time:2019-12-30 20:02:43
    --@type: 配置表type
	--@level: 配置表level
    @return: bool值
]]
function PromotionData:isDeveleGiftBought(type, level)
    for i, v in ipairs(self.develop_gift.data) do
        if v.type == type then
            return v.level >= level
        end
    end

    return false
end

--[[
    func: 获取当前显示的超值养成礼包
    author:徐东浩
    time:2019-12-30 19:56:22
    --@type: 配置表type字段
    @return: 配置,是否已经购买
]]
function PromotionData:DevelopGiftCurShow(type)
    local configs = cfg.developgift.getConfigListByType(type)

    local isBought = false
    local config = nil
    for i, v in ipairs(configs) do
        if not self:isDeveleGiftBought(v.type, v.level) then
            config = v
            isBought = false
            break
        end
    end

    if config == nil then
        config = configs[#configs]
        isBought = true
    end

    return config, isBought
end

function PromotionData:checkDevelopGiftRedDot()
    -- 活动有3个,第一个才有价格为0的，对应type 1
    local config, isBought = self:DevelopGiftCurShow(1)

    if config ~= nil and not isBought and config.cost ~= nil and #config.cost > 0 and config.cost[1].item_num <= 0 then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CZYC_YXYC, true)
    else
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CZYC_YXYC, false)
    end
end

--------------------------限时抢购---------------------
function PromotionData:reqFlashSaleData()
    NetManager:sendMessage(ProtocolID.GReqFlashSaleData)
end

function PromotionData:refreshFlashSaleData(data)
    self.limit_buy_data = {}

    self.limit_buy_data = data.reward_count

    ex.EventManager:fire(EVENT.LIMIT_BUY_EVENT.REFRESH_UI_DATA)

    if self.limit_buy_timer ~= nil then
        ex.Timer:removeTimerById(self.limit_buy_timer)
        self.limit_buy_timer = nil
    end

    local remain_time = ex.Tools:getDayRemainingTime() - ex.Tools:getServerTimeWithUTC() + 2
    self.limit_buy_timer =
        ex.Timer:addTimer(
        remain_time * 1000,
        function()
            self:reqFlashSaleData()
        end,
        false
    )
end

function PromotionData:getFlashSaleCountForIdx(idx)
    for i, v in ipairs(self.limit_buy_data) do
        if v.key == idx then
            return v.value
        end
    end

    return 0
end

function PromotionData:checkFlashSaleIsOpen()
    return self:getTimeIsOpen(promotionPros.gReqFlashSaleData.id)
end

--------------------------周末福利---------------------
function PromotionData:WeedendGiftSetTime(begin_time, end_time)
    self.weekend_gift_data.begin_time = begin_time
    self.weekend_gift_data.end_time = end_time
end

function PromotionData:WeedendGiftSetRewardStatus(data)
    self.weekend_gift_data.reward_status = {}

    for i, v in ipairs(data) do
        table.insert(self.weekend_gift_data.reward_status, {idx = v.idx, status = v.status})
    end

    self:WeedendGiftIsRedDot()
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.WEEDEND_GIFT_REFRESH)
end

function PromotionData:WeedendGiftGetRewardStatusByIdx(idx)
    for i, v in ipairs(self.weekend_gift_data.reward_status) do
        if v.idx == idx then
            return v.status
        end
    end

    return 0
end

function PromotionData:WeedendGiftIsOpen()
    local cur_time = ex.Game:getServerTime()
    return cur_time >= self.weekend_gift_data.begin_time and cur_time <= self.weekend_gift_data.end_time
end

function PromotionData:WeedendGiftIsRedDot()
    if self:WeedendGiftIsOpen() then
        for i, v in ipairs(self.weekend_gift_data.reward_status) do
            if v.status == 1 then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_ZMFL, true)
                return true
            end
        end
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HDXS_ZMFL, false)
    return false
end

------------------------购买皮肤------------------------------
function PromotionData:checkBuySkinIsOpen()
    return self:getTimeIsOpen(promotionPros.gReqFashionBuyData.id)
end

function PromotionData:checkBuySkinLimitIsOpen()
    return self:getTimeIsOpen(promotionPros.gReqFashionBuyData.id)
end

function PromotionData:reqBuySkinRewardList()
    NetManager:sendMessage(ProtocolID.GReqFashionBuyData)
end

function PromotionData:setBuySkinRewardList(list)
    self.buy_skin_reward_list = list

    ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_REFRESH_DATA)
end

------------------------诸神遗迹礼包------------------------------
function PromotionData:getGodRelicGiftData()
    -- 获得礼包列表
    local vec_gift = {}
    for _, v in pairs(ex.Player.promotion_data.limit_gift) do
        local config = cfg.buygem.buygem[v.idx]
        if config ~= nil and config.kind == 22 then
            table.insert(vec_gift, clone(v))
        end
    end
    table.sort(
        vec_gift,
        function(a, b)
            return a.idx < b.idx
        end
    )
    return vec_gift
end

function PromotionData:getGodRelicGiftMinCD()
    local last_time = 0
    local now = ex.Game:getServerTime()
    for _, v in pairs(ex.Player.promotion_data.limit_gift) do
        local config = cfg.buygem.buygem[v.idx]
        if config ~= nil and config.kind == 22 then
            if v.num > 0 and v.last_time > now and (last_time <= 0 or v.last_time < last_time) then
                last_time = v.last_time
            end
        end
    end
    return last_time
end

----------------------------召唤周卡--------------------------
function PromotionData:reqSummonWeeksCardsInfo()
    NetManager:sendMessage(ProtocolID.GResSummonWeeksCardsInfo)
end

function PromotionData:updateSummonWeekCardData(data)
    -- dump(data, "PromotionData:updateSummonWeekCardData")
    self.summon_week_card_data = {}

    self.summon_week_card_data.idx = data.buy.key
    self.summon_week_card_data.buy_times = data.buy.value

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.SUMMON_WEEK_CARD_REFRESH)
end

function PromotionData:getSummonWeekCardConfig(idx)
    if not cfg.promotionsummonweekscard or not cfg.promotionsummonweekscard.promotionsummonweekscard then
        return 0
    end

    return cfg.promotionsummonweekscard.promotionsummonweekscard[idx]
end

function PromotionData:checkSummonWeekCardIsOpen()
    if not cfg.promotionsummonweekscard or not cfg.promotionsummonweekscard.promotionsummonweekscard then
        return false
    end

    return self:getTimeIsOpen(promotionPros.gReqSummonWeeksCardsInfo.id)
end

----------------------------高级召唤周卡--------------------------
function PromotionData:reqSuperSummonWeeksCardsInfo()
    NetManager:sendMessage(ProtocolID.GReqHighWeeksCardsInfo)
end

function PromotionData:updateSuperSummonWeekCardData(data)
    -- dump(data, "PromotionData:updateSuperSummonWeekCardData")
    self.super_summon_week_card_data = {}

    self.super_summon_week_card_data.idx = data.buy.key
    self.super_summon_week_card_data.buy_times = data.buy.value

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.SUPER_SUMMON_WEEK_CARD_REFRESH)
end

function PromotionData:getSuperSummonWeekCardConfig(idx)
    if not cfg.promotionhighweekscard or not cfg.promotionhighweekscard.promotionhighweekscard then
        return 0
    end

    return cfg.promotionhighweekscard.promotionhighweekscard[idx]
end

function PromotionData:checkSuperSummonWeekCardIsOpen()
    if not cfg.promotionhighweekscard or not cfg.promotionhighweekscard.promotionhighweekscard then
        return false
    end

    return self:getTimeIsOpen(promotionPros.gReqHighWeeksCardsInfo.id)
end

-----------------------------精灵周卡------------------------------------
function PromotionData:reqSpiritWeekCardInfo()
    NetManager:sendMessage(ProtocolID.GReqElfWeeksCardInfo)
end

function PromotionData:updateSpiritWeekCardData(data)
    -- dump(data, "PromotionData:updateSuperSummonWeekCardData")
    self.spirit_week_card_data = {}

    self.spirit_week_card_data.idx = data.buy.key
    self.spirit_week_card_data.buy_times = data.buy.value

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.SPIRIT_WEEK_CARD_REFRESH)
end

function PromotionData:getSpiritWeekCardConfig(idx)
    if not cfg.promotionelfweekcard or not cfg.promotionelfweekcard.promotionelfweekcard then
        return 0
    end

    return cfg.promotionelfweekcard.promotionelfweekcard[idx]
end

function PromotionData:SpiritWeekCardIsOpen()
    return self:getTimeIsOpen(promotionPros.gReqElfWeeksCardInfo.id)
end

----------------------------三天礼包------------------------------

function PromotionData:checkThreeDayGiftIsOpen()
    if not cfg.promotion3daytaskreward or not cfg.promotion3daytaskreward.promotion3daytaskreward then
        return false
    end

    return self:getTimeIsOpen(promotionPros.gReqThreeDayTaskData.id)

    -- return true
end

function PromotionData:updateThreeDayGigtData(data)
    self.three_day_gift_data = data
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.THREE_DAY_GIFT_REFRESH)
    self:threeDayCheckRedDot()
end

function PromotionData:updateThreeDayTask(data)
    if self.three_day_gift_data.task_list == nil then return end
    
    for i, v in ipairs(self.three_day_gift_data.task_list) do
        for _, task in pairs(data.update_tasks) do
            if v.idx == task.idx then
                v.progress = task.progress
            end
        end
    end

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.THREE_DAY_GIFT_REFRESH)
    self:threeDayCheckRedDot()
end

function PromotionData:threeDayIsRewardDay(day)
    return TableEx.findValueFunction(
        self.three_day_gift_data.ultimate_reward_idx,
        function(value)
            return value == day
        end
    )
end

function PromotionData:threeDayGetCurTask(day)
    local turns = self:getPromotionTurns(promotionPros.gReqThreeDayTaskData.id)

    local sub_task_list = {}
    for i, v in ipairs(cfg.promotion3daytask.promotion3daytask) do
        if v.turns == turns and v.day == day then
            table.insert(sub_task_list, v)
        end
    end

    local cur_sub_task = nil
    for i, v in ipairs(sub_task_list) do
        local is_reward =
            TableEx.findValueFunction(
            ex.Player.promotion_data.three_day_gift_data.reward_idx,
            function(value)
                return value == v.idx
            end
        )

        if is_reward == nil then
            cur_sub_task = v
            break
        end
    end

    if cur_sub_task == nil then
        cur_sub_task = sub_task_list[table.nums(sub_task_list)]
    end

    return cur_sub_task
end

-- 0: 不可领取 1: 可以领取  2:已经领取
function PromotionData:threeDayGetUltimateRewardStatus(day)
    local turns = self:getPromotionTurns(promotionPros.gReqThreeDayTaskData.id)

    -- 任务个数
    local is_finish = nil
    for i, v in ipairs(cfg.promotion3daytask.promotion3daytask) do
        if v.turns == turns and v.day == day then
            local data =
                TableEx.findValueFunction(
                self.three_day_gift_data.reward_idx,
                function(value)
                    return value == v.idx
                end
            )
            is_finish = true
            if not data then
                is_finish = false
                break
            end
        end
    end

    local is_reward =
        TableEx.findValueFunction(
        self.three_day_gift_data.ultimate_reward_idx,
        function(value)
            return day == value
        end
    )

    if is_finish ~= true then
        return 0
    elseif is_finish and is_reward == nil then
        return 1
    end
    return 2
end

function PromotionData:threeDayCheckRedDot()
    local is_visible = false
    for i = 1, 3 do
        if i <= self.three_day_gift_data.day and self:threeDayCheckRedDotByDay(i) then
            is_visible = true
            break
        end
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_PFHD_STHD, is_visible)
end

function PromotionData:threeDayCheckRedDotByDay(day)
    local ultimate_status = self:threeDayGetUltimateRewardStatus(day)

    if ultimate_status == 1 then
        return true
    end

    local cur_sub_task = self:threeDayGetCurTask(day)
    -- 活动过期了
    if cur_sub_task == nil then
        return false
    end

    local cur_sub_task_data =
        TableEx.findValueFunction(
        self.three_day_gift_data.task_list,
        function(value)
            return cur_sub_task.idx == value.idx
        end
    )

    local is_reward =
        TableEx.findValueFunction(
        self.three_day_gift_data.reward_idx,
        function(value)
            return cur_sub_task.idx == value
        end
    )

    -- 活动可能未开启
    if cur_sub_task_data == nil then
        return false
    end

    -- 如果已经领奖
    local is_sub_task = cur_sub_task_data.progress >= cur_sub_task.task.target and is_reward == nil
    return is_sub_task
end

-----------------------------龙舟活动-----------------------------------
function PromotionData:setDragonBoatTaskInfo(data)
    self.promotiondragonboattaskinfo_value = data
end

function PromotionData:checkDragonBoatIsOpen()
    if not cfg.promotioneldragonboatprop or not cfg.promotioneldragonboatprop.promotioneldragonboatprop then
        return false
    end

    return self:getTimeIsOpen(promotionPros.gReqDragonBoatTaskInfo.id)
end

function PromotionData:checkDragonBoatRedDot()
    local is_visible = self:dragonBoatCheckRedDottask()

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_PFHD_DWHD_LZRW, is_visible)
end

-- 获得红点显示状态
function PromotionData:dragonBoatCheckRedDottask()
    local is_visible = false
    -- day_turns：轮数 天数
    local day_turns = self.promotiondragonboattaskinfo_value.day_turns
    -- box_rewards：已经领取的宝箱
    local box_rewards = self.promotiondragonboattaskinfo_value.box_rewards
    -- task_count: 已经完成的任务个数
    local task_count = #self.promotiondragonboattaskinfo_value.reward_ids
    -- 任务进度
    local task_list = self.promotiondragonboattaskinfo_value.task_list
    -- 已经完成的任务列表
    local reward_ids = self.promotiondragonboattaskinfo_value.reward_ids

    for k, v in ipairs(cfg.promotiondragonboatboxreward.promotiondragonboatboxreward) do
        if v.day_turns == day_turns then
            v.isget = 0
            v.flag = false
            for i, h in ipairs(box_rewards) do
                if v.idx == h then
                    v.isget = 1
                    break
                end
            end
            if v.isget == 0 then
                if task_count >= v.task_count then
                    is_visible = true
                    break
                end
            end
        end
    end

    if not is_visible then
        for i, v in ipairs(cfg.promotiondragonboattask.promotiondragonboattask) do
            local data = {}
            if day_turns == v.day_turns then
                data.target = v.task_target.target
                data.progress = 0
                data.idx = v.idx
                data.iscomplete = 0
                for k, h in ipairs(task_list) do
                    if h.idx == data.idx then
                        data.progress = h.progress
                        -- 充值类型除100倍
                        if v.task_target.type == "RECHARGE" then
                            data.target = tonumber(data.target) * 0.01
                            data.progress = tonumber(data.progress) * 0.01
                        end
                        for o, p in ipairs(reward_ids) do
                            if p == data.idx then
                                data.iscomplete = 1
                                break
                            end
                        end
                        if data.progress >= data.target and data.iscomplete == 0 then
                            is_visible = true
                        end
                        break
                    end
                end
            end
        end
    end

    return is_visible
end

-- 設置刷新任務進度 只刷新單個任務進度
function PromotionData:setDragonBoatTaskProgress(data)
    for i, v in ipairs(self.promotiondragonboattaskinfo_value.task_list) do
        for q, h in ipairs(data.task) do
            if v.idx == h.idx then
                v.progress = h.progress
                break
            end
        end
    end
end

----------------------------奇珍异宝------------------------------
function PromotionData:setTimeTreasureInfo(data)
    self.promotion_timetreasureinfo = data
    self:checkTimeTreasureRedDot()
end

function PromotionData:updataTimeTreasureInfo(data)
    self.promotion_timetreasureinfo.status = data.status
    self.promotion_timetreasureinfo.idx_list = data.idx_list
    self:checkTimeTreasureRedDot()
end

function PromotionData:checkTimeTreasureIsOpen()
    if not cfg.promotimetreasureinfo or not cfg.promotimetreasureinfo.promotimetreasureinfo then
        return false
    end
    return self:getTimeIsOpen(promotionPros.GReqSpaceTimeTreasureInfo.id)
end

function PromotionData:checkTimeTreasureRedDot()
    local is_visible = true
    if not self:checkTimeTreasureIsOpen() or self.promotion_timetreasureinfo.status == 1 then
        is_visible = false
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_PFHD_SKYB, is_visible)
end

----------------------------七日目标------------------------------
-- add 熊梦
function PromotionData:checkDayTargetIsOpen()
    return self:getTimeIsOpen(promotionPros.gReqSevenDayTargetList.id)
end

-------------------------98元累充奖励--------------------------------
function PromotionData:reqRechargeReward()
    NetManager:sendMessage(ProtocolID.GReqRechargeDaysBList)
end

function PromotionData:setRechargeReward(server_data, recharge_day)
    self.recharge_reward.data = {}
    self.recharge_reward.days = recharge_day
    for i, v in ipairs(cfg.promotionrechargedays98.promotionrechargedays98) do
        local ndata = {}
        ndata.day = v.day
        ndata.item = v.item
        ndata.has_reward = 0
        ndata.money = 0
        for sk, sv in pairs(server_data) do
            if ndata.day == sv.day then
                ndata.has_reward = sv.has_reward
                ndata.money = sv.money
            end
        end
        table.insert(self.recharge_reward.data, ndata)
    end
end

function PromotionData:getRechargeReward(day)
    for k, v in pairs(self.recharge_reward.data) do
        if v.day == day then
            v.has_reward = 1
        end
    end

    local req = Promotion060_pb.GReqRechargeDaysBReward()
    req.day = day
    NetManager:sendMessage(ProtocolID.GReqRechargeDaysBReward, req)

    self:checkRechargeAward2RedDot()
end

function PromotionData:customizedIsOpen()
    local cur_time = ex.Game:getServerTime()
    local open_data = self.running_promotion_data[62]
    if open_data == nil or table.nums(open_data) == 0 then
        return false
    end
    return cur_time >= open_data.start_time and cur_time <= open_data.end_time
end

function PromotionData:checkMagicButterflyIsOpen()
    local cur_time = ex.Game:getServerTime()
    local open_data = self.running_promotion_data[65]
    if open_data == nil or table.nums(open_data) == 0 then
        return false
    end
    return cur_time >= open_data.start_time and cur_time <= open_data.end_time
    -- return true
end

function PromotionData:checkLuckFishIsOpen()
    local cur_time = ex.Game:getServerTime()
    local open_data = self.running_promotion_data[67]
    if open_data == nil or table.nums(open_data) == 0 then
        return false
    end
    return cur_time >= open_data.start_time and cur_time <= open_data.end_time
end

-------------------------功能预告--------------------------------
function PromotionData:setPromotion66Info(data)
    if not cfg.promotiongameplayprediction then
        return
    end

    local config = cfg.promotiongameplayprediction.promotiongameplayprediction
    if not config then
        self.promotion66_config = nil
        self.promotion66_receive_time = 0
        self.promotion66_start_time = 0
        self.promotion66_end_time = 0
        return
    end



	local config = cfg.promotiongameplayprediction.promotiongameplayprediction;
	if not config then
		self.promotion66_config = nil;
		self.promotion66_receive_time = 0;
		return;
	end

    self.promotion66_config = config
    self.promotion66_receive_time = data.receive_time or 0
    self.promotion66_start_time = data.start_time or 0
    self.promotion66_end_time = data.end_time or 0

    local isSameDay = Maths.isSameDay(cpp.Game:instance():getServerTime(), data.receive_time)

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_GNYG, not isSameDay)
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_GNYG_MRJL, not isSameDay)
end

function PromotionData:setPromotion66ReceiveTime(data)
    self.promotion66_receive_time = data.receive_time
    local isSameDay = Maths.isSameDay(cpp.Game:instance():getServerTime(), data.receive_time)

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_GNYG, not isSameDay)
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_GNYG_MRJL, not isSameDay)
end

function PromotionData:checkPromotion66IsOpen()
    if self.promotion66_start_time < ex.Game:getServerTime() and ex.Game:getServerTime() < self.promotion66_end_time then
        return true
    end

    return false
end

-------------------------梦境秘宝--------------------------------
function PromotionData:reqPromotion70Data()
    -- return self:getPromotionDatas(promotionPros.GReqGetDataInfo.id)
    NetManager:sendMessage(ProtocolID.GReqGetDataInfo)
end

function PromotionData:getPromotion70Data()
    return self:getPromotionDatas(promotionPros.GReqGetDataInfo.id)
end

function PromotionData:setPromotion70Info(data)
    self.promotion70_mission = {}
    self.promotion70_game_info = {}
    self.promotion70_choose_rewards = nil

    if not cfg.promotion070reward or not cfg.promotion070reward.promotion070reward then
        return
    end

    for k, v in ipairs(cfg.promotion070reward.promotion070reward) do
        self.promotion70_rewards[v.idx] = clone(v)
    end

    self.promotion70_open_day = data.open_day
    self.promotion70_good_buy_count = data.good_buy_count

    local open_config = cfg.promotion070opencountreward.promotion070opencountreward
    local max_open_reward_num = open_config[#open_config].count
    self.promotion70_game_info.max_open_reward_num = max_open_reward_num

    local count_reward = {}
    if data.count_reward then
        count_reward = clone(data.count_reward)
    end

    self.promotion70_game_info.count_reward = count_reward

    local open_count = 0
    if data.open_count then
        open_count = data.open_count
    end

    self.promotion70_game_info.open_count = open_count
    self.promotion70_game_info.open_record = {}
    self.promotion70_game_info.res_open_record = data.open_record 
    if data.open_record and #data.open_record > 0 then
        for k, v in ipairs(data.open_record) do
            local idx = v.key
            local reward_id = v.value
            if self.promotion70_rewards[reward_id] and self.promotion70_rewards[reward_id].reward then
                local reward = self.promotion70_rewards[reward_id].reward
                local type = self.promotion70_rewards[reward_id].type

                if reward and #reward > 0 then
                    self.promotion70_game_info.open_record[idx] = {
                        reward = clone(reward[1]),
                        is_top_reward = type == 1
                    }
                end
            end
        end
    end

    self:selectPromotion70Reward(data)

    if data.mission and #data.mission > 0 then
        for k, v in ipairs(data.mission) do
            if v then
                self.promotion70_mission[v.idx] = clone(v)
            end
        end
    end

    self.promotion70_mission_box_reward_record = data.mission_box_reward_record

    
    ex.EventManager:fire(EVENT.SECRET_TREASURE.EVENT_BUY)
    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)

    self:checkPromotion70RedDot()
end

function PromotionData:selectPromotion70Reward(data)
    if not self.promotion70_game_info then
        return
    end

    local select_info = {}
    if not data.select_info or #data.select_info == 0 then
        return
    end

    self.promotion70_choose_rewards = {}
    for k, v in ipairs(data.select_info) do
        if v.reward_id and #v.reward_id > 0 then
            for k1, v1 in ipairs(v.reward_id) do
                select_info[v1] = v1
            end
        end
    end

    for k, v in ipairs(cfg.promotion070reward.promotion070reward) do
        if v.type > 0 and v.type < 4 then
            if not self.promotion70_choose_rewards[v.type] then
                self.promotion70_choose_rewards[v.type] = {}
            end

            local is_get = false
            if self.promotion70_game_info.res_open_record and 
            #self.promotion70_game_info.res_open_record > 0 then
                for k1, v1 in ipairs(self.promotion70_game_info.res_open_record ) do
                    local idx = v1.value
                    if idx == v.idx then
                        is_get = true
                        break
                    end
                end
            end

            local model = {
                config = clone(v),
                is_get = is_get,
                is_choose = select_info[v.idx] ~= nil
            }

            table.insert(self.promotion70_choose_rewards[v.type], model)
        end
    end
end

function PromotionData:openPromotion70Item(data)
    if not self.promotion70_game_info then
        return
    end

    if not self.promotion70_game_info.open_count then
        self.promotion70_game_info.open_count = 0
    end

    self.promotion70_game_info.open_count = self.promotion70_game_info.open_count + 1
    self.promotion70_game_info.open_record = {}
    if data.open_record and #data.open_record then
        for k, v in ipairs(data.open_record) do
            local idx = v.key
            local reward_id = v.value
            if self.promotion70_rewards[reward_id] and self.promotion70_rewards[reward_id].reward then
                local reward = self.promotion70_rewards[reward_id].reward
                local type = self.promotion70_rewards[reward_id].type
                if reward and #reward > 0 then
                    self.promotion70_game_info.open_record[idx] = {
                        reward = clone(reward[1]),
                        is_top_reward = type == 1
                    }
                    
                    if self.promotion70_choose_rewards[type] and #self.promotion70_choose_rewards[type] > 0 then
                        for k, v in ipairs(self.promotion70_choose_rewards[type]) do
                            if v.config.idx == reward_id then
                                v.is_get = true
                            end
                        end
                    end
                end
            end
        end
    end
end

function PromotionData:getPromotion70RewardItem(idx)
    return self.promotion70_rewards[idx]
end

function PromotionData:getPromotion70CounrReward(data)
    if not self.promotion70_game_info then
        return
    end
    
    if not self.promotion70_game_info.count_reward then
        self.promotion70_game_info.count_reward = {}
    end

    table.insert(self.promotion70_game_info.count_reward, data.idx)
end

function PromotionData:resetPromotion70Select()
    self.promotion70_game_info.res_open_record = {}
    self.promotion70_game_info.open_record = {}
    self.promotion70_choose_rewards = nil
end

function PromotionData:getPromotion70MissionReward(data)
    if data.mission_info and data.mission_info.idx and self.promotion70_mission[data.mission_info.idx] then
        self.promotion70_mission[data.mission_info.idx] = clone(data.mission_info)
    end
    ex.EventManager:fire(EVENT.SECRET_TREASURE.EVENT_GET_MISSION)
    self:checkPromotion70RedDot()
end

function PromotionData:updatePromotion70Mission(data)
    if data.mission and #data.mission > 0 then
        for k, v in ipairs(data.mission) do
            if v then
                self.promotion70_mission[v.idx] = clone(v)
            end
        end
    end
    ex.EventManager:fire(EVENT.SECRET_TREASURE.EVENT_UPDATA_MISSION)
    self:checkPromotion70RedDot()
end

function PromotionData:updatePromotion70GetMissionBox(data)
    if self.promotion70_mission_box_reward_record == nil then
        return
    end

    table.insert(self.promotion70_mission_box_reward_record, data.idx)
    ex.EventManager:fire(EVENT.SECRET_TREASURE.EVENT_GET_BOX)
    self:checkPromotion70RedDot()
end

function PromotionData:checkPromotion70RedDot()
    -- 判断是否有可以领取的任务
    local is_mission_reward = false
    for k,v in pairs(self.promotion70_mission) do
        local config = cfg.promotion070mission.promotion070mission[v.idx]
        if config and config.day == self.promotion70_open_day then
            local status = self:getPromotion70MissionStatus(v.idx)
            if status == 0 then
                is_mission_reward = true
                break
            end
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_MJMB_MBRW_BXJL, is_mission_reward)

    -- 判断是否有可以领取的宝箱
    local is_box_reward = false
    for i,v in ipairs(cfg.promotion070missionboxreward.promotion070missionboxreward) do
        local status = self:getPromotion70BoxRewardStatus(v.idx)
        if status == 0 then
            is_box_reward = true
            break
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_MJMB_MBRW_RWJL, is_box_reward)
end

function PromotionData:getPromotion70MissionRewardNum()
    local reward_num = 0
    for k,v in pairs(self.promotion70_mission) do
       if v.had_reward then
            reward_num = reward_num + 1
       end 
    end
    return reward_num
end

function PromotionData:getPromotion70BoxRewardStatus(idx)
    local is_reward = TableEx.findValueFunction(self.promotion70_mission_box_reward_record, function(value)
        return value == idx
    end)
    if is_reward then
        return -1
    end

    local reward_num = self:getPromotion70MissionRewardNum()

    local config = cfg.promotion070missionboxreward.promotion070missionboxreward[idx]
    if config and config.count <= reward_num then
        return 0
    end
    
    return 1
end

function PromotionData:getPromotion70MissionStatus(idx)
    local data = self.promotion70_mission[idx]
    if data then
        if data.had_reward then
            return -1
        end

        local config = cfg.promotion070mission.promotion070mission[idx]
        if config and data.process >= config.target.target then
            return 0
        end
    end
    return 1
end

function PromotionData:getChooseNumByType(reward_type)
    if not cfg.promotion070type or not cfg.promotion070type.promotion070type then
        return 0
    end

    for k, v in ipairs(cfg.promotion070type.promotion070type) do
        if v.idx == reward_type then
            return v.num
        end
    end

    return 0
end

function PromotionData:checkPromotion70IsOpen()
    if not cfg.promotion070reward or not cfg.promotion070reward.promotion070reward then
        return false
    end

    if not self.promotion70_game_info then
        return false
    end

    return self:getTimeIsOpen(promotionPros.GReqGetDataInfo.id)
end


-------------------------七神器--------------------------------
function PromotionData:setPromotion71GetInfo(data)
    self.promotion71_buy_record = {}
    if data and #data then
        for k, v in ipairs(data) do
            self.promotion71_buy_record[v.key] = v.value
        end
    end

    self.promotion71_is_get_info = true
    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)

end

function PromotionData:updatePromotion71BuyRecord(data)
    for k, v in pairs(self.promotion71_buy_record) do
        if k == data.key then
            self.promotion71_buy_record[k] = data.value
            break
        end
    end
end

function PromotionData:getPromotion71Info()
    if not cfg.promotion071QSQ or not cfg.promotion071QSQ.promotion071QSQ or #cfg.promotion071QSQ.promotion071QSQ == 0 then
        return
    end

    local goods_list = {}
    for k, v in ipairs(cfg.promotion071QSQ.promotion071QSQ) do
        local goods = {
            idx = v.idx,
            reward = v.reward,
            product_id = v.product_id,
            buy_limit = v.buy_limit,
            name = ex.Tools:getLang(v.gift_name),
            buy_times = self.promotion71_buy_record[v.idx] or 0
        }

        table.insert(goods_list, goods)
    end
    
    local len = #goods_list
    local index = 1
    for i = 1, len do
        local goods = goods_list[index]
        if goods.buy_limit <= goods.buy_times then
            local temp_goods = table.remove(goods_list, index)
            table.insert(goods_list, temp_goods)
        else
            index = index + 1
        end
    end
    
    return goods_list
end

function PromotionData:getPromotion71Data()
    return self:getPromotionDatas(promotionPros.GReqQiShenQiInfo.id)
end

function PromotionData:checkPromotion71IsOpen()
    if not cfg.promotion071QSQ or not cfg.promotion071QSQ.promotion071QSQ then
        return false
    end

    if not self.promotion71_is_get_info then
        return false
    end
    
    local promotion_data = self:getPromotion71Data()
    if not promotion_data or 
    (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or
    (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or 
    (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time) then
        return false
    end

    return true
end

function PromotionData:checkShenYuOpen( )
    local open_data = self:getPromotionDatas(72)
    if not open_data then return false end 
    return self:getTimeIsOpen(72)
end

-------------------------储值重置--------------------------------
function PromotionData:setPromotion73Status(is_reset)
    self.promotion73_is_reset = is_reset
end

function PromotionData:getPromotion73Status()
    return self.promotion73_is_reset
end

----------------------------国庆活动--秋赏明月------------------------------
function PromotionData:checkShangYueRedDot()
    local bool = self.zhongqiu_data:RedPointByMainCity()
    return bool
end

function PromotionData:checkShangYueSlotIsOpen()
    return self:getTimeIsOpen(74)
end

function PromotionData:checkJiaYaoIsOpen()
    return self:getTimeIsOpen(75)
end


----------------------------国庆活动--皮肤活动------------------------------
function PromotionData:setMidFashionGetDataInfo(data)
    -- promotion76_skin_info ：拼图奖励进度
    -- promotion76_forever_active ： 已经拥有的皮肤列表
    self.promotion76_skin_info = {}
    self.promotion76_forever_active = data.forever_active
    if data and #data then
        for k, v in ipairs(data.fashion_count_reward) do
            table.insert(self.promotion76_skin_info, v)
        end
    end
    self:checkZhongQiuSkinRedDot()
end

function PromotionData:setMidFashionFashionCount(data)
    if data and #data then
        table.insert(self.promotion76_skin_info, data.idx)
    end
    ex.EventManager:fire(EVENT.APPRECIATE_SKIN.EVENT_UPDATA)
    self:checkZhongQiuSkinRedDot()
end

function PromotionData:setMidFashionExchangeFashion(data)
    self.promotion76_skin_info = {}
    if data and #data then
        for k, v in ipairs(data.fashion_count_reward) do
            table.insert(self.promotion76_skin_info, v)
        end
    end
    ex.EventManager:fire(EVENT.APPRECIATE_SKIN.EVENT_UPDATA)
    self:checkZhongQiuSkinRedDot()
end

function PromotionData:checkZhongQiuSkinIsOpen()
    return self:getTimeIsOpen(76)
end

function PromotionData:checkZhongQiuSkinRedDot()
    local bool = false
    local need_item = cfg.promotionskindatainfo.promotionskindatainfo[1].need_item[1]
	local num = ex.Player:getItemNum(need_item.item_type)
    for i=1,4 do
		local item = cfg.promotion076fashioncountreward.promotion076fashioncountreward[i].need_item[1]
        if num >= item.item_num and self.promotion76_skin_info and next(self.promotion76_skin_info) then
            local boolTemp = false
            for k,v in ipairs(self.promotion76_skin_info) do
                if i == v then
                    boolTemp = true
                    break
                end
            end
            if not boolTemp then
                bool = true
                break
            end
		end
    end

	local max_num = need_item.item_num
	if num >= max_num then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZQHD_PFHD_PFDH, true)
    else
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZQHD_PFHD_PFDH, false)
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZQHD_PFHD, bool)
    end

end

--------------------------- 观月任务 ---------------------------
function PromotionData:handleGetProm77Data(data)
    self.promotion77_open_day = data.open_day

    if data.mission and #data.mission > 0 then
        for k, v in ipairs(data.mission) do
            if v then
                self.promotion77_mission[v.idx] = clone(v)
            end
        end
    end

    self.promotion77_mission_box_reward_record = data.mission_box_reward_record
    self:checkPromotion77RedDot()
end

function PromotionData:handleGetProm77MissionDone(data)
    if data.mission_info and data.mission_info.idx and self.promotion77_mission[data.mission_info.idx] then
        self.promotion77_mission[data.mission_info.idx] = clone(data.mission_info)
    end
    ex.EventManager:fire(EVENT.SECRET_TREASURE.EVENT_GET_MISSION)
    self:checkPromotion77RedDot()
end

function PromotionData:handleUpdateProm77Mission(data)
    if data.mission and #data.mission > 0 then
        for k, v in ipairs(data.mission) do
            if v then
                self.promotion77_mission[v.idx] = clone(v)
            end
        end
    end
    ex.EventManager:fire(EVENT.SECRET_TREASURE.EVENT_UPDATA_MISSION)
    self:checkPromotion77RedDot()
end

function PromotionData:handlegetProm77BoxAward(data)
    if self.promotion77_mission_box_reward_record == nil then
        return
    end

    table.insert(self.promotion77_mission_box_reward_record, data.idx)
    ex.EventManager:fire(EVENT.SECRET_TREASURE.EVENT_GET_BOX)
    self:checkPromotion77RedDot()
end

function PromotionData:checkPromotion77RedDot()
    -- 判断是否有可以领取的任务
    local is_mission_reward = false
    for k, v in pairs(self.promotion77_mission) do
        local config = cfg.promotion077mission.promotion077mission[v.idx]
        if config and config.day == self.promotion77_open_day then
            local status = self:getPromotion77MissionStatus(v.idx)
            if status == 0 then
                is_mission_reward = true
                break
            end
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZQHD_SYRW_RWJL, is_mission_reward)

    -- 判断是否有可以领取的宝箱
    local is_box_reward = false
    for i, v in ipairs(cfg.promotion077missionboxreward.promotion077missionboxreward) do
        local status = self:getPromotion77BoxRewardStatus(v.idx)
        if status == 0 then
            is_box_reward = true
            break
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZQHD_SYRW_RWBX, is_box_reward)
end

function PromotionData:getPromotion77MissionStatus(idx)
    local data = self.promotion77_mission[idx]
    if data then
        if data.had_reward then
            return -1
        end

        local config = cfg.promotion077mission.promotion077mission[idx]
        if config and data.process >= config.target.target then
            return 0
        end
    end
    return 1
end

function PromotionData:getPromotion77BoxRewardStatus(idx)
    local is_reward =
        TableEx.findValueFunction(
        self.promotion77_mission_box_reward_record,
        function(value)
            return value == idx
        end
    )
    if is_reward then
        return -1
    end

    local reward_num = self:getPromotion77MissionRewardNum()

    local config = cfg.promotion077missionboxreward.promotion077missionboxreward[idx]
    if config and config.count <= reward_num then
        return 0
    end

    return 1
end

function PromotionData:getPromotion77MissionRewardNum()
    local reward_num = 0
    for k, v in pairs(self.promotion77_mission) do
        if v.had_reward then
            reward_num = reward_num + 1
        end
    end
    return reward_num
end

function PromotionData:checkPromotion77IsOpen()
    if self.promotion77_open_day == 0 then
        return false
    end

    local promotion_data = self:getPromotion77Data()
    if
        not promotion_data or (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or
            (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time)
     then
        return false
    end

    return true
end

function PromotionData:getPromotion77Data()
    return self:getPromotionDatas(promotionPros.GReqMidMissionGetDataInfo.id)
end

-------------------------惊喜扭蛋，活动78----------------------------------
function PromotionData:setPromotion78GetInfo(data)
    self.promotion78_data = {}
    self.promotion78_data.select_info = data.select_info
    self.promotion78_data.box_reward_record = {}
    if data.lottery_reward and #data.lottery_reward > 0 then
        for k, v in ipairs(data.lottery_reward) do
            self.promotion78_data.box_reward_record[v] = true
        end
    end

    self.promotion78_data.lottery_reward = data.lottery_reward
    self.promotion78_data.lottery_count = data.lottery_count
    self.promotion78_data.lottery_best_remaining_count = data.lottery_best_remaining_count
    self.promotion78_data.last_lottery_id = data.last_lottery_id
    self.promotion78_is_get_info = true

    ex.EventManager:fire(EVENT.HALLOWEEN.EVENT_UPDATE_GACHA)
    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)
end

function PromotionData:handlePromotion78Select(data)
    self.promotion78_data.select_info = data.select_info

    ex.EventManager:fire(EVENT.HALLOWEEN.EVENT_UPDATE_GACHA)
end

function PromotionData:handlePromotion78Draw(data)
    self.promotion78_data.lottery_best_remaining_count = data.lottery_best_remaining_count
    self.promotion78_data.idx = data.idx
    self.promotion78_data.lottery_count = data.lottery_count
    self.promotion78_data.last_lottery_id = data.idx
    local vec_reward = {}
    if data.reward and #data.reward > 0 then
        for i,v in ipairs(data.reward) do
            local item = {}
            item.item_type = v.type 
            item.item_num = v.num
            table.insert(vec_reward,item)
        end
    end
    if ex.MainSceneCtr.cur_layer_type ~= MainSceneType.MAIN_ACT_HALLOWEEN then
        require("src.layer.ItemRewardCtr"):instance():openWindow(vec_reward)
    else
        ex.EventManager:fire(EVENT.HALLOWEEN.EVENT_GACHA_DRAW, vec_reward)
    end
end

function PromotionData:handlePromotion78BoxReward(data)
    if not self.promotion78_data.box_reward_record then
        self.promotion78_data.box_reward_record = {}
    end
    
    self.promotion78_data.box_reward_record[data.idx] = true
    
    ex.EventManager:fire(EVENT.HALLOWEEN.EVENT_UPDATE_GACHA)
end

function PromotionData:getPromotion78Data()
    return self:getPromotionDatas(promotionPros.GReqHalloweenLotteryGetDataInfo.id)
end

function PromotionData:checkPromotion78IsOpen()
    if not cfg.promotion078lotteryreward or not cfg.promotion078lotteryreward.promotion078lotteryreward then
        return false
    end

    if not self.promotion78_is_get_info then
        return false
    end

    local promotion_data = self:getPromotion78Data()
    if
        not promotion_data or (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or
            (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time)
     then
        return false
    end

    return true
end


-------------------------鬼怪巡游会，活动79--------------------------------
function PromotionData:setPromotion79GetInfo(data)
    self.promotion79_buy_record = {}
    if data and #data then
        for k, v in ipairs(data) do
            self.promotion79_buy_record[v.key] = v.value
        end
    end

    self.promotion79_is_get_info = true
    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)
end

function PromotionData:updatePromotion79BuyRecord(data)
    for k, v in pairs(self.promotion79_buy_record) do
        if k == data.key then
            self.promotion79_buy_record[k] = data.value
            break
        end
    end

    ex.EventManager:fire(EVENT.HALLOWEEN.EVENT_BUY_GOODS)
end

function PromotionData:getPromotion79Info()
    if not cfg.promotion079 or not cfg.promotion079.promotion079 or #cfg.promotion079.promotion079 == 0 then
        return
    end

    local goods_list = {}
    for k, v in ipairs(cfg.promotion079.promotion079) do
        local goods = {
            idx = v.idx,
            reward = v.reward,
            product_id = v.product_id,
            buy_limit = v.buy_limit,
            name = ex.Tools:getLang(v.gift_name),
            buy_times = self.promotion79_buy_record[v.idx] or 0
        }

        table.insert(goods_list, goods)
    end

    local len = #goods_list
    local index = 1
    for i = 1, len do
        local goods = goods_list[index]
        if goods.buy_limit <= goods.buy_times then
            local temp_goods = table.remove(goods_list, index)
            table.insert(goods_list, temp_goods)
        else
            index = index + 1
        end
    end

    return goods_list
end

function PromotionData:getPromotion79Data()
    return self:getPromotionDatas(promotionPros.GReqHalloweenGiftInfo.id)
end

function PromotionData:checkPromotion79IsOpen()
    if not cfg.promotion079 or not cfg.promotion079.promotion079 then
        return false
    end

    if not self.promotion79_is_get_info then
        return false
    end

    local promotion_data = self:getPromotion79Data()
    if
        not promotion_data or (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or
            (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time)
     then
        return false
    end

    return true
end

function PromotionData:handleGetProm80Data(data)
    self.promotion80_open_day = data.open_day

    if data.mission and #data.mission > 0 then
        for k, v in ipairs(data.mission) do
            if v then
                self.promotion80_mission[v.idx] = clone(v)
            end
        end
    end

    self.promotion80_mission_box_reward_record = data.mission_box_reward_record
    self:checkPromotion80RedDot()
    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)
end

function PromotionData:handleGetProm80MissionDone(data)
    if data.mission_info and data.mission_info.idx and self.promotion80_mission[data.mission_info.idx] then
        self.promotion80_mission[data.mission_info.idx] = clone(data.mission_info)
    end
    ex.EventManager:fire(EVENT.HALLOWEEN.EVENT_GET_MISSION)
    self:checkPromotion80RedDot()
end

function PromotionData:handleUpdateProm80Mission(data)
    if data.mission and #data.mission > 0 then
        for k, v in ipairs(data.mission) do
            if v then
                self.promotion80_mission[v.idx] = clone(v)
            end
        end
    end
    ex.EventManager:fire(EVENT.HALLOWEEN.EVENT_UPDATA_MISSION)
    self:checkPromotion80RedDot()
end

function PromotionData:handlegetProm80BoxAward(data)
    if self.promotion80_mission_box_reward_record == nil then
        return
    end

    table.insert(self.promotion80_mission_box_reward_record, data.idx)
    ex.EventManager:fire(EVENT.HALLOWEEN.EVENT_GET_BOX)
    self:checkPromotion80RedDot()
end

function PromotionData:checkPromotion80RedDot()
    -- 判断是否有可以领取的任务
    local is_mission_reward = false
    for k, v in pairs(self.promotion80_mission) do
        local config = cfg.promotion080mission.promotion080mission[v.idx]
        if config and config.day == self.promotion80_open_day then
            local status = self:getPromotion80MissionStatus(v.idx)
            if status == 0 then
                is_mission_reward = true
                break
            end
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_WSHD_WSRW_RWJL, is_mission_reward)

    -- 判断是否有可以领取的宝箱
    local is_box_reward = false
    for i, v in ipairs(cfg.promotion080missionboxreward.promotion080missionboxreward) do
        local status = self:getPromotion80BoxRewardStatus(v.idx)
        if status == 0 then
            is_box_reward = true
            break
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_WSHD_WSRW_BXJL, is_box_reward)
end

function PromotionData:getPromotion80MissionStatus(idx)
    local data = self.promotion80_mission[idx]
    if data then
        if data.had_reward then
            return -1
        end

        local config = cfg.promotion080mission.promotion080mission[idx]
        if config and data.process >= config.target.target then
            return 0
        end
    end
    return 1
end

function PromotionData:getPromotion80BoxRewardStatus(idx)
    local is_reward =
        TableEx.findValueFunction(
        self.promotion80_mission_box_reward_record,
        function(value)
            return value == idx
        end
    )
    if is_reward then
        return -1
    end

    local reward_num = self:getPromotion80MissionRewardNum()

    local config = cfg.promotion080missionboxreward.promotion080missionboxreward[idx]
    if config and config.count <= reward_num then
        return 0
    end

    return 1
end

function PromotionData:getPromotion80MissionRewardNum()
    local reward_num = 0
    for k, v in pairs(self.promotion80_mission) do
        if v.had_reward then
            reward_num = reward_num + 1
        end
    end
    return reward_num
end

function PromotionData:checkPromotion80IsOpen()
    if self.promotion80_open_day == 0 then
        return false
    end

    local promotion_data = self:getPromotion80Data()
    if
        not promotion_data or (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or
            (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time)
     then
        return false
    end

    return true
end

function PromotionData:getPromotion80Data()
    return self:getPromotionDatas(promotionPros.GReqHalloweenMissionGetDataInfo.id)
end


---------------- 黑色星期五 ------------------
-- 血拼黑五
function PromotionData:getPromotion82Data()
    return self:getPromotionDatas(promotionPros.gReqBlackFiveGiftInfo.id)
end

function PromotionData:checkPromotionIs82Open()
    local promotion_data = self:getPromotion82Data()
    if
        not promotion_data or (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or
            (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time)
     then
        return false
    end

    return true
end

function PromotionData:getPromotion82Info()
    if not cfg.promotion082XPHW or not cfg.promotion082XPHW.promotion082XPHW or #cfg.promotion082XPHW.promotion082XPHW == 0 then
        return
    end

    local goods_list = {}
    for k, v in ipairs(cfg.promotion082XPHW.promotion082XPHW) do
        local goods = {
            idx = v.idx,
            reward = v.reward,
            product_id = v.product_id,
            buy_limit = v.buy_limit,
            name = ex.Tools:getLang(v.gift_name),
            buy_times = self.promotion82_buy_record[v.idx] or 0
        }

        table.insert(goods_list, goods)
    end
    
    local len = #goods_list
    local index = 1
    for i = 1, len do
        local goods = goods_list[index]
        if goods.buy_limit <= goods.buy_times then
            local temp_goods = table.remove(goods_list, index)
            table.insert(goods_list, temp_goods)
        else
            index = index + 1
        end
    end
    
    return goods_list
end

function PromotionData:setPromotion82GetInfo(data)
    self.promotion82_buy_record = {}
    if data and #data then
        for k, v in ipairs(data) do
            self.promotion82_buy_record[v.key] = v.value
        end
    end

    self.promotion82_is_get_info = true
    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)

end

function PromotionData:updatePromotion82BuyRecord(data)
    for k, v in pairs(self.promotion82_buy_record) do
        if k == data.key then
            self.promotion82_buy_record[k] = data.value
            break
        end
    end

    ex.EventManager:fire(EVENT.BLACKFRIDAY.EVENT_BUY_GOODS)
end

---------------- 超级折扣 ---------------------
function PromotionData:checkPromotionIs81Open()
    local promotion_data = self:getPromotion81Data()
    if
        not promotion_data or (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or
            (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time)
     then
        return false
    end

    return true
end

function PromotionData:getPromotion81Data()
    return self:getPromotionDatas(promotionPros.gReqBlackFiveMissionGetDataInfo.id)
end

function PromotionData:handleGetProm81Data(data)
    if data.mission and #data.mission > 0 then
        for k, v in ipairs(data.mission) do
            if v then
                self.promotion81_mission[v.idx] = clone(v)
            end
        end
    end
    self.promotion81_mission_box_reward_record = data.mission_box_reward_record
    self.promotion81_mission_reward_count = data.mission_reward_count -- 任务领取数量

    self.promotion81_buy_record = data.buy
    self:checkPromotion81RedDot()
end

function PromotionData:getPromotion81MissionStatus(idx)
    local data = self.promotion81_mission[idx]
    if data then
        if data.had_reward then
            return -1
        end

        local config = cfg.promotion081mission.promotion081mission[idx]
        if config and data.process >= config.target.target then
            return 0
        end
    end
    return 1
end

function PromotionData:checkPromotion81RedDot()
    -- 判断是否有可以领取的任务
    local is_mission_reward = false
    for k, v in pairs(self.promotion81_mission) do
        local config = cfg.promotion081mission.promotion081mission[v.idx]
        if config then
            local status = self:getPromotion81MissionStatus(v.idx)
            if status == 0 then
                is_mission_reward = true
                break
            end
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HSXQW_CJDZ_RWJL, is_mission_reward)

    -- 判断是否有可以领取的宝箱
    local is_box_reward = false
    for i, v in ipairs(cfg.promotion081missionboxreward.promotion081missionboxreward) do
        local status = self:getPromotion81BoxRewardStatus(v.idx)
        if status == 0 then
            is_box_reward = true
            break
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HSXQW_CJDZ_RWBX, is_box_reward)
end

function PromotionData:handleGetProm81MissionDone(data)
    if data.mission_info and data.mission_info.idx and self.promotion81_mission[data.mission_info.idx] then
        self.promotion81_mission[data.mission_info.idx] = clone(data.mission_info)
    end
    self.promotion81_mission_reward_count = data.mission_reward_count -- 任务领取数量
    ex.EventManager:fire(EVENT.BLACKFRIDAY.EVENT_GET_MISSION)
    self:checkPromotion81RedDot()
end

function PromotionData:handleUpdateProm81Mission(data)
    if data.mission and #data.mission > 0 then
        for k, v in ipairs(data.mission) do
            if v then
                self.promotion81_mission[v.idx] = clone(v)
            end
        end
    end
    ex.EventManager:fire(EVENT.BLACKFRIDAY.EVENT_UPDATA_MISSION)
    self:checkPromotion81RedDot()
end

function PromotionData:handlegetProm81BoxAward(data)
    if self.promotion81_mission_box_reward_record == nil then
        return
    end

    table.insert(self.promotion81_mission_box_reward_record, data.idx)
    ex.EventManager:fire(EVENT.BLACKFRIDAY.EVENT_GET_BOX)
    self:checkPromotion81RedDot()
end

function PromotionData:getPromotion81BoxRewardStatus(idx)
    local is_reward =
        TableEx.findValueFunction(
        self.promotion81_mission_box_reward_record,
        function(value)
            return value == idx
        end
    )
    if is_reward then
        return -1
    end

    local reward_num = self:getPromotion81MissionRewardNum()

    local config = cfg.promotion081missionboxreward.promotion081missionboxreward[idx]
    if config and config.count <= reward_num then
        return 0
    end

    return 1
end

function PromotionData:getPromotion81MissionRewardNum()
    local reward_num = 0
    for k, v in pairs(self.promotion81_mission) do
        if v.had_reward then
            reward_num = reward_num + 1
        end
    end
    return reward_num
end

function PromotionData:handlegetProm81Giftbuy(data)
    for k, v in pairs(self.promotion81_buy_record) do
        if v.key == data.key then
            self.promotion81_buy_record[k].value = data.value
            ex.EventManager:fire(EVENT.BLACKFRIDAY.EVENT_BUY_GIFT)
            return
        end
    end

    table.insert(self.promotion81_buy_record,data)
    ex.EventManager:fire(EVENT.BLACKFRIDAY.EVENT_BUY_GIFT)
end

----------------------------------------------------- 黑色通缉
function PromotionData:checkPromotionIs83Open()
    return self:getTimeIsOpen(promotionPros.GReqBlackFiveLotteryGetDataInfo.id)
end

function PromotionData:getBlackFiveLotteryGetDataInfo(data)
    self.blackfivelottery_select_info = {}
    self.blackfivelottery_reward_cord = {}
    self.blackfivelottery_summon_count = 0
    self.blackfivelottery_remaining_count = 0
    self:setBlackFiveLotterySelectInfo(data.select_info)
    self:setBlackFiveLotterySummonCount(data.lottery_count)
    self:setBlackFiveLotteryRemainingCount(data.lottery_best_remaining_count)
    for i,v in ipairs(data.lottery_reward) do
        self:setBlackFiveLotteryRewardCord(v)
    end
    self:RedPointBlackFiveLottery()
end

function PromotionData:setBlackFiveLotterySummonCount(data)
    self.blackfivelottery_summon_count = data
end

function PromotionData:setBlackFiveLotterySelectInfo(data)
    self.blackfivelottery_select_info = data 
end

function PromotionData:UpdateBlackFiveLotterySelectInfo(data)
    self.blackfivelottery_select_info = data.select_info
end

function PromotionData:setBlackFiveLotteryRemainingCount(data)
    self.blackfivelottery_remaining_count = data
end

function PromotionData:setBlackFiveLotteryRewardCord(idx)
    --self.reward_cord = data
    self.blackfivelottery_reward_cord[idx] = true
end


function PromotionData:RedPointBlackFiveLottery()
    local bool = false 
    local is_open = ex.Player.promotion_data:getTimeIsOpen(83)
    if is_open ~= true then 
        return false 
    end 

    for i,v in ipairs(cfg.promotion083lotterycountreward.promotion083lotterycountreward) do
        bool = self:checkBlackFiveLotteryBoxStatus(v.idx) == 0 
        if bool == true then 
            break 
        end 
    end

    local cost = cfg.system.promotion083_lottery_cost[1]
    local has_num = ex.Player:getItemNum(cost.item_type)


    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HSXQW_HWTJ_RWBX, bool or has_num > 0)
    return bool
end 

function PromotionData:getBlackFiveLotteryBoxCordByIdx(idx)
    return self.blackfivelottery_reward_cord[idx] == true
end

function PromotionData:checkBlackFiveLotteryBoxStatus(idx)
    local geted = self:getBlackFiveLotteryBoxCordByIdx(idx)
    local status = geted == true and -1 or 0
    if geted == true then 
        return status
    else 
        local box_cfg = cfg.promotion083lotterycountreward.promotion083lotterycountreward[idx]
        if not box_cfg then return false end 
        if self.blackfivelottery_summon_count >= box_cfg.count then 
            status = 0
        else 
            status = 1
        end 
    end 

    return status 
end 

function PromotionData:BlackFiveLotteryisSelected()
    local _bool = self.blackfivelottery_select_info.key > 0 and self.blackfivelottery_select_info.value > 0
    return _bool
end

function PromotionData:getBlackFiveLotterySelectIndex()
    return self.blackfivelottery_select_info.value 
end

-------------------------------------- 黑五活动 英雄排行榜-----------------------------
function PromotionData:checkPromotionIs92Open()
    local promotion_data = self:getPromotion92Data()
    if
        not promotion_data or (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or
            (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time)
     then
        return false
    end

    return true
end

function PromotionData:getPromotion92Data()
    return self:getPromotionDatas(promotionPros.gReqDeliverFlowerGetData.id)
end

function PromotionData:handleGetProm92Data(data)
    self.promotion92_data = data
    self:checkPromotion92RedDot()
end

function PromotionData:handleGetSelectHero(data)
    self.promotion92_data.hero_scores = data.hero_scores
    ex.EventManager:fire(EVENT.BLACKFRIDAY.EVENT_CHOOSE_HEROES)
end

-- 献花
function PromotionData:handleGetDeliverFlower(data)
    for k,v in pairs(self.promotion92_data.hero_scores) do
        if v.key == data.hero_score.key then
            v.value = data.hero_score.value
        end
    end
    self.promotion92_data.deliver_count = data.deliver_count

    local req = Promotion092_pb.GReqDeliverCountRank()
    NetManager:sendMessage(ProtocolID.GReqDeliverCountRank, req)

    self:checkPromotion92RedDot()

    ex.EventManager:fire(EVENT.BLACKFRIDAY.EVENT_SEND_FLOWERS)
    ex.EventManager:fire(EVENT.BLACKFRIDAY.EVENT_CHOOSE_HEROES)
end

-- 献花次数排行
function PromotionData:handleGetDeliverCountRank(data)
    local list = {}
    list.list = data.list
    list.self = data.self
    self.promotion92_data.flower_rank = list

    ex.EventManager:fire(EVENT.BLACKFRIDAY.EVENT_SEND_FLOWERS)
end

-- 领取献花次数达标奖励
function PromotionData:handleGetDeliverFlowerCountReward(data)
    table.insert( self.promotion92_data.count_reward_idx, data.idx )

    self:checkPromotion92RedDot()

    ex.EventManager:fire(EVENT.BLACKFRIDAY.EVENT_FLOWER_COUNT_REWARD)
end

-- 英雄积分排行
function PromotionData:handleGetDeliverHeroScoreRank(data)
    self.promotion92_data.hero_rank_list = data.list
    ex.EventManager:fire(EVENT.BLACKFRIDAY.EVENT_UPDATA_HERO_SCORE)
end

-- 买花
function PromotionData:handleGetDeliverBuyFlower(data)
    self.promotion92_data.buy_count = data.buy_count
    ex.EventManager:fire(EVENT.BLACKFRIDAY.EVENT_UPDATA_FLOWER)
end

function PromotionData:checkPromotion92RedDot()
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HSXQW_YXPHB_JLYL, false)
    for i,v in ipairs(cfg.promotion092countreward.promotion092countreward) do
        if ex.Player.promotion_data.promotion92_data.deliver_count >= v.count then
            local show_red = true
            for k,idx in ipairs(ex.Player.promotion_data.promotion92_data.count_reward_idx) do
                if v.idx == idx then
                    show_red = false
                    break
                end
            end
            if show_red then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HSXQW_YXPHB_JLYL, true)
                break
            end
        end
    end
  
end

-----------------------------三日累充-----------------------------
function PromotionData:handleGetProm84Data(data)
    self.promotion84_record = data
    self:checkThreeDaysRechargeRedDot()
end

function PromotionData:handleGetProm84ThreeDayGet(data)
    table.insert(self.promotion84_record.reward_record,data.idx)
    ex.EventManager:fire(EVENT.THREEDAYSRECHARGE.RECEIVE_REWARDS)
    self:checkThreeDaysRechargeRedDot()
end

function PromotionData:UpdataProm84Recharge(data)
    local isbool = false
    for i,v in ipairs(self.promotion84_record.recharge_info) do
        if v.day == data.recharge_info.day then
            v.recharge = data.recharge_info.recharge
            isbool = true
            break
        end
    end
  
    if not isbool then
        local rech_table = {}
        rech_table.day = data.recharge_info.day
        rech_table.recharge = data.recharge_info.recharge
        table.insert( self.promotion84_record.recharge_info, rech_table )
    end
    ex.EventManager:fire(EVENT.THREEDAYSRECHARGE.EVENT_RECHARGE_AMOUNT)
    self:checkThreeDaysRechargeRedDot()
    dump("---更新奖励---",data)
end

function PromotionData:checkThreeDaysRechargeRedDot()
    -- 三日累充 红点
    if cfg.promotion084reward ~= nil then
        local recharge = 0
        local red_id = {
            RedDotType.ZCJ_DHZC_PFHD_SRLC_DYT,
            --  主场景  导航-主城  皮肤活动  三日累充  第二天
            RedDotType.ZCJ_DHZC_PFHD_SRLC_DET,
            --  主场景  导航-主城  皮肤活动  三日累充  第三天
            RedDotType.ZCJ_DHZC_PFHD_SRLC_DST,
        }
        -- 第一天的价格
        local standar_recharge_one = cfg.promotion084reward.promotion084reward[1].rmb
        local day_index = 0
        for i,v in ipairs(self.promotion84_record.recharge_info) do
            if v.recharge >= standar_recharge_one then
                day_index = v.day
                break
            end
        end

        if day_index ~= 0 then
            local index = 1
            for i,v in ipairs(self.promotion84_record.recharge_info) do
                local isget = false
                if index >= 4 then return end
                local standar_recharge = cfg.promotion084reward.promotion084reward[index].rmb
                if v.recharge >= standar_recharge then
                    for k,g in ipairs(self.promotion84_record.reward_record) do
                        if v.day == g then
                            isget = true
                        end
                    end
                    if not isget then
                        ex.RedDotManager:setRedNodeVisible(red_id[index], true)
                    else
                        ex.RedDotManager:setRedNodeVisible(red_id[index], false)
                    end
                    index = index + 1
                end
            end
        end
    end
end

function PromotionData:checkThreeDaysRechargeIsOpen()
    if cfg.promotion084reward == nil then
        print(">>>>>PromotionData:checkThreeDaysRechargeIsOpen not exist config!")
        return false
    end

    return self:getTimeIsOpen(promotionPros.gReqThreeDay.id)
end

--------------------------------圣诞节活动--------------------------------
------------------- 圣诞奇幻夜
function PromotionData:checkPromotionIsChristmas1Open()
    if self:checkPromotionIsChristmas2Open() or
    self:checkPromotionIsChristmas3Open() or
    self:checkPromotionIsChristmas4Open() or
    self:checkPromotionIsChristmas5Open() or
    self:checkPromotionIsChristmas6Open() then
        return true
    else
        return false
    end
end

----------------- 圣诞连线
function PromotionData:checkPromotionIsChristmas2Open()
    if self.promotion85_open_day == 0 then
        return false
    end

    local promotion_data = self:getPromotion85Data()
    if
        not promotion_data or (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or
            (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time)
     then
        return false
    end

    return true
end

function PromotionData:handleGetProm85Data(data)
    self.promotion85_open_day = data.open_day

    if data.mission and #data.mission > 0 then
        for k, v in ipairs(data.mission) do
            if v then
                self.promotion85_mission[v.idx] = clone(v)
            end
        end
    end

    self.promotion85_mission_box_reward_record = data.mission_box_reward_record
    self:checkPromotion85RedDot()
end

function PromotionData:handleGetProm85MissionDone(data)
    if data.mission_info and data.mission_info.idx and self.promotion85_mission[data.mission_info.idx] then
        self.promotion85_mission[data.mission_info.idx] = clone(data.mission_info)
    end
    ex.EventManager:fire(EVENT.CHRISTMAS.EVENT_GET_MISSION)
    self:checkPromotion85RedDot()
end

function PromotionData:handleUpdateProm85Mission(data)
    if data.mission and #data.mission > 0 then
        for k, v in ipairs(data.mission) do
            if v then
                self.promotion85_mission[v.idx] = clone(v)
            end
        end
    end
    ex.EventManager:fire(EVENT.CHRISTMAS.EVENT_UPDATA_MISSION)
    self:checkPromotion85RedDot()
end

function PromotionData:handlegetProm85BoxAward(data)
    if self.promotion85_mission_box_reward_record == nil then
        return
    end

    table.insert(self.promotion85_mission_box_reward_record, data.idx)
    ex.EventManager:fire(EVENT.CHRISTMAS.EVENT_GET_BOX)
    self:checkPromotion85RedDot()
end

function PromotionData:checkPromotion85RedDot()
    -- 判断是否有可以领取的任务
    local is_mission_reward = false
    for k, v in pairs(self.promotion85_mission) do
        local config = cfg.promotion085mission.promotion085mission[v.idx]
        if config and config.day == self.promotion85_open_day then
            local status = self:getPromotion85MissionStatus(v.idx)
            if status == 0 then
                is_mission_reward = true
                break
            end
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDLX_RWJL, is_mission_reward)
    
   
    -- 判断是否有可以领取的宝箱
    local is_box_reward = false
    if cfg.promotion085missionboxreward ~= nil then
        for i, v in ipairs(cfg.promotion085missionboxreward.promotion085missionboxreward) do
            local status = self:getPromotion85BoxRewardStatus(v.idx)
            if status == 0 then
                is_box_reward = true
                break
            end
        end
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDLX_RWBX, is_box_reward)   
    end

    if is_mission_reward or is_box_reward then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_SDLX, true)
    else
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_SDLX, false)
    end
end

function PromotionData:getPromotion85MissionStatus(idx)
    local data = self.promotion85_mission[idx]
    if data then
        if data.had_reward then
            return -1
        end

        local config = cfg.promotion085mission.promotion085mission[idx]
        if config and data.process >= config.target.target then
            return 0
        end
    end
    return 1
end

function PromotionData:getPromotion85BoxRewardStatus(idx)
    local is_reward =
        TableEx.findValueFunction(
        self.promotion85_mission_box_reward_record,
        function(value)
            return value == idx
        end
    )
    if is_reward then
        return -1
    end

    local reward_num = self:getPromotion85MissionRewardNum()

    local config = cfg.promotion085missionboxreward.promotion085missionboxreward[idx]
    if config and config.count <= reward_num then
        return 0
    end

    return 1
end

function PromotionData:getPromotion85MissionRewardNum()
    local reward_num = 0
    for k, v in pairs(self.promotion85_mission) do
        if v.had_reward then
            reward_num = reward_num + 1
        end
    end
    return reward_num
end

function PromotionData:getPromotion85Data()
    return self:getPromotionDatas(promotionPros.gReqChristmasMissionGetDataInfo.id)
end

----------------- 约惠圣诞
function PromotionData:setPromotion86GetInfo(data)
    self.promotion86_buy_record = {}
    if data and #data then
        for k, v in ipairs(data) do
            self.promotion86_buy_record[v.key] = v.value
        end
    end

    self.promotion86_is_get_info = true
    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)

end

function PromotionData:updatePromotion86BuyRecord(data)
    for k, v in pairs(self.promotion86_buy_record) do
        if k == data.key then
            self.promotion86_buy_record[k] = data.value
            break
        end
    end
end

function PromotionData:getPromotion86Info()
    if not cfg.promotion086gift or not cfg.promotion086gift.promotion086gift or #cfg.promotion086gift.promotion086gift == 0 then
        return
    end

    local goods_list = {}
    for k, v in ipairs(cfg.promotion086gift.promotion086gift) do
        local goods = {
            idx = v.idx,
            reward = v.reward,
            product_id = v.product_id,
            buy_limit = v.buy_limit,
            name = ex.Tools:getLang(v.gift_name),
            buy_times = self.promotion86_buy_record[v.idx] or 0
        }

        table.insert(goods_list, goods)
    end
    
    local len = #goods_list
    local index = 1
    for i = 1, len do
        local goods = goods_list[index]
        if goods.buy_limit <= goods.buy_times then
            local temp_goods = table.remove(goods_list, index)
            table.insert(goods_list, temp_goods)
        else
            index = index + 1
        end
    end
    
    return goods_list
end

function PromotionData:getPromotion86Data()
    return self:getPromotionDatas(promotionPros.gReqChristmasGiftInfo.id)
end

function PromotionData:checkPromotionIsChristmas3Open()
    if not cfg.promotion086gift or not cfg.promotion086gift.promotion086gift then
        return false
    end

    if not self.promotion86_is_get_info then
        return false
    end
    
    local promotion_data = self:getPromotion86Data()
    if not promotion_data or 
    (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or
    (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or 
    (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time) then
        return false
    end

    return true
end

 -- 圣诞活动 五一抽奖 --------start------------
 function PromotionData:getPromotion97Data()
    return self:getPromotionDatas(promotionPros.gReqLaborDayLuckDrawGetDataInfo.id)
end

--五一抽奖是否开放
function PromotionData:getPromotion097IsOpen()
    if not cfg.promotion097labordayreward or not cfg.promotion097labordayreward.promotion097labordayreward then
        return false
    end
    local promotion_data = self:getPromotion97Data()
    if not promotion_data or 
    (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or
    (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or 
    (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time) then
        return false
    end
    return true
end

--下发的初始五一基本数据
function PromotionData:handleGetProm97Data(data)
    print("下发的初始五一基本数据")
    self.promotion097Info = data
    local is_open = self:getIsShowFiveOneRed()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_LDJZ, is_open)
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_LDJZ, is_open)
    --刷新界面道具显示数据  --刷新以领取的奖励数据显示  --刷新重置次数显示  --刷新抽奖消耗数据显示  --刷新点击自选礼包显示
    ex.EventManager:fire(EVENT.FIVE_ONE.EVENT_UPDATE_ALL_LAYER) --刷新所有数据
end

--下发的重置五一基本数据
function PromotionData:handleGetProm97ResetData(data)
    self.promotion097Info = data
    --刷新界面道具显示数据  --刷新以领取的奖励数据显示  --刷新重置次数显示  --刷新抽奖消耗数据显示  --刷新点击自选礼包显示
    ex.EventManager:fire(EVENT.FIVE_ONE.EVENT_UPDATE_ALL_LAYER) --刷新所有数据
end

--下发的抽奖到的道具
function PromotionData:handleGetProm97Record(data)
    self.promotion097Info.times = math.min(self.promotion097Info.times + 1, 16)
    self.promotion097Info.reward_record = data.reward_record
    ex.EventManager:fire(EVENT.FIVE_ONE.EVENT_REWARD_FINISH, data.reward) --刷新以领取的奖励数据显示
end

--下发的选择的自选礼包数据
function PromotionData:handleGetProm97Choice(data)
    self.promotion097Info.rewards = data.rewards
    ex.EventManager:fire(EVENT.FIVE_ONE.EVENT_GIFT_CHOOSE, data)--刷新点击自选礼包显示
end

function PromotionData:getSaveFiveOneData()
    return self.promotion097Info
end

--获取五一抽奖最大轮次
function PromotionData:getMaxRound()
    if not cfg.promotion097labordayreward or not cfg.promotion097labordayreward.promotion097labordayreward or not cfg.promotion097labordayreward.promotion097labordayreward[#cfg.promotion097labordayreward.promotion097labordayreward] then
        return 0
    end
    local info = cfg.promotion097labordayreward.promotion097labordayreward[#cfg.promotion097labordayreward.promotion097labordayreward]
    return info[1].round
end

function PromotionData:getConfigInfByRound(round)
    if not cfg.promotion097labordayreward or not cfg.promotion097labordayreward.promotion097labordayreward or not cfg.promotion097labordayreward.promotion097labordayreward[round] then
        return nil
    end
    return cfg.promotion097labordayreward.promotion097labordayreward[round]
end

--自选奖励（通过位置获取协议下发数据自选奖励）
function PromotionData:getChoiceReward(position)
    local rewardData = nil
    if self.promotion097Info and self.promotion097Info.rewards then
        for i,v in ipairs(self.promotion097Info.rewards) do
            if v.position == position then
                rewardData = v
                break
            end
        end
    end
    return rewardData
end

--获取当前位置奖励是否以领取
function PromotionData:isFinishByPosIndex(posIndex)
    local isFinish = false
    if self.promotion097Info and self.promotion097Info.reward_record then
        for i,v in ipairs(self.promotion097Info.reward_record) do
            if v == posIndex then
                isFinish = true
                break
            end
        end
    end
    return isFinish
end

--判断是否显示五一抽奖红点q
function PromotionData:getIsShowFiveOneRed() 
    local isShowRed = false
    if self:getPromotion097IsOpen() then
        if self.promotion097Info then
            local resumeInfo = self:getResumeByRoundsAndCounts(self.promotion097Info.cur_round, self.promotion097Info.times)
            if resumeInfo and resumeInfo[1] then
                local nowHaveNum = ex.Player:getItemNum(resumeInfo[1].item_type)
                isShowRed = nowHaveNum >= resumeInfo[1].item_num
                if (self.promotion097Info.cur_round == #cfg.promotion097labordayreward.promotion097labordayreward and #self.promotion097Info.reward_record >= 16) or
                    (self.promotion097Info.cur_round > #cfg.promotion097labordayreward.promotion097labordayreward) then
                        isShowRed = false
                end
            end
        end
    end
    return isShowRed
end

--五一通过传入参数（第几轮，第几次）获取消耗，默认返回nil
function PromotionData:getResumeByRoundsAndCounts(round, count)
    if not cfg.promotion097cost or not cfg.promotion097cost.promotion097cost then
        return nil
    end
    local resumeData = nil;
    for i, v in ipairs(cfg.promotion097cost.promotion097cost) do
        if v.turns == round and v.times == count then
            resumeData = v.cost
            break
        end
    end
    return resumeData
end

--五一抽奖初始化协议请求
function PromotionData:GReqLaborDayLuckDrawGetDataInfo()
    print("五一抽奖初始化协议请求")
    NetManager:sendMessage(ProtocolID.GReqLaborDayLuckDrawGetDataInfo) 
end

 --五一抽奖初始化，重置协议请求
 function PromotionData:GReqLaborDayLuckDrawReset()
    print("五一抽奖重置协议请求")
    NetManager:sendMessage(ProtocolID.GReqLaborDayLuckDrawReset) 
end
------------------------end----------------------

------------------- 嗨翻圣诞
function PromotionData:checkPromotionIsChristmas4Open()
    local promotion_data = self:getPromotion87Data()
    if
        not promotion_data or (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or
            (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time)
     then
        return false
    end

    return true
end

function PromotionData:getPromotion87Data()
    return self:getPromotionDatas(promotionPros.gReqChristmasLotteryGetDataInfo.id)
end

function PromotionData:handleGetProm87Data(data)
    self.promotion87_data = data
    self:checkPromotion87RedDot()
end

function PromotionData:handlePromotion87Draw(data)
   -- self.promotion87_lottery_record = data.lottery_record

    -- 更新数据
    local isbool = false
    for k,n in ipairs(self.promotion87_data.lottery_record) do
        if n == data.lottery_record then
            isbool = true
            break
        end
    end
    if not isbool then
        table.insert(self.promotion87_data.lottery_record,data.lottery_record)
    end
     
    if #self.promotion87_data.lottery_record % 6 == 0 then
        if self.promotion87_data.bookmark < 5 then
            self.promotion87_data.bookmark = self.promotion87_data.bookmark + 1
        end
    end

    local vec_reward = {}
    if data.lottery_record  then
        for i,v in ipairs(cfg.promotion087lotteryreward.promotion087lotteryreward) do
            if v.idx == data.lottery_record then
                local item = {}
                item.item_type = v.reward[1].item_type 
                item.item_num = v.reward[1].item_num
                table.insert(vec_reward,item)
            end
        end
    end
    if ex.MainSceneCtr.cur_layer_type ~= MainSceneType.MAIN_CHRISTMAS then
        require("src.layer.ItemRewardCtr"):instance():openWindow(vec_reward)
    else
        ex.EventManager:fire(EVENT.CHRISTMAS.EVENT_GACHA_DRAW, data)
    end
    self:checkPromotion87RedDot()
end

function PromotionData:checkPromotion87RedDot()
    local cost_cfg = {}
    for k,v in pairs(cfg.promotion087lotterytype.promotion087lotterytype) do
        if v.idx == self.promotion87_data.bookmark then
            cost_cfg = v.cost[1]
            break
        end
    end
    local item_type = cost_cfg.item_type
    local need_num = cost_cfg.item_num 
    local has_num = ex.Player:getItemNum(item_type)
    if has_num >= need_num then 
        local isVisible_red = true
        if self.promotion87_data.bookmark == #cfg.promotion087lotterytype.promotion087lotterytype then
            local index = 0
            for i,v in ipairs(self.promotion87_data.lottery_record) do
                if cfg.promotion087lotteryreward.promotion087lotteryreward[v].lottery_type == self.promotion87_data.bookmark then
                    index = index + 1
                end
            end
            if index == 6 then
                isVisible_red = false
            end
        end
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_HFSD_DB, isVisible_red) 
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_HFSD, isVisible_red)
    else    
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_HFSD_DB, false) 
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_HFSD, false)
    end
end
----------------- 圣诞礼盒
function PromotionData:checkPromotionIsChristmas5Open()
    local promotion_data = self:getPromotion88Data()
    if
        not promotion_data or (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or
            (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time)
     then
        return false
    end

    return true
end

function PromotionData:getPromotion88Data()
    return self:getPromotionDatas(promotionPros.gReqChristmasScoreInfo.id)
end

function PromotionData:handleGetProm88Data(data)
    self.promotion88_score = data.score
    self:checkPromotion88RedDot()
end

function PromotionData:handleGetProm88ExchangeScore(data)
    self.promotion88_score = data.score
    ex.EventManager:fire(EVENT.CHRISTMAS.GIFTBOX_UPDATA)
end

function PromotionData:handleGetProm88Box(data)
    self.promotion88_score = data.score
    ex.EventManager:fire(EVENT.CHRISTMAS.GIFTBOX_UPDATA)
end

function PromotionData:checkPromotion88RedDot()
    local num = 0
    for i,v in ipairs(cfg.promotion088score.promotion088score[1].cost_item) do
        local has_num = ex.Player:getItemNum(v.item_type)
        local max_num = v.item_num
        if has_num >= max_num then
            num = num + 1
        end
    end
    --道具是否足够
    local is_props_reward = false
    if num == #cfg.promotion088score.promotion088score[1].cost_item then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDLH_BZ, true) 
        is_props_reward = true
    else
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDLH_BZ, false) 
    end
    --大奖是否可以领取
    local is_grand_prix = false
    if self.promotion88_score >= cfg.promotion088score.promotion088score[1].cost_score then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDLH_DJ, true) 
        is_grand_prix = true
    else
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDLH_DJ, false) 
    end

    --圣诞奇幻夜红点
    if is_grand_prix or is_props_reward then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_SDLH, true) 
    else
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_SDLH, false) 
    end

end

----------------- 圣诞感谢信
function PromotionData:handleGetProm89Data(data)
    self.receive_time = data.reward_time 
end

function PromotionData:thankLetterisOpen()
    local isopen = false
    local year = os.date("%Y", self.receive_time)
    local moon = os.date("%m", self.receive_time)
    local day = os.date("%d", self.receive_time)

    local now_time = ex.Game:getServerTime()
    local now_year = os.date("%Y", now_time)
    local now_moon = os.date("%m", now_time)
    local now_day = os.date("%d", now_time)
    if now_year > year or now_moon > moon or now_day > day then
        isopen = true
    end
    return isopen
end

------------------------春节活动-惊喜盲盒--------------------------------
function PromotionData:checkPromotionIsChristmas6Open()
    local promotion_data = self:getPromotion91Data()
    if
        not promotion_data or (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or 
        (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or
            (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time)
     then
        return false
    end
    return true
end

--砸蛋奖励数据
function PromotionData:getPromotion91BreakEggRewardData()
    local reward_data = cfg.promotion091Gashaponlotteryreward.promotion091Gashaponlotteryreward
    for i,v in ipairs(reward_data) do
        if v ~= nil and v.idx == self.promotion91_break_egg_data.idx and v.reward ~= nil then
            return v.reward
        end 
    end 
end

function PromotionData:getPromotion91Data()
    return self:getPromotionDatas(promotionPros.gReqSpringFestivalGetDataInfo.id)
end

--进入游戏前获得的轮数数据
function PromotionData:handleGetPromotion91BreakEggTurnsData(data)
    self.promotion91_break_egg_turns_data = data
    ex.EventManager:fire(EVENT.CHRISTMAS.EVEN_GET_REWARD)
    self:checkPromotion91RedDot()
end
--砸蛋后获得的数据
function PromotionData:handleGetPromotion91EggReward(data)
    self.promotion91_break_egg_data = data
    self:checkPromotion91RedDot()
    ex.EventManager:fire(EVENT.CHRISTMAS.EVEN_GET_BREAK_EGG_REWARD)
end
--盲盒抽奖后的奖励数据
function PromotionData:handleGetPromotion91BlindBoxReward(data)
    self.promotion91_blind_box_reward = nil
    local reward_data = cfg.promotion091boxlotteryreward.promotion091boxlotteryreward
    for i,v in ipairs(reward_data) do
        if v.idx == data.idx then
            self.promotion91_blind_box_reward = v.reward    
        end
    end
    ex.EventManager:fire(EVENT.CHRISTMAS.EVEN_GET_REWARD)
    ex.EventManager:fire(EVENT.CHRISTMAS.EVEN_GET_BLIND_BOX_REWARD)
    self:checkPromotion91RedDot()
end

--惊喜盲盒的红点
function PromotionData:checkPromotion91RedDot()
    local bool_1 = ex.Player:getItemNum(901820) > 0
    local bool_2 = ex.Player:getItemNum(901819) > 0

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_JXMH, bool_1)
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_JXMH_DB, bool_1)
    if not bool_1 then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_SDQHY_JXMH, bool_2 and not self:getBreakEggIsOver())
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_SDJHD_JXMH, bool_2 and not self:getBreakEggIsOver())
    end
end

--获取砸蛋活动轮数是否抽完  true：抽完   false：没有抽完
function PromotionData:getBreakEggIsOver()
    local item_data = cfg.promotion091Gashaponlotteryreward.promotion091Gashaponlotteryreward
    local max_turns = 0
    for i,v in ipairs(item_data) do 
        if v.turns > max_turns  then
            max_turns = v.turns
        end
    end
    local data = self.promotion91_break_egg_turns_data
        for i,v in ipairs(data.lottery_record) do
            if data.curr_lottery_turns == v.turns then
                if data.curr_lottery_turns == max_turns and i == max_turns and #v.place_record == 3 then
                   return true
                end
            end
        end   
    return false 
end

--提示窗口的控制
function PromotionData:surpriseBlindBoxTipsisOpen(time)
    local isopen = false
    if time <= 0 then
        return isopen
    end
    local year = os.date("%Y", time)
    local moon = os.date("%m", time)
    local day = os.date("%d", time)

    local now_time = ex.Game:getServerTime()
    local now_year = os.date("%Y", now_time)
    local now_moon = os.date("%m", now_time)
    local now_day = os.date("%d", now_time)
    if now_year > year or now_moon > moon or now_day > day then
        isopen = true
    end
    return isopen
end

-------------------------------春日踏青---------------------------------------
----- 活动一：春日踏青
function PromotionData:handleGetProm93Data(data)
    self.promotion93data = data
    self:checkPromotion93RedDot()
end

function PromotionData:getProm93GridDiceData(data)
    self.grid_dice_data = data
    self.promotion93data.curr_idx = data.curr_idx
    ex.EventManager:fire(EVENT.SPRING.EVENT_UPDAT_LAYER)
    ex.EventManager:fire(EVENT.SPRING.EVENT_DICE_POINT)
end

function PromotionData:getProm93GridScenicRewardData(data)
    self.promotion93data.scenic_record = data.scenic_record
    ex.EventManager:fire(EVENT.SPRING.EVENT_UPDAT_LAYER)

end

function PromotionData:checkPromotion93IsOpen()
    local promotion_data = self:getPromotion93Data()
    if
        not promotion_data or (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or
            (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time)
     then
        return false
    end
    return true
end

function PromotionData:checkPromotion93RedDot()

    local is_red_dot = false
    local cost_cfg = cfg.system.promotion093_dice_cost[1]
    --判断道具是否足够
    local item_num = ex.Player:getItemNum(cost_cfg.item_type)
    if item_num >= cost_cfg.item_num then
        is_red_dot = true 
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CRHD_CRTQ_TZ, is_red_dot)    

   -- 判断是否有可以领取的宝箱
   local is_box_reward = false
   if cfg.promotion093scenic ~= nil then
       for i, v in ipairs(cfg.promotion093scenic.promotion093scenic) do
           local status = self:getPromotion93BoxRewardStatus(v.idx)
           if status == 0 then
               is_box_reward = true
               break
           end
       end
       ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CRHD_CRTQ, is_box_reward)   
   end
   if is_red_dot or is_box_reward then
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CRHD_CRTQ, true)
   end
    
end

function PromotionData:getPromotion93BoxRewardStatus(idx)
    local is_reward = false
    for i,v in pairs(self.promotion93data.scenic_record) do
        if idx == v then
            is_reward = true
            break
        end
    end

    if is_reward then
        return -1
    end

    local reward_num = self:getPromotion93MissionRewardNum()

    local config = cfg.promotion093scenic.promotion093scenic[idx]
    if config and config.count <= reward_num then
        return 0
    end

    return 1
end

function PromotionData:getPromotion93MissionRewardNum()
    local num = 0
    if self.grid_dice_data then
        num = self.grid_dice_data.scenic_count[1] and self.grid_dice_data.scenic_count[1].value or 0
    else
        num = self.promotion93data.scenic_count[1] and self.promotion93data.scenic_count[1].value or 0
    end
    return num
end

function PromotionData:getPromotion93Data()
    return self:getPromotionDatas(promotionPros.gReqSpringOutingGrid.id)
end
----- 活动二：制作彩蛋
function PromotionData:checkPromotion94IsOpen()
    local promotion_data = self:getPromotion94Data()
    if
        not promotion_data or (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or
            (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time)
     then
        return false
    end

    return true
end

function PromotionData:getPromotion94Data()
    return self:getPromotionDatas(promotionPros.gReqMakeEggScoreInfo.id)
end

function PromotionData:handleGetProm94Data(data)
    self.promotion94_score = data.score
    self:checkPromotion94RedDot()
end

function PromotionData:handleGetProm94ExchangeScore(data)
    self.promotion94_score = data.score
    ex.EventManager:fire(EVENT.SPRING.GIFTBOX_UPDATA)
end

function PromotionData:handleGetProm94Box(data)
    self.promotion94_score = data.score
    ex.EventManager:fire(EVENT.SPRING.GIFTBOX_UPDATA)
end

function PromotionData:checkPromotion94RedDot()
    local num = 0
    for i,v in ipairs(cfg.promotion094score.promotion094score[1].cost_item) do
        local has_num = ex.Player:getItemNum(v.item_type)
        local max_num = v.item_num
        if has_num >= max_num then
            num = num + 1
        end
    end
    --道具是否足够
    local is_props_reward = false
    if num == #cfg.promotion094score.promotion094score[1].cost_item then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CRHD_ZZCD_BZ, true) 
        is_props_reward = true
    else
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CRHD_ZZCD_BZ, false) 
    end
    --大奖是否可以领取
    if self.promotion94_score >= cfg.promotion094score.promotion094score[1].cost_score then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CRHD_ZZCD_DJ, true) 
    else
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CRHD_ZZCD_DJ, false) 
    end
end
----- 活动三：春游记
function PromotionData:setPromotion95GetInfo(data)
    self.promotion95_buy_record = {}
    if data and #data then
        for k, v in ipairs(data) do
            self.promotion95_buy_record[v.key] = v.value
        end
    end

    self.promotion95_is_get_info = true
    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)

end

function PromotionData:updatePromotion95BuyRecord(data)
    for k, v in pairs(self.promotion95_buy_record) do
        if k == data.key then
            self.promotion95_buy_record[k] = data.value
            break
        end
    end
end

function PromotionData:getPromotion95Info()
    if not cfg.promotion095gift or not cfg.promotion095gift.promotion095gift or #cfg.promotion095gift.promotion095gift == 0 then
        return
    end

    local goods_list = {}
    for k, v in ipairs(cfg.promotion095gift.promotion095gift) do
        local goods = {
            idx = v.idx,
            reward = v.reward,
            product_id = v.product_id,
            buy_limit = v.buy_limit,
            name = ex.Tools:getLang(v.gift_name),
            buy_times = self.promotion95_buy_record[v.idx] or 0
        }

        table.insert(goods_list, goods)
    end
    
    local len = #goods_list
    local index = 1
    for i = 1, len do
        local goods = goods_list[index]
        if goods.buy_limit <= goods.buy_times then
            local temp_goods = table.remove(goods_list, index)
            table.insert(goods_list, temp_goods)
        else
            index = index + 1
        end
    end
    
    return goods_list
end

function PromotionData:getPromotion95Data()
    return self:getPromotionDatas(promotionPros.gReqSpringOutingGiftInfo.id)
end

function PromotionData:checkPromotion95IsOpen()
    if not cfg.promotion095gift or not cfg.promotion095gift.promotion095gift then
        return false
    end

    if not self.promotion95_is_get_info then
        return false
    end
    
    local promotion_data = self:getPromotion95Data()
    if not promotion_data or 
    (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or
    (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or 
    (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time) then
        return false
    end

    return true
end
----- 活动四：出游寻春
function PromotionData:checkPromotion96IsOpen()
    if self.promotion96_open_day == 0 then
        return false
    end

    local promotion_data = self:getPromotion96Data()
    if
        not promotion_data or (promotion_data.start_time and promotion_data.start_time > ex.Game:getServerTime()) or (promotion_data.end_time and ex.Game:getServerTime() > promotion_data.end_time) or
            (promotion_data.clear_time and ex.Game:getServerTime() > promotion_data.clear_time)
     then
        return false
    end

    return true
end

function PromotionData:handleGetProm96Data(data)
    self.promotion96_open_day = data.open_day

    if data.mission and #data.mission > 0 then
        for k, v in ipairs(data.mission) do
            if v then
                self.promotion96_mission[v.idx] = clone(v)
            end
        end
    end

    self.promotion96_mission_box_reward_record = data.mission_box_reward_record
    self:checkPromotion96RedDot()
end

function PromotionData:handleGetProm96MissionDone(data)
    if data.mission_info and data.mission_info.idx and self.promotion96_mission[data.mission_info.idx] then
        self.promotion96_mission[data.mission_info.idx] = clone(data.mission_info)
    end
    ex.EventManager:fire(EVENT.SPRING.EVENT_GET_MISSION)
    self:checkPromotion96RedDot()
end

function PromotionData:handleUpdateProm96Mission(data)
    if data.mission and #data.mission > 0 then
        for k, v in ipairs(data.mission) do
            if v then
                self.promotion96_mission[v.idx] = clone(v)
            end
        end
    end
    ex.EventManager:fire(EVENT.SPRING.EVENT_UPDATA_MISSION)
    self:checkPromotion96RedDot()
end

function PromotionData:handlegetProm96BoxAward(data)
    if self.promotion96_mission_box_reward_record == nil then
        return
    end

    table.insert(self.promotion96_mission_box_reward_record, data.idx)
    ex.EventManager:fire(EVENT.SPRING.EVENT_GET_BOX)
    self:checkPromotion96RedDot()
end

function PromotionData:checkPromotion96RedDot()
    -- 判断是否有可以领取的任务
    local is_mission_reward = false
    for k, v in pairs(self.promotion96_mission) do
        local config = cfg.promotion096mission.promotion096mission[v.idx]
        if config and config.day == self.promotion96_open_day then
            local status = self:getPromotion96MissionStatus(v.idx)
            if status == 0 then
                is_mission_reward = true
                break
            end
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CRHD_CYXC_RWJL, is_mission_reward)
    
   
    -- 判断是否有可以领取的宝箱
    local is_box_reward = false
    if cfg.promotion096missionboxreward ~= nil then
        for i, v in ipairs(cfg.promotion096missionboxreward.promotion096missionboxreward) do
            local status = self:getPromotion96BoxRewardStatus(v.idx)
            if status == 0 then
                is_box_reward = true
                break
            end
        end
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CRHD_CYXC_RWBX, is_box_reward)   
    end

    if is_mission_reward or is_box_reward then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CRHD_CYXC_SDLX, true)  
    else
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_CRHD_CYXC_SDLX, false)
    end
end

function PromotionData:getPromotion96MissionStatus(idx)
    local data = self.promotion96_mission[idx]
    if data then
        if data.had_reward then
            return -1
        end

        local config = cfg.promotion096mission.promotion096mission[idx]
        if config and data.process >= config.target.target then
            return 0
        end
    end
    return 1
end

function PromotionData:getPromotion96BoxRewardStatus(idx)
    local is_reward =
        TableEx.findValueFunction(
        self.promotion96_mission_box_reward_record,
        function(value)
            return value == idx
        end
    )
    if is_reward then
        return -1
    end

    local reward_num = self:getPromotion96MissionRewardNum()

    local config = cfg.promotion096missionboxreward.promotion096missionboxreward[idx]
    if config and config.count <= reward_num then
        return 0
    end

    return 1
end

function PromotionData:getPromotion96MissionRewardNum()
    local reward_num = 0
    for k, v in pairs(self.promotion96_mission) do
        if v.had_reward then
            reward_num = reward_num + 1
        end
    end
    return reward_num
end

function PromotionData:getPromotion96Data()
    return self:getPromotionDatas(promotionPros.gReqSpringOutingMissionGetDataInfo.id)
end

return PromotionData
