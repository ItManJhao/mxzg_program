local ResponseManager = class("ResponseManager", require("src.common.SingleInstance"))
-- ResponseManager.map_response = {}

require "src.common.ProtocolID"
require "src.net.Protocols"

function ResponseManager:ctor()
    self.map_response = {}
    
    -- 跑马灯
    self:addHandlerAuto(ProtocolID.GResMarquee, Marquee_pb.GResMarquee, require("src.net.NoticeResponse").noticeAdd)

    -- 角色
    self:addHandler(ProtocolID.GResHeartBeat, Login_pb.GResHeartBeat, require("src.net.RoleResponse").heartBeat)
    self:addHandler(ProtocolID.GResLogin, Login_pb.GResLogin, require("src.net.RoleResponse").login)
    self:addHandler(ProtocolID.GResInit, Login_pb.GResInit, require("src.net.RoleResponse").roleInit)
    self:addHandler(ProtocolID.GResError, Login_pb.GResError, require("src.net.RoleResponse").error)
    self:addHandler(ProtocolID.GResOffline, Login_pb.GResOffline, require("src.net.RoleResponse").offline)


    self:addHandler(ProtocolID.GResRoleInfo, Role_pb.GResRoleInfo, require("src.net.RoleResponse").roleInfo)

    self:addHandler(ProtocolID.GResCdk, Code_pb.GResCdk, require("src.net.RoleResponse").inputCodeGift) -- 兑换码礼包
    self:addHandler(ProtocolID.GResRoleEditNick, Role_pb.GResRoleEditNick, require("src.net.RoleResponse").renameDone) 
    self:addHandler(ProtocolID.GResRoleRename, Role_pb.GResRoleRename, require("src.net.RoleResponse").changeNickDone) 
    self:addHandler(ProtocolID.GResRoleRandNick, Role_pb.GResRoleRandNick, require("src.net.RoleResponse").randNick)
    self:addHandler(ProtocolID.GResRoleUpgradeReward, Role_pb.GResRoleUpgradeReward, require("src.net.RoleResponse").roleUpgrade)
    self:addHandlerAuto(ProtocolID.GResPlayerDetaile, Role_pb.GResPlayerDetaile, require("src.net.RoleResponse").playerInfo)
    self:addHandlerAuto(ProtocolID.GResRoleForbidChat, Role_pb.GResRoleForbidChat, require("src.net.RoleResponse").roleForbidChat)
    self:addHandler(ProtocolID.GResRoleForbid, Role_pb.GResRoleForbid, require("src.net.RoleResponse").roleForbid)
    self:addHandlerAuto(ProtocolID.GResUpdateAreaId, Role_pb.GResUpdateAreaId, require("src.net.RoleResponse").roleUpdateAreaIdx)
    self:addHandlerAuto(ProtocolID.GResGetNewbieReward, Role_pb.GResGetNewbieReward, require("src.net.RoleResponse").newbieReward)

    self:addHandlerAuto(ProtocolID.GResWorldLevel, WorldLevel_pb.GResWorldLevel, require("src.net.RoleResponse").worldLevel)

    -- 评论有礼
    self:addHandlerAuto(ProtocolID.GResCommentSharedState, Role_pb.GResCommentSharedState, require("src.net.RoleResponse").commentSharedState)
    self:addHandlerAuto(ProtocolID.GResCommentSharedComment, Role_pb.GResCommentSharedComment, require("src.net.RoleResponse").commentSharedComment)
    self:addHandlerAuto(ProtocolID.GResCommentSharedReward, Role_pb.GResCommentSharedReward, require("src.net.RoleResponse").commentSharedReward)

    -- 尊贵标识
    self:addHandlerAuto(ProtocolID.GResUpdatePeerageStatus, Role_pb.GResUpdatePeerageStatus, require("src.net.RoleResponse").UpdatePeerageReward)
    self:addHandlerAuto(ProtocolID.GResActivePeerage, Role_pb.GResActivePeerage, require("src.net.RoleResponse").showActivePeerage)
    -- 我要变强
    self:addHandlerAuto(ProtocolID.GResScanHeroScore, HeroScore_pb.GResScanHeroScore, require("src.net.HeroScoreResponse").heroScore)

    -- 充值
    self:addHandler(ProtocolID.GResRechargeOrder, Recharge_pb.GResRechargeOrder, require("src.net.RechargeResponse").rechargeOrder)


    -- 背包
    self:addHandler(ProtocolID.GResBackPackList, BackPack_pb.GResBackPackList, require("src.net.BackpackResponse").backpackList)
    self:addHandlerAuto(ProtocolID.GResBackpackGain, BackPack_pb.GResBackpackGain, require("src.net.BackpackResponse").backpackGain)
    self:addHandler(ProtocolID.GResMakeEquip, BackPack_pb.GResMakeEquip, require("src.net.BackpackResponse").backpackMakeEquip)
    self:addHandler(ProtocolID.GResOneKeyMakeEquip, BackPack_pb.GResOneKeyMakeEquip, require("src.net.BackpackResponse").backpackMakeOneKeyEquip)
    self:addHandlerAuto(ProtocolID.GResOpenBoxReward, BackPack_pb.GResOpenBoxReward, require("src.net.BackpackResponse").backpackBoxReward)
    self:addHandler(ProtocolID.GResPieceReward, BackPack_pb.GResPieceReward, require("src.net.BackpackResponse").backpackPieceReward)
    -- 回调函数跟普通碎片一样
    self:addHandler(ProtocolID.GResElitePieceHero, BackPack_pb.GResElitePieceHero, require("src.net.BackpackResponse").backpackPieceReward) 
    self:addHandler(ProtocolID.GResTimeLimitList, BackPack_pb.GResTimeLimitList, require("src.net.BackpackResponse").handleTimeLimitList)

    -- 聊天
    self:addHandlerAuto(ProtocolID.GResChat, Chat_pb.GResChat, require("src.net.ChatResponse").chatList)
    -- self:addHandlerAuto(ProtocolID.GResChatLog, Chat_pb.GResChatLog, require("src.net.ChatResponse").chatLogList)
    self:addHandlerAuto(ProtocolID.GResChatLogByType, Chat_pb.GResChatLogByType, require("src.net.ChatResponse").chatLogWithType)
    self:addHandlerAuto(ProtocolID.GResChatNum, Chat_pb.GResChatNum, require("src.net.ChatResponse").chatNum)
    self:addHandlerAuto(ProtocolID.GResPrivateChatRoles, Chat_pb.GResPrivateChatRoles, require("src.net.ChatResponse").chatFriendList)
    self:addHandlerAuto(ProtocolID.GResPrivateChatLog, Chat_pb.GResPrivateChatLog, require("src.net.ChatResponse").ChatFriendChatList)
    self:addHandlerAuto(ProtocolID.GResAddPrivateChat, Chat_pb.GResAddPrivateChat, require("src.net.ChatResponse").ChatFriendAdd)
    self:addHandlerAuto(ProtocolID.GResRemovePrivateChat, Chat_pb.GResRemovePrivateChat, require("src.net.ChatResponse").ChatFriendDel)

    -- 好友
    self:addHandler(ProtocolID.GResFriendsGift, Friend_pb.GResFriendsGift, require("src.net.FriendResponse").friendsGive) --收到礼物的通知
    self:addHandler(ProtocolID.GResFriendsList, Friend_pb.GResFriendsList, require("src.net.FriendResponse").friendsListInfo)
    self:addHandler(ProtocolID.GResFriendsRequestList, Friend_pb.GResFriendsRequestList, require("src.net.FriendResponse").friendsRequestInfo)
    self:addHandlerAuto(ProtocolID.GResBlackList, Friend_pb.GResBlackList, require("src.net.FriendResponse").blackList)
    self:addHandlerAuto(ProtocolID.GResAddBlackList, Friend_pb.GResAddBlackList, require("src.net.FriendResponse").blackListAdd)
    self:addHandlerAuto(ProtocolID.GResRemoveBlackList, Friend_pb.GResRemoveBlackList, require("src.net.FriendResponse").blackListRemove)
    self:addHandler(ProtocolID.GResFriendsSearch, Friend_pb.GResFriendsSearch, require("src.net.FriendResponse").friendsSearch)
    self:addHandler(ProtocolID.GResFriendsAdd, Friend_pb.GResFriendsAdd, require("src.net.FriendResponse").friendsAdd)
    self:addHandler(ProtocolID.GResFriendsAgree, Friend_pb.GResFriendsAgree, require("src.net.FriendResponse").friendsAgree)
    self:addHandler(ProtocolID.GResFriendsDelete, Friend_pb.GResFriendsDelete, require("src.net.FriendResponse").friendsDelete)
    self:addHandler(ProtocolID.GResFriendChatList, Friend_pb.GResFriendChatList, require("src.net.FriendResponse").friendsChatList)
    self:addHandler(ProtocolID.GResFriendsGive, Friend_pb.GResFriendsGive, require("src.net.FriendResponse").friendsGift)
    self:addHandler(ProtocolID.GResFriendsReward, Friend_pb.GResFriendsReward, require("src.net.FriendResponse").friendsRewardGet)
    self:addHandler(ProtocolID.GResFriendsRewardAll, Friend_pb.GResFriendsRewardAll, require("src.net.FriendResponse").friendsRewardAll)
    self:addHandler(ProtocolID.GResFriendsGiveAll, Friend_pb.GResFriendsGiveAll, require("src.net.FriendResponse").friendsGivedAll)  
    self:addHandler(ProtocolID.GResFriendsOnlineRadio, Friend_pb.GResFriendsOnlineRadio, require("src.net.FriendResponse").friendOnlineStatus)
    self:addHandler(ProtocolID.GResFriendApplying, Friend_pb.GResFriendApplying, require("src.net.FriendResponse").friendApplying)
    -- self.map_response[1209001] = require("src.net.FriendResponse").friendsListInfo
    -- self.map_response[1209002] = require("src.net.FriendResponse").friendsRequestInfo
    -- self.map_response[1209003] = require("src.net.FriendResponse").friendsSearch
    -- self.map_response[1209004] = require("src.net.FriendResponse").friendsAdd
    -- self.map_response[1209005] = require("src.net.FriendResponse").friendsAgree
    -- self.map_response[1209006] = require("src.net.FriendResponse").friendsDelete
    -- self.map_response[1209007] = require("src.net.FriendResponse").friendsChatList
    -- self.map_response[1209008] = require("src.net.FriendResponse").friendsGift


    -- 永恒梦境
    self:addHandlerAuto(ProtocolID.GResDreamlandData, Dreamland_pb.GResDreamlandData, require("src.net.DreamlandResponse").dreamlandData)
    self:addHandlerAuto(ProtocolID.GResFriendAssistHeroList, Dreamland_pb.GResFriendAssistHeroList, require("src.net.DreamlandResponse").friendAssistHeroList)
    self:addHandlerAuto(ProtocolID.GResDreamlandRank, Dreamland_pb.GResDreamlandRank, require("src.net.DreamlandResponse").dreamlandRank)
    self:addHandlerAuto(ProtocolID.GResDreamlandGetLevel, Dreamland_pb.GResDreamlandGetLevel, require("src.net.DreamlandResponse").dreamlandGetLevel)
    self:addHandlerAuto(ProtocolID.GResDreamlandBattle, Dreamland_pb.GResDreamlandBattle, require("src.net.DreamlandResponse").dreamlandBattle)
    self:addHandlerAuto(ProtocolID.GResDreamlandSelectFriend, Dreamland_pb.GResDreamlandSelectFriend, require("src.net.DreamlandResponse").dreamlandSelectFriend)
    self:addHandlerAuto(ProtocolID.GResDreamlandSelectBuff, Dreamland_pb.GResDreamlandSelectBuff, require("src.net.DreamlandResponse").dreamlandSelectBuff)
    self:addHandlerAuto(ProtocolID.GResDreamlandStartBattle, Dreamland_pb.GResDreamlandStartBattle, require("src.net.DreamlandResponse").dreamlandStartBattle)
    self:addHandlerAuto(ProtocolID.GResDreamlandDispatchHero, Dreamland_pb.GResDreamlandDispatchHero, require("src.net.DreamlandResponse").dreamlandDispatchHero)
    self:addHandlerAuto(ProtocolID.GResDreamlandBattleStatus, Dreamland_pb.GResDreamlandBattleStatus, require("src.net.DreamlandResponse").dreamlandBattleStatus)
    self:addHandlerAuto(ProtocolID.GResDreamlandBattleReport, Dreamland_pb.GResDreamlandBattleReport, require("src.net.DreamlandResponse").dreamlandBattleReport)
    self:addHandlerAuto(ProtocolID.GResDreamlandEndBattle, Dreamland_pb.GResDreamlandEndBattle, require("src.net.DreamlandResponse").dreamlandEndBattle)
    -- self:addHandlerAuto(ProtocolID.GResDreamlandAddLv, Dreamland_pb.GResDreamlandAddLv, require("src.net.DreamlandResponse").dreamlandAddLv)
    self:addHandlerAuto(ProtocolID.GResDreamlandWinAddLv, Dreamland_pb.GResDreamlandWinAddLv, require("src.net.DreamlandResponse").dreamlandWinAddLv)


    -- 商店1
    self:addHandlerAuto(ProtocolID.GResShopList, Shop_pb.GResShopList, require("src.net.ShopResponse").shopList)
    self:addHandler(ProtocolID.GResShopRefresh, Shop_pb.GResShopRefresh, require("src.net.ShopResponse").shopRefresh)
    self:addHandler(ProtocolID.GResShopBuy, Shop_pb.GResShopBuy, require("src.net.ShopResponse").shopBuy)
    self:addHandler(ProtocolID.GResShopBuySacrifice, Promotion042_pb.GResShopBuySacrifice, require("src.net.ShopResponse").timeshopBuy)
    -- self.map_response[ProtocolID.GResMarketList] = require("src.net.ShopResponse").shopList
    -- self:addHandler(ProtocolID.GResShopList, Shop_pb.GResShopList, require("src.net.ShopResponse").blackMarketList) --废弃
    self:addHandler(ProtocolID.GResOneShopData, Shop_pb.GResOneShopData, require("src.net.ShopResponse").refreshTime)
    self:addHandler(ProtocolID.GResGetFreeNum, Shop_pb.GResGetFreeNum, require("src.net.ShopResponse").addFreeNum)

    -- 充值
    self:addHandlerAuto(ProtocolID.GResShopRechargeCheck, Recharge_pb.GResShopRechargeCheck, require("src.net.ShopResponse").shopRecharge)
    self:addHandler(ProtocolID.GResShopLog, Promotion_pb.GResShopLog, require("src.net.ShopResponse").shopLog)
    self:addHandler(ProtocolID.GResPromotionList, Promotion_pb.GResPromotionList, require("src.net.PromotionResponse").promotionList)
    --self.map_response[1220002] = require("src.net.PromotionResponse").promotionRewardList
    -- self.map_response[ProtocolID.GResVipRewardBuy] = require("src.net.PromotionResponse").vipRewardBuy
    self:addHandler(ProtocolID.GResVipRewardBuy, Promotion_pb.GResVipRewardBuy, require("src.net.PromotionResponse").vipRewardBuy)
    self:addHandler(ProtocolID.GResVipRewardLog, Promotion_pb.GResVipRewardLog, require("src.net.PromotionResponse").vipRewardLog)
    self:addHandler(ProtocolID.GResDayLimitLog, Promotion_pb.GResDayLimitLog, require("src.net.PromotionResponse").dayLimitLog)
    
    self:addHandlerAuto(ProtocolID.GResFirstRecharge, FirstRecharge_pb.GResFirstRecharge, require("src.net.PromotionResponse").rechargeFirstList)
    self:addHandler(ProtocolID.GResFirstRechargeReward, FirstRecharge_pb.GResFirstRechargeReward, require("src.net.PromotionResponse").rechargeFirstAward)
    
    --周向阳
    --超值赠礼
    self:addHandlerAuto(ProtocolID.GResGetRechargeGiftReward, promotion069_pb.GResGetRechargeGiftReward, require("src.net.PromotionResponse").supreGiftReward)
    self:addHandlerAuto(ProtocolID.GResRechargeGiftInfo, promotion069_pb.GResRechargeGiftInfo, require("src.net.PromotionResponse").supreGiftInfo)


    
    self:addHandler(ProtocolID.GResPrivilegeGiftAddOrUpdate, Promotion010_pb.GResPrivilegeGiftAddOrUpdate, require("src.net.PromotionResponse").handlePrivilegeGiftAddOrUpdate)
    self:addHandler(ProtocolID.GResPrivilegeGiftBuy, Promotion010_pb.GResPrivilegeGiftBuy, require("src.net.PromotionResponse").updatePrivilegeGift)

    -- 关卡
    self:addHandler(ProtocolID.GResChapterEnd, Battle_pb.GResChapterEnd, require("src.net.BattleResponse").chapterEnd)
    self:addHandler(ProtocolID.GResChapterItemList, Battle_pb.GResChapterItemList, require("src.net.BattleResponse").chapterItemList)
    self:addHandler(ProtocolID.GResChapterItemReward, Battle_pb.GResChapterItemReward, require("src.net.BattleResponse").chapterItemListReward)
    self:addHandlerAuto(ProtocolID.GResChapterData, Battle_pb.GResChapterData, require("src.net.BattleResponse").chapterSetData)
    self:addHandlerAuto(ProtocolID.GResChapterRewardList, Battle_pb.GResChapterRewardList, require("src.net.BattleResponse").chapterRewardList)
    self:addHandlerAuto(ProtocolID.GResBattleMatch, Battle_pb.GResBattleMatch, require("src.net.BattleResponse").chapterStart)
    self:addHandlerAuto(ProtocolID.GResExtraReward, Battle_pb.GResExtraReward, require("src.net.BattleResponse").chapterExtraReward)
    self:addHandlerAuto(ProtocolID.GResGuideBattle, Battle_pb.GResGuideBattle, require("src.net.BattleResponse").guideBattle)
    self:addHandlerAuto(ProtocolID.GResPreComputeStrength, Battle_pb.GResPreComputeStrength, require("src.net.BattleResponse").preComputeStrength)

    -- 召唤
    self:addHandlerAuto(ProtocolID.GResHeroSummon, Hero_pb.GResHeroSummon, require("src.net.SummonResponse").summonList)
    self:addHandler(ProtocolID.GResHeroSummonCount, Hero_pb.GResHeroSummonCount,require("src.net.SummonResponse").summonCompleted)
    self:addHandler(ProtocolID.GResHeroSummonAward, Hero_pb.GResHeroSummonAward, require("src.net.SummonResponse").summonAward)

    -- 英雄许愿
    self:addHandler(ProtocolID.GResHeroPrayerData, HeroPrayer_pb.GResHeroPrayerData, require("src.net.HeroPrayerResponse").heroPrayerData)
    self:addHandler(ProtocolID.GResHeroPrayer, HeroPrayer_pb.GResHeroPrayer, require("src.net.HeroPrayerResponse").heroPrayer)
    
    self:addHandler(ProtocolID.GResChoose, Hero_pb.GResChoose, require("src.net.HeroResponse").getChoose)
    -- 英雄
    self:addHandlerAuto(ProtocolID.GResHeroList, Hero_pb.GResHeroList, require("src.net.HeroResponse").heroList)
    self:addHandler(ProtocolID.GResIllustratReward, Hero_pb.GResIllustratReward, require("src.net.HeroResponse").heroIllustratList)
    self:addHandler(ProtocolID.GResIllustratActive,Hero_pb.GResIllustratActive,require("src.net.HeroResponse").heroIllustratUpdate)
    self:addHandler(ProtocolID.GResHeroUpLevel,Hero_pb.GResHeroUpLevel,require("src.net.HeroResponse").heroUpLevel)  
    self:addHandler(ProtocolID.GResHeroUpgrade,Hero_pb.GResHeroUpgrade,require("src.net.HeroResponse").heroUpgradeLevel)
    self:addHandlerAuto(ProtocolID.GResHeroUpStar,Hero_pb.GResHeroUpStar,require("src.net.HeroResponse").heroUpgradeStar)
    -- self:addHandler(ProtocolID.GResHeroCompose,Hero_pb.GResHeroCompose,require("src.net.HeroResponse").heroCreat)
    self:addHandlerAuto(ProtocolID.GResHeroEquip, Hero_pb.GResHeroEquip, require("src.net.HeroResponse").heroEquipData)
    self:addHandler(ProtocolID.GResHeroEquipChange, Hero_pb.GResHeroEquipChange, require("src.net.HeroResponse").heroEquipChange)
    self:addHandler(ProtocolID.GResHeroEquipDisboard, Hero_pb.GResHeroEquipDisboard, require("src.net.HeroResponse").heroEquipDisboard)
    self:addHandler(ProtocolID.GResHeroEquipOneKeyWear, Hero_pb.GResHeroEquipOneKeyWear, require("src.net.HeroResponse").heroOneKeyEquip)
    self:addHandler(ProtocolID.GResHeroEquipOneKeyDisboard, Hero_pb.GResHeroEquipOneKeyDisboard, require("src.net.HeroResponse").heroOneKeyDisboard)
    self:addHandler(ProtocolID.GResHeroFighting, Hero_pb.GResHeroFighting, require("src.net.HeroResponse").heroFighting)
    self:addHandler(ProtocolID.GResRoleFighting, Hero_pb.GResRoleFighting, require("src.net.HeroResponse").roleFighting)
    self:addHandler(ProtocolID.GResHeroAdd, Hero_pb.GResHeroAdd, require("src.net.HeroResponse").heroAdd)
    self:addHandler(ProtocolID.GResHeroDelete, Hero_pb.GResHeroDelete, require("src.net.HeroResponse").heroDelete)
    self:addHandler(ProtocolID.GResHeroCapacity, Hero_pb.GResHeroCapacity, require("src.net.HeroResponse").heroCapacity)
    self:addHandler(ProtocolID.GResHeroShare, HeroShare_pb.GResHeroShare, require("src.net.HeroResponse").onHeroShare)
    self:addHandlerAuto(ProtocolID.GResShareHeroInfo, HeroShare_pb.GResShareHeroInfo, require("src.net.HeroResponse").onShareHeroInfo)
    self:addHandlerAuto(ProtocolID.GResHeroBriefInfo, HeroShare_pb.GResHeroBriefInfo, require("src.net.HeroResponse").onShareHeroInfo)
    self:addHandlerAuto(ProtocolID.GResHeroLock, Hero_pb.GResHeroLock, require("src.net.HeroResponse").onLock)

    self:addHandler(ProtocolID.GResHeroReborn, Hero_pb.GResHeroReborn, require("src.net.HeroResponse").heroReborn)
    -- 英雄进化
    self:addHandler(ProtocolID.GResEvolve, Hero_pb.GResEvolve, require("src.net.HeroResponse").heroEvolution)
    self:addHandlerAuto(ProtocolID.GResEvolveBack, Hero_pb.GResEvolveBack, require("src.net.HeroResponse").evolveComeBack) --背包英雄回退

    -- 英雄装备附魂
    self:addHandler(ProtocolID.GResHeroEquipSoulLvUp, Hero_pb.GResHeroEquipSoulLvUp, require("src.net.HeroResponse").heroEquipSoulLvUp)
    self:addHandler(ProtocolID.GResHeroEquipSoulReset, Hero_pb.GResHeroEquipSoulReset, require("src.net.HeroResponse").heroEquipSoulReset)
    self:addHandler(ProtocolID.GResSwitchInfo, Hero_pb.GResSwitchInfo, require("src.net.HeroResponse").switchInfo)
    self:addHandler(ProtocolID.GResSwitchTargetList, Hero_pb.GResSwitchTargetList, require("src.net.HeroResponse").switchTargetList)
    self:addHandlerAuto(ProtocolID.GResSwitch, Hero_pb.GResSwitch, require("src.net.HeroResponse").switch)
    
    self:addHandlerAuto(ProtocolID.GResComeBackInfo, Hero_pb.GResComeBackInfo, require("src.net.HeroResponse").comeBackInfo)
    self:addHandlerAuto(ProtocolID.GResComeBack, Hero_pb.GResComeBack, require("src.net.HeroResponse").comeBack)
    self:addHandlerAuto(ProtocolID.GResHeroDetail, Hero_pb.GResHeroDetail, require("src.net.HeroResponse").heroDetail)

    self:addHandlerAuto(ProtocolID.GResGetData, HeroComment_pb.GResGetData, require("src.net.HeroResponse").heroCommentInfo)
    self:addHandlerAuto(ProtocolID.GResComment, HeroComment_pb.GResComment, require("src.net.HeroResponse").UpdateheroCommentsSccessInfo)
    self:addHandlerAuto(ProtocolID.GResLikeComment, HeroComment_pb.GResLikeComment, require("src.net.HeroResponse").UpdateheroCommentLikeInfo)
    self:addHandlerAuto(ProtocolID.GResLikeHero, HeroComment_pb.GResLikeHero, require("src.net.HeroResponse").UpdateheroCommentInfo)
    -- 星盘
    self:addHandlerAuto(ProtocolID.GResAstrolabeData, Astrolabe_pb.GResAstrolabeData, require("src.net.AstrolabeResponse").handleAstrolabeData)
    self:addHandlerAuto(ProtocolID.GResAstrolabeActiveElem, Astrolabe_pb.GResAstrolabeActiveElem, require("src.net.AstrolabeResponse").handleAstrolabeActiveElem)
    self:addHandlerAuto(ProtocolID.GResAstrolabeLight, Astrolabe_pb.GResAstrolabeLight, require("src.net.AstrolabeResponse").handleAstrolabeLight)
    self:addHandlerAuto(ProtocolID.GResAstrolabeReset, Astrolabe_pb.GResAstrolabeReset, require("src.net.AstrolabeResponse").handleAstrolabeReset)
    self:addHandlerAuto(ProtocolID.GResAstrolabeUpdateMaxStar, Astrolabe_pb.GResAstrolabeUpdateMaxStar, require("src.net.AstrolabeResponse").handleAstrolabeUpdateMaxStar)
    self:addHandlerAuto(ProtocolID.GResAstrolabeUnlockElem, Astrolabe_pb.GResAstrolabeUnlockElem, require("src.net.AstrolabeResponse").handleAstrolabeUnlockElem)


    -- 英雄殿堂
    self:addHandlerAuto(ProtocolID.GResHeroPalaceData, HeroPalace_pb.GResHeroPalaceData, require("src.net.HeroResponse").heroPalaceInfo)
    self:addHandlerAuto(ProtocolID.GResHeroPalaceWorship, HeroPalace_pb.GResHeroPalaceWorship, require("src.net.HeroResponse").heroPalaceWorship)
    self:addHandlerAuto(ProtocolID.GResHeroPalaceGetReward, HeroPalace_pb.GResHeroPalaceGetReward, require("src.net.HeroResponse").heroPalaceGetReward)


    --英雄宝石
    self:addHandler(ProtocolID.GResHeroJewel, HeroJewel_pb.GResHeroJewel, require("src.net.HeroResponse").heroJewel)
    self:addHandler(ProtocolID.GResHeroJewelChange, HeroJewel_pb.GResHeroJewelChange, require("src.net.HeroResponse").heroJewelChange)
    self:addHandler(ProtocolID.GResHeroJewelDisboard, HeroJewel_pb.GResHeroJewelDisboard, require("src.net.HeroResponse").heroJewelDisboard)
    self:addHandler(ProtocolID.GResHeroJewelOneKeyWear, HeroJewel_pb.GResHeroJewelOneKeyWear, require("src.net.HeroResponse").heroJewelOneKeyWear)
    self:addHandler(ProtocolID.GResHeroJewelOneKeyDisboard, HeroJewel_pb.GResHeroJewelOneKeyDisboard, require("src.net.HeroResponse").heroJewelOneKeyDisboard)

    --英雄觉醒
    self:addHandlerAuto(ProtocolID.GResHeroAwakenSelect, HeroAwaken_pb.GResHeroAwakenSelect, require("src.net.HeroResponse").awakenSelect)

    --公会
    self:addHandlerAuto(ProtocolID.GResClanInfo, Clan_pb.GResClanInfo, require("src.net.ClanResponse").clanInfo)
    self:addHandlerAuto(ProtocolID.GResQuitClanTime, Clan_pb.GResQuitClanTime, require("src.net.ClanResponse").clanLastQuitTime)
    self:addHandlerAuto(ProtocolID.GResClanCreate, Clan_pb.GResClanCreate, require("src.net.ClanResponse").clanCreate)
    self:addHandlerAuto(ProtocolID.GResClanSearch, Clan_pb.GResClanSearch, require("src.net.ClanResponse").clanSearch)
    self:addHandlerAuto(ProtocolID.GResClanJoin, Clan_pb.GResClanJoin, require("src.net.ClanResponse").clanJoin)
    self:addHandlerAuto(ProtocolID.GResClanQuit, Clan_pb.GResClanQuit, require("src.net.ClanResponse").clanQuit)
    self:addHandlerAuto(ProtocolID.GResClanMsgInfo, Clan_pb.GResClanMsgInfo, require("src.net.ClanResponse").clanHistoryList)
    self:addHandlerAuto(ProtocolID.GResClanReqMsgInfo, Clan_pb.GResClanReqMsgInfo, require("src.net.ClanResponse").clanApplyList)
    self:addHandlerAuto(ProtocolID.GResClanReqAgree, Clan_pb.GResClanReqAgree, require("src.net.ClanResponse").clanMemberAgree)
    self:addHandlerAuto(ProtocolID.GResClanAgree, Clan_pb.GResClanAgree, require("src.net.ClanResponse").clanApplyAgreeSucceed)
    self:addHandlerAuto(ProtocolID.GResClanChangePos, Clan_pb.GResClanChangePos, require("src.net.ClanResponse").clanChangePos)
    self:addHandlerAuto(ProtocolID.GResClanSkillList, Clan_pb.GResClanSkillList, require("src.net.ClanResponse").clanSkillList)
    self:addHandlerAuto(ProtocolID.GResClanSkillLight, Clan_pb.GResClanSkillLight, require("src.net.ClanResponse").clanSkillLight)
    self:addHandlerAuto(ProtocolID.GResClanRemoveSkill, Clan_pb.GResClanRemoveSkill, require("src.net.ClanResponse").clanSkillReset)

    self:addHandlerAuto(ProtocolID.GResClanDonateList, Clan_pb.GResClanDonateList, require("src.net.ClanResponse").clanDonateList)
    self:addHandlerAuto(ProtocolID.GResClanTotalDonateReward, Clan_pb.GResClanTotalDonateReward, require("src.net.ClanResponse").clanDonatePointReward)
    self:addHandlerAuto(ProtocolID.GResClanMissionInfo, ClanDungeon_pb.GResClanMissionInfo, require("src.net.ClanResponse").clanMissionInfo)
    self:addHandlerAuto(ProtocolID.GResClanMissionEnd, ClanDungeon_pb.GResClanMissionEnd, require("src.net.ClanResponse").clanMissionEnd)
    self:addHandlerAuto(ProtocolID.GResClanMissionBuy, ClanDungeon_pb.GResClanMissionBuy, require("src.net.ClanResponse").clanMissionBuyAccountDone)
    self:addHandlerAuto(ProtocolID.GResClanRankDamage, Clan_pb.GResClanRankDamage, require("src.net.ClanResponse").clanRankDamage)
    self:addHandlerAuto(ProtocolID.GResUpdateAllClanInfo, Clan_pb.GResUpdateAllClanInfo, require("src.net.ClanResponse").clanUpdateAllInfo)
    
    self:addHandlerAuto(ProtocolID.GResScanWarInfo, ClanWar_pb.GResScanWarInfo, require("src.net.ClanResponse").clanGvgInfo)
    self:addHandlerAuto(ProtocolID.GResScanRoadInfo, ClanWar_pb.GResScanRoadInfo, require("src.net.ClanResponse").clanGvgRoadInfo)
    self:addHandlerAuto(ProtocolID.GResScanMemberRoadInfo, ClanWar_pb.GResScanMemberRoadInfo, require("src.net.ClanResponse").clanGvgMemberInfo)
    self:addHandlerAuto(ProtocolID.GResSaveRoadFormation, ClanWar_pb.GResSaveRoadFormation, require("src.net.ClanResponse").clanGvgRoadLineup)
    self:addHandlerAuto(ProtocolID.GResAdjustRoadSort, ClanWar_pb.GResAdjustRoadSort, require("src.net.ClanResponse").clanGvgRoadSort)
    self:addHandlerAuto(ProtocolID.GResRoadInfoChange, ClanWar_pb.GResRoadInfoChange, require("src.net.ClanResponse").clanGvgRoadInfoChange)
    self:addHandlerAuto(ProtocolID.GResScanBattlingInfo, ClanWar_pb.GResScanBattlingInfo, require("src.net.ClanResponse").clanGvgBattleInfo)
    self:addHandlerAuto(ProtocolID.GResScanHisBattlingInfo, ClanWar_pb.GResScanHisBattlingInfo, require("src.net.ClanResponse").clanGvgHistory)
    self:addHandlerAuto(ProtocolID.GResScanWarBox, ClanWar_pb.GResScanWarBox, require("src.net.ClanResponse").clanGvgBoxList)
    self:addHandlerAuto(ProtocolID.GResOpenWarBox, ClanWar_pb.GResOpenWarBox, require("src.net.ClanResponse").clanGvgOpenBox)
    self:addHandlerAuto(ProtocolID.GResMemberOpenBox, ClanWar_pb.GResMemberOpenBox, require("src.net.ClanResponse").clanGvgMemberOpenBox)
    self:addHandlerAuto(ProtocolID.GResWarBattleNext, ClanWar_pb.GResWarBattleNext, require("src.net.ClanResponse").clanGvgHistoryUpdate)

    self:addHandlerAuto(ProtocolID.GResScanWorldBoss, ClanWorldBoss_pb.GResScanWorldBoss, require("src.net.ClanResponse").clanBossInfo)
    self:addHandlerAuto(ProtocolID.GResChallengeBoss, ClanWorldBoss_pb.GResChallengeBoss, require("src.net.ClanResponse").clanBossChallenge)
    self:addHandlerAuto(ProtocolID.GResScanRobHis, ClanWorldBoss_pb.GResScanRobHis, require("src.net.ClanResponse").clanBossRobHistory)
    self:addHandlerAuto(ProtocolID.GResReadNewRecord, ClanWorldBoss_pb.GResReadNewRecord, require("src.net.ClanResponse").clanBossRobHistoryRead)
    self:addHandlerAuto(ProtocolID.GResGetRobableRole, ClanWorldBoss_pb.GResGetRobableRole, require("src.net.ClanResponse").clanBossRobList)
    self:addHandlerAuto(ProtocolID.GResRobOtherRole, ClanWorldBoss_pb.GResRobOtherRole, require("src.net.ClanResponse").clanBossRobRole)
    self:addHandlerAuto(ProtocolID.GResRobByOtherRole, ClanWorldBoss_pb.GResRobByOtherRole, require("src.net.ClanResponse").clanBossRobByOther)
    self:addHandlerAuto(ProtocolID.GResScanClanRank, ClanWorldBoss_pb.GResScanClanRank, require("src.net.ClanResponse").clanBossRankClan)
    self:addHandlerAuto(ProtocolID.GResScanRoleRank, ClanWorldBoss_pb.GResScanRoleRank, require("src.net.ClanResponse").clanBossRankPlayer)
    self:addHandlerAuto(ProtocolID.GResBossPointChange, ClanWorldBoss_pb.GResBossPointChange, require("src.net.ClanResponse").clanBossRankChange)
    --公会改名卡
    self:addHandlerAuto(ProtocolID.GResClanRenamingCard, Clan_pb.GResClanRenamingCard, require("src.net.RoleResponse").clanChangeNickDone) 

    -- self.map_response[ProtocolID.GResClanShopList] = require("src.net.ClanResponse").shopList

    -- 点金
    self:addHandler(ProtocolID.GResBuyGoldLog, BugGold_pb.GResBuyGoldLog, require("src.net.BuyGoldResponse").buyaGoldLog)
    self:addHandler(ProtocolID.GResBuyGold, BugGold_pb.GResBuyGold, require("src.net.BuyGoldResponse").buyaGold)

    -- 战斗
    self:addHandler(ProtocolID.GResBattleTest, Battle_pb.GResBattleTest, require("src.net.BattleResponse").battleTest)
    self:addHandler(ProtocolID.GResChapterReport, Battle_pb.GResChapterReport, require("src.net.BattleResponse").battleHang)
    self:addHandlerAuto(ProtocolID.GResLineUp, Battle_pb.GResLineUp, require("src.net.BattleResponse").battleLineup)
    self:addHandlerAuto(ProtocolID.GResBattleReport, Battle_pb.GResBattleReport, require("src.net.BattleResponse").battleReport)

    -- 第二契约
    self:addHandlerAuto(ProtocolID.GResUnlock, Battle_pb.GResUnlock, require("src.net.BattleResponse").unlock2Contract)
    self:addHandlerAuto(ProtocolID.GResQueryFormation, Battle_pb.GResQueryFormation, require("src.net.BattleResponse").queryFormations)
    self:addHandlerAuto(ProtocolID.GResUnlockFormation, Battle_pb.GResUnlockFormation, require("src.net.BattleResponse").unlockFormation)

    -- 幻境之塔
    self:addHandler(ProtocolID.GResTowerData, Tower_pb.GResTowerData, require("src.net.TowerResponse").resTowerData)
    self:addHandlerAuto(ProtocolID.GResTowerBattle, Tower_pb.GResTowerBattle, require("src.net.TowerResponse").resTowerBattleEnd)
    self:addHandler(ProtocolID.GResTowerEnergyBuy, Tower_pb.GResTowerEnergyBuy, require("src.net.TowerResponse").resTowerEnergyBuy)
    self:addHandler(ProtocolID.GResTowerRewardList, Tower_pb.GResTowerRewardList, require("src.net.TowerResponse").resTowerRewardList)
    self:addHandler(ProtocolID.GResTowerSweep, Tower_pb.GResTowerSweep, require("src.net.TowerResponse").resTowerSweep)
    self:addHandlerAuto(ProtocolID.GResEditBattle, Tower_pb.GResEditBattle, require("src.net.TowerResponse").editBattle)
    self:addHandlerAuto(ProtocolID.GResTowerLog, Tower_pb.GResTowerLog, require("src.net.TowerResponse").towerLog)

    -- 排行榜
    self:addHandlerAuto(ProtocolID.GResTowerRank, Rank_pb.GResTowerRank, require("src.net.RankResponse").rankTowerList)   -- 幻境之塔排行榜
    self:addHandlerAuto(ProtocolID.GResPvpRankList, Rank_pb.GResPvpRankList, require("src.net.RankResponse").rankPvpList)     -- PVP排行榜
    self:addHandlerAuto(ProtocolID.GResClanRank, Rank_pb.GResClanRank, require("src.net.RankResponse").rankClanList)        -- 公会排行榜
    self:addHandlerAuto(ProtocolID.GResRankChapterList, Rank_pb.GResRankChapterList, require("src.net.RankResponse").rankChapterList) -- 剧情排行榜
    self:addHandlerAuto(ProtocolID.GResFightingRankList, Rank_pb.GResFightingRankList, require("src.net.RankResponse").rankPlayerList)  -- 战力排行榜
    self:addHandlerAuto(ProtocolID.GResDungeonRankList, Rank_pb.GResDungeonRankList, require("src.net.RankResponse").rankDungeonList) -- 地牢排行榜
    self:addHandlerAuto(ProtocolID.GResRankWorshipList, Rank_pb.GResRankWorshipList, require("src.net.RankResponse").rankWorshipList) -- 膜拜列表
    self:addHandlerAuto(ProtocolID.ResRankWorshipOffline, Rank_pb.ResRankWorshipOffline, require("src.net.RankResponse").rankWorshipOffline)     -- 被膜拜列表

    self:addHandlerAuto(ProtocolID.GResCrossClanRank, Rank_pb.GResCrossClanRank, require("src.net.RankResponse").rankCrossClanList) -- 跨服公会排行榜
    self:addHandlerAuto(ProtocolID.GResCrossFightingRankList, Rank_pb.GResCrossFightingRankList, require("src.net.RankResponse").rankCrossFightingList) -- 跨服战力排行榜

    self:addHandlerAuto(ProtocolID.GResGodRelicRank, Rank_pb.GResGodRelicRank, require("src.net.RankResponse").godRelicRank)

    self:addHandlerAuto(ProtocolID.GResFloatingIslandsRank, FloatingIslands_pb.GResFloatingIslandsRank, require("src.net.RankResponse").floatingIslandsRank) -- 浮空岛

    -- 成就
    -- self:addHandler(ProtocolID.GResAchievementLevel, Achievement_pb.GResAchievementLevel, require("src.net.AchievementResponse").achievementInitData)
    -- self:addHandler(ProtocolID.GResUpdateAchievementData, Achievement_pb.GResUpdateAchievementData, require("src.net.AchievementResponse").upAchievementByType)
    -- self:addHandler(ProtocolID.GResAchievementReward, Achievement_pb.GResAchievementReward, require("src.net.AchievementResponse").achievementRewardResult)
    -- self:addHandler(ProtocolID.GResDailyData, Achievement_pb.GResDailyData, require("src.net.AchievementResponse").dailyInitData)
    -- self:addHandler(ProtocolID.GResDailyReward, Achievement_pb.GResDailyReward, require("src.net.AchievementResponse").dailyRewardResult)
    -- self:addHandler(ProtocolID.GResDailyBoxReward, Achievement_pb.GResDailyBoxReward, require("src.net.AchievementResponse").dailyBoxRewardResult)
    -- self:addHandler(ProtocolID.GResUpdateDailyData, Achievement_pb.GResUpdateDailyData, require("src.net.AchievementResponse").upDailyByType)
    self:addHandler(ProtocolID.GResAchievementList, Achievement_pb.GResAchievementList, require("src.net.AchievementResponse").initAchievementData)
    self:addHandler(ProtocolID.GResAchievementGetReward, Achievement_pb.GResAchievementGetReward, require("src.net.AchievementResponse").onAchievementReward)
    self:addHandler(ProtocolID.GResUpdateAchievementTask, Achievement_pb.GResUpdateAchievementTask, require("src.net.AchievementResponse").updateAchievement)
    self:addHandler(ProtocolID.GResAchievementTaskComplete, Achievement_pb.GResAchievementTaskComplete, require("src.net.AchievementResponse").updateAchievementComplete)
    self:addHandler(ProtocolID.GResDailyTaskList, Achievement_pb.GResDailyTaskList, require("src.net.AchievementResponse").initDailyData)
    self:addHandler(ProtocolID.GResDailyTaskGetReward, Achievement_pb.GResDailyTaskGetReward, require("src.net.AchievementResponse").getDailyReward)
    self:addHandler(ProtocolID.GResDailyTaskBoxGetReward, Achievement_pb.GResDailyTaskBoxGetReward, require("src.net.AchievementResponse").getDailyBoxReward)
    self:addHandler(ProtocolID.GResUpdateDailyTask, Achievement_pb.GResUpdateDailyTask, require("src.net.AchievementResponse").upDailyByTask)

    -- 活动
    self:addHandlerAuto(ProtocolID.GResRunningPromotion, PromotionNew_pb.GResRunningPromotion, require("src.net.PromotionResponse").setRunningPromotionData) -- 活动时间总编
    self:addHandlerAuto(ProtocolID.GResActivityConfig, PromotionNew_pb.GResActivityConfig, require("src.net.PromotionResponse").serverActivityConfig) -- 后台活动
    self:addHandlerAuto(ProtocolID.GResActivityConfigHadUpdate, PromotionNew_pb.GResActivityConfigHadUpdate, require("src.net.PromotionResponse").HandleActivityConfigHadUpdate)    -- 后台配置在线更新
    self:addHandlerAuto(ProtocolID.GResActivityBaseInfoUpdate, PromotionNew_pb.GResActivityBaseInfoUpdate, require("src.net.PromotionResponse").HandleActivityBaseInfoUpdate)   -- 后台配置在线更新后更新活动基础数据

    self:addHandler(ProtocolID.GResSignInList, SignIn_pb.GResSignInList, require("src.net.PromotionResponse").signInList) -- 签到
    self:addHandler(ProtocolID.GResSignInAward, SignIn_pb.GResSignInAward, require("src.net.PromotionResponse").signInAward)
    self:addHandler(ProtocolID.GResWeeklyGiftData, Promotion024_pb.GResWeeklyGiftData, require("src.net.PromotionResponse").weekGiftList) -- 每周福利

    --self:addHandler(ProtocolID.GResRechargeDaysList, Task1_pb.GResRechargeDaysList, require("src.net.PromotionResponse").rechargeDaysList) -- 积天豪礼
    self:addHandler(ProtocolID.GResRechargeDaysList, Promotion049_pb.GResRechargeDaysList, require("src.net.PromotionResponse").rechargeDaysList) -- 积天豪礼
    

    self:addHandler(ProtocolID.GResFestivalLoginInfo, Promotion051_pb.GResFestivalLoginInfo, require("src.net.PromotionResponse").festivalLoginInfo) -- 积天豪礼
    self:addHandler(ProtocolID.GResFestivalLoginReward, Promotion051_pb.GResFestivalLoginReward, require("src.net.PromotionResponse").festivalLoginReward) -- 积天豪礼
    self:addHandler(ProtocolID.GResFestivalLoginUpdate, Promotion051_pb.GResFestivalLoginUpdate, require("src.net.PromotionResponse").festivalLoginUpdat) -- 积天豪礼


    self:addHandler(ProtocolID.GResRechargeDaysGain, Task1_pb.GResRechargeDaysGain, require("src.net.PromotionResponse").rechargeDaysAward) 
    
    self:addHandler(ProtocolID.GResRechargeWeekList, Promotion048_pb.GResRechargeWeekList, require("src.net.PromotionResponse").rechargeWeekList) -- 周充值累计
    --self.map_response[1213016] = require("src.net.PromotionResponse").rechargeWeekAward

    self:addHandler(ProtocolID.GResMonthCardList, Task1_pb.GResMonthCardList, require("src.net.PromotionResponse").monthCardList) -- 月卡
    self:addHandler(ProtocolID.GResMonthVipReward, Task1_pb.GResMonthVipReward, require("src.net.PromotionResponse").monthCardGain)
    self:addHandler(ProtocolID.GResMonthCardReward, Task1_pb.GResMonthCardReward, require("src.net.PromotionResponse").getMonthCardReward)  --领取

    self:addHandler(ProtocolID.GResLevelUpGiftList, Promotion019_pb.GResLevelUpGiftList, require("src.net.PromotionResponse").levelUpList)   --登记升级礼包
    
    self:addHandler(ProtocolID.GResLevelUpGift, Promotion019_pb.GResLevelUpGift, require("src.net.PromotionResponse").obtainLevelUpGift)
    
    
    self:addHandler(ProtocolID.GResExchangeList, Promotion016_pb.GResExchangeList, require("src.net.PromotionResponse").timeExchangeGiftList) 
    self:addHandler(ProtocolID.GResExchangeBuy, Promotion016_pb.GResExchangeBuy, require("src.net.PromotionResponse").getTimeExchangeGift) 

    self:addHandler(ProtocolID.GResLimitedtimeRechargeReward, Promotion017_pb.GResLimitedtimeRechargeReward, require("src.net.PromotionResponse").timeLImitGiftList)
    
    
    self:addHandler(ProtocolID.GResMidAutumnInfo, Task2_pb.GResMidAutumnInfo, require("src.net.PromotionResponse").midAutumnInfo) 
    self:addHandler(ProtocolID.GResSummonCrystalInfo, Promotion043_pb.GResSummonCrystalInfo, require("src.net.PromotionResponse").summonCrystalInfo) 

    self:addHandler(ProtocolID.GResAdventureCountData, Promotion027_pb.GResAdventureCountData,require("src.net.PromotionResponse").AdventureList)
    self:addHandlerAuto(ProtocolID.GResScanAdventureRank, Promotion027_pb.GResScanAdventureRank,require("src.net.PromotionResponse").AdventureRankList)
    self:addHandler(ProtocolID.GResGetAdventureReward, Promotion027_pb.GResGetAdventureReward,require("src.net.PromotionResponse").AdventureGift)

    self:addHandler(ProtocolID.GResSpeedFightCountData, Promotion026_pb.GResSpeedFightCountData,require("src.net.PromotionResponse").SpeedFightList)
    self:addHandlerAuto(ProtocolID.GResScanSpeedFightRank, Promotion026_pb.GResScanSpeedFightRank,require("src.net.PromotionResponse").SpeedFightRankList)
    self:addHandler(ProtocolID.GResGetSpeedFightReward, Promotion026_pb.GResGetSpeedFightReward,require("src.net.PromotionResponse").SpeedFightGift)
    
    self:addHandler(ProtocolID.GResTavernCountData, Promotion028_pb.GResTavernCountData,require("src.net.PromotionResponse").TavernWeeklyList)
    self:addHandlerAuto(ProtocolID.GResScanTavernRank, Promotion028_pb.GResScanTavernRank,require("src.net.PromotionResponse").TavernWeeklyRankList)
    self:addHandler(ProtocolID.GResGetTavernReward, Promotion028_pb.GResGetTavernReward,require("src.net.PromotionResponse").TavernWeeklyGift)

    -- 许愿池达标
    self:addHandler(ProtocolID.GResBlessingPoolLists, Promotion037_pb.GResBlessingPoolLists,require("src.net.PromotionResponse").getBlessingPoolList)
    self:addHandler(ProtocolID.GResBlessingPoolGift, Promotion037_pb.GResBlessingPoolGift,require("src.net.PromotionResponse").getBlessingPoolGift)
    
    self:addHandler(ProtocolID.GResMarkHeroList, Promotion033_pb.GResMarkHeroList,require("src.net.PromotionResponse").getMarkHeroList)
    self:addHandler(ProtocolID.GResMarkHeroGift, Promotion033_pb.GResMarkHeroGift,require("src.net.PromotionResponse").getMarkHeroGift)


    self:addHandler(ProtocolID.GResPromotionSacrificeShop, Promotion042_pb.GResPromotionSacrificeShop,require("src.net.PromotionResponse").getAlterHeroList)

    -- 通用活动
    self:addHandler(ProtocolID.GResActivityInfo, Task4_pb.GResActivityInfo, require("src.net.PromotionResponse").CommonActivityInfo)
    self:addHandler(ProtocolID.GResActivityItemGet, Task4_pb.GResActivityItemGet, require("src.net.PromotionResponse").ActivityItemGet)
    -- 冒险日记
    self:addHandler(ProtocolID.GResAdventureNoteInfo, Task4_pb.GResAdventureNoteInfo, require("src.net.PromotionResponse").AdventureNoteInfo)
    self:addHandler(ProtocolID.GResAdventureNoteGet, Task4_pb.GResAdventureNoteGet, require("src.net.PromotionResponse").AdventureNoteGet)
    self:addHandler(ProtocolID.GResAdventureNoteRechargeGet, Task4_pb.GResAdventureNoteRechargeGet, require("src.net.PromotionResponse").AdventureNoteRechargeGet)
    self:addHandler(ProtocolID.GResAdventureNoteAdvGet, Task4_pb.GResAdventureNoteAdvGet, require("src.net.PromotionResponse").AdventureNoteAdvGet)
    self:addHandler(ProtocolID.GResAdventureNoteRechargeUpdate, Task4_pb.GResAdventureNoteRechargeUpdate, require("src.net.PromotionResponse").AdventureNoteRechargeUpdate)
    -- 神秘魔盒
    self:addHandler(ProtocolID.GResMysteryBoxInfo, Task4_pb.GResMysteryBoxInfo, require("src.net.PromotionResponse").MysteryBoxInfo)
    self:addHandler(ProtocolID.GResMysteryBoxGet, Task4_pb.GResMysteryBoxGet, require("src.net.PromotionResponse").MysteryBoxGet)
    self:addHandler(ProtocolID.GResMysteryBoxRechargeGet, Task4_pb.GResMysteryBoxRechargeGet, require("src.net.PromotionResponse").MysteryBoxRechargeGet)
    self:addHandler(ProtocolID.GResMysteryBoxExpGet, Task4_pb.GResMysteryBoxExpGet, require("src.net.PromotionResponse").MysteryBoxExpGet)
    self:addHandler(ProtocolID.GResMysteryBoxRechargeUpdate, Task4_pb.GResMysteryBoxRechargeUpdate, require("src.net.PromotionResponse").MysteryBoxRechargeUpdate)

    -- 占星阵任务
    self:addHandler(ProtocolID.GResAstrologyTaskInfo, Promotion038_pb.GResAstrologyTaskInfo,require("src.net.PromotionResponse").AstrologyTaskInfo)
    self:addHandler(ProtocolID.GResAstrologyTaskSubmit, Promotion038_pb.GResAstrologyTaskSubmit,require("src.net.PromotionResponse").AstrologyTaskSubmit)

    -- 超值礼包
    self:addHandler(ProtocolID.GResOverValueData, Promotion039_pb.GResOverValueData,require("src.net.PromotionResponse").OverValueData)

    -- BUYGEM活动
    self:addHandler(ProtocolID.GResMonthGiftData, Promotion023_pb.GResMonthGiftData, require("src.net.PromotionResponse").mouthWelfareList) -- 每月福利
    self:addHandler(ProtocolID.GResDailyWelfareList, Welfate_pb.GResDailyWelfareList, require("src.net.PromotionResponse").dailyWelfareList)  -- 每日福利
    
    self:addHandler(ProtocolID.GResScanBuyInfo, Promotion015_pb.GResScanBuyInfo, require("src.net.PromotionResponse").newServerLimitList)
    self:addHandler(ProtocolID.GResDailyTotalChargeData, Promotion022_pb.GResDailyTotalChargeData,require("src.net.PromotionResponse").dailyTotalChargeData)   --  每日累冲
    
    -- 每日首充
    self:addHandler(ProtocolID.GResDailyChargeData, Promotion021_pb.GResDailyChargeData,require("src.net.PromotionResponse").dailyChargeData)        -- 每日累冲
    self:addHandler(ProtocolID.GResDailyChargeReward, Promotion021_pb.GResDailyChargeReward,require("src.net.PromotionResponse").getDailyChargeData) 

    self:addHandler(ProtocolID.GResZhuShenData, Promotion034_pb.GResZhuShenData,require("src.net.PromotionResponse").setPromotionPveMonsterData)        -- 诸神之战
    self:addHandler(ProtocolID.GResUpdateLevelData, Promotion034_pb.GResUpdateLevelData,require("src.net.PromotionResponse").setUpdataPromotionPveMonsterData)        -- 诸神之战，数据更新
    self:addHandlerAuto(ProtocolID.GResZhuShenBattle, Promotion034_pb.GResZhuShenBattle,require("src.net.PromotionResponse").setPromotionPveMonsterBattleData)        -- 战斗
    self:addHandler(ProtocolID.GResBuyItem, Promotion034_pb.GResBuyItem,require("src.net.PromotionResponse").buyPromotionItem)        -- 战斗
    
    -- 七彩华章
    self:addHandler(ProtocolID.GResColourfulShopData, Promotion044_pb.GResColourfulShopData, require("src.net.PromotionResponse").ColourfulShopData)
    self:addHandler(ProtocolID.GResColourfulShopReward, Promotion044_pb.GResColourfulShopReward, require("src.net.PromotionResponse").ColourfulShopReward)
    -- 登录有礼
    self:addHandler(ProtocolID.GResLoginGiftData, Promotion045_pb.GResLoginGiftData, require("src.net.PromotionResponse").LoginGiftData)
    self:addHandler(ProtocolID.GResLoginGiftReward, Promotion045_pb.GResLoginGiftReward, require("src.net.PromotionResponse").LoginGiftReward)
    -- 碎片进化
    self:addHandler(ProtocolID.GResExchangeShopData, Promotion046_pb.GResExchangeShopData, require("src.net.PromotionResponse").ExchangeShopData)
    self:addHandler(ProtocolID.GResExchangeShopReward, Promotion046_pb.GResExchangeShopReward, require("src.net.PromotionResponse").ExchangeShopReward)

    -- 节日豪礼
    self:addHandlerAuto(ProtocolID.GResFestivalOvervalueGift, Promotion050_pb.GResFestivalOvervalueGift, require("src.net.PromotionResponse").festivalOvervalueGift)
    self:addHandlerAuto(ProtocolID.GResFestivalGiftReceive, Promotion050_pb.GResFestivalGiftReceive, require("src.net.PromotionResponse").festivalGiftReceive)
    self:addHandlerAuto(ProtocolID.GResFestivalReceiveDay, Promotion050_pb.GResFestivalReceiveDay, require("src.net.PromotionResponse").festivalReceiveDay)

    self:addHandler(ProtocolID.GResDailyGiftData, Promotion020_pb.GResDailyGiftData, require("src.net.PromotionResponse").dayLimitLog)

    -- 酒馆达标
    self:addHandler(ProtocolID.GResPubArriveInfo, Promotion032_pb.GResPubArriveInfo,require("src.net.PromotionResponse").pubArriveInfo)
    self:addHandler(ProtocolID.GResPubArriveGot, Promotion032_pb.GResPubArriveGot,require("src.net.PromotionResponse").pubArriveGot)

    --点金活动
    self:addHandler(ProtocolID.GResBuyGoldCountData, Promotion025_pb.GResBuyGoldCountData,require("src.net.PromotionResponse").buyGoldList)  
    self:addHandlerAuto(ProtocolID.GResScanBuyGoldRank, Promotion025_pb.GResScanBuyGoldRank,require("src.net.PromotionResponse").buyGoldRankList)  
    self:addHandler(ProtocolID.GResBuyGoldGift, Promotion025_pb.GResBuyGoldGift,require("src.net.PromotionResponse").getBuyGoldGift)    

    self:addHandler(ProtocolID.GResProphecyList, Promotion041_pb.GResProphecyList,require("src.net.PromotionResponse").getProphecyList)    

    self:addHandler(ProtocolID.GResProphecyTimesGift, Promotion041_pb.GResProphecyTimesGift,require("src.net.PromotionResponse").getProphecyGift)    
    self:addHandler(ProtocolID.GResPvpwinList, Promotion031_pb.GResPvpwinList,require("src.net.PromotionResponse").getPvpwinsList)    
    self:addHandler(ProtocolID.GResPvpwinTimesGift, Promotion031_pb.GResPvpwinTimesGift,require("src.net.PromotionResponse").getPvpwinsGift)    
    

    self:addHandler(ProtocolID.GResSummonList, Promotion040_pb.GResSummonList,require("src.net.PromotionResponse").getSummonTimesList)    
    self:addHandler(ProtocolID.GResSummonTimesGift, Promotion040_pb.GResSummonTimesGift,require("src.net.PromotionResponse").getSummonTimesGift)    

    self:addHandler(ProtocolID.GResInvitationList, InviteGift_pb.GResInvitationList,require("src.net.PromotionResponse").getInvitationList)    
    self:addHandler(ProtocolID.GResInviteReward, InviteGift_pb.GResInviteReward,require("src.net.PromotionResponse").getInvitationGift)
    self:addHandler(ProtocolID.GResInviteUseCode, InviteGift_pb.GResInviteUseCode,require("src.net.PromotionResponse").useInvitationCode)

    -- 限时英雄升级礼包
    self:addHandlerAuto(ProtocolID.GResLimitGiftList, Task1_pb.GResLimitGiftList,require("src.net.PromotionResponse").limitGiftList)
    self:addHandler(ProtocolID.GResLimitGiftAdd, Task2_pb.GResLimitGiftAdd,require("src.net.PromotionResponse").gainNewLimitGift)
    
    -- 月度回馈计划
    self:addHandler(ProtocolID.GResInvestList, Promotion006_pb.GResInvestList,require("src.net.PromotionResponse").monthInvestList)
    self:addHandler(ProtocolID.GResInvestGain, Promotion006_pb.GResInvestGain,require("src.net.PromotionResponse").monthInvestGain)

    -- 成长礼包
    self:addHandler(ProtocolID.GResVipDecorateReward, Promotion_pb.GResVipDecorateReward, require("src.net.PromotionResponse").growUpList)
    self:addHandler(ProtocolID.GResVipDecorateBuy, Promotion_pb.GResVipDecorateBuy, require("src.net.PromotionResponse").privilegeReward)
    self:addHandler(ProtocolID.GResGrowthGiftCharge, Promotion_pb.GResGrowthGiftCharge, require("src.net.PromotionResponse").updateRecharge)
    
    -- 限时购买
    self:addHandlerAuto(ProtocolID.GResFlashSaleData, Promotion054_pb.GResFlashSaleData, require("src.net.PromotionResponse").handleFlashSaleData)

    -- 皮肤购买
    self:addHandler(ProtocolID.GResFashionBuyData, Promotion056_pb.GResFashionBuyData,require("src.net.PromotionResponse").getBuySkinRewardList)


    self:addHandler(ProtocolID.GResEveryDayLoginPromotion, Promotion057_pb.GResEveryDayLoginPromotion,require("src.net.PromotionResponse").getEveryDayLoginPromotion)
    self:addHandler(ProtocolID.GResEveryDayLoginReward, Promotion057_pb.GResEveryDayLoginReward,require("src.net.PromotionResponse").getEveryDayLoginReward)
    self:addHandler(ProtocolID.GResUpdateEveryDayLoginTarget, Promotion057_pb.GResUpdateEveryDayLoginTarget,require("src.net.PromotionResponse").getUpdateEveryDayLoginTarget)
        

    -- 酒馆任务
    self:addHandlerAuto(ProtocolID.GResPubTaskList, PubTask_pb.GResPubTaskList, require("src.net.PubTaskResponse").pubTaskList)
    self:addHandler(ProtocolID.GResPubTaskRefresh, PubTask_pb.GResPubTaskRefresh, require("src.net.PubTaskResponse").pubtaskRereshOne)
    self:addHandler(ProtocolID.GResPubTaskStart, PubTask_pb.GResPubTaskStart, require("src.net.PubTaskResponse").pubTaskStart)
    self:addHandler(ProtocolID.GResPubTaskAward, PubTask_pb.GResPubTaskAward, require("src.net.PubTaskResponse").pubTaskAward)
    self:addHandlerAuto(ProtocolID.GResLockUpPubTask, PubTask_pb.GResLockUpPubTask, require("src.net.PubTaskResponse").updataLockStatus)

    self:addHandler(ProtocolID.GResPubAdventureCount, PubTask_pb.GResPubAdventureCount, require("src.net.PubTaskResponse").pubAdventureCount)
    self:addHandler(ProtocolID.GResOneKeyGetReward, PubTask_pb.GResOneKeyGetReward, require("src.net.PubTaskResponse").oneKeyGetReward)
    

    -- 皮肤
    self:addHandlerAuto(ProtocolID.GResHeroFashion, HeroFashion_pb.GResHeroFashion, require("src.net.HeroFashionResponse").handleHeroFashion)
    self:addHandler(ProtocolID.GResHeroFashionList, HeroFashion_pb.GResHeroFashionList, require("src.net.HeroFashionResponse").heroFashionList)
    self:addHandler(ProtocolID.GResActiveHeroFashion, HeroFashion_pb.GResActiveHeroFashion, require("src.net.HeroFashionResponse").activeHeroFashion)
    self:addHandlerAuto(ProtocolID.GResHeroFashionChange, HeroFashion_pb.GResHeroFashionChange, require("src.net.HeroFashionResponse").handleHeroFashionChange)
    self:addHandlerAuto(ProtocolID.GResHeroFashionUp, HeroFashion_pb.GResHeroFashionUp, require("src.net.HeroFashionResponse").handleHeroFashionUp)
    
    
    -- 许愿池
    self:addHandlerAuto(ProtocolID.GResBlessingPoolList, BlessingPool_pb.GResBlessingPoolList, require("src.net.BlessingPoolResponse").blessingPoolList)
    self:addHandlerAuto(ProtocolID.GResBlessingPoolRefresh, BlessingPool_pb.GResBlessingPoolRefresh, require("src.net.BlessingPoolResponse").lockItemList)
    self:addHandlerAuto(ProtocolID.GResBlessingPoolDone, BlessingPool_pb.GResBlessingPoolDone, require("src.net.BlessingPoolResponse").awardList)
    -- self.map_response[ProtocolID.GResBlessingPoolShop] = require("src.net.BlessingPoolResponse").shopList
    self:addHandlerAuto(ProtocolID.GResBlessingPoolLuckyReward, BlessingPool_pb.GResBlessingPoolLuckyReward, require("src.net.BlessingPoolResponse").HandleBlessingPoolLuckyReward)

    -- 先知之树
    self:addHandler(ProtocolID.GResProphetSummon, ProphetSummon_pb.GResProphetSummon, require("src.net.ProphetResponse").prophetSummon)
    self:addHandlerAuto(ProtocolID.GResProphetSummonInfo, ProphetSummon_pb.GResProphetSummonInfo, require("src.net.ProphetResponse").prophetSummonLuck)
    self:addHandler(ProtocolID.GResProphetChange, ProphetSummon_pb.GResProphetChange, require("src.net.ProphetResponse").changeHero)

    -- 献祭
    self:addHandler(ProtocolID.GResAltarHero, Task1_pb.GResAltarHero, require("src.net.AltarResponse").altarList)
    
    
    -- 商店2
    self:addHandler(ProtocolID.GResShopBuyHeroCapacity, Buy_pb.GResShopBuyHeroCapacity, require("src.net.HeroResponse").shopHeroCapacity)

    -- 邮件
    self:addHandlerAuto(ProtocolID.GResMailList, Mail_pb.GResMailList, require("src.net.MailResponse").mailList)
    self:addHandlerAuto(ProtocolID.GResNewMail, Mail_pb.GResNewMail, require("src.net.MailResponse").newMail)
    self:addHandlerAuto(ProtocolID.GResDealWithMail, Mail_pb.GResDealWithMail, require("src.net.MailResponse").mailDeal)
    self:addHandlerAuto(ProtocolID.GResReceiveAllMail, Mail_pb.GResReceiveAllMail, require("src.net.MailResponse").receiveAllMail)
    self:addHandlerAuto(ProtocolID.GResDeleteAllMail, Mail_pb.GResDeleteAllMail, require("src.net.MailResponse").deleteAllMail)
    
    -- 试炼
    self:addHandlerAuto(ProtocolID.GResTrialCfg, Adven_pb.GResTrialCfg, require("src.net.TrialResponse").getTrialCfg)
    self:addHandlerAuto(ProtocolID.GResTrialPass, Adven_pb.GResTrialPass, require("src.net.TrialResponse").trialPass)
    self:addHandler(ProtocolID.GResTrialBox, Adven_pb.GResTrialBox, require("src.net.TrialResponse").trialBox)
    -- self.map_response[ProtocolID.GResAdventureShopList] = require("src.net.TrialResponse").shopList
    self:addHandler(ProtocolID.GResTrialBattleList, Adven_pb.GResTrialBattleList, require("src.net.TrialResponse").battleList)
    self:addHandler(ProtocolID.GResTrialBattleHeroList, Adven_pb.GResTrialBattleHeroList, require("src.net.TrialResponse").battleHeroList)
    self:addHandler(ProtocolID.GResRedState, Adven_pb.GResRedState, require("src.net.TrialResponse").redState)
    self:addHandlerAuto(ProtocolID.GResAdvenAssistHeroList, Adven_pb.GResAdvenAssistHeroList, require("src.net.TrialResponse").friendAssistHeroList)
    self:addHandlerAuto(ProtocolID.GResAdvenSelect, Adven_pb.GResAdvenSelect, require("src.net.TrialResponse").selectFriend)
    self:addHandlerAuto(ProtocolID.GResAdvenAssist, Adven_pb.GResAdvenAssist, require("src.net.TrialResponse").dispatchHero)
    self:addHandlerAuto(ProtocolID.GResAdvenSelectLv, Adven_pb.GResAdvenSelectLv, require("src.net.TrialResponse").selectHard)


    -- PVP接口
    self:addHandlerAuto(ProtocolID.GResPvpData, Pvp_pb.GResPvpData, require("src.net.PvpResponse").pvpData)
    self:addHandlerAuto(ProtocolID.GResPvpPlayerRefresh, Pvp_pb.GResPvpPlayerRefresh, require("src.net.PvpResponse").pvpPlayerRefresh)

    self:addHandlerAuto(ProtocolID.GResPvpBattle, Pvp_pb.GResPvpBattle, require("src.net.PvpResponse").pvpBattle)
    -- self:addHandler(ProtocolID.GResPvpBattleEnd, Pvp_pb.GResPvpBattleEnd, require("src.net.PvpResponse").pvpBattleEnd)
    -- self:addHandler(ProtocolID.GResPvpBattleHistory, Pvp_pb.GResPvpBattleHistory, require("src.net.PvpResponse").pvpBattleHistory)
    self:addHandler(ProtocolID.GResPvpBattleHistoryList, Pvp_pb.GResPvpBattleHistoryList, require("src.net.PvpResponse").pvpBattleHistoryList)
    self:addHandlerAuto(ProtocolID.GResPvpLike, Pvp_pb.GResPvpLike, require("src.net.PvpResponse").pvpLike)
    self:addHandlerAuto(ProtocolID.GResPvpSeasonReward, Pvp_pb.GResPvpSeasonReward, require("src.net.PvpResponse").pvpSeasonReward)

    -- 日常副本
    self:addHandlerAuto(ProtocolID.GResDailyDungeonList, DailyDungeon_pb.GResDailyDungeonList, require("src.net.DailyDungeonResponse").dailyDungeonList)
    self:addHandlerAuto(ProtocolID.GResDailyDungeonEnd, DailyDungeon_pb.GResDailyDungeonEnd, require("src.net.DailyDungeonResponse").dailyDungeonEnd)
    self:addHandlerAuto(ProtocolID.GResDailyDungeonSweep, DailyDungeon_pb.GResDailyDungeonSweep, require("src.net.DailyDungeonResponse").dailyDungeonSweep)

    -- 七日目标
    -- self:addHandler(ProtocolID.GResSevenDayTargetData, SevenDayTarget_pb.GResSevenDayTargetData, require("src.net.SevenDayTargetResponse").sevenDayTargetInitData)
    -- self:addHandler(ProtocolID.GResUpdateSevenDayTargetData, SevenDayTarget_pb.GResUpdateSevenDayTargetData, require("src.net.SevenDayTargetResponse").upSevenDayByType) 
    -- self:addHandler(ProtocolID.GResSevenDayTargetReward, SevenDayTarget_pb.GResSevenDayTargetReward, require("src.net.SevenDayTargetResponse").sevenDayTargetRewardResult)
    -- self:addHandler(ProtocolID.GResSevenDayTargetBoxReward, SevenDayTarget_pb.GResSevenDayTargetBoxReward, require("src.net.SevenDayTargetResponse").sevenDayTargetBoxRewardResult)
    -- self:addHandler(ProtocolID.GResSevenDayTargetUpdataDay, SevenDayTarget_pb.GResSevenDayTargetUpdataDay, require("src.net.SevenDayTargetResponse").sevenDayTargetUpdateDay) 

    -- 新七日目标
    self:addHandler(ProtocolID.GResSevenDayTargetList, SevenDayTarget_pb.GResSevenDayTargetList, require("src.net.SevenDayTargetResponse").setGResSevenDayTargetList)
    self:addHandler(ProtocolID.GResSevenDayTargetGetReward, SevenDayTarget_pb.GResSevenDayTargetGetReward, require("src.net.SevenDayTargetResponse").setGResSevenDayTargetGetReward)
    self:addHandler(ProtocolID.GResSevenDayTargetBoxGetReward, SevenDayTarget_pb.GResSevenDayTargetBoxGetReward, require("src.net.SevenDayTargetResponse").setGResSevenDayTargetBoxGetReward)
    self:addHandler(ProtocolID.GResUpdateSevenDayTarget, SevenDayTarget_pb.GResUpdateSevenDayTarget, require("src.net.SevenDayTargetResponse").setGResUpdateSevenDayTarget)

    -- 七天登录
    self:addHandler(ProtocolID.GResSevenDayLoginData, SevenDayLogin_pb.GResSevenDayLoginData, require("src.net.SevenDayTargetResponse").sevenDayInitData)
    self:addHandler(ProtocolID.GResSevenDayLoginReward, SevenDayLogin_pb.GResSevenDayLoginReward, require("src.net.SevenDayTargetResponse").sevenDayRewardResult)
    self:addHandler(ProtocolID.GResSevenDayLoginUpdateDay, SevenDayLogin_pb.GResSevenDayLoginUpdateDay, require("src.net.SevenDayTargetResponse").sevenDayLoginUpdataDay)

    -- 英雄降临
    self:addHandler(ProtocolID.GResHeroArriveData, HeroArrive_pb.GResHeroArriveData, require("src.net.HeroArriveResponse").heroArriveInitData)
    self:addHandler(ProtocolID.GResHeroArriveReward, HeroArrive_pb.GResHeroArriveReward, require("src.net.HeroArriveResponse").heroArriveRewardResult)
    self:addHandler(ProtocolID.GResHeroArriveUpdate, HeroArrive_pb.GResHeroArriveUpdate, require("src.net.HeroArriveResponse").heroArriveUpdate)
    self:addHandler(ProtocolID.GResHeroArriveStatusUpdate, HeroArrive_pb.GResHeroArriveStatusUpdate, require("src.net.HeroArriveResponse").rewardStatus)

    -- 英雄避难所
    self:addHandlerAuto(ProtocolID.GResDungeonInfo, Dungeon_pb.GResDungeonInfo, require("src.net.DungeonResponse").dungeonInfo)
    self:addHandlerAuto(ProtocolID.GResDungeonShopList, Dungeon_pb.GResDungeonShopList, require("src.net.DungeonResponse").dungeonShopList)
    self:addHandlerAuto(ProtocolID.GResDungeonTeam, Dungeon_pb.GResDungeonTeam, require("src.net.DungeonResponse").dungeonTeam)
    self:addHandlerAuto(ProtocolID.GResDungeonInitTeam, Dungeon_pb.GResDungeonInitTeam, require("src.net.DungeonResponse").dungeonInitTeam)
    self:addHandlerAuto(ProtocolID.GResDungeonKillRewardList, Dungeon_pb.GResDungeonKillRewardList, require("src.net.DungeonResponse").dungeonKillRewardList)
    self:addHandlerAuto(ProtocolID.GResDungeonKillReward, Dungeon_pb.GResDungeonKillReward, require("src.net.DungeonResponse").dungeonKillReward)
    self:addHandlerAuto(ProtocolID.GResDungeonPropsList, Dungeon_pb.GResDungeonPropsList, require("src.net.DungeonResponse").dungeonPropsList)
    self:addHandlerAuto(ProtocolID.GResDungeonBuffList, Dungeon_pb.GResDungeonBuffList, require("src.net.DungeonResponse").dungeonBuffList)
    self:addHandlerAuto(ProtocolID.GResDungeonMonsterHpList, Dungeon_pb.GResDungeonMonsterHpList, require("src.net.DungeonResponse").dungeonMonsterHpList)
    self:addHandlerAuto(ProtocolID.GResDungeonNextStage, Dungeon_pb.GResDungeonNextStage, require("src.net.DungeonResponse").dungeonNextStage)
    self:addHandlerAuto(ProtocolID.GResDungeonUseProps, Dungeon_pb.GResDungeonUseProps, require("src.net.DungeonResponse").dungeonUseProps)
    self:addHandlerAuto(ProtocolID.GResDungeonGetRes, Dungeon_pb.GResDungeonGetRes, require("src.net.DungeonResponse").dungeonGetRes)
    self:addHandlerAuto(ProtocolID.GResDungeonOpenBox, Dungeon_pb.GResDungeonOpenBox, require("src.net.DungeonResponse").dungeonOpenBox)
    self:addHandlerAuto(ProtocolID.GResDungeonShopBuy, Dungeon_pb.GResDungeonShopBuy, require("src.net.DungeonResponse").dungeonShopBuy)
    self:addHandlerAuto(ProtocolID.GResDungeonShopAdd, Dungeon_pb.GResDungeonShopAdd, require("src.net.DungeonResponse").dungeonShopAdd)
    self:addHandlerAuto(ProtocolID.GResDungeonBattleEnd, Dungeon_pb.GResDungeonBattleEnd, require("src.net.DungeonResponse").dungeonBattleEnd)
    self:addHandlerAuto(ProtocolID.GResRemoveShelterInfo, Dungeon_pb.GResRemoveShelterInfo, require("src.net.DungeonResponse").dungeonUpdate)
    self:addHandlerAuto(ProtocolID.GResDungeonGridLight, Dungeon_pb.GResDungeonGridLight, require("src.net.DungeonResponse").dungeonGridLight)

    --快速战斗
    self:addHandlerAuto(ProtocolID.GResQuickBattleInitData, Battle_pb.GResQuickBattleInitData, require("src.net.BattleResponse").quickBattleInitData)
    self:addHandlerAuto(ProtocolID.GResQuickBattleReward, Battle_pb.GResQuickBattleReward, require("src.net.BattleResponse").quickBattleReward)

    
    -- 在线奖励
    self:addHandlerAuto(ProtocolID.GResInitOnlineRewardData, OnlineReward_pb.GResInitOnlineRewardData, require("src.net.OnlineRewardResponse").onlineRewardInit)
    self:addHandler(ProtocolID.GResInitOnlineReward, OnlineReward_pb.GResInitOnlineReward, require("src.net.OnlineRewardResponse").onlineRewardResult)
    self:addHandlerAuto(ProtocolID.GResOnceAgainOnlineReward, OnlineReward_pb.GResOnceAgainOnlineReward, require("src.net.OnlineRewardResponse").onlineRewardAgain)
    -- self:addHandler(ProtocolID.GResInitOnlineReward, OnlineReward_pb.GResInitOnlineReward, require("src.net.OnlineRewardResponse").onlineRewardStatus) --缺失


    -- 羁绊
    self:addHandlerAuto(ProtocolID.GResFetterList, Fetter_pb.GResFetterList, require("src.net.FetterResponse").fetterList)    -- 羁绊列表数据
    self:addHandler(ProtocolID.GResFetterUpSkill, Fetter_pb.GResFetterUpSkill, require("src.net.FetterResponse").fetterUpskill) 
    self:addHandler(ProtocolID.GResFetterUpLevel, Fetter_pb.GResFetterUpLevel, require("src.net.FetterResponse").fetterUplevel) 
    self:addHandler(ProtocolID.GResFetterUpRefine, Fetter_pb.GResFetterUpRefine, require("src.net.FetterResponse").fetterRefine) 
    self:addHandler(ProtocolID.GResFetterWash, Fetter_pb.GResFetterWash, require("src.net.FetterResponse").fetterBaptism) 
    self:addHandlerAuto(ProtocolID.GResFetterUplimit, Fetter_pb.GResFetterUplimit, require("src.net.FetterResponse").fetterUplimit) 
    self:addHandler(ProtocolID.GResFetterReset, Fetter_pb.GResFetterReset, require("src.net.FetterResponse").fetterReset)
    self:addHandlerAuto(ProtocolID.GResFetterMakeSoul, Fetter_pb.GResFetterMakeSoul, require("src.net.FetterResponse").fetterMakeSoul)

    self:addHandler(ProtocolID.GResFetterInitTask, Fetter_pb.GResFetterInitTask, require("src.net.FetterResponse").fetterInitTask) -- 初始化任务
    self:addHandler(ProtocolID.GResFetterUpProgress, Fetter_pb.GResFetterUpProgress, require("src.net.FetterResponse").fetterUpProgress)
    self:addHandler(ProtocolID.GResFetterReward, Fetter_pb.GResFetterReward, require("src.net.FetterResponse").fetterRewardResult) -- 领取结果
    self:addHandler(ProtocolID.GResFetterInitVip, Fetter_pb.GResFetterInitVip, require("src.net.FetterResponse").fetterInitVIP)
    self:addHandler(ProtocolID.GResFetterUpdateVip, Fetter_pb.GResFetterUpdateVip, require("src.net.FetterResponse").fetterUpdateVIP) -- 更新VIP等级
    self:addHandler(ProtocolID.GResFetterData, Fetter_pb.GResFetterData, require("src.net.FetterResponse").activeFetter) -- 更新VIP等级

    self:addHandlerAuto(ProtocolID.GResFetterContractInfo, Fetter_pb.GResFetterContractInfo, require("src.net.FetterResponse").fetterContractInfo)    -- 
    self:addHandlerAuto(ProtocolID.GResFetterContractActive, Fetter_pb.GResFetterContractActive, require("src.net.FetterResponse").fetterContractActive)    -- 

    -- 羁绊幻化数据
    self:addHandlerAuto(ProtocolID.GResFashionData, Fetter_pb.GResFashionData, require("src.net.FetterResponse").fetterIllusionData)
    self:addHandlerAuto(ProtocolID.GResFashionTasks, Fetter_pb.GResFashionTasks, require("src.net.FetterResponse").fetterIllusionTaskData)
    self:addHandlerAuto(ProtocolID.GResFashionTaskGet, Fetter_pb.GResFashionTaskGet, require("src.net.FetterResponse").fetterIllusionUpdataTaskDataTemp)
    self:addHandlerAuto(ProtocolID.GResFashionUpdateTask, Fetter_pb.GResFashionUpdateTask, require("src.net.FetterResponse").fetterIllusionUpdataTaskData)
    self:addHandlerAuto(ProtocolID.GResFashionSmelt, Fetter_pb.GResFashionSmelt, require("src.net.FetterResponse").fetterIllusionUpdataItemNum)
    self:addHandlerAuto(ProtocolID.GResFashionActive, Fetter_pb.GResFashionActive, require("src.net.FetterResponse").fetterIllusionActivation)
    self:addHandlerAuto(ProtocolID.GResFashionUse, Fetter_pb.GResFashionUse, require("src.net.FetterResponse").fetterIllusionWear)
    -- 符文
    self:addHandlerAuto(ProtocolID.GResRunesList, Rune_pb.GResRunesList, require("src.net.RunesResponse").runesList)        -- 符文列表
    self:addHandlerAuto(ProtocolID.GResRunesDelList, Rune_pb.GResRunesDelList, require("src.net.RunesResponse").deleteRunes)-- 符文删除
    self:addHandlerAuto(ProtocolID.GResRune, Rune_pb.GResRune, require("src.net.RunesResponse").addRunes)                   -- 符文增改
    self:addHandlerAuto(ProtocolID.GResRuneOnOff, Rune_pb.GResRuneOnOff, require("src.net.RunesResponse").runesOnOff)       -- 符文穿戴
    self:addHandlerAuto(ProtocolID.GResRuneCombine, Rune_pb.GResRuneCombine, require("src.net.RunesResponse").runesCompose) -- 符文合成
    self:addHandlerAuto(ProtocolID.GResRuneDisCombine, Rune_pb.GResRuneDisCombine, require("src.net.RunesResponse").runesDiscompose)-- 符文分解
    self:addHandlerAuto(ProtocolID.GResRuneWash, Rune_pb.GResRuneWash, require("src.net.RunesResponse").recastRunes)        -- 符文重铸
    self:addHandlerAuto(ProtocolID.GResRuneWashSave, Rune_pb.GResRuneWashSave, require("src.net.RunesResponse").recastRunesSave)    -- 符文重铸保存


    -- 头像框
    self:addHandler(ProtocolID.GResBorderData, Border_pb.GResBorderData, require("src.net.BorderResponse").initBorderData)
    self:addHandler(ProtocolID.GResActiveBorder, Border_pb.GResActiveBorder, require("src.net.BorderResponse").activeBorder)
    self:addHandler(ProtocolID.GResUseBorder, Border_pb.GResUseBorder, require("src.net.BorderResponse").useBorder)

    -- 头像
    self:addHandler(ProtocolID.GResHeadPortraitList, HeadPortrait_pb.GResHeadPortraitList, require("src.net.BorderResponse").initHeadData)
    self:addHandler(ProtocolID.GResChangeHeadPortrait, HeadPortrait_pb.GResChangeHeadPortrait, require("src.net.BorderResponse").useHead)
    self:addHandler(ProtocolID.GResUnlockHeadPortrait, HeadPortrait_pb.GResUnlockHeadPortrait, require("src.net.BorderResponse").activeHead)

    -- 称号
    self:addHandler(ProtocolID.GResScanTitleList, Title_pb.GResScanTitleList, require("src.net.TitleResponse").scanTitleList)


    -- 冠军赛
    self:addHandlerAuto(ProtocolID.GResScanChampion, Champion_pb.GResScanChampion, require("src.net.ChampionResponse").scanChampion)                         -- 冠军赛活动数据
    self:addHandlerAuto(ProtocolID.GResScanChampionKnockout, Champion_pb.GResScanChampionKnockout, require("src.net.ChampionResponse").scanChampionKnockout) -- 冠军赛32强数据
    self:addHandlerAuto(ProtocolID.GResMyChampionBattle, Champion_pb.GResMyChampionBattle, require("src.net.ChampionResponse").myChampionBattle)             -- 冠军赛我的数据
    self:addHandlerAuto(ProtocolID.GResChampionLike, Champion_pb.GResChampionLike, require("src.net.ChampionResponse").championLike)                         -- 点赞
    self:addHandlerAuto(ProtocolID.GResChampionBiubiu, Champion_pb.GResChampionBiubiu, require("src.net.ChampionResponse").championBiubiu)                   -- 弹幕
    self:addHandlerAuto(ProtocolID.GResGuessChampionBattle, Champion_pb.GResGuessChampionBattle, require("src.net.ChampionResponse").guessChampionBattle)    -- 竞猜数据
    self:addHandlerAuto(ProtocolID.GResGuessOneBattle, Champion_pb.GResGuessOneBattle, require("src.net.ChampionResponse").guessOneBattle)                   -- 竞猜结果
    self:addHandlerAuto(ProtocolID.GResGetChampionBattle, Champion_pb.GResGetChampionBattle, require("src.net.ChampionResponse").getChampionBattle)          -- 获取战斗id
    self:addHandlerAuto(ProtocolID.GResChampionBiuList, Champion_pb.GResChampionBiuList, require("src.net.ChampionResponse").championBiuList)                -- 弹幕列表
    self:addHandlerAuto(ProtocolID.GResChampionGuessList, Champion_pb.GResChampionGuessList, require("src.net.ChampionResponse").championGuessList)          -- 竞猜列表
    self:addHandlerAuto(ProtocolID.GResScanMyChampionBattle, Champion_pb.GResScanMyChampionBattle, require("src.net.ChampionResponse").GResScanMyChampionBattle)-- 我的比赛记录
    self:addHandlerAuto(ProtocolID.GResChampionGuessWin, Champion_pb.GResChampionGuessWin, require("src.net.ChampionResponse").championGuessWin)             -- 投注获得奖励
    self:addHandlerAuto(ProtocolID.GResChampionStageChange, Champion_pb.GResChampionStageChange, require("src.net.ChampionResponse").championStageChange)    -- 阶段变化
    self:addHandlerAuto(ProtocolID.GResChampionRank, Champion_pb.GResChampionRank, require("src.net.ChampionResponse").championRank)                         -- 冠军赛排行榜
    self:addHandlerAuto(ProtocolID.GResChampionShowTop, Champion_pb.GResChampionShowTop, require("src.net.ChampionResponse").championShowTop)                -- 冠军赛排行榜
    self:addHandlerAuto(ProtocolID.GResChampionEnd, Champion_pb.GResChampionEnd, require("src.net.ChampionResponse").championEnd)                            -- 冠军赛排行榜
    self:addHandlerAuto(ProtocolID.GResChampionGuessBroadcast, Champion_pb.GResChampionGuessBroadcast, require("src.net.ChampionResponse").championGuessBroadcast)-- 投注广播
    self:addHandlerAuto(ProtocolID.GResChampionBiuChange, Champion_pb.GResChampionBiuChange, require("src.net.ChampionResponse").championBiuChange)-- 投注广播
    self:addHandlerAuto(ProtocolID.GResChampionSaveFormation, Champion_pb.GResChampionSaveFormation, require("src.net.ChampionResponse").championSaveFormation)-- 自己阵容改变
    self:addHandlerAuto(ProtocolID.GResChampionFormationChange, Champion_pb.GResChampionFormationChange, require("src.net.ChampionResponse").championFormationChange) -- 阵容改变
    self:addHandlerAuto(ProtocolID.GResChampionCleanBiu, Champion_pb.GResChampionCleanBiu, require("src.net.ChampionResponse").championCleanBiu) -- 清除弹幕

    -- 跨服冠军赛
    self:addHandlerAuto(ProtocolID.GResScanChampionCross, ChampionCross_pb.GResScanChampionCross, require("src.net.ChampionCrossResponse").scanChampionCross)                         -- 冠军赛活动数据
    self:addHandlerAuto(ProtocolID.GResScanChampionCrossKnockout, ChampionCross_pb.GResScanChampionCrossKnockout, require("src.net.ChampionCrossResponse").scanChampionCrossKnockout) -- 冠军赛32强数据
    self:addHandlerAuto(ProtocolID.GResMyChampionCrossBattle, ChampionCross_pb.GResMyChampionCrossBattle, require("src.net.ChampionCrossResponse").myChampionCrossBattle)             -- 冠军赛我的数据
    self:addHandlerAuto(ProtocolID.GResChampionCrossLike, ChampionCross_pb.GResChampionCrossLike, require("src.net.ChampionCrossResponse").championCrossLike)                         -- 点赞
    self:addHandlerAuto(ProtocolID.GResChampionCrossBiubiu, ChampionCross_pb.GResChampionCrossBiubiu, require("src.net.ChampionCrossResponse").championCrossBiubiu)                   -- 弹幕
    self:addHandlerAuto(ProtocolID.GResGuessChampionCrossBattle, ChampionCross_pb.GResGuessChampionCrossBattle, require("src.net.ChampionCrossResponse").guessChampionCrossBattle)    -- 竞猜数据
    self:addHandlerAuto(ProtocolID.GResGuessCrossOneBattle, ChampionCross_pb.GResGuessCrossOneBattle, require("src.net.ChampionCrossResponse").guessCrossOneBattle)                   -- 竞猜结果
    self:addHandlerAuto(ProtocolID.GResGetChampionCrossBattle, ChampionCross_pb.GResGetChampionCrossBattle, require("src.net.ChampionCrossResponse").getChampionCrossBattle)          -- 获取战斗id
    self:addHandlerAuto(ProtocolID.GResChampionCrossBiuList, ChampionCross_pb.GResChampionCrossBiuList, require("src.net.ChampionCrossResponse").championCrossBiuList)                -- 弹幕列表
    self:addHandlerAuto(ProtocolID.GResChampionCrossGuessList, ChampionCross_pb.GResChampionCrossGuessList, require("src.net.ChampionCrossResponse").championCrossGuessList)          -- 竞猜列表
    self:addHandlerAuto(ProtocolID.GResScanMyChampionCrossBattle, ChampionCross_pb.GResScanMyChampionCrossBattle, require("src.net.ChampionCrossResponse").GResScanMyChampionCrossBattle)-- 我的比赛记录
    self:addHandlerAuto(ProtocolID.GResChampionCrossGuessWin, ChampionCross_pb.GResChampionCrossGuessWin, require("src.net.ChampionCrossResponse").championCrossGuessWin)             -- 投注获得奖励
    self:addHandlerAuto(ProtocolID.GResChampionCrossStageChange, ChampionCross_pb.GResChampionCrossStageChange, require("src.net.ChampionCrossResponse").championCrossStageChange)    -- 阶段变化
    self:addHandlerAuto(ProtocolID.GResChampionCrossRank, ChampionCross_pb.GResChampionCrossRank, require("src.net.ChampionCrossResponse").championCrossRank)                         -- 冠军赛排行榜
    self:addHandlerAuto(ProtocolID.GResChampionCrossShowTop, ChampionCross_pb.GResChampionCrossShowTop, require("src.net.ChampionCrossResponse").championCrossShowTop)                -- 冠军赛排行榜
    self:addHandlerAuto(ProtocolID.GResChampionCrossEnd, ChampionCross_pb.GResChampionCrossEnd, require("src.net.ChampionCrossResponse").championCrossEnd)                            -- 冠军赛排行榜
    self:addHandlerAuto(ProtocolID.GResChampionCrossGuessBroadcast, ChampionCross_pb.GResChampionCrossGuessBroadcast, require("src.net.ChampionCrossResponse").championCrossGuessBroadcast)-- 投注广播
    self:addHandlerAuto(ProtocolID.GResChampionCrossBiuChange, ChampionCross_pb.GResChampionCrossBiuChange, require("src.net.ChampionCrossResponse").championCrossBiuChange)-- 投注广播
    self:addHandlerAuto(ProtocolID.GResChampionCrossSaveFormation, ChampionCross_pb.GResChampionCrossSaveFormation, require("src.net.ChampionCrossResponse").championCrossSaveFormation)-- 自己阵容改变
    self:addHandlerAuto(ProtocolID.GResChampionCrossFormationChange, ChampionCross_pb.GResChampionCrossFormationChange, require("src.net.ChampionCrossResponse").championCrossFormationChange) -- 阵容改变
    self:addHandlerAuto(ProtocolID.GResChampionCrossCleanBiu, Champion_pb.GResChampionCrossCleanBiu, require("src.net.ChampionCrossResponse").championCrossCleanBiu) -- 清除弹幕

    --录像馆
    self:addHandlerAuto(ProtocolID.GResVideos, Video_pb.GResVideos, require("src.net.VideoStudioResponse").setVideoList)                        --录像列表
    self:addHandlerAuto(ProtocolID.GResKeepFavorite, Video_pb.GResKeepFavorite, require("src.net.VideoStudioResponse").favoriteVideo)           --录像收藏
    self:addHandlerAuto(ProtocolID.GResDeleteFavorite, Video_pb.GResDeleteFavorite, require("src.net.VideoStudioResponse").favoriteCancel)      --录像收藏取消
    self:addHandlerAuto(ProtocolID.GResScanShare, Video_pb.GResScanShare, require("src.net.VideoStudioResponse").onBattle)                               --回放
    self:addHandlerAuto(ProtocolID.GResMyVideos, Video_pb.GResMyVideos, require("src.net.VideoStudioResponse").onMyVideos)                               --个人收藏协议
    self:addHandlerAuto(ProtocolID.GResStudy, Battle_pb.GResStudy, require("src.net.VideoStudioResponse").onCompare) 

    -- 超值养成礼
    self:addHandlerAuto(ProtocolID.GResDevelopGiftList, Promotion052_pb.GResDevelopGiftList, require("src.net.PromotionResponse").handleDevelopGiftList)
    self:addHandlerAuto(ProtocolID.GResBuyDevelopGift, Promotion052_pb.GResBuyDevelopGift, require("src.net.PromotionResponse").handleBuyDevelopGift)

    -- 跨服联赛玩法
    -- 天梯争霸
    self:addHandlerAuto(ProtocolID.GResLadderInfo, Ladder_pb.GResLadderInfo, require("src.net.LeagueResponse").handleLadderInfo)
    self:addHandlerAuto(ProtocolID.GResRefreshDefends, Ladder_pb.GResRefreshDefends, require("src.net.LeagueResponse").handleRefreshDefends)
    self:addHandlerAuto(ProtocolID.GResLadderChallenge, Ladder_pb.GResLadderChallenge, require("src.net.LeagueResponse").handleLadderChallenge)
    self:addHandlerAuto(ProtocolID.GResLadderOneKeyChallenge, Ladder_pb.GResLadderOneKeyChallenge, require("src.net.LeagueResponse").handleLadderOneKeyChallenge)
    self:addHandlerAuto(ProtocolID.GResMyLadderBattleRecord, Ladder_pb.GResMyLadderBattleRecord, require("src.net.LeagueResponse").handleMyLadderBattleRecord)
    self:addHandlerAuto(ProtocolID.GResLadderReadReport, Ladder_pb.GResLadderReadReport, require("src.net.LeagueResponse").handleMyLadderBattleRecordRead)
    self:addHandlerAuto(ProtocolID.GResHighLadderBattleRecord, Ladder_pb.GResHighLadderBattleRecord, require("src.net.LeagueResponse").handleHighLadderBattleRecord)
    self:addHandlerAuto(ProtocolID.GResLadderRank, Ladder_pb.GResLadderRank, require("src.net.LeagueResponse").rankLadderList)
    self:addHandlerAuto(ProtocolID.GResBuyTimes, Ladder_pb.GResBuyTimes, require("src.net.LeagueResponse").handleBuyTimes)
    self:addHandlerAuto(ProtocolID.GResLadderLineUpData, Ladder_pb.GResLadderLineUpData, require("src.net.LeagueResponse").handleLadderLineUpData)
    self:addHandlerAuto(ProtocolID.GResLikeList, Ladder_pb.GResLikeList, require("src.net.LeagueResponse").likeList)
    self:addHandlerAuto(ProtocolID.GResBeLikeSuperior, Ladder_pb.GResBeLikeSuperior, require("src.net.LeagueResponse").beLikeSuperior)
    -- 红点
    self:addHandlerAuto(ProtocolID.GResMyBattleRed, Ladder_pb.GResMyBattleRed, require("src.net.LeagueResponse").handleRedDotList)


    self:addHandlerAuto(ProtocolID.GResTrafficPermitList, Promotion053_pb.GResTrafficPermitList, require("src.net.NewYearResponse").initList)
    self:addHandlerAuto(ProtocolID.GResBuyTrafficPermitLevel, Promotion053_pb.GResBuyTrafficPermitLevel, require("src.net.NewYearResponse").buyLevel)
    self:addHandlerAuto(ProtocolID.GResTrafficPermitLevelReward, Promotion053_pb.GResTrafficPermitLevelReward, require("src.net.NewYearResponse").getLevelReward)
    self:addHandlerAuto(ProtocolID.GResTrafficPermitAllReward, Promotion053_pb.GResTrafficPermitAllReward, require("src.net.NewYearResponse").oneKeyLevelReward)
    self:addHandlerAuto(ProtocolID.GResTrafficPermitTaskReward, Promotion053_pb.GResTrafficPermitTaskReward, require("src.net.NewYearResponse").getTaskReward)
    self:addHandlerAuto(ProtocolID.GResDayTaskProgress, Promotion053_pb.GResDayTaskProgress, require("src.net.NewYearResponse").updateTaskProgress)
    self:addHandlerAuto(ProtocolID.GResTrafficPermitPrivilege, Promotion053_pb.GResTrafficPermitPrivilege, require("src.net.NewYearResponse").buySpecial)
    -- self:addHandlerAuto(ProtocolID.GResLikeList, Ladder_pb.GResLikeList, require("src.net.NewYearResponse").likeList)

    -- 彩虹圣殿
    self:addHandlerAuto(ProtocolID.GResRainbowInfo, Rainbow_pb.GResRainbowInfo, require("src.net.RainbowResponse").handleRainbowInfo)
    self:addHandlerAuto(ProtocolID.GResRainbowChallenge, Rainbow_pb.GResRainbowChallenge, require("src.net.RainbowResponse").handleRainbowChallenge)
    self:addHandlerAuto(ProtocolID.GResRainbowRecord, Rainbow_pb.GResRainbowRecord, require("src.net.RainbowResponse").handleRainbowRecord)

    -- 宝石合成
    self:addHandlerAuto(ProtocolID.GResJewelCombine, HeroJewel_pb.GResJewelCombine, require("src.net.BackpackResponse").handleJewelCombine)
    self:addHandlerAuto(ProtocolID.GResJewelAllCombine, HeroJewel_pb.GResJewelAllCombine, require("src.net.BackpackResponse").handleJewelAllCombine)

    -- 天赋
    self:addHandlerAuto(ProtocolID.GResHeroTalentLearn, HeroTalent_pb.GResHeroTalentLearn, require("src.net.TalentResponse").handleHeroTalentLearn)
    self:addHandlerAuto(ProtocolID.GResHeroTalentUpgrade, HeroTalent_pb.GResHeroTalentUpgrade, require("src.net.TalentResponse").handleHeroTalentUpgrade)
    self:addHandlerAuto(ProtocolID.GResHeroTalentForget, HeroTalent_pb.GResHeroTalentForget, require("src.net.TalentResponse").handleHeroTalentForget)

    -- 周末福利
    self:addHandlerAuto(ProtocolID.GResWeekendGiftData, WeekendGift_pb.GResWeekendGiftData, require("src.net.PromotionResponse").handleWeekendGiftData)
    self:addHandlerAuto(ProtocolID.GResGetReward, WeekendGift_pb.GResGetReward, require("src.net.PromotionResponse").handleGetReward)

    -- 神装
    self:addHandlerAuto(ProtocolID.GResScanGodEquipLottery, GodEquip_pb.GResScanGodEquipLottery, require("src.net.GodEquipResponse").lotteryInfo)
    self:addHandlerAuto(ProtocolID.GResScanGodEquipRecord, GodEquip_pb.GResScanGodEquipRecord, require("src.net.GodEquipResponse").lotteryHistory)
    self:addHandlerAuto(ProtocolID.GResLotteryGodEquip, GodEquip_pb.GResLotteryGodEquip, require("src.net.GodEquipResponse").lotteryReward)
    self:addHandlerAuto(ProtocolID.GResGodEquipPrivilege, GodEquip_pb.GResGodEquipPrivilege, require("src.net.GodEquipResponse").godEquipPrivilege)
    self:addHandlerAuto(ProtocolID.GResGetPrivilegeReward, GodEquip_pb.GResGetPrivilegeReward, require("src.net.GodEquipResponse").getPrivilegeReward)
    
    --------------组对竞技场 TeamArena_pb
    self:addHandlerAuto(ProtocolID.GResTeam, TeamArena_pb.GResTeam, require("src.net.TeamArenaResponse").handleTeam)
    self:addHandlerAuto(ProtocolID.GResTeamArenaState, TeamArena_pb.GResTeamArenaState, require("src.net.TeamArenaResponse").teamArenaState)
    self:addHandlerAuto(ProtocolID.GResTeamArenaRank, TeamArena_pb.GResTeamArenaRank, require("src.net.TeamArenaResponse").teamArenaRank)
    self:addHandlerAuto(ProtocolID.GResTeamSearch, TeamArena_pb.GResTeamSearch, require("src.net.TeamArenaResponse").handleTeamSearch)
    self:addHandlerAuto(ProtocolID.GResTeamRecommend, TeamArena_pb.GResTeamRecommend, require("src.net.TeamArenaResponse").handleTeamRecommend)
    self:addHandlerAuto(ProtocolID.GResTeamArenaRefreshDefend, TeamArena_pb.GResTeamArenaRefreshDefend, require("src.net.TeamArenaResponse").teamArenaRefreshDefend)
    self:addHandlerAuto(ProtocolID.GResTeamArenaBattle, TeamArena_pb.GResTeamArenaBattle, require("src.net.TeamArenaResponse").teamArenaBattle)
    self:addHandlerAuto(ProtocolID.GResTeamApply, TeamArena_pb.GResTeamApply, require("src.net.TeamArenaResponse").handleTeamApply)
    self:addHandlerAuto(ProtocolID.GResTeamCreate, TeamArena_pb.GResTeamCreate, require("src.net.TeamArenaResponse").handleTeamCreate)
    self:addHandlerAuto(ProtocolID.GResTeamReset, TeamArena_pb.GResTeamReset, require("src.net.TeamArenaResponse").handleTeamReset)
    self:addHandlerAuto(ProtocolID.GResTeamArenaChangeCaptain, TeamArena_pb.GResTeamArenaChangeCaptain, require("src.net.TeamArenaResponse").handleTeamArenaChangeCaptain)
    self:addHandlerAuto(ProtocolID.GResTeamKickOut, TeamArena_pb.GResTeamKickOut, require("src.net.TeamArenaResponse").handleTeamKickOut)
    self:addHandlerAuto(ProtocolID.GResTeamExit, TeamArena_pb.GResTeamExit, require("src.net.TeamArenaResponse").handleTeamExit)
    self:addHandlerAuto(ProtocolID.GResTeamArenaSign, TeamArena_pb.GResTeamArenaSign, require("src.net.TeamArenaResponse").handleTeamArenaSign)
    self:addHandlerAuto(ProtocolID.GResTeamArenaBattleReport, TeamArena_pb.GResTeamArenaBattleReport, require("src.net.TeamArenaResponse").teamArenaBattleReport)
    self:addHandlerAuto(ProtocolID.GResTeamArenaBattleRecord, TeamArena_pb.GResTeamArenaBattleRecord, require("src.net.TeamArenaResponse").teamArenaBattleRecord)
    self:addHandlerAuto(ProtocolID.GResTeamArenaBattleRecordDetail, TeamArena_pb.GResTeamArenaBattleRecordDetail, require("src.net.TeamArenaResponse").teamArenaBattleRecordDetail)
    self:addHandlerAuto(ProtocolID.GResTeamArenaData, TeamArena_pb.GResTeamArenaData, require("src.net.TeamArenaResponse").teamArenaData)
    self:addHandlerAuto(ProtocolID.GResTeamHandleApply, TeamArena_pb.GResTeamHandleApply, require("src.net.TeamArenaResponse").handleTeamHandleApple)
    self:addHandlerAuto(ProtocolID.GResTeamApplyList, TeamArena_pb.GResTeamApplyList, require("src.net.TeamArenaResponse").handleTeamApplyList)
    self:addHandlerAuto(ProtocolID.GResTeamArenaRecommendRole, TeamArena_pb.GResTeamArenaRecommendRole, require("src.net.TeamArenaResponse").handleTeamArenaRecommendRole)
    self:addHandlerAuto(ProtocolID.GResTeamArenaSearchRole, TeamArena_pb.GResTeamArenaSearchRole, require("src.net.TeamArenaResponse").handleTeamArenaSearchRole)
    self:addHandlerAuto(ProtocolID.GResTeamInvite, TeamArena_pb.GResTeamInvite, require("src.net.TeamArenaResponse").handleTeamInvite)
    self:addHandlerAuto(ProtocolID.GResTeamHandleInvite, TeamArena_pb.GResTeamHandleInvite, require("src.net.TeamArenaResponse").handleTeamHandleInvite)
    self:addHandlerAuto(ProtocolID.GResTeamInviteList, TeamArena_pb.GResTeamInviteList, require("src.net.TeamArenaResponse").handleTeamInviteList)
    self:addHandlerAuto(ProtocolID.GResTeamArenaBeKickOut, TeamArena_pb.GResTeamArenaBeKickOut, require("src.net.TeamArenaResponse").handleTeamArenaBeKickOut)
    self:addHandlerAuto(ProtocolID.GResTeamArenaLineUp, TeamArena_pb.GResTeamArenaLineUp, require("src.net.TeamArenaResponse").handleTeamArenaLineUp)
    self:addHandlerAuto(ProtocolID.GResTeamArenaRedState, TeamArena_pb.GResTeamArenaRedState, require("src.net.TeamArenaResponse").handleTeamArenaRedState)
    
    -- 诸神遗迹
    self:addHandlerAuto(ProtocolID.GResGodRelicData, GodRelic_pb.GResGodRelicData, require("src.net.GodRelicResponse").godRelicData)
    self:addHandlerAuto(ProtocolID.GResGodRelicChallenge, GodRelic_pb.GResGodRelicChallenge, require("src.net.GodRelicResponse").godRelicChallenge)
    self:addHandlerAuto(ProtocolID.GResGodRelicBuyCount, GodRelic_pb.GResGodRelicBuyCount, require("src.net.GodRelicResponse").godRelicBuyCount)
    self:addHandlerAuto(ProtocolID.GResGodRelicGetStarReward, GodRelic_pb.GResGodRelicGetStarReward, require("src.net.GodRelicResponse").godRelicGetStarReward)
    self:addHandlerAuto(ProtocolID.GResGodRelicSweep, GodRelic_pb.GResGodRelicSweep, require("src.net.GodRelicResponse").godRelicSweep)

    -- 神装数据列表
    self:addHandlerAuto(ProtocolID.GResScanGodEquip, GodEquip_pb.GResScanGodEquip, require("src.net.GodEquipResponse").scanGodEquip)
    self:addHandlerAuto(ProtocolID.GResGodEquipAdd, GodEquip_pb.GResGodEquipAdd, require("src.net.GodEquipResponse").addGodEquip)
    self:addHandlerAuto(ProtocolID.GResGodEquipDelete, GodEquip_pb.GResGodEquipDelete, require("src.net.GodEquipResponse").delGodEquip)
    self:addHandlerAuto(ProtocolID.GResWearGodEquip, GodEquip_pb.GResWearGodEquip, require("src.net.GodEquipResponse").wearGodEquip)
    self:addHandlerAuto(ProtocolID.GResDisboardGodEquip, GodEquip_pb.GResDisboardGodEquip, require("src.net.GodEquipResponse").disboardGodEquip)
    self:addHandlerAuto(ProtocolID.GResGodEquipUpStar, GodEquip_pb.GResGodEquipUpStar, require("src.net.GodEquipResponse").godEquipUpStar)

    self:addHandlerAuto(ProtocolID.GResWashGodEquip, GodEquip_pb.GResWashGodEquip, require("src.net.GodEquipResponse").washGodEquip)
    self:addHandlerAuto(ProtocolID.GResSaveWashGodEquip, GodEquip_pb.GResSaveWashGodEquip, require("src.net.GodEquipResponse").saveWashGodEquip)
    self:addHandlerAuto(ProtocolID.GResUpdateGodEquipOff, GodEquip_pb.GResUpdateGodEquipOff, require("src.net.GodEquipResponse").updateGodEquipOff)
    
    self:addHandlerAuto(ProtocolID.GResGodEquipFighting, GodEquip_pb.GResGodEquipFighting, require("src.net.GodEquipResponse").godEquipFighting)

    -- 神职
    self:addHandlerAuto(ProtocolID.GResUnlockClergyLevel, Clergy_pb.GResUnlockClergyLevel, require("src.net.ClergyResponse").handleUnlockClergyLevel)
    self:addHandlerAuto(ProtocolID.GResClergyExpChange, Clergy_pb.GResClergyExpChange, require("src.net.ClergyResponse").handleClergyExpChange)
    
    -- 召唤周卡
    self:addHandlerAuto(ProtocolID.GResSummonWeeksCardsInfo, Promotion059_pb.GResSummonWeeksCardsInfo, require("src.net.PromotionResponse").handleSummonWeeksCardsInfo)
    -- 高级召唤周卡
    self:addHandlerAuto(ProtocolID.GResHighWeeksCardsInfo, Promotion058_pb.GResHighWeeksCardsInfo, require("src.net.PromotionResponse").handleHighWeeksCardsInfo)
    -- 三天活动
    self:addHandlerAuto(ProtocolID.GResThreeDayTaskData, Promotion061_pb.GResThreeDayTaskData, require("src.net.PromotionResponse").handleThreeDayInfo)
    self:addHandlerAuto(ProtocolID.GResUpdateThreeDayTask, Promotion061_pb.GResUpdateThreeDayTask, require("src.net.PromotionResponse").handleUpdateThreeDayTask)
    -- 精灵周卡
    self:addHandlerAuto(ProtocolID.GResElfWeeksCardInfo, Promotion063_pb.GResElfWeeksCardInfo, require("src.net.PromotionResponse").handleSpiritWeekCardInfo)
    -- 功能预告
    self:addHandlerAuto(ProtocolID.GResNewGamePlayInfo, Promotion066_pb.GResNewGamePlayInfo, require("src.net.PromotionResponse").handlePromotion66GetInfo)
    self:addHandlerAuto(ProtocolID.GResGetEveryDayReward, Promotion066_pb.GResGetEveryDayReward, require("src.net.PromotionResponse").handlePromotion66GetReward)
    -- 龙舟活动
    self:addHandlerAuto(ProtocolID.GResDragonBoatTaskInfo, Promotion064_pb.GResDragonBoatTaskInfo, require("src.net.PromotionResponse").handleDragonBoatTaskInfo)
    self:addHandlerAuto(ProtocolID.GResTurnOverCard, Promotion064_pb.GResTurnOverCard, require("src.net.PromotionResponse").updateDragonBoatGameInfo)
    self:addHandlerAuto(ProtocolID.GResDragonBoatCards, Promotion064_pb.GResDragonBoatCards, require("src.net.PromotionResponse").updateDragonBoatNextGameInfo)
    self:addHandlerAuto(ProtocolID.GResChooseUltimateReward, Promotion064_pb.GResChooseUltimateReward, require("src.net.PromotionResponse").updateDragonBoatUltimateReward)
    self:addHandlerAuto(ProtocolID.GResDragonBoatBuyInfo, Promotion064_pb.GResDragonBoatBuyInfo, require("src.net.PromotionResponse").updateDragonBoatBuyInfo)
    self:addHandlerAuto(ProtocolID.GResGetTaskReward, Promotion064_pb.GResGetTaskReward, require("src.net.PromotionResponse").updateDragonBoatTaskReward)
    self:addHandlerAuto(ProtocolID.GResGetBoxReward, Promotion064_pb.GResGetBoxReward, require("src.net.PromotionResponse").updateDragonBoatBoxReward)
    self:addHandlerAuto(ProtocolID.GResTaskProgress, Promotion064_pb.GResTaskProgress, require("src.net.PromotionResponse").updateDragonBoatTaskInfo)
    -- 梦境秘宝活动
    self:addHandlerAuto(ProtocolID.GResGetDataInfo, Promotion070_pb.GResGetDataInfo, require("src.net.PromotionResponse").handlePromotion70GetInfo)
    self:addHandlerAuto(ProtocolID.GResSelect, Promotion070_pb.GResSelect, require("src.net.PromotionResponse").handlePromotion70RewardSelect)
    self:addHandlerAuto(ProtocolID.GResGetMission, Promotion070_pb.GResGetMission, require("src.net.PromotionResponse").handlePromotion70MissiongetReward)
    self:addHandlerAuto(ProtocolID.GResOpen, Promotion070_pb.GResOpen, require("src.net.PromotionResponse").handlePromotion70GameOpen)
    self:addHandlerAuto(ProtocolID.GResGetCountReward, Promotion070_pb.GResGetCountReward, require("src.net.PromotionResponse").handlePromotion70getReward)
    self:addHandlerAuto(ProtocolID.GResResetSelect, Promotion070_pb.GResResetSelect, require("src.net.PromotionResponse").handlePromotion70SelectReset)
    self:addHandlerAuto(ProtocolID.GResUpdateProcess, Promotion070_pb.GResUpdateProcess, require("src.net.PromotionResponse").handlePromotion70MissionUpdate)
    self:addHandlerAuto(ProtocolID.GResGetMissionBox, Promotion070_pb.GResGetMissionBox, require("src.net.PromotionResponse").handlePromotion70GetMissionBox)

    -- 七神器
    self:addHandlerAuto(ProtocolID.GResQiShenQiInfo, Promotion071_pb.GResQiShenQiInfo, require("src.net.PromotionResponse").handlePromotion71GetInfo)
    self:addHandlerAuto(ProtocolID.GResQiShenQiBuy, Promotion071_pb.GResQiShenQiBuy, require("src.net.PromotionResponse").handlePromotion71BuyGoods)

    -- 惊喜扭蛋
    self:addHandlerAuto(ProtocolID.GResHalloweenLotteryGetDataInfo, Promotion078_pb.GResHalloweenLotteryGetDataInfo, require("src.net.PromotionResponse").setPromotion78GetInfo)
    self:addHandlerAuto(ProtocolID.GResHalloweenLotterySelect, Promotion078_pb.GResHalloweenLotterySelect, require("src.net.PromotionResponse").handlePromotion78Select)
    self:addHandlerAuto(ProtocolID.GResHalloweenLotteryLottery, Promotion078_pb.GResHalloweenLotteryLottery, require("src.net.PromotionResponse").handlePromotion78Draw)
    self:addHandlerAuto(ProtocolID.GResHalloweenLotteryGetLotteryCountReward, Promotion078_pb.GResHalloweenLotteryGetLotteryCountReward, require("src.net.PromotionResponse").handlePromotion78BoxReward)


    -- 鬼怪巡游会
    self:addHandlerAuto(ProtocolID.GResHalloweenGiftInfo, Promotion079_pb.GResHalloweenGiftInfo, require("src.net.PromotionResponse").handlePromotion79GetInfo)
    self:addHandlerAuto(ProtocolID.GResHalloweenGiftBuy, Promotion079_pb.GResHalloweenGiftBuy, require("src.net.PromotionResponse").handlePromotion79BuyGoods)

    -- 万圣任务
    self:addHandlerAuto(ProtocolID.GResHalloweenMissionGetDataInfo, Promotion080_pb.GResHalloweenMissionGetDataInfo, require("src.net.PromotionResponse").handleGetProm80Data)
    self:addHandlerAuto(ProtocolID.GResHalloweenMissionGetMission, Promotion080_pb.GResHalloweenMissionGetMission, require("src.net.PromotionResponse").handleGetProm80MissionDone)
    self:addHandlerAuto(ProtocolID.GResHalloweenMissionUpdateProcess, Promotion080_pb.GResHalloweenMissionUpdateProcess, require("src.net.PromotionResponse").handleUpdateProm80Mission)
    self:addHandlerAuto(ProtocolID.GResHalloweenMissionGetMissionBox, Promotion080_pb.GResHalloweenMissionGetMissionBox, require("src.net.PromotionResponse").handlegetProm80BoxAward)

    -- 圣龙
    self:addHandlerAuto(ProtocolID.GResDragonScanInfo, Dragon_pb.GResDragonScanInfo, require("src.net.DragonResponse").dragonInfo)
    self:addHandlerAuto(ProtocolID.GResDragonPutStone, Dragon_pb.GResDragonPutStone, require("src.net.DragonResponse").dragonPutStone)
    self:addHandlerAuto(ProtocolID.GResDragonUpgradeIdentity, Dragon_pb.GResDragonUpgradeIdentity, require("src.net.DragonResponse").dragonUpgradeIdentity)
    self:addHandlerAuto(ProtocolID.GResDragonSpeedUpIdentity, Dragon_pb.GResDragonSpeedUpIdentity, require("src.net.DragonResponse").dragonSpeedUpIdentity)
    self:addHandlerAuto(ProtocolID.GResDragonIdentityFinish, Dragon_pb.GResDragonIdentityFinish, require("src.net.DragonResponse").dragonIdentityFinish)
    self:addHandlerAuto(ProtocolID.GResDragonFinishNotice, Dragon_pb.GResDragonFinishNotice, require("src.net.DragonResponse").dragonIdentityFinishNotice)
    self:addHandlerAuto(ProtocolID.GResDragonUpgradeLevel, Dragon_pb.GResDragonUpgradeLevel, require("src.net.DragonResponse").dragonUpgradeLevel)
    self:addHandlerAuto(ProtocolID.GResDragonChange, Dragon_pb.GResDragonChange, require("src.net.DragonResponse").dragonChange)
    self:addHandlerAuto(ProtocolID.GResDragonChangeSort, Dragon_pb.GResDragonChangeSort, require("src.net.DragonResponse").dragonChangeSort)
    self:addHandlerAuto(ProtocolID.GResDragonCollection, Dragon_pb.GResDragonCollection, require("src.net.DragonResponse").dragonCollection)
    self:addHandlerAuto(ProtocolID.GResDragonUpStarInBag, Dragon_pb.GResDragonUpStarInBag, require("src.net.DragonResponse").dragonUpStarInBag)
    self:addHandlerAuto(ProtocolID.GResDragonUpStarInSlot, Dragon_pb.GResDragonUpStarInSlot, require("src.net.DragonResponse").dragonUpStarInSlot)
    self:addHandlerAuto(ProtocolID.GResDragonResolve, Dragon_pb.GResDragonResolve, require("src.net.DragonResponse").dragonResolve)

    -- 98元累计充值
    self:addHandlerAuto(ProtocolID.GResRechargeDaysBList, Promotion060_pb.GResRechargeDaysBList, require("src.net.PromotionResponse").handleRechargeDaysBList)
    self:addHandlerAuto(ProtocolID.GResRechargeDaysBReward, Promotion060_pb.GResRechargeDaysBReward, require("src.net.PromotionResponse").handleRechargeDaysBReward)

    -- 私人订制
    self:addHandlerAuto(ProtocolID.GResCustomRewardData, Promotion062_pb.GResCustomRewardData, require("src.net.CustomizedResponse").buyRecord)
    self:addHandlerAuto(ProtocolID.GResRewardCustom, Promotion062_pb.GResRewardCustom, require("src.net.CustomizedResponse").customizedReward)

    -- 灵器
    self:addHandlerAuto(ProtocolID.GResActiveReikiEquipPlace, ReikiEquip_pb.GResActiveReikiEquipPlace, require("src.net.ArtifactRespone").onActiveData)
    self:addHandlerAuto(ProtocolID.GResReikiEquipData, ReikiEquip_pb.GResReikiEquipData, require("src.net.ArtifactRespone").onInitArtifactData)
    self:addHandlerAuto(ProtocolID.GResWearReikiEquip, ReikiEquip_pb.GResWearReikiEquip, require("src.net.ArtifactRespone").onWearArtifactInfo)
    self:addHandlerAuto(ProtocolID.GResDisboardReikiEquip, ReikiEquip_pb.GResDisboardReikiEquip, require("src.net.ArtifactRespone").onOutArtifactInfo)
    self:addHandlerAuto(ProtocolID.GResCombineReikiEquip, ReikiEquip_pb.GResCombineReikiEquip, require("src.net.ArtifactRespone").onCompose)
    self:addHandlerAuto(ProtocolID.GResAddReikiEquip, ReikiEquip_pb.GResAddReikiEquip, require("src.net.ArtifactRespone").onAddEquip)
    self:addHandlerAuto(ProtocolID.GResTransformReikiEquip, ReikiEquip_pb.GResTransformReikiEquip, require("src.net.ArtifactRespone").onTransform)
    self:addHandlerAuto(ProtocolID.GResCostReikiEquip, ReikiEquip_pb.GResCostReikiEquip, require("src.net.ArtifactRespone").deleteArtifact)

    -- 魔蝶
    self:addHandlerAuto(ProtocolID.GResHeroRollingData, Promotion065_pb.GResHeroRollingData, require("src.net.MagicButterflyRespone").onInitData)
    self:addHandlerAuto(ProtocolID.GResHeroRollingReward, Promotion065_pb.GResHeroRollingReward, require("src.net.MagicButterflyRespone").onRewardData)
    self:addHandlerAuto(ProtocolID.GResHeroRollingSummon, Promotion065_pb.GResHeroRollingSummon, require("src.net.MagicButterflyRespone").onUpdateSummonNum)
    
    
    -- 超凡段位赛
    self:addHandlerAuto(ProtocolID.GResStageMatchData, StageMatch_pb.GResStageMatchData, require("src.net.SuperStageResponse").superStageInfo)
    self:addHandlerAuto(ProtocolID.GResMatchOpponent, StageMatch_pb.GResMatchOpponent, require("src.net.SuperStageResponse").superStageMatch)
    self:addHandlerAuto(ProtocolID.GResMatchInfo, StageMatch_pb.GResMatchInfo, require("src.net.SuperStageResponse").superStageMatchPlayerInfo)
    self:addHandlerAuto(ProtocolID.GResPurchases, StageMatch_pb.GResPurchases, require("src.net.SuperStageResponse").superStageMatchAddTimes)
    self:addHandlerAuto(ProtocolID.GResChallenge, StageMatch_pb.GResChallenge, require("src.net.SuperStageResponse").superStageMatchBattle)
    self:addHandlerAuto(ProtocolID.GResMyVideo, StageMatch_pb.GResMyVideo, require("src.net.SuperStageResponse").superStageBattleLog)
    self:addHandlerAuto(ProtocolID.GResGreatStyle, StageMatch_pb.GResGreatStyle, require("src.net.SuperStageResponse").superStageSuperBattleLog)
    self:addHandlerAuto(ProtocolID.GResReceiveAward, StageMatch_pb.GResReceiveAward, require("src.net.SuperStageResponse").superStageFirstReward)
    self:addHandlerAuto(ProtocolID.GResSeasonLegend, StageMatch_pb.GResSeasonLegend, require("src.net.SuperStageResponse").superStageLegendList)
    self:addHandlerAuto(ProtocolID.GResRankInfo, StageMatch_pb.GResRankInfo, require("src.net.SuperStageResponse").superStageRankInfo)

    self:addHandlerAuto(ProtocolID.GResStageToken, StageMatchRim_pb.GResStageToken, require("src.net.SuperStageResponse").superStageTokenInfo)
    self:addHandlerAuto(ProtocolID.GResStageTokenGetReward, StageMatchRim_pb.GResStageTokenGetReward, require("src.net.SuperStageResponse").superStageTokenGetReward)
    self:addHandlerAuto(ProtocolID.GResDetailSeason, StageMatchRim_pb.GResDetailSeason, require("src.net.SuperStageResponse").superStageDetailSeason)

    -- 巅峰赛预赛部分
    self:addHandlerAuto(ProtocolID.GResPreliminaries, Pinnacle_pb.GResPreliminaries, require("src.net.SuperStageResponse").topLadderInfo)
    self:addHandlerAuto(ProtocolID.GResRefreshOpponent, Pinnacle_pb.GResRefreshOpponent, require("src.net.SuperStageResponse").topRefreshOpponent)
    self:addHandlerAuto(ProtocolID.GResPinnacleLineData, Pinnacle_pb.GResPinnacleLineData, require("src.net.SuperStageResponse").topOpponentInfo)
    self:addHandlerAuto(ProtocolID.GResChallengeOpponent, Pinnacle_pb.GResChallengeOpponent, require("src.net.SuperStageResponse").topLadderChallenge)
    self:addHandlerAuto(ProtocolID.GResPreliminariesRecord, Pinnacle_pb.GResPreliminariesRecord, require("src.net.SuperStageResponse").topMyLadderBattleRecord)
    self:addHandlerAuto(ProtocolID.GResGreatDemeanor, Pinnacle_pb.GResGreatDemeanor, require("src.net.SuperStageResponse").topHighLadderBattleRecord)
    self:addHandlerAuto(ProtocolID.GResPreliminariesPurchases, Pinnacle_pb.GResPreliminariesPurchases, require("src.net.SuperStageResponse").topBuyTimes)

    -- 巅峰赛决赛部分
    self:addHandlerAuto(ProtocolID.GResScanPinnacle, Pinnacle_pb.GResScanPinnacle, require("src.net.SuperStageResponse").top2Info)                         -- 活动数据
    self:addHandlerAuto(ProtocolID.GResScanPinnacleKnockout, Pinnacle_pb.GResScanPinnacleKnockout, require("src.net.SuperStageResponse").top2Knockout)     -- 128强数据
    self:addHandlerAuto(ProtocolID.GResMyPinnacleBattle, Pinnacle_pb.GResMyPinnacleBattle, require("src.net.SuperStageResponse").myTop2Battle)             -- 我的数据
    self:addHandlerAuto(ProtocolID.GResPinnacleBiubiu, Pinnacle_pb.GResPinnacleBiubiu, require("src.net.SuperStageResponse").top2Biubiu)                   -- 弹幕
    self:addHandlerAuto(ProtocolID.GResPinnacleBiuList, Pinnacle_pb.GResPinnacleBiuList, require("src.net.SuperStageResponse").top2BiuList)                -- 弹幕列表
    self:addHandlerAuto(ProtocolID.GResPinnacleBiuChange, Pinnacle_pb.GResPinnacleBiuChange, require("src.net.SuperStageResponse").top2BiuChange)          -- 弹幕改变
    self:addHandlerAuto(ProtocolID.GResPinnacleCleanBiu, Pinnacle_pb.GResPinnacleCleanBiu, require("src.net.SuperStageResponse").championCrossCleanBiu)    -- 清除弹幕
    self:addHandlerAuto(ProtocolID.GResGuessPinnacleBattle, Pinnacle_pb.GResGuessPinnacleBattle, require("src.net.SuperStageResponse").guessTop2Battle)    -- 竞猜数据
    self:addHandlerAuto(ProtocolID.GResPinnacleGuessList, Pinnacle_pb.GResPinnacleGuessList, require("src.net.SuperStageResponse").top2GuessList)          -- 竞猜列表
    self:addHandlerAuto(ProtocolID.GResGuess, Pinnacle_pb.GResGuess, require("src.net.SuperStageResponse").guessTop2OneBattle)                             -- 竞猜结果
    self:addHandlerAuto(ProtocolID.GResGetPinnacleBattle, Pinnacle_pb.GResGetPinnacleBattle, require("src.net.SuperStageResponse").getTop2Battle)          -- 获取战斗id
    self:addHandlerAuto(ProtocolID.GResScanMyPinnacleBattle, Pinnacle_pb.GResScanMyPinnacleBattle, require("src.net.SuperStageResponse").myTop2BattleInfo) -- 我的比赛记录
    self:addHandlerAuto(ProtocolID.GResPinnacleGuessWin, Pinnacle_pb.GResPinnacleGuessWin, require("src.net.SuperStageResponse").top2GuessWin)             -- 投注获得奖励
    self:addHandlerAuto(ProtocolID.GResPinnacleStageChange, Pinnacle_pb.GResPinnacleStageChange, require("src.net.SuperStageResponse").top2StageChange)    -- 阶段变化
    self:addHandlerAuto(ProtocolID.GResPreliminariesRank, Pinnacle_pb.GResPreliminariesRank, require("src.net.SuperStageResponse").topRank)                -- 排行榜
    self:addHandlerAuto(ProtocolID.GResPinnacleRank, Pinnacle_pb.GResPinnacleRank, require("src.net.SuperStageResponse").top2Rank)                         -- 排行榜
    self:addHandlerAuto(ProtocolID.GResPreliminariesLike, Pinnacle_pb.GResPreliminariesLike, require("src.net.SuperStageResponse").topLike)                -- 点赞
    self:addHandlerAuto(ProtocolID.GResPinnacleLike, Pinnacle_pb.GResPinnacleLike, require("src.net.SuperStageResponse").top2Like)                         -- 点赞
    self:addHandlerAuto(ProtocolID.GResPinnacleShowTop, Pinnacle_pb.GResPinnacleShowTop, require("src.net.SuperStageResponse").top2ShowTop)                -- 排行榜
    self:addHandlerAuto(ProtocolID.GResPinnacleEnd, Pinnacle_pb.GResPinnacleEnd, require("src.net.SuperStageResponse").top2End)                            -- 战斗结果
    self:addHandlerAuto(ProtocolID.GResPinnacleGuessBroadcast, Pinnacle_pb.GResPinnacleGuessBroadcast, require("src.net.SuperStageResponse").top2GuessBroadcast)-- 投注广播
    self:addHandlerAuto(ProtocolID.GResPinnacleSaveFormation, Pinnacle_pb.GResPinnacleSaveFormation, require("src.net.SuperStageResponse").top2SaveFormation)-- 自己阵容改变
    self:addHandlerAuto(ProtocolID.GResPinnacleFormationChange, Pinnacle_pb.GResPinnacleFormationChange, require("src.net.SuperStageResponse").top2FormationChange) -- 阵容改变

    -- 浮空岛
    self:addHandler(ProtocolID.GResFloatingIslandsTime, FloatingIslands_pb.GResFloatingIslandsTime, require("src.net.FloatingIslandsResponse").floatingIslandsTime)
    self:addHandler(ProtocolID.GResFloatingIslandsData, FloatingIslands_pb.GResFloatingIslandsData, require("src.net.FloatingIslandsResponse").floatingIslandsData)
    self:addHandlerAuto(ProtocolID.GResFloatingIslandsChallenge, FloatingIslands_pb.GResFloatingIslandsChallenge, require("src.net.FloatingIslandsResponse").floatingIslandsChallenge)
    self:addHandler(ProtocolID.GResFloatingIslandsBuyCount, FloatingIslands_pb.GResFloatingIslandsBuyCount, require("src.net.FloatingIslandsResponse").floatingIslandsBuyCount)

    -- 时空魔塔
    self:addHandlerAuto(ProtocolID.GResTimeTowerInfo, TimeTower_pb.GResTimeTowerInfo, require("src.net.STMagicTowerResponse").setSTMagicTowerInfo)
    self:addHandlerAuto(ProtocolID.GResTimeTowerChallenge, TimeTower_pb.GResTimeTowerChallenge, require("src.net.STMagicTowerResponse").stMagicTowerBattle)
    self:addHandlerAuto(ProtocolID.GResTimeTowerRankInfo, TimeTower_pb.GResTimeTowerRankInfo, require("src.net.STMagicTowerResponse").setSTMagicTowerRankInfo)

    -- 冥域魔都
    self:addHandlerAuto(ProtocolID.GResHadesInfo, Hades_pb.GResHadesInfo, require("src.net.UnderworldPagodaResponse").setUnderworldPagodaInfo)
    self:addHandlerAuto(ProtocolID.GResHadesChallenge, Hades_pb.GResHadesChallenge, require("src.net.UnderworldPagodaResponse").getUnderworldPagodaChallenge)
    self:addHandlerAuto(ProtocolID.GResHadesSweep, Hades_pb.GResHadesSweep, require("src.net.UnderworldPagodaResponse").getUnderworldPagodaSweep)
    self:addHandlerAuto(ProtocolID.GResHadesRankList, Hades_pb.GResHadesRankList, require("src.net.UnderworldPagodaResponse").getUnderworldPagodaRankList)
    
     -- 奇珍异宝
    self:addHandlerAuto(ProtocolID.GResSpaceTimeTreasureInfo, Promotion068_pb.GResSpaceTimeTreasureInfo, require("src.net.PromotionResponse").handleTimeTreasureInfo)
    self:addHandlerAuto(ProtocolID.GResChooseItem, Promotion068_pb.GResChooseItem, require("src.net.PromotionResponse").updataTimeTreasureInfo)
    
    --锦鲤
    self:addHandlerAuto(ProtocolID.GResWeekendKoiInfo, Promotion067_pb.GResWeekendKoiInfo, require("src.net.LuckFishResponse").onInfo)
    self:addHandlerAuto(ProtocolID.GResBlessingInfo, Promotion067_pb.GResBlessingInfo, require("src.net.LuckFishResponse").onRecordData)
    self:addHandlerAuto(ProtocolID.GResUseBlessing, Promotion067_pb.GResUseBlessing, require("src.net.LuckFishResponse").onUseBlessing)
    self:addHandlerAuto(ProtocolID.GResKoiNick, Promotion067_pb.GResKoiNick, require("src.net.LuckFishResponse").onNick)
    self:addHandlerAuto(ProtocolID.GResBuyProduct,Promotion067_pb.GResBuyProduct, require("src.net.LuckFishResponse").onBuyLimit)

    -- 宠物
    self:addHandlerAuto(ProtocolID.GResPetInfoList, Pet_pb.GResPetInfoList, require("src.net.PetRespone").onInitPetData)
    self:addHandlerAuto(ProtocolID.GResAddPetInfo, Pet_pb.GResAddPetInfo, require("src.net.PetRespone").onAddPetData)
    self:addHandlerAuto(ProtocolID.GResDelPetInfo, Pet_pb.GResDelPetInfo, require("src.net.PetRespone").onDeletePetData)
    self:addHandlerAuto(ProtocolID.GResDisboardPet, Pet_pb.GResDisboardPet, require("src.net.PetRespone").onDisboardPetInfo)
    self:addHandlerAuto(ProtocolID.GResCarryPet, Pet_pb.GResCarryPet, require("src.net.PetRespone").onCarryPetInfo)
    self:addHandlerAuto(ProtocolID.GResPetUpLevel, Pet_pb.GResPetUpLevel, require("src.net.PetRespone").onUpdatePetLevel)
    self:addHandlerAuto(ProtocolID.GResPetIllustrate, Pet_pb.GResPetIllustrate, require("src.net.PetRespone").onInitPetIllustrateData)

    -- 图腾
    self:addHandlerAuto(ProtocolID.GResTotemsInfoList, Totems_pb.GResTotemsInfoList, require("src.net.TotemRespone").onInitTotemData)
    self:addHandlerAuto(ProtocolID.GResTotemsUp, Totems_pb.GResTotemsUp, require("src.net.TotemRespone").onUpdateTotemLevel)
    self:addHandlerAuto(ProtocolID.GResTotemsReset, Totems_pb.GResTotemsReset, require("src.net.TotemRespone").onReset)
    self:addHandlerAuto(ProtocolID.GResTotemsOprea, Totems_pb.GResTotemsOprea, require("src.net.TotemRespone").onEquipStatus)
    self:addHandlerAuto(ProtocolID.GResAddTotemsInfo, Totems_pb.GResAddTotemsInfo, require("src.net.TotemRespone").onAddEquips)

    -- 神谕
    self:addHandlerAuto(ProtocolID.GResZSJTInfo, Promotion072_pb.GResZSJTInfo, require("src.net.ShenYuRespone").onShenYuInfo)
    self:addHandlerAuto(ProtocolID.GResZSJTLuckDraw, Promotion072_pb.GResZSJTLuckDraw, require("src.net.ShenYuRespone").onShenYuReward)

    -- 魔方 （9.17版本更新临时注释不需要的的协议）
    self:addHandlerAuto(ProtocolID.GResTweakCube, TweakCube_pb.GResTweakCube, require("src.net.MagicCubeRespone").initMagicCubeData)
    self:addHandlerAuto(ProtocolID.GResTrenchAddHero, TweakCube_pb.GResTrenchAddHero, require("src.net.MagicCubeRespone").addHero)
    self:addHandlerAuto(ProtocolID.GResTrenchRemoveHero, TweakCube_pb.GResTrenchRemoveHero, require("src.net.MagicCubeRespone").onDisboardHero)
    self:addHandlerAuto(ProtocolID.GResTrenchOpen, TweakCube_pb.GResTrenchOpen, require("src.net.MagicCubeRespone").openTrench)
    self:addHandlerAuto(ProtocolID.GResTrenchClearCd, TweakCube_pb.GResTrenchClearCd, require("src.net.MagicCubeRespone").onClearCD)
    self:addHandlerAuto(ProtocolID.GResUpdateHeroTweakCube, TweakCube_pb.GResUpdateHeroTweakCube, require("src.net.MagicCubeRespone").onHeroCubeLevel)

    --  异界冒险
    self:addHandlerAuto(ProtocolID.GResSpaceTimeAdventureInfo, SpaceTimeAdventure_pb.GResSpaceTimeAdventureInfo, require("src.net.ExoticAdventureResponse").adventureData)
    self:addHandlerAuto(ProtocolID.GResFleetInfo, SpaceTimeAdventure_pb.GResFleetInfo, require("src.net.ExoticAdventureResponse").adventureFleetData)
    self:addHandlerAuto(ProtocolID.GResModifyName, SpaceTimeAdventure_pb.GResModifyName, require("src.net.ExoticAdventureResponse").modifyNick)
    self:addHandlerAuto(ProtocolID.GResFleetRepair, SpaceTimeAdventure_pb.GResFleetRepair, require("src.net.ExoticAdventureResponse").repair)
    self:addHandlerAuto(ProtocolID.GResFleetUpSkill, SpaceTimeAdventure_pb.GResFleetUpSkill, require("src.net.ExoticAdventureResponse").upSkill)
    self:addHandlerAuto(ProtocolID.GResChooseRoute, SpaceTimeAdventure_pb.GResChooseRoute, require("src.net.ExoticAdventureResponse").startsailing)
    self:addHandlerAuto(ProtocolID.GResCargoHoldInfo, SpaceTimeAdventure_pb.GResCargoHoldInfo, require("src.net.ExoticAdventureResponse").setBackpack)
    self:addHandlerAuto(ProtocolID.GResSailingIllustrate, SpaceTimeAdventure_pb.GResSailingIllustrate, require("src.net.ExoticAdventureResponse").setIllustratedBooks)
    self:addHandlerAuto(ProtocolID.GResUpdateIllustrate, SpaceTimeAdventure_pb.GResUpdateIllustrate, require("src.net.ExoticAdventureResponse").updataIllustratedBooks)
    self:addHandlerAuto(ProtocolID.GResSailingEnd, SpaceTimeAdventure_pb.GResSailingEnd, require("src.net.ExoticAdventureResponse").setSailingEnd)
    self:addHandlerAuto(ProtocolID.GResUpdateSailingProgress, SpaceTimeAdventure_pb.GResUpdateSailingProgress, require("src.net.ExoticAdventureResponse").updataSailingProgress)
    self:addHandlerAuto(ProtocolID.GResFleetExplore, SpaceTimeAdventure_pb.GResFleetExplore, require("src.net.ExoticAdventureResponse").setFleetExplore)
    self:addHandlerAuto(ProtocolID.GResEnemyInfo, SpaceTimeAdventure_pb.GResEnemyInfo, require("src.net.ExoticAdventureResponse").setEnemyInfo)
    self:addHandlerAuto(ProtocolID.GResSpaceTimeShopBuy, SpaceTimeAdventure_pb.GResSpaceTimeShopBuy, require("src.net.ExoticAdventureResponse").setShopInfo)
    self:addHandlerAuto(ProtocolID.GResSailingInfo, SpaceTimeAdventure_pb.GResSailingInfo, require("src.net.ExoticAdventureResponse").setSailingInfo)
    self:addHandlerAuto(ProtocolID.GResFleetGiftBuy, SpaceTimeAdventure_pb.GResFleetGiftBuy, require("src.net.ExoticAdventureResponse").setFleetGiftBuy)
    -- 事件
    -- 放弃事件
    self:addHandlerAuto(ProtocolID.GResQuiteEvent, SpaceTimeAdventure_pb.GResQuiteEvent, require("src.net.ExoticAdventureResponse").setFleetQuitEvent)
    -- 舰队残骸事件
    self:addHandlerAuto(ProtocolID.GResFleetEventOne, SpaceTimeAdventure_pb.GResFleetEventOne, require("src.net.ExoticAdventureResponse").setFleetEventOne)
    -- 舰队残骸 怪物事件
    self:addHandlerAuto(ProtocolID.GResFleetEventTwo, SpaceTimeAdventure_pb.GResFleetEventTwo, require("src.net.ExoticAdventureResponse").setFleetEventTwo)
    -- 其他舰队
    self:addHandlerAuto(ProtocolID.GResFleetEventThree, SpaceTimeAdventure_pb.GResFleetEventThree, require("src.net.ExoticAdventureResponse").setFleetEventThree)
    -- 隐藏航线
    self:addHandlerAuto(ProtocolID.GResFleetEventFour, SpaceTimeAdventure_pb.GResFleetEventFour, require("src.net.ExoticAdventureResponse").setFleetEventFour)
    -- 风暴降临
    self:addHandlerAuto(ProtocolID.GResFleetEventFive, SpaceTimeAdventure_pb.GResFleetEventFive, require("src.net.ExoticAdventureResponse").setFleetEventFive)
    -- 土著商人
    self:addHandlerAuto(ProtocolID.GResFleetEventSix, SpaceTimeAdventure_pb.GResFleetEventSix, require("src.net.ExoticAdventureResponse").setFleetEventSix)
    -- 搁浅舰队
    self:addHandlerAuto(ProtocolID.GResFleetEventSeven, SpaceTimeAdventure_pb.GResFleetEventSeven, require("src.net.ExoticAdventureResponse").setFleetEventSeven)
    -- 天降宝箱事件
    self:addHandlerAuto(ProtocolID.GResFleetEventEight, SpaceTimeAdventure_pb.GResFleetEventEight, require("src.net.ExoticAdventureResponse").setFleetEventEight)
    -- 什么事件都没发生
    self:addHandlerAuto(ProtocolID.GResFleetEventNine, SpaceTimeAdventure_pb.GResFleetEventNine, require("src.net.ExoticAdventureResponse").setFleetEventNine)
    -- 航线礼包
    self:addHandlerAuto(ProtocolID.GResFleetEventTen, SpaceTimeAdventure_pb.GResFleetEventTen, require("src.net.ExoticAdventureResponse").setFleetEventTen)
    -- 疾风之力
    self:addHandlerAuto(ProtocolID.GResFleetEventEleven, SpaceTimeAdventure_pb.GResFleetEventEleven, require("src.net.ExoticAdventureResponse").setFleetEventEleven)
    ----------------------------------
    
    -- 中秋
    self:addHandlerAuto(ProtocolID.GResMidLotteryGetDataInfo, Promotion074_pb.GResMidLotteryGetDataInfo, require("src.net.ZhongQiuResponse").onInfo)
    self:addHandlerAuto(ProtocolID.GResMidLotteryLottery, Promotion074_pb.GResMidLotteryLottery, require("src.net.ZhongQiuResponse").onSummon)
    self:addHandlerAuto(ProtocolID.GResMidLotterySelect, Promotion074_pb.GResMidLotterySelect, require("src.net.ZhongQiuResponse").onSelect)
    self:addHandlerAuto(ProtocolID.GResMidLotteryGetLotteryCountReward, Promotion074_pb.GResMidLotteryGetLotteryCountReward, require("src.net.ZhongQiuResponse").onBoxReward)

    self:addHandlerAuto(ProtocolID.GResMidFoodInfo, Promotion075_pb.GResMidFoodInfo, require("src.net.ZhongQiuResponse").onJiaYaoData)
    self:addHandlerAuto(ProtocolID.GResMidFoodBuy, Promotion075_pb.GResMidFoodBuy, require("src.net.ZhongQiuResponse").onBuyData)

    -------------------- 国庆活动 皮肤活动----------------------
    self:addHandlerAuto(ProtocolID.GResMidFashionGetDataInfo, Promotion076_pb.GResMidFashionGetDataInfo, require("src.net.PromotionResponse").setMidFashionGetDataInfo)
    self:addHandlerAuto(ProtocolID.GResMidFashionGetFashionCount, Promotion076_pb.GResMidFashionGetFashionCount, require("src.net.PromotionResponse").setMidFashionFashionCount)
    self:addHandlerAuto(ProtocolID.GResMidFashionExchangeFashion, Promotion076_pb.GResMidFashionExchangeFashion, require("src.net.PromotionResponse").setMidFashionExchangeFashion)
    -------------------- 赏月任务 ----------------------
    self:addHandlerAuto(ProtocolID.GResMidMissionGetDataInfo, Promotion077_pb.GResMidMissionGetDataInfo, require("src.net.PromotionResponse").handleGetProm77Data)
    self:addHandlerAuto(ProtocolID.GResMidMissionGetMission, Promotion077_pb.GResMidMissionGetMission, require("src.net.PromotionResponse").handleGetProm77MissionDone)
    self:addHandlerAuto(ProtocolID.GResMidMissionUpdateProcess, Promotion077_pb.GResMidMissionUpdateProcess, require("src.net.PromotionResponse").handleUpdateProm77Mission)
    self:addHandlerAuto(ProtocolID.GResMidMissionGetMissionBox, Promotion077_pb.GResMidMissionGetMissionBox, require("src.net.PromotionResponse").handlegetProm77BoxAward)

    -------------------- 黑色星期五 ----------------------------
    -- 血拼黑五
    self:addHandlerAuto(ProtocolID.GResBlackFiveGiftInfo, Promotion082_pb.GResBlackFiveGiftInfo, require("src.net.PromotionResponse").handlePromotion82GetInfo)
    self:addHandlerAuto(ProtocolID.GResBlackFiveGiftBuy, Promotion082_pb.GResBlackFiveGiftBuy, require("src.net.PromotionResponse").handlePromotion82BuyGoods)

    -- 黑色通缉
    self:addHandlerAuto(ProtocolID.GResBlackFiveLotteryGetDataInfo, Promotion083_pb.GResBlackFiveLotteryGetDataInfo, require("src.net.PromotionResponse").getBlackFiveLotteryGetDataInfo)
    self:addHandlerAuto(ProtocolID.GResBlackFiveLotterySelect, Promotion083_pb.GResBlackFiveLotterySelect, require("src.net.PromotionResponse").UpdateBlackFiveLotterySelectInfo)
    self:addHandlerAuto(ProtocolID.GResBlackFiveLotteryLottery, Promotion083_pb.GResBlackFiveLotteryLottery, require("src.net.PromotionResponse").onBlackFiveLotterySummon)
    self:addHandlerAuto(ProtocolID.GResBlackFiveLotteryGetLotteryCountReward, Promotion083_pb.GResBlackFiveLotteryGetLotteryCountReward, require("src.net.PromotionResponse").onBlackFiveLotteryBoxReward)

    -- 超级折扣
    self:addHandlerAuto(ProtocolID.GResBlackFiveMissionGetDataInfo, Promotion081_pb.GResBlackFiveMissionGetDataInfo, require("src.net.PromotionResponse").handleGetProm81Data)
    self:addHandlerAuto(ProtocolID.GResBlackFiveMissionGetMission, Promotion081_pb.GResBlackFiveMissionGetMission, require("src.net.PromotionResponse").handleGetProm81MissionDone)
    self:addHandlerAuto(ProtocolID.GResBlackFiveMissionUpdateProcess, Promotion081_pb.GResBlackFiveMissionUpdateProcess, require("src.net.PromotionResponse").handleUpdateProm81Mission)
    self:addHandlerAuto(ProtocolID.GResBlackFiveMissionGetMissionBox, Promotion081_pb.GResBlackFiveMissionGetMissionBox, require("src.net.PromotionResponse").handlegetProm81BoxAward)
    self:addHandlerAuto(ProtocolID.GResBlackFiveMissionGiftBuy, Promotion081_pb.GResBlackFiveMissionGiftBuy, require("src.net.PromotionResponse").handlegetProm81Giftbuy)

    -- 英雄排行榜
    self:addHandlerAuto(ProtocolID.GResDeliverFlowerGetData, Promotion092_pb.GResDeliverFlowerGetData, require("src.net.PromotionResponse").handleGetProm92Data)
    self:addHandlerAuto(ProtocolID.GResDeliverFlowerSelectHero, Promotion092_pb.GResDeliverFlowerSelectHero, require("src.net.PromotionResponse").handleGetSelectHero)
    self:addHandlerAuto(ProtocolID.GResDeliverFlower, Promotion092_pb.GResDeliverFlower, require("src.net.PromotionResponse").handleGetDeliverFlower)
    self:addHandlerAuto(ProtocolID.GResDeliverCountRank, Promotion092_pb.GResDeliverCountRank, require("src.net.PromotionResponse").handleGetDeliverCountRank)
    self:addHandlerAuto(ProtocolID.GResDeliverFlowerCountReward, Promotion092_pb.GResDeliverFlowerCountReward, require("src.net.PromotionResponse").handleGetDeliverFlowerCountReward)
    self:addHandlerAuto(ProtocolID.GResHeroScoreRank, Promotion092_pb.GResHeroScoreRank, require("src.net.PromotionResponse").handleGetDeliverHeroScoreRank)
    self:addHandlerAuto(ProtocolID.GResBuyFlower, Promotion092_pb.GResBuyFlower, require("src.net.PromotionResponse").handleGetDeliverBuyFlower)
    
    -- 三日累充
    self:addHandlerAuto(ProtocolID.GResThreeDay, Promotion084_pb.GResThreeDay, require("src.net.PromotionResponse").handleGetProm84Data)
    self:addHandlerAuto(ProtocolID.GResThreeDayGet, Promotion084_pb.GResThreeDayGet, require("src.net.PromotionResponse").handleGetProm84ThreeDayGet)
    self:addHandlerAuto(ProtocolID.GResThreeDayUpdateRecharge, Promotion084_pb.GResThreeDayUpdateRecharge, require("src.net.PromotionResponse").UpdataProm84Recharge)

    -- 圣诞活动 圣诞连线
    self:addHandlerAuto(ProtocolID.GResChristmasMissionGetDataInfo, Promotion085_pb.GResChristmasMissionGetDataInfo, require("src.net.PromotionResponse").handleGetProm85Data)
    self:addHandlerAuto(ProtocolID.GResChristmasMissionGetMission, Promotion085_pb.GResChristmasMissionGetMission, require("src.net.PromotionResponse").handleGetProm85MissionDone)
    self:addHandlerAuto(ProtocolID.GResChristmasMissionUpdateProcess, Promotion085_pb.GResChristmasMissionUpdateProcess, require("src.net.PromotionResponse").handleUpdateProm85Mission)
    self:addHandlerAuto(ProtocolID.GResChristmasMissionGetMissionBox, Promotion085_pb.GResChristmasMissionGetMissionBox, require("src.net.PromotionResponse").handlegetProm85BoxAward)
    --圣诞活动 约会圣诞
    self:addHandlerAuto(ProtocolID.GResChristmasGiftInfo, Promotion086_pb.GResChristmasGiftInfo, require("src.net.PromotionResponse").handlePromotion86GetInfo)
    self:addHandlerAuto(ProtocolID.GResChristmasGiftBuy, Promotion086_pb.GResChristmasGiftBuy, require("src.net.PromotionResponse").handlePromotion86BuyGoods)
    --圣诞活动 嗨翻圣诞
    self:addHandlerAuto(ProtocolID.GResChristmasLotteryGetDataInfo, Promotion087_pb.GResChristmasLotteryGetDataInfo, require("src.net.PromotionResponse").handleGetProm87Data)
    self:addHandlerAuto(ProtocolID.GResChristmasLottery, Promotion087_pb.GResChristmasLottery, require("src.net.PromotionResponse").handlePromotion87Draw)
    --圣诞活动 圣诞礼盒
    self:addHandlerAuto(ProtocolID.GResChristmasScoreInfo, Promotion088_pb.GResChristmasScoreInfo, require("src.net.PromotionResponse").handleGetProm88Data)
    self:addHandlerAuto(ProtocolID.GResChristmasExchangeScore, Promotion088_pb.GResChristmasExchangeScore, require("src.net.PromotionResponse").handleGetProm88ExchangeScore)
    self:addHandlerAuto(ProtocolID.GResChristmasBox, Promotion088_pb.GResChristmasBox, require("src.net.PromotionResponse").handleGetProm88Box)
    
    
    --圣诞活动 感谢信
    self:addHandlerAuto(ProtocolID.GResChristmasNote, Promotion089_pb.GResChristmasNote, require("src.net.PromotionResponse").handleGetProm89Data)
    self:addHandlerAuto(ProtocolID.GResChristmasNoteReward, Promotion089_pb.GResChristmasNoteReward, require("src.net.PromotionResponse").handlegetProm89Reward)

    --运营活动（新战令 id 90）
    self:addHandlerAuto(ProtocolID.GResTPermitList, Promotion090_pb.GResTPermitList, require("src.net.PromWarOrderResponse").initList)
    self:addHandlerAuto(ProtocolID.GResTPermitBuyLevel, Promotion090_pb.GResTPermitBuyLevel, require("src.net.PromWarOrderResponse").buyLevel)
    self:addHandlerAuto(ProtocolID.GResTPermitLevelReward, Promotion090_pb.GResTPermitLevelReward, require("src.net.PromWarOrderResponse").getLevelReward)
    self:addHandlerAuto(ProtocolID.GResTPermitAllReward, Promotion090_pb.GResTPermitAllReward, require("src.net.PromWarOrderResponse").oneKeyLevelReward)
    self:addHandlerAuto(ProtocolID.GResTPermitTaskReward, Promotion090_pb.GResTPermitTaskReward, require("src.net.PromWarOrderResponse").getTaskReward)
    self:addHandlerAuto(ProtocolID.GResTPermitDayTaskProgress, Promotion090_pb.GResTPermitDayTaskProgress, require("src.net.PromWarOrderResponse").updateTaskProgress)
    self:addHandlerAuto(ProtocolID.GResTPermitPrivilege, Promotion090_pb.GResTPermitPrivilege, require("src.net.PromWarOrderResponse").buySpecial)
    --新年活动 惊喜盲盒
    self:addHandlerAuto(ProtocolID.GResSpringFestivalGetDataInfo, Promotion091_pb.GResSpringFestivalGetDataInfo, require("src.net.PromotionResponse").setPromotion91BreakEggTurnsData)
    self:addHandlerAuto(ProtocolID.GResSpringFestivalGashaponLottery, Promotion091_pb.GResSpringFestivalGashaponLottery, require("src.net.PromotionResponse").setPromotion91EggReward)
    self:addHandlerAuto(ProtocolID.GResSpringFestivalBoxLottery, Promotion091_pb.GResSpringFestivalBoxLottery, require("src.net.PromotionResponse").setPromotion91BlindBoxReward)

    -- 春日活动
    -- 活动一：春日踏青
    self:addHandlerAuto(ProtocolID.GResSpringOutingGrid, Promotion093_pb.GResSpringOutingGrid, require("src.net.PromotionResponse").handleGetProm93Data)
    self:addHandlerAuto(ProtocolID.GResSpringOutingGridDice, Promotion093_pb.GResSpringOutingGridDice, require("src.net.PromotionResponse").getProm93GridDiceData)
    self:addHandlerAuto(ProtocolID.GResSpringOutingGridScenicReward, Promotion093_pb.GResSpringOutingGridScenicReward, require("src.net.PromotionResponse").getProm93GridScenicRewardData)

    -- 活动二：制作彩蛋
    self:addHandlerAuto(ProtocolID.GResMakeEggScoreInfo, Promotion094_pb.GResMakeEggScoreInfo, require("src.net.PromotionResponse").handleGetProm94Data)
    self:addHandlerAuto(ProtocolID.GResMakeEggExchangeScore, Promotion094_pb.GResMakeEggExchangeScore, require("src.net.PromotionResponse").handleGetProm94ExchangeScore)
    self:addHandlerAuto(ProtocolID.GResMakeEggBox, Promotion094_pb.GResMakeEggBox, require("src.net.PromotionResponse").handleGetProm94Box)
    -- 活动三：春游记
    self:addHandlerAuto(ProtocolID.GResSpringOutingGiftInfo, Promotion095_pb.GResSpringOutingGiftInfo, require("src.net.PromotionResponse").handlePromotion95GetInfo)
    self:addHandlerAuto(ProtocolID.GResSpringOutingGiftBuy, Promotion095_pb.GResSpringOutingGiftBuy, require("src.net.PromotionResponse").handlePromotion95BuyGoods)
    -- 活动四：出游寻春
    self:addHandlerAuto(ProtocolID.GResSpringOutingMissionGetDataInfo, Promotion096_pb.GResSpringOutingMissionGetDataInfo, require("src.net.PromotionResponse").handleGetProm96Data)
    self:addHandlerAuto(ProtocolID.GResSpringOutingMissionGetMission, Promotion096_pb.GResSpringOutingMissionGetMission, require("src.net.PromotionResponse").handleGetProm96MissionDone)
    self:addHandlerAuto(ProtocolID.GResSpringOutingMissionUpdateProcess, Promotion096_pb.GResSpringOutingMissionUpdateProcess, require("src.net.PromotionResponse").handleUpdateProm96Mission)
    self:addHandlerAuto(ProtocolID.GResSpringOutingMissionGetMissionBox, Promotion096_pb.GResSpringOutingMissionGetMissionBox, require("src.net.PromotionResponse").handlegetProm96BoxAward)

    ---五一活动 ----start-------------
    --抽奖活动
    self:addHandlerAuto(ProtocolID.GResLaborDayLuckDrawGetDataInfo, Promotion097_pb.GResLaborDayLuckDrawGetDataInfo, require("src.net.PromotionResponse").handleGetProm97Data)
    self:addHandlerAuto(ProtocolID.GResLaborDayLuckDrawReset, Promotion097_pb.GResLaborDayLuckDrawReset, require("src.net.PromotionResponse").handleGetProm97ResetData)
    self:addHandlerAuto(ProtocolID.GResLaborDayLuckDraw, Promotion097_pb.GResLaborDayLuckDraw, require("src.net.PromotionResponse").handleGetProm97Record) --返回抽奖记录
    self:addHandlerAuto(ProtocolID.GResLaborDayLuckDrawChoice, Promotion097_pb.GResLaborDayLuckDrawChoice, require("src.net.PromotionResponse").handleGetProm97Choice)
    ---------------end----------------


    ---六芒星----start-------------
    self:addHandlerAuto(ProtocolID.GResHeroHexagramReset, HeroHexagram_pb.GResHeroHexagramReset, require("src.net.HeroHexagramResponse").hexagramReset)
    self:addHandlerAuto(ProtocolID.GResHeroHexagramUpgrade, HeroHexagram_pb.GResHeroHexagramUpgrade, require("src.net.HeroHexagramResponse").hexagramUpgrade)
    ---------------end----------------

    ---魔杖----start-------------
    self:addHandlerAuto(ProtocolID.GResHeroMagicWandList, HeroMagicWand_pb.GResHeroMagicWandList, require("src.net.HeroMagicWandResponse").resHeroMagicWandList)
    self:addHandlerAuto(ProtocolID.GResHeroMagicWandOn, HeroMagicWand_pb.GResHeroMagicWandOn, require("src.net.HeroMagicWandResponse").resHeroMagicWandOn)
    self:addHandlerAuto(ProtocolID.GResHeroMagicWandOff, HeroMagicWand_pb.GResHeroMagicWandOff, require("src.net.HeroMagicWandResponse").resHeroMagicWandOff) --返回抽奖记录
    self:addHandlerAuto(ProtocolID.GResMagicWandStrengthen, HeroMagicWand_pb.GResMagicWandStrengthen, require("src.net.HeroMagicWandResponse").resMagicWandStrengthen)
    self:addHandlerAuto(ProtocolID.GResMagicWandBaptism, HeroMagicWand_pb.GResMagicWandBaptism, require("src.net.HeroMagicWandResponse").resMagicWandBaptism)
    self:addHandlerAuto(ProtocolID.GResMagicWandSave, HeroMagicWand_pb.GResMagicWandSave, require("src.net.HeroMagicWandResponse").resMagicWandSave)
    self:addHandlerAuto(ProtocolID.GResMagicWandDecompose, HeroMagicWand_pb.GResMagicWandDecompose, require("src.net.HeroMagicWandResponse").resMagicWandDecompose) --返回抽奖记录
    self:addHandlerAuto(ProtocolID.GResMagicWandBaginfo, HeroMagicWand_pb.GResMagicWandBaginfo, require("src.net.HeroMagicWandResponse").resMagicWandBaginfo)
    ---------------end----------------

    ---英雄重生----start-------------
    self:addHandlerAuto(ProtocolID.GResHeroLevelResetTimes, Hero_pb.GResHeroLevelResetTimes, require("src.net.HeroResponse").updataHeroResetNum)
    self:addHandlerAuto(ProtocolID.GResHeroLevelReset, Hero_pb.GResHeroLevelReset, require("src.net.HeroResponse").heroLevelReset)
    ---------------end----------------

    ---幻魔塔----start-------------
    self:addHandlerAuto(ProtocolID.GResMagicTowerData, MagicTower_pb.GResMagicTowerData, require("src.net.MagicTowerResponse").magicTowerData)
    self:addHandlerAuto(ProtocolID.GResMagicTowerChallenge, MagicTower_pb.GResMagicTowerChallenge, require("src.net.MagicTowerResponse").magicTowerChallenge)
    self:addHandlerAuto(ProtocolID.GResMagicTowerBuyCount, MagicTower_pb.GResMagicTowerBuyCount, require("src.net.MagicTowerResponse").magicTowerBuyCount)
    self:addHandlerAuto(ProtocolID.GResMagicTowerSweep, MagicTower_pb.GResMagicTowerSweep, require("src.net.MagicTowerResponse").magicTowerSweep)
    self:addHandlerAuto(ProtocolID.GResMagicTowerChallengeArena, MagicTower_pb.GResMagicTowerChallengeArena, require("src.net.MagicTowerResponse").magicTowerChallenger)
    self:addHandlerAuto(ProtocolID.GResMagicTowerArenaBro, MagicTower_pb.GResMagicTowerArenaBro, require("src.net.MagicTowerResponse").magicTowerChallengerBrocast)
    self:addHandlerAuto(ProtocolID.GResMagicTowerLevelPassDetail, MagicTower_pb.GResMagicTowerLevelPassDetail, require("src.net.MagicTowerResponse").magicTowerStageLog)
    self:addHandlerAuto(ProtocolID.GResMagicTowerQuery, MagicTower_pb.GResMagicTowerQuery, require("src.net.MagicTowerResponse").magicTowerShowLog)
    self:addHandlerAuto(ProtocolID.GResMagicTowerLevelRank, MagicTower_pb.GResMagicTowerLevelRank, require("src.net.MagicTowerResponse").magicTowerRank)
    self:addHandlerAuto(ProtocolID.GResMagicTowerRoadInfo, MagicTower_pb.GResMagicTowerRoadInfo, require("src.net.MagicTowerResponse").magicTowerRoadInfo)
    self:addHandlerAuto(ProtocolID.GResMagicTowerRoadReceive, MagicTower_pb.GResMagicTowerRoadReceive, require("src.net.MagicTowerResponse").magicTowerRoadInfoReward)
    ---------------end----------------


    --英雄永久皮肤
    self:addHandlerAuto(ProtocolID.GResHeroSkinList, HeroSkinShop_pb.GResHeroSkinList, require("src.net.HeroResponse").resheroSkinList)


    if ctr then
        ctr:registerResponse(self)
    end
