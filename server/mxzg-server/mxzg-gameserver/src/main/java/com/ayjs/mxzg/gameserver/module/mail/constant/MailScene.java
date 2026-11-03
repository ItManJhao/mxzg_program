/**
 *
 */
package com.ayjs.mxzg.gameserver.module.mail.constant;

/**
 * @author YY
 *
 */
public enum MailScene {

    XU_YUAN_DA_BIAO(		1, "许愿达标补发奖励"),
    ZHAO_HUAN_SHUI_JING(	2, "召唤水晶补发奖励"),
    HE_CHENG_JUE_XING(		3, "合成觉醒补发奖励"),
    JIU_GUAN_DA_BIAO(		4, "酒馆达标补发奖励"),
    DIAN_SHI_CHENG_JIN(		5, "点石成金补发奖励"),
    SHI_LIAN_ZHI_LU(		6, "试炼之路补发奖励"),
    SU_ZHAN_ZHI_WANG(		7, "速战之王补发奖励"),
    JIU_GUAN_CHANG_KE(		8, "酒馆常客补发奖励"),
    DIAN_SHI_CHENG_JIN_RANK(9, "点石成金排行奖励"),
    SHI_LIAN_ZHI_LU_RANK(	10, "试炼之路排行奖励"),
    SU_ZHAN_ZHI_WANG_RANK(	11, "速战之王排行奖励"),
    JIU_GUAN_CHANG_KE_RANK(	12, "酒馆常客排行奖励"),
    CLAN_DUNGEON_BOSS(		13, "公会副本BOSS击杀奖励"),
	CLAN_DUNGEON_BOSS_RANK(	14, "公会副本伤害排行榜奖励"),
    XIAN_ZHI_KUI_ZENG(		15, "先知馈赠补发奖励"),
    MAO_XIAN_RI_JI_LEVEL(	16, "冒险日记等级补发奖励"),
    MAO_XIAN_RI_JI_RECHARGE(17, "冒险日记累充补发奖励"),
    SHEN_MI_MO_HE_LEVEL(	18, "神秘魔盒等级补发奖励"),
    SHEN_MI_MO_HE_RECHARGE(	19, "神秘魔盒累充补发奖励"),
    ZHAO_HUAN_DA_BIAO(		20, "召唤达标补发奖励"),
    JING_JI_ZHI_DIAN(		21, "竞技之巅补发奖励"),
    KUANG_HUAN_SHI_KE(		22, "狂欢时刻补发奖励"),
    LEI_JI_CHONG_ZHI(		23, "累计充值"),
    YING_XIONG_JIANG_LIN(	24, "英雄降临补发奖励"),
    CWB_CLAN_RANK(			25, "世界boss军团排名奖励"),
    CWB_ROLE_RANK(			26, "世界boss个人排名奖励"),
    MONTH_CARD(				27, "月卡到期未领取奖励补发"),
    BEST_MONTH_CARD(		28, "至尊月卡到期未领取奖励补发"),
    INVEST_128_GAIN(		29, "128投资基金到期未领取奖励补发"),
    INVEST_328_GAIN(		30, "328投资基金到期未领取奖励补发"),
    PVP_DAILY_REWARD(		31, "竞技场每日排行榜结算奖励"),
    PVP_SEASON_REWARD(		32, "竞技场每赛季排行榜结算奖励"),
    CLAN_WAR_WIN(			33, "公会战胜利全体奖励邮件"),
    CLAN_WAR_LOSE(			34, "公会战失败全体奖励邮件"),
    JIE_RI_HAO_LU(          35, "节日豪礼未领取奖励邮件补发"),
    DREAMLAND_RANK_REWARD(  36, "永恒梦境排名奖励"),

    LADDER_RANK(  		    37, "天梯"),
    CHAMPION_RANK(  		38, "冠军赛排名奖励邮件"),

    ONLINE_REWARD(          39, "累积在线月卡奖励补发"),

    RAINBOW_LOSS(          	40, "彩虹圣殿被挑战失去控制权"),
    RAINBOW_END(          	41, "彩虹圣殿到时失去控制权"),
    ADVEN_BE_SELECT(        42, "勇者试炼支援被选择的奖励"),

    JI_TIAN_HAO_LI(			43, "积天豪礼 未领取自动发邮件"),
    CHAMPION_COIN(			44, "冠军赛竞猜币兑换邮件"),

    CHAMPION_CROSS_RANK(  	45, "跨服冠军赛排名奖励邮件"),
    CHAMPION_CROSS_COIN(  	46, "跨服冠军赛竞猜币兑换邮件"),

    GOD_EQUIP_PRIVILEGE(    47,"神装特权未领奖励邮件"),
    TEAM_ARENA_APPLY_PASS(  48,"组队竞技场入队申请被通过"),
    TEAM_ARENA_TEAM_NUM_MAX(49,"组队竞技场队伍满员"),
    TEAM_ARENA_RANK(        50,"组队竞技场排名奖励"),
    WEEKS_CARD_REWARD(      51,"周卡奖励"),
    JI_TIAN_HAO_LI2(	    52, "积天豪礼 未领取自动发邮件"),
    STAGE_TOKEN_REWARD(	    54, "超凡段位赛战令补发"),
    NEW_HERO_ROLLING(	    55, "新英雄抽卡补发"),
    FLOATING_ISLANDS_DMG(       56,"浮空岛输出达标奖励"),
    FLOATING_ISLANDS_RANK_REWARD(57,"浮空岛排名奖励奖励"),
    STAGE_MATCH_REWARD(	    58, "段位赛结算奖励"),
    STAGE_MATCH_RANK(	    59, "段位赛排名奖励"),
    WEEKEND_KOI(            60,"锦鲤大奖"),
    SPACE_TIME_TREASURE(	61,"时空异宝"),
    TIME_TOWER(				62,"时空魔塔"),
    CREATE_MAIL_REWARD1(63,"创角邮件奖励1"),
    CREATE_MAIL_REWARD2(64,"创角邮件奖励2"),
    PINNACLE_RANK(65, "巅峰赛排名奖励"),
    PINNACLE_COIN(66, "巅峰赛竞猜奖励"),
    TEAM_ARENA_CHALLENGE_REWARD(67, "组队竞技场挑战奖励"),
    PLANE_WAR_RANK(68, "位面之战通关数排名奖励"),
    PROMOTION_048(69, "48活动邮件奖励"),
    MERGE_ROLE(70, "合服玩家改名卡"),
    MERGE_CLAN(71, "合服公会改名卡"),
    PROMOTION_084(72, "三日累充"),
    PROMOTION_092_COUNT_RANK(73, "献花次数排名奖励"),
    PROMOTION_092_HERO_SCORE_RANK(74, "英雄积分排名奖励"),

    COUNTRY_WAR_SCORE(81,"积分榜"),
    COUNTRY_WAR_HERO(82,"英雄榜"),
    COUNTRY_WAR_KILL(83,"击杀榜"),
    COUNTRY_WAR_DAMAGE(84,"伤害榜"),
    COUNTRY_WAR_MATCH_FAIL(85,"国战轮空补偿"),

    HAPPY_TIME_REPAIR_DATA_MAIL(998, "狂欢时刻数据维护奖励"),
    SYS_MAIL(				999, "系统邮件")

    ;

    private final int id;
    private final String remark;

    private MailScene(int id, String remark) {
        this.id = id;
        this.remark = remark;
    }

    public int getId() {
        return id;
    }

    public String getRemark() {
        return remark;
    }
}
