package com.ayjs.mxzg.message.module.crusadegroup.map.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ChallengeRecord implements Comparable<ChallengeRecord>{

    private long rid;
    private String nick;
    private int serverId;
    private int head_id; //头像id
    private int border_id; //头像框id
    private int level;  //等级
    private long totalDamage;   //伤害
    private String battleId;    //战报id

    @Override
    public int compareTo(ChallengeRecord o) {
        return Long.compare(o.getTotalDamage(), this.totalDamage);
    }
}
