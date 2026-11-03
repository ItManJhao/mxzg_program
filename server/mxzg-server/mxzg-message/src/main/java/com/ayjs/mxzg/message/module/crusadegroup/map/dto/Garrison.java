package com.ayjs.mxzg.message.module.crusadegroup.map.dto;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

/**
 * npc驻军信息
 */
@Getter
@Setter
@AllArgsConstructor
public class Garrison {
    private int hero_type = 1;   // 英雄类型
    private int star = 2;        // 星际
    private int level = 3;       // 等级
    private long hp = 4;          // 当前血量
    private long max_hp = 5;      // 最大血量
    private int position = 6;    // 位置

    public static Garrison valueOf(int hero_type, int star, int level, long hp, long max_hp, int position){
        return new Garrison(hero_type, star, level, hp, max_hp, position);
    }
}
