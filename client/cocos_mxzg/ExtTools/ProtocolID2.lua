-- 文件由脚本生成，禁止修改!!!

ProtocolID = {}

----------------模块: 错误模块----------------
ProtocolID.GResError = 1200000

----------------模块: 系统、登录模块----------------
ProtocolID.GReqLogin = 1101001
ProtocolID.GReqInit = 1101002
ProtocolID.GReqOffline = 1101003
ProtocolID.GReqError = 1101010
ProtocolID.GResLogin = 1201001
ProtocolID.GResInit = 1201002
ProtocolID.GReqHeartbeat = 2101001
ProtocolID.GReqNotice = 2101002
ProtocolID.GResHeartbeat = 2201001
ProtocolID.GResNoticeList = 2201002

----------------模块: 角色模块----------------
ProtocolID.GReqRoleInfo = 1102001
ProtocolID.GReqRoleEditNick = 1102003
ProtocolID.GReqPlayerDetaile = 1102004
ProtocolID.GReqGuideSerial = 1102005
ProtocolID.GReqGuideFirstPveReward = 1102007
ProtocolID.GReqGMCommand = 1102008
ProtocolID.GReqGMRemovebackpack = 1102009
ProtocolID.GReqRoleChangeHead = 1102011
ProtocolID.GReqRoleRandNick = 1102013
ProtocolID.GResRoleInfo = 1202001
ProtocolID.GResRoleEditNick = 1202003
ProtocolID.GResPlayerDetaile = 1202004
ProtocolID.GResRoleUpgradeReward = 1202012
ProtocolID.GResRoleRandNick = 1202013

----------------模块: 战斗模块----------------
ProtocolID.GReqBattleMatch = 1103001
ProtocolID.GReqChapterEnd = 1103002
ProtocolID.GReqChapterChangeMission = 1103003
ProtocolID.GReqChapterItemList = 1103004
ProtocolID.GReqChapterItemReward = 1103005
ProtocolID.GReqChapterData = 1103007
ProtocolID.GReqChapterIdleLineup = 1103008
ProtocolID.GReqChapterBattleLineup = 1103009
ProtocolID.GReqChapterRewardList = 1103010
ProtocolID.GReqChapterFirstReward = 1103011
ProtocolID.GReqLineUpSave = 1103100
ProtocolID.GReqLineUp = 1103101
ProtocolID.GReqTowerData = 1103200
ProtocolID.GReqTowerBattleEnd = 1103201
ProtocolID.GReqTowerEnergyBuy = 1103202
ProtocolID.GReqTowerRewardList = 1103203
ProtocolID.GReqTowerFirstReward = 1103204
ProtocolID.GReqTowerBattleEndNew = 1103205
ProtocolID.GReqTowerSweep = 1103206
ProtocolID.GReqQuickBattleReward = 1103208
ProtocolID.GResBattleMatch = 1203001
ProtocolID.GResChapterEnd = 1203002
ProtocolID.GResChapterItemList = 1203004
ProtocolID.GResChapterItemReward = 1203005
ProtocolID.GResChapterData = 1203007
ProtocolID.GResChapterRewardList = 1203010
ProtocolID.GResBattleReward = 1203020
ProtocolID.GResLineUpData = 1203101
ProtocolID.GResTowerData = 1203200
ProtocolID.GResTowerBattleEnd = 1203201
ProtocolID.GResTowerEnergyBuy = 1203202
ProtocolID.GResTowerRewardList = 1203203
ProtocolID.GResTowerSweep = 1203206
ProtocolID.GResQuickBattleInitData = 1203207
ProtocolID.GResQuickBattleReward = 1203208

