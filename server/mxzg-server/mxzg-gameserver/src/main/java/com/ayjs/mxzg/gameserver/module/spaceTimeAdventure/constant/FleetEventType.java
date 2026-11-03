package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant;

import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.template.constant.ErrorCode;

import java.util.HashMap;
import java.util.Map;

/**
 * 航行事件
 *
 * @author hyx
 */
public enum FleetEventType {

    /**
     * 舰队残骸事件
     */
    JIAN_DUI_CAN_HAI(101,1,"舰队残骸",0),
    /**
     * 舰队残骸（怪物）事件
     */
    WEI_ZHI_GUAI_WU(102,1,"舰队残骸（怪物）",0),
    /**
     * 其他舰队事件
     */
    QI_TA_JIAN_DUI(103,1,"其他舰队",0),
    /**
     * 隐藏航线事件
     */
    YIN_CANG_HANG_XIAN(104,1,"隐藏航线",0),
    /**
     * 风暴降临
     */
    FENG_BAO_JIANG_LIN(105,1,"风暴降临",0),
    /**
     * 土著商人事件
     */
    TU_ZHU_SHANG_REN(106,0,"土著商人",0),
    /**
     * 搁浅舰队
     */
    GE_QIAN_JIAN_DUI(107,1,"搁浅舰队",0),
    /**
     * 天降宝箱
     */
    TIAN_JIANG_BAO_XIANG(108,1,"天降宝箱",0),
    /**
     * 什么事都没发生
     */
    MAI_YOU_SHI_JIAN(109,0,"啥也没有",0),

    /**
     * 航线礼包
     */
    HANG_XIAN_LI_BAO(110,0,"航线礼包",1),

    /**
     * 疾风之力
     */
    JI_FENG_ZHI_Li(111,1,"疾风之力",1),
    ;
    private int eventId;
    /**
     * 0不执行。1要执行
     */
    private int is_executor;

    /**
     * 事件描述
     */
    private String desc;

    /**
     * 一次航行只能遭遇一次，1是，0否
     */
    private int unique;

    public int getUnique() {
        return unique;
    }

    public int getEventId() {
        return eventId;
    }

    public int getIs_executor() {
        return is_executor;
    }

    public String getDesc() {
        return desc;
    }

    FleetEventType(int eventId, int is_executor,String desc, int unique) {
        this.eventId = eventId;
        this.is_executor = is_executor;
        this.desc = desc;
        this.unique = unique;
    }

    private static Map<Integer, FleetEventType> typeMap = new HashMap<>();

    static {
        for (FleetEventType type : FleetEventType.values()) {
            typeMap.put(type.getEventId(), type);
        }
    }

    public static FleetEventType valueOf(int eventId) {
        FleetEventType fleetEventType = typeMap.get(eventId);
        Asserts.notNull(fleetEventType, ErrorCode.SPACE_TIME_FLEET_EVENT_NULL.getValue(), String.format("航行事件类型不存在{%s}", eventId));
        return fleetEventType;
    }

}
