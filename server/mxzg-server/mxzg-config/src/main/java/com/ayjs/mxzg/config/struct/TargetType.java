package com.ayjs.mxzg.config.struct;

import com.ayjs.mxzg.common.util.Asserts;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2019/10/26
 **/
public enum TargetType {

    /**
     * 通关主线
     */
    PASS_MAIN_LEVEL(1, 1),

    /**
     * 工会捐献
     */
    CLAN_DONATE(2, 1),
    /**
     * 召唤CLAN_DONATE
     */
    SUMMON(3, 1),
    /**
     * 幻境之塔
     */
    TOWER_LEVEL(4, 0),
    /**
     * 竞技场挑战
     */
    ARENA_CHALLENGE(5, 1),
    /**
     * 合成英雄
     */
    COMBINE_HERO(6, 1),
    /**
     * 获得英雄
     */
    GET_HERO(7, 1),
    /**
     * 完成酒馆任务
     */
    COMPLETE_TAVERN_TASK(8, 1),
    /**
     * 完成酒馆星际任务以上
     */
    COMPLETE_TAVERN_TASK_STAR_HIGH(9, 1) {
        @Override
        protected JudgeType getConditionJudge() {
            return JudgeType.MORE_THAN;
        }
    },
    /**
     * 接取酒馆任务
     */
    ACCEPT_TAVERN_TASK(10, 1),
    /**
     * 接取酒馆任务
     */
    ACCEPT_TAVERN_TASK_STAR_HIGH(11, 1) {
        @Override
        protected JudgeType getConditionJudge() {
            return JudgeType.MORE_THAN;
        }
    },
    /**
     * 刷新酒馆任务
     */
    REFRESH_TAVERN_TASK(12, 1),
    /**
     * 解锁羁绊女神
     */
    UNLOCK_GODDESS(13, 1),
    /**
     * 升级女神
     */
    GODDESS_LEVEL_UP(14, 1),
    /**
     * 女神升级到某个等级
     */
    GODDESS_LEVEL(15, 1),
    /**
     * 冒险等级(角色等级)
     */
    ADVENTURE_LEVEL(16, 0),
    /**
     * 合成装备
     */
    COMBINE_EQUIP(17, 1),
    /**
     * 许愿
     */
    WISH(18, 1),
    /**
     * 试炼层数
     */
    ADVEN_LEVEL(19, 1),
    /**
     * 通关试炼
     */
    PASS_ADVEN(20, 1),
    /**
     * 拥有英雄
     */
    HAD_HIGH_STAR_HERO(21, 1),
    /**
     * 拥有英雄
     */
    HAD_HIGH_LEVEL_HERO(22, 1),
    /**
     * 合成精灵
     */
    COMBINE_RUNE(23, 1),
    /**
     * 洗练精灵
     */
    WASH_RUNE(24, 1),

    /**
     * 快速作战
     */
    QUICK_BATTLE(25, 1),
    /**
     * 先知召唤
     */
    PROPHECY(26, 1),
    /**
     * 好友赠送
     */
    FRIEND_GIFT(27, 1),
    /**
     * 通关幻境之塔或扫荡
     */
    TOWER_CHALLENGE(28, 1),
    /**
     * 参加日常副本
     */
    DAILY_DUNGEON_CHALLENGE(29, 1),
    /**
     * 登录
     */
    LOGIN(30, 1),

    /**
     * 公会副本挑战
     */
    CHALLENGE_CLAN_DUNGEON(31, 1),

    /**
     * 好友数量
     */
    FRIEND_NUM(32, 1),

    /***
     * 获得品质装备
     */
    GET_EQUIP_QUALITY(33, 1),

    /***
     * 竞技场分数
     *
     */
    ARENA_SCORE(34, 1),

    /**
     * 竞技场排名
     */
    ARENA_MAX_RANK(35, 1) {
        @Override
        protected JudgeType getConditionJudge() {
            return JudgeType.LESS_THAN;
        }

        @Override
        public boolean needInit() {
            return true;
        }
    },

    /**
     * 英雄置换
     */
    HERO_SWAP(37, 1),

    /**
     * 历史最高战力
     */
    ROLE_MAX_FIGHTING(38, 0),

    /***
     * 商品购买
     */
    SHOP_BUY(39, 1),

    /**
     * 加入公会
     */
    JOIN_CLAN(40, 1),

    /***
     * 献祭英雄
     */
    SACRIFICE(41, 1),

    /**
     * 公会击杀副本boss
     */
    BEAT_CLAN_DUNGEON(42, 1),

    /**
     * 获得新英雄
     */
    GET_NEW_HERO(43, 0),

    /**
     * 玩家总充值
     */
    TOTAL_RECHARGE(44, 0),

    /**
     * 公会技能升级
     */
    CLAN_SKILL_LEVEL_UP(45, 1),

    /**
     * 永恒梦境挑战次数
     */
    INFINITE_CHALLENGE(46, 1),

    /**
     * 获得日活跃
     */
    DAY_ACTIVE(47, 1),

    /**
     * 钻石获得
     */
    GEM_GAIN(48, 1),

    /**
     * 钻石消耗
     */
    GEM_CONSUME(49, 1),

    /**
     * 金币消耗
     */
    GOLD_CONSUME(50, 1),

    /**
     * 英雄经验消耗
     */
    HERO_EXP_CONSUME(51, 1),

    /**
     * 赢得1次竞技场
     */
    ARENA_CHALLENGE_WIN(52, 1),