----------------模块: 英雄模块----------------
ProtocolID.GReqHeroList = 1104001
ProtocolID.GReqHeroSummon = 1104002
ProtocolID.GReqHeroSummonCount = 1104004
ProtocolID.GReqHeroSummonAward = 1104005
ProtocolID.GReqHeroUnlock = 1104006
ProtocolID.GReqHeroSkillUnlock = 1104009
ProtocolID.GReqIllustratReward = 1104013
ProtocolID.GReqHeroLock = 1104015
ProtocolID.GReqHeroUpLevel = 1104018
ProtocolID.GReqHeroUpgrade = 1104019
ProtocolID.GReqHeroUpStar = 1104020
ProtocolID.GReqHeroCompose = 1104021
ProtocolID.GReqHeroEquip = 1104022
ProtocolID.GReqHeroEquipChange = 1104023
ProtocolID.GReqHeroEquipDisboard = 1104024
ProtocolID.GReqHeroEquipOneKeyWear = 1104025
ProtocolID.GReqHeroEquipOneKeyDisboard = 1104026
ProtocolID.GResHeroList = 1204001
ProtocolID.GResHeroSummonList = 1204002
ProtocolID.GResHeroFreeSummonTime = 1204003
ProtocolID.GResHeroSummonCount = 1204004
ProtocolID.GResHeroSummonAward = 1204005
ProtocolID.GResHeroUnlock = 1204006
ProtocolID.GResIllustratReward = 1204013
ProtocolID.GResIllustratActive = 1204014
ProtocolID.GResHeroUpgradeLevel = 1204018
ProtocolID.GResHeroUpgrade = 1204019
ProtocolID.GResHeroUpStar = 1204020
ProtocolID.GResHeroCompose = 1204021
ProtocolID.GResHeroEquip = 1204022
ProtocolID.GResHeroEquipChange = 1204023
ProtocolID.GResHeroEquipDisboard = 1204024
ProtocolID.GResHeroEquipOneKeyWear = 1204025
ProtocolID.GResHeroEquipOneKeyDisboard = 1204026

----------------模块: 背包模块----------------
ProtocolID.GReqBackPackList = 1105001
ProtocolID.GReqMakeEquip = 1105004
ProtocolID.GReqOneKeyMakeEquip = 1105005
ProtocolID.GReqOpenBoxReward = 1105006
ProtocolID.GReqPieceReward = 1105007
ProtocolID.GReqMarketList = 1105101
ProtocolID.GReqMarketBuy = 1105102
ProtocolID.GReqBlackMarketList = 1105103
ProtocolID.GReqBlackMarketBuy = 1105104
ProtocolID.GResBackPackList = 1205001
ProtocolID.GResBackpackGainNoPrompt = 1205002
ProtocolID.GResBackpackGain = 1205003
ProtocolID.GResMakeEquip = 1205004
ProtocolID.GResOneKeyMakeEquip = 1205005
ProtocolID.GResOpenBoxReward = 1205006
ProtocolID.GResPieceReward = 1205007
ProtocolID.GResMarketList = 1205101
ProtocolID.GResBlackMarketList = 1205103

----------------模块: 聊天模块----------------
ProtocolID.GReqChat = 1106001
ProtocolID.GResChat = 1206001

----------------模块: 军团模块----------------
ProtocolID.GReqClanInfo = 1107001
ProtocolID.GReqClanCreate = 1107002
ProtocolID.GReqClanSearch = 1107003
ProtocolID.GReqClanJoin = 1107004
ProtocolID.GReqClanQuit = 1107005
ProtocolID.GReqClanMsgInfo = 1107006
ProtocolID.GReqClanReqMsgInfo = 1107007
ProtocolID.GReqClanReqAgree = 1107008
ProtocolID.GReqClanChangInfo = 1107010
ProtocolID.GReqClanChangePos = 1107011
ProtocolID.GReqClanRank = 1107021
ProtocolID.GReqClanRankDamage = 1107022
ProtocolID.GReqClanSkillList = 1107031
ProtocolID.GReqClanSkillLight = 1107032
ProtocolID.GReqClanDonateList = 1107041
ProtocolID.GReqClanDonate = 1107042
ProtocolID.GReqClanTotalDonateReward = 1107043
ProtocolID.GReqClanMissionInfo = 1107051
ProtocolID.GReqClanMissionEnd = 1107052
ProtocolID.GReqClanMissionBuy = 1107053
ProtocolID.GReqClanShopList = 1107061
ProtocolID.GReqClanShopBuy = 1107062
ProtocolID.GResClanInfo = 1207001
ProtocolID.GResClanCreate = 1207002
ProtocolID.GResClanSearch = 1207003
ProtocolID.GResClanJoin = 1207004
ProtocolID.GResClanQuit = 1207005
ProtocolID.GResClanMsgInfo = 1207006
ProtocolID.GResClanReqMsgInfo = 1207007
ProtocolID.GResClanReqAgree = 1207008
ProtocolID.GResUpdateAllClanInfo = 1207009
ProtocolID.GResClanChangPos = 1207011
ProtocolID.GResClanChatList = 1207020
ProtocolID.GResClanRank = 1207021
ProtocolID.GResClanRankDamage = 1207022
ProtocolID.GResClanRankDonate = 1207023
ProtocolID.GResClanSkillList = 1207031
ProtocolID.GResClanDonateList = 1207041
ProtocolID.GResClanMissionInfo = 1207051
ProtocolID.GResClanMissionEnd = 1207052
ProtocolID.GResClanShopList = 1207061

