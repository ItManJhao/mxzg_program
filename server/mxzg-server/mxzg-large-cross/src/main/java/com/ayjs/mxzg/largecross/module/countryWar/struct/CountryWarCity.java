package com.ayjs.mxzg.largecross.module.countryWar.struct;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 * @Author: CWJ
 * @Date: 2021/4/13
 **/
@Getter
@Setter
public class CountryWarCity {
    @Column(name = "id", comment = "城市标识")
    private int id;
    @Column(name = "defend_rid", comment = "防守玩家")
    private ConcurrentMap<Long, Integer> defendRid = new ConcurrentHashMap<>();
    @Column(name = "defend_count", comment = "防守次数")
    private ConcurrentMap<Long, Integer> defendCount = new ConcurrentHashMap<>();
    @Column(name = "last_reward_time", comment = "奖励时间")
    private LocalDateTime lastRewardTime = LocalDateTime.of(1970, 1, 1, 0, 0);
    @Column(name = "server_id", comment = "所属服务器")
    private int serverId;
    /***
     * 是否是孤立状态
     */
    private boolean isolate;

    private LocalDateTime battleTime;

    private LocalDateTime occupyTime;

    public void removeDefend(long rid) {
        defendRid.remove(rid);
        defendCount.remove(rid);
    }


}
