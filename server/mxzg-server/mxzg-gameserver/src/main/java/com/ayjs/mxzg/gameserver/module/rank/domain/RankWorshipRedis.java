package com.ayjs.mxzg.gameserver.module.rank.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import lombok.Data;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;

/**
 * @Author: CWJ
 * @Date: 2019/10/16
 **/
@Table(name = "rank_worship_redis")
@Entity
@Data
public class RankWorshipRedis extends AbstractEntity {
    @Id
    @Column(name = "rid")
    private long rid;
    @Column(name = "worship_types", comment = "膜拜类型")
    private CopyOnWriteArraySet<Integer> worshipTypes = new CopyOnWriteArraySet<>();
    @Column(name = "worship_time", comment = "膜拜时间")
    private int worshipTime;
    @Column(name = "count", comment = "被膜拜次数")
    private int count;
    @Column(name = "be_worship_record", comment = "离线时，被膜拜记录")
    private Map<Integer, CopyOnWriteArraySet<Long>> beWorshipRecord = new ConcurrentHashMap<>();
    @Column(name = "be_worship_time", comment = "膜拜时间")
    private int beWorshipTime;

    public void addWorship(int type) {
        worshipTypes.add(type);
    }

    public void addBeWorshipRecordOffline(int type, long worshipId) {
        CopyOnWriteArraySet<Long> beWorshipSet = beWorshipRecord.get(type);
        if (beWorshipSet == null) {
            beWorshipSet = new CopyOnWriteArraySet<>();
            beWorshipRecord.put(type, beWorshipSet);
        }
        beWorshipSet.add(worshipId);
        beWorshipTime = TimeDateUtil.getCurrentTimeInt();
    }


}