----------------模块: 副本模块----------------
ProtocolID.GResAdventureList = 1208001
ProtocolID.GResRoomBekickedRoom = 1208107

----------------模块: 好友模块----------------
ProtocolID.GReqFriendsList = 1109001
ProtocolID.GReqFriendsRequestList = 1109002
ProtocolID.GReqFriendsSearch = 1109003
ProtocolID.GReqFriendsAdd = 1109004
ProtocolID.GReqFriendsAgree = 1109005
ProtocolID.GReqFriendsDelete = 1109006
ProtocolID.GReqFriendChatList = 1109007
ProtocolID.GReqFriendsGive = 1109008
ProtocolID.GReqFriendsGiveAll = 1109010
ProtocolID.GReqFriendsReward = 1109011
ProtocolID.GReqFriendsRewardAll = 1109012
ProtocolID.GResFriendsList = 1209001
ProtocolID.GResFriendsRequestList = 1209002
ProtocolID.GResFriendsSearch = 1209003
ProtocolID.GResFriendsAdd = 1209004
ProtocolID.GResFriendAgree = 1209005
ProtocolID.GResFriendsDelete = 1209006
ProtocolID.GResFriendChatList = 1209007
ProtocolID.GResFriendsGive = 1209008
ProtocolID.GResFriendsGift = 1209013

----------------模块: 排行榜模块----------------
ProtocolID.GReqTowerRank = 1111003
ProtocolID.GReqPvpRankList = 1111004
ProtocolID.GReqFightingRankList = 1111006
ProtocolID.GReqDungeonRankList = 1111011
ProtocolID.GReqRankWorshipList = 1111100
ProtocolID.GReqRankWorship = 1111101
ProtocolID.GResRankTowerList = 1211003
ProtocolID.GResRankPvpList = 1211004
ProtocolID.GResFightinRankList = 1211006
ProtocolID.GResRankDungeonList = 1211011
ProtocolID.GResRankWorshipList = 1211100
ProtocolID.GResRankWorshipOffline = 1211102

----------------模块: 成就模块----------------
ProtocolID.GReqAchievementLevel = 1112000
ProtocolID.GReqAchievementReward = 1112002
ProtocolID.GReqDailyData = 1112003
ProtocolID.GReqDailyReward = 1112004
ProtocolID.GReqDailyBoxReward = 1112005
ProtocolID.GResAchievementLevel = 1212000
ProtocolID.GResUpdateAchievementData = 1212001
ProtocolID.GResAchievementReward = 1212002
ProtocolID.GResDailyData = 1212003
ProtocolID.GResDailyReward = 1212004
ProtocolID.GResDailyBoxReward = 1212005
ProtocolID.GResUpdateDailyData = 1212006

