package com.ayjs.mxzg.gameserver.module.role.constant;

import com.ayjs.mxzg.gameserver.module.role.domain.RoleParam;
import com.google.common.collect.ImmutableMap;

import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * 角色参数类型
 */
public enum RoleParamType {


    /**
     * 七日签到的数据(测试)
     */
    SEVEN_SIGN_DATA(1),

    /**
     * 羁绊重置次数
     */
    GODDESS_RESET(2),

    /**
     * 下一次允许加入公会时间
     */
    QUIT_CLAN_TIME(5),

    /**
     * 最后一次拉取系统邮件的时间
     */
    MAIL_LAST_TIME(6),

    /***
     * 英雄降临激活时间
     */
    HERO_ARRIVE_ACTIVE_TIME(7),

    /***
     * 聊天阅读时间
     */
    CHAT_READ_TIME(8),
    /**
     * 玩家评论和分享数据
     */
    ROLE_COMMENT_SHARED(9),

    /**
     * 七日目标登天天数计数时间
     */
    SEVEN_DAY_COUNT_TIME(10),



    ;

    private final int value;

    private static final Map<Integer, RoleParamType> ENUMS = Stream.of(values()).collect(
            Collectors.collectingAndThen(Collectors.toMap(RoleParamType::getValue, Function.identity()),
                    ImmutableMap::copyOf));

    RoleParamType(int value) {
        this.value = value;
    }

    public int getValue() {
        return this.value;
    }

    public static RoleParamType valueOf(int roleParam) {
        return ENUMS.get(roleParam);
    }

    public static void main(String args[]) {
        Map<String, String> map = new HashMap<>();
        map.put(1 + "", 1 + "");
        RoleParam roleParam = new RoleParam();
        roleParam.saveJson(map);
        System.out.println(roleParam.getRpValue());
        Map map_ = roleParam.parseJson(Map.class);
        map_.put(1 + "", 2 + "");
        System.out.println(map_);
    }
}