end

-- [[函数用于添加网络数据监听功能 --]]
function ResponseManager:addHandler(protocol_id, acceptor, handler)
    if self.map_response[tonumber(protocol_id)] ~= nil then
        print("!!! protocol_id:", protocol_id, " response message register repeat!!!")
    end

    if protocol_id == nil then return end 
    self.map_response[tonumber(protocol_id)] = {}
    self.map_response[tonumber(protocol_id)].protocol_id = tonumber(protocol_id)
    self.map_response[tonumber(protocol_id)].acceptor = acceptor
    self.map_response[tonumber(protocol_id)].handler = handler
end

-- [[函数用于添加网络数据监听功能 --]]
function ResponseManager:addHandlerAuto(protocol_id, acceptor, handler)
    if not protocol_id then 
        print("protocol_id not found", debug.traceback())
        return
    end 

    if self.map_response[tonumber(protocol_id)] ~= nil then
        print("!!! protocol_id:", protocol_id, " response message register repeat!!!")
        return
    end

    self.map_response[tonumber(protocol_id)] = {}
    self.map_response[tonumber(protocol_id)].protocol_id = tonumber(protocol_id)
    self.map_response[tonumber(protocol_id)].acceptor = acceptor
    self.map_response[tonumber(protocol_id)].handler = handler
    self.map_response[tonumber(protocol_id)].auto = true
end


function ResponseManager:response(byte_array)
    local protocol = byte_array:readInt()
    local info = self.map_response[tonumber(protocol)]
    if type(info) ~= "function" then
        self:responseHandle(byte_array)
    else
        self.map_response[tonumber(protocol)](nil, byte_array)
    end
end

function ResponseManager:responseHandle(byte_array)
    byte_array:resetPos()
    local protocol = byte_array:readInt()
	local acceptor = self.map_response[tonumber(protocol)].acceptor()
    local data = byte_array:readByteArray(4, byte_array:getLength() - 4)
    print(">>>>>ParseFromString:", protocol)
    acceptor:ParseFromString(data)

    local res = self.map_response[tonumber(protocol)]
    if res.auto == true then
        local tab = {}
        generator_protobuf_raw_table(acceptor, tab)
        res.handler(nil,  tab, byte_array)
    else
        res.handler(nil, acceptor, byte_array)
    end
end

function ResponseManager:registerResponse()
    -- 将C++的接口修改掉
    for key, value in pairs(self.map_response) do
        cpp.ResponseManager:instance():addLuaResponse(key)
    end
end

function ResponseManager:clear()
    self.map_response = {}
end

return ResponseManager