----------------模块: 每日任务模块----------------
ProtocolID.GReqEveryDayTaskList = 1113001
ProtocolID.GReqEveryDayTaskGetReward = 1113002
ProtocolID.GReqTaskProgress = 1113003
ProtocolID.GReqSignInList = 1113010
ProtocolID.GReqSignInAward = 1113011
ProtocolID.GReqWeekGiftList = 1113012
ProtocolID.GReqRechargeDaysList = 1113013
ProtocolID.GReqRechargeWeekList = 1113015
ProtocolID.GReqMonthCradList = 1113017
ProtocolID.GReqMonthVipReward = 1113018
ProtocolID.GReqLevelUpGift = 1113020
ProtocolID.GReqPubTaskList = 1113021
ProtocolID.GReqPubTaskRefresh = 1113022
ProtocolID.GReqPubTaskStart = 1113023
ProtocolID.GReqPubTaskAward = 1113024
ProtocolID.GReqBlessingPoolList = 1113031
ProtocolID.GReqBlessingPoolRefresh = 1113032
ProtocolID.GReqBlessingPoolDone = 1113033
ProtocolID.GReqBlessingPoolShopList = 1113034
ProtocolID.GReqBlessingPoolShopBuy = 1113035
ProtocolID.GReqProphetSummon = 1113041
ProtocolID.GReqProphetChange = 1113042
ProtocolID.GReqProphetConfirmChange = 1113043
ProtocolID.GReqProphetShopList = 1113045
ProtocolID.GReqProphetShopBuy = 1113046
ProtocolID.GReqAltarHero = 1113051
ProtocolID.GReqAltarShopList = 1113054
ProtocolID.GReqAltarShopBuy = 1113055
ProtocolID.GReqLimitGiftList = 1113060
ProtocolID.GReqInvestList = 1113062
ProtocolID.GReqInvestGain = 1113063
ProtocolID.GReqPropomtionLimitedtimeReward = 1113070
ProtocolID.GReqExchangeList = 1113071
ProtocolID.GReqExchangeBuy = 1113072
ProtocolID.GReqBuyGoldList = 1113073
ProtocolID.GReqBuyGoldRankList = 1113074
ProtocolID.GReqBuyGoldGift = 1113075
ProtocolID.GReqProphecyList = 1113076
ProtocolID.GReqProphecyTimesGift = 1113077
ProtocolID.GReqPvpwinList = 1113078
ProtocolID.GReqPvpwinTimesGift = 1113079
ProtocolID.GReqSummonList = 1113080
ProtocolID.GReqSummonTimesGift = 1113081
ProtocolID.GReqInvitationList = 1113082
ProtocolID.GReqInviteReward = 1113083
ProtocolID.GReqInviteUseCode = 1113084
ProtocolID.GReqMidAutumnInfo = 1113086
ProtocolID.GReqSummonCrystalInfo = 1113087
ProtocolID.GReqSummonCrystalGet = 1113088
ProtocolID.GReqBlessingPoolLists = 1113090
ProtocolID.GReqBuyServerLimitInfo = 1113091
ProtocolID.GReqBlessingPoolGift = 1113092
ProtocolID.GReqMarkHeroList = 1113093
ProtocolID.GReqMarkHeroGift = 1113094
ProtocolID.GReqPromotionSacrificeShop = 1113095
ProtocolID.GReqAstrologyTaskInfo = 1113100
ProtocolID.GReqAstrologyTaskSubmit = 1113101
ProtocolID.GReqPubArriveInfo = 1113106
ProtocolID.GReqPubArriveGot = 1113107
ProtocolID.GReqLimitShopList = 1113110
ProtocolID.GReqLimitShopGift = 1113111
ProtocolID.GReqAdventureList = 1113112
ProtocolID.GReqAdventureRankList = 1113113
ProtocolID.GReqAdventureGift = 1113114
ProtocolID.GReqSpeedFightList = 1113115
ProtocolID.GReqSpeedFightRankList = 1113116
ProtocolID.GReqSpeedfightGift = 1113117
ProtocolID.GReqTavernWeeklyList = 1113118
ProtocolID.GReqTavernWeeklyRankList = 1113119
ProtocolID.GReqTavernWeeklyGift = 1113120
ProtocolID.GResEveryDayTaskList = 1213001
ProtocolID.GResSignInList = 1213010
ProtocolID.GResSignInAward = 1213011
ProtocolID.GResWeekGiftList = 1213012
ProtocolID.GResRechargeDaysList = 1213013
ProtocolID.GResRechargeDaysGain = 1213014
ProtocolID.GResRechargeWeekList = 1213015
ProtocolID.GResRechargeWeekGain = 1213016
ProtocolID.GResMonthCardList = 1213017
ProtocolID.GResMonthCardGain = 1213018
ProtocolID.GResLevelUpGiftList = 1213019
ProtocolID.GResLevelUpGift = 1213020
ProtocolID.GResPubTaskList = 1213021
ProtocolID.GResPubTaskRereshOne = 1213022
ProtocolID.GResPubTaskStart = 1213023
ProtocolID.GResPubTaskAward = 1213024
ProtocolID.GResBlessingPoolList = 1213031
ProtocolID.GResBlessingPoolTag = 1213032
ProtocolID.GResBlessingPoolDone = 1213033
ProtocolID.GResBlessingPoolShop = 1213034
ProtocolID.GResProphetSummon = 1213041
ProtocolID.GResProphetChange = 1213042
ProtocolID.GResProphetShopList = 1213045
ProtocolID.GResAltarHero = 1213051
ProtocolID.GResAltarShopList = 1213054
ProtocolID.GResLimitGiftList = 1213060
ProtocolID.GResLimitGiftAdd = 1213061
ProtocolID.GResInvestList = 1213062
ProtocolID.GResInvestGain = 1213063
ProtocolID.GResGetExchangeGiftList = 1213071
ProtocolID.GResBuyGoldList = 1213073
ProtocolID.GResBuyGoldRankList = 1213074
ProtocolID.GResProphecyList = 1213076
ProtocolID.GResPvpwinList = 1213078
ProtocolID.GResSummonTimesList = 1213080
ProtocolID.GResInvitationList = 1213082
ProtocolID.GResInviteGetReward = 1213083
ProtocolID.GResInviteUseCode = 1213084
ProtocolID.GResLimitedtimeRechargeReward = 1213085
ProtocolID.GResMidAutumnInfo = 1213086
ProtocolID.GResSummonCrystalInfo = 1213087
ProtocolID.GResBlessingPoolTimesList = 1213090
ProtocolID.GResNewServerLimitListInfo = 1213091
ProtocolID.GResMarkHeroList = 1213093
ProtocolID.GResPromotionSacrificeShop = 1213095
ProtocolID.GResAstrologyTaskInfo = 1213100
ProtocolID.GResAstrologyTaskSubmit = 1213101
ProtocolID.GResPubArriveInfo = 1213106
ProtocolID.GResLimitShopList = 1213110
ProtocolID.GResPromotionAdventureList = 1213112
ProtocolID.GResAdventureRankList = 1213113
ProtocolID.GResPromotionSpeedFightList = 1213115
ProtocolID.GResSpeedFightRankList = 1213116
ProtocolID.GResPromotionTavernWeeklyList = 1213118
ProtocolID.GResTavernWeeklyRankList = 1213119