    /**
     * 庇护所击杀守卫
     */
    SHELTER_KILL(53, 1),

    /**
     * 庇护所使用药剂
     */
    SHELTER_MEDICINE(54, 1),
    /**
     * 完成指定类型副本
     */
    DUNGEON_CHALLENGE(55, 1),

    /**
     * 勇者试炼获得宝箱
     */
    ADVEN_GEM_BOX(56, 1),
    /**
     * 激活新皮肤
     */
    GET_NEW_FASHION(57, 1),

    /**
     * 神职等级
     */
    CLERGY_LEVEL(58, 0),

    /**
     * 挑战世界BOSS
     */
    CHALLENGE_WORLD_BOSS(59, 1),

    /**
     * 玩家充值
     */
    RECHARGE(60, 1),

    /**
     * 永恒梦镜通过第几层
     */
    INFINITE_LEVEL(61, 0),

    /**
     * 点金
     */
    BUY_GOLD(62, 0),

    /**
     * 历史最高段位
     */
    STAGE_MATCH_LAST(63, 0),

    /**
     * 消耗道具
     */
    CONSUME_ITEM(64, 0),

    /**
     * 国战随机商城
     */
    COUNTRY_WAR_RANDOM_BUY(65, 0),

    /***
     * 获得道具
     */
    ADD_ITEM(66, 0),

    /***
     * 占领城池
     */
    COUNTRY_WAR_OCCUPY(67, 0),

    /***
     * 进攻成功
     */
    COUNTRY_WAR_ATTACK_SUCC(68, 0),

    /***
     * 防守成功
     */
    COUNTRY_WAR_DEFEND_SUCC(69, 0),

    /***
     * 消耗攻击令
     */
    COUNTRY_WAR_ATTACK(70,0),
    /***
     * 消耗迁移令
     */
    COUNTRY_WAR_MOVE(71,0),

    //***************************（讨伐团）职级任务1000-

    /**
     * 占领领土
     */
    OCCUPATION_LAND_HOLD(1000, 0),

    /**
     * 开垦土地
     */
    OCCUPATION_LAND_OPEN(1001, 0),

    /**
     * 获得精华
     */
    OCCUPATION_JINGHUA_GET(1002, 0),

    /**
     * 获得神兵
     */
    OCCUPATION_SHENBIN_GET(1003, 0),

    /**
     * 神兵核心升级
     */
    OCCUPATION_SHENBINCORE_UP(1004, 0),

    /**
     * boss伤害
     */
    OCCUPATION_BOSS_HURT(1005, 0),

    /**
     * 击杀boss
     */
    OCCUPATION_BOSS_KILL(1006, 0),
    ;

    private int value;
    /***
     * 是否入库
     */
    private int saveDb;

    TargetType(int value, int saveDb) {
        this.value = value;
        this.saveDb = saveDb;
    }

    public int getValue() {
        return value;
    }

    /***
     * 创建的时候是否根据玩家自身状态赋值初始化
     * @return
     */
    public boolean needInit() {
        return false;
    }

//    public TargetType dbType() {
//        return this;
//    }
//
//    public void updateEntity(Object o) {
//
//    }

    public boolean isSaveDb() {
        return saveDb == 1;
    }

    protected JudgeType getConditionJudge() {
        return JudgeType.EQUAL;
    }

    protected JudgeType getSubConditionJudge() {
        return JudgeType.EQUAL;
    }

    /***
     * 检测参数是否满足条件
     * @param targetStruct
     *
     * @param condition
     * @param subCondition
     * @return
     */
    public boolean check(TargetStruct targetStruct, int condition, int subCondition) {
        if (targetStruct.getType() != this)
            return false;
        //condition未0时，代表不计算这个条件
        if (targetStruct.getCondition() != 0 && !getConditionJudge().check(condition, targetStruct.getCondition())) {
            return false;
        }
        //subCondition，代表不计算这个条件
        if (targetStruct.getSubCondition() != 0 && !getSubConditionJudge().check(condition, targetStruct.getCondition()))
            return false;
        return true;
    }

    private static Map<Integer, TargetType> VALUE_MAP = new HashMap<>();

    static {
        for (TargetType type : TargetType.values()) {
            TargetType old = VALUE_MAP.put(type.getValue(), type);
            Asserts.isNull(old, String.format("相同的枚举值：{%s}-{%s}", old, type));
        }
    }

    public static TargetType getType(int value) {
        return VALUE_MAP.get(value);
    }

    public static boolean checkStruct(TargetStruct targetStruct, int condition, int subCondition) {
        return targetStruct.getType().check(targetStruct, condition, subCondition);
    }

    /***
     * 判定是否触发该目标
     * @param target
     * @param triggerTarget
     * @return
     */
    public static boolean checkTrigger(TargetStruct target, TargetStruct triggerTarget) {
        if (target.getType() != triggerTarget.getType()) {
            return false;
        }
        return target.getType().check(target, triggerTarget.getCondition(), triggerTarget.getSubCondition());
    }

    public enum JudgeType {

        EQUAL {
            @Override
            public boolean check(int value1, int value2) {
                return value1 == value2;
            }
        },
        MORE_THAN {
            @Override
            public boolean check(int value1, int value2) {
                return value1 > value2 || value1 == value2;
            }
        },
        LESS_THAN {
            @Override
            public boolean check(int value1, int value2) {
                return value1 < value2 || value1 == value2;
            }
        },
        ;

        public abstract boolean check(int value1, int value2);

    }
}