----------------模块: 商店模块----------------
ProtocolID.GReqBuyItem = 1114000
ProtocolID.GReqShopBuyEnergy = 1114001
ProtocolID.GReqShopBuyHeroCapacity = 1114003
ProtocolID.GReqShopRefreshPvp = 1114005
ProtocolID.GReqShopBuySummonTicket = 1114010
ProtocolID.GResShopBuyEnergy = 1214001
ProtocolID.GResShopBuyHeroCapacity = 1214003
ProtocolID.GResShopBuySummonTicket = 1214010

----------------模块: 邮件、兑换码模块----------------
ProtocolID.GReqMailList = 1115000
ProtocolID.GReqDealWithMail = 1115001
ProtocolID.GReqCdk = 1115010
ProtocolID.GResMailList = 1215000
ProtocolID.GResCDK = 1215010

----------------模块: 试炼模块----------------
ProtocolID.GReqTrialCfg = 1116000
ProtocolID.GReqTrialPass = 1116001
ProtocolID.GReqTrialBox = 1116002
ProtocolID.GReqTrialReset = 1116003
ProtocolID.GReqAdventureShopList = 1116005
ProtocolID.GReqAdventureShopBuy = 1116006
ProtocolID.GReqTrialBattleList = 1116007
ProtocolID.GReqTrialBattleHeroUpdate = 1116009
ProtocolID.GResTrialCfg = 1216000
ProtocolID.GResTrialPass = 1216001
ProtocolID.GResTrialBox = 1216002
ProtocolID.GResAdventureShopList = 1216005
ProtocolID.GResTrialBattleList = 1216007
ProtocolID.GResTrialBattleHeroList = 1216008

----------------模块: 点金模块----------------
ProtocolID.GReqBuyGoldLog = 1117000
ProtocolID.GReqBuyGold = 1117001
ProtocolID.GResBuyaGoldLog = 1217000
ProtocolID.GResBuyaGold = 1217001

----------------模块: PVP模块----------------
ProtocolID.GReqPvpData = 1118001
ProtocolID.GReqPvpBattle = 1118002
ProtocolID.GReqPvpBattleEnd = 1118003
ProtocolID.GReqPvpBattleHistory = 1118004
ProtocolID.GReqPvpBattleHistoryList = 1118005
ProtocolID.GReqPvpShopList = 1118006
ProtocolID.GReqPvpShopBuy = 1118007
ProtocolID.GResPvpData = 1218001
ProtocolID.GResPvpBattle = 1218002
ProtocolID.GResPvpBattleEnd = 1218003
ProtocolID.GResPvpBattleHistory = 1218004
ProtocolID.GResPvpBattleHistoryList = 1218005
ProtocolID.GResPvpShopList = 1218006

----------------模块: 日常模块----------------
ProtocolID.GReqDailyDungeonData = 1119001
ProtocolID.GReqDailyDungeonEnd = 1119002
ProtocolID.GResDailyDungeonData = 1219001
ProtocolID.GResDailyDungeonEnd = 1219002
ProtocolID.GResEveryDayTaskReward = 1219003

----------------模块: 市场模块----------------
ProtocolID.GReqShopRechargeCheck = 1120000
ProtocolID.GReqPromotionList = 1120001
ProtocolID.GReqPromotionReward = 1120002
ProtocolID.GReqVipRewardBuy = 1120004
ProtocolID.GReqDayLimitReward = 1120007
ProtocolID.GReqDailyFirstRecharge = 1120008
ProtocolID.GReqDailyFirstRechargeReward = 1120009
ProtocolID.GReqVipDecorateBug = 1120010
ProtocolID.GReqRechargeFirst = 1120012
ProtocolID.GReqRechargeFirstReward = 1120013
ProtocolID.GReqPrivilegeGiftAddOrUpdate = 1120014
ProtocolID.GReqPrivilegeGiftBuy = 1120015
ProtocolID.GReqDailyTotalRecharge = 1120016
ProtocolID.GReqDailyTotalRechargeGet = 1120017
ProtocolID.GResShopRechargeCheck = 1220000
ProtocolID.GResPromotionList = 1220001
ProtocolID.GResFoundAtionRewardList = 1220002
ProtocolID.GResShopLog = 1220003
ProtocolID.GResVipRewardBuy = 1220004
ProtocolID.GResVipRewardLog = 1220005
ProtocolID.GResDayLimitLog = 1220006
ProtocolID.GResVipDecorateReward = 1220007
ProtocolID.GResDailyFirstRecharge = 1220008
ProtocolID.GResDailyFirstRechareReward = 1220009
ProtocolID.GResRechargeFirst = 1220012
ProtocolID.GResRechargeFristReward = 1220013
ProtocolID.GResPrivilegeGiftAddOrUpdate = 1220014
ProtocolID.GResDailyTotalRecharge = 1220016

----------------模块: 七天目标模块----------------
ProtocolID.GReqSevenDayTargetData = 1121000
ProtocolID.GReqSevenDayTargetReward = 1121002
ProtocolID.GReqSevenDayTargetBoxReward = 1121003
ProtocolID.GResSevenDayTargetData = 1221000
ProtocolID.GResUpdateSevenDayTargetData = 1221001
ProtocolID.GResSevenDayTargetReward = 1221002
ProtocolID.GResSevenDayTargetBoxReward = 1221003
ProtocolID.GResSevenDayTargetUpdataDay = 1221004

----------------模块: 七天登录模块----------------
ProtocolID.GReqSevenDayLoginData = 1122000
ProtocolID.GReqSevenDayLoginReward = 1122001
ProtocolID.GResSevenDayLoginData = 1222000
ProtocolID.GResSevenDayLoginReward = 1222001
ProtocolID.GResSevenDayLoginUpdataDay = 1222002

----------------模块: 英雄降临模块----------------
ProtocolID.GReqHeroArriveReward = 1123001
ProtocolID.GResHeroArriveData = 1223000
ProtocolID.GResHeroArriveReward = 1223001
ProtocolID.GResHeroArriveUpdate = 1223002

----------------模块: 地牢降临模块----------------
ProtocolID.GReqDungeonInfo = 1124001
ProtocolID.GReqDungeonShopList = 1124002
ProtocolID.GReqDungeonTeam = 1124003
ProtocolID.GReqDungeonInitTeam = 1124004
ProtocolID.GReqDungeonKillRewardList = 1124005
ProtocolID.GReqDungeonKillReward = 1124006
ProtocolID.GReqDungeonPropsList = 1124007
ProtocolID.GReqDungeonBuffList = 1124008
ProtocolID.GReqDungeonMonsterHpList = 1124009
ProtocolID.GReqDungeonGridLight = 1124011
ProtocolID.GReqDungeonNextStage = 1124012
ProtocolID.GReqDungeonUseProps = 1124013
ProtocolID.GReqDungeonGetRes = 1124014
ProtocolID.GReqDungeonOpenBox = 1124016
ProtocolID.GReqDungeonShopBuy = 1124021
ProtocolID.GReqDungeonShopAdd = 1124022
ProtocolID.GReqDungeonBattleEnd = 1124031
ProtocolID.GResDungeonInfo = 1224001
ProtocolID.GResDungeonShopList = 1224002
ProtocolID.GResDungeonTeam = 1224003
ProtocolID.GResDungeonInitTeam = 1224004
ProtocolID.GResDungeonKillRewardList = 1224005
ProtocolID.GResDungeonKillReward = 1224006
ProtocolID.GResDungeonPropsList = 1224007
ProtocolID.GResDungeonBuffList = 1224008
ProtocolID.GResDungeonMonsterHpList = 1224009
ProtocolID.GResDungeonNextStage = 1224012
ProtocolID.GResDungeonUseProps = 1224013
ProtocolID.GResDungeonGetRes = 1224014
ProtocolID.GResDungeonOpenBox = 1224016
ProtocolID.GResDungeonShopBuy = 1224021
ProtocolID.GResDungeonShopAdd = 1224022
ProtocolID.GResDungeonBattleEnd = 1224031

----------------模块: 在线奖励模块----------------
ProtocolID.GReqInitOnlineReward = 1125002
ProtocolID.GResInitOnlineRewardData = 1225001
ProtocolID.GResInitOnlineReward = 1225002
ProtocolID.GResOnlineReward = 1225003

----------------模块: 限时活动模块----------------
ProtocolID.GReqMouthWelfareList = 1126001
ProtocolID.GReqDailyWelfareList = 1126002
ProtocolID.GResMouthWelfareList = 1226001
ProtocolID.GResDailyWelfareList = 1226002

----------------模块: 羁绊模块----------------
ProtocolID.GReqFetterReward = 1128002
ProtocolID.GReqFetterList = 1128100
ProtocolID.GReqFetterUpLevel = 1128101
ProtocolID.GReqFetterUpSkill = 1128102
ProtocolID.GReqFetterUpRefine = 1128103
ProtocolID.GReqFetterUplimit = 1128104
ProtocolID.GResFetterInitTask = 1228000
ProtocolID.GResFetterUpProgress = 1228001
ProtocolID.GResFetterReward = 1228002
ProtocolID.GResFetterInitVip = 1228003
ProtocolID.GResFetterUpdateVip = 1228004
ProtocolID.GResFetterData = 1228005
ProtocolID.GResFetterList = 1228100
ProtocolID.GResFetterUpLevel = 1228101
ProtocolID.GResFetterUpskill = 1228102
ProtocolID.GResFetterUpRefine = 1228103
ProtocolID.GResFetterUplimit = 1228104

----------------模块: 符文模块----------------
ProtocolID.GReqRunesList = 1129001
ProtocolID.GReqRuneOnOff = 1129002
ProtocolID.GReqRuneDisCombine = 1129003
ProtocolID.GReqRuneCombine = 1129004
ProtocolID.GReqRuneWash = 1129005
ProtocolID.GReqRuneWashSave = 1129014
ProtocolID.GResRunesList = 1229001
ProtocolID.GResAllHeroRunes = 1229002
ProtocolID.GResRuneCombine = 1229004
ProtocolID.GResRuneWash = 1229005
ProtocolID.GResRune = 1229011
ProtocolID.GResHeroRunes = 1229012
ProtocolID.GResRunesDelList = 1229021

----------------模块: 商店模块----------------
ProtocolID.GReqShopRefresh = 1150001
ProtocolID.GReqShopBuy = 1150002
ProtocolID.GReqShopBuySacrifice = 1150003
ProtocolID.GResShopList = 1250000
ProtocolID.GResShopRefresh = 1250001
ProtocolID.GResShopBuy = 1250002
ProtocolID.GResShopBuySacrifice = 1250003

----------------模块: GM指令模块----------------
ProtocolID.GReqGMStr = 1199001
ProtocolID.GResGMLsStr = 1299002
