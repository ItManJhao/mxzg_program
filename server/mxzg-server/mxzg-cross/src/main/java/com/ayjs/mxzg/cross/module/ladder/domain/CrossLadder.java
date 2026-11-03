package com.ayjs.mxzg.cross.module.ladder.domain;


import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

@Entity
@Table(name = "cross_ladder", comment = "跨服天梯")
@Getter
@Setter
public class CrossLadder extends AbstractEntity {
    @Id
    @Column(name = "id", comment = "主键ID")
    private int groupId;

    @Column(name = "ranks", comment = "排名数据")
    private CopyOnWriteArrayList<CrossLadderData> ranks;

    /**
     * 默认排序为0
     *
     * @param rid
     * @return
     */
    public int getRank(long rid) {
        int rank = 0;
        Iterator<CrossLadderData> iterator = ranks.iterator();
        while (iterator.hasNext()) {
            CrossLadderData data = iterator.next();
            if (data.getRid() == rid) {
                rank = data.getRank();
                break;
            }
        }
        return rank;
    }

    /**
     * 不在排行榜中返回空
     *
     * @param rid
     * @return
     */
    public CrossLadderData getCrossLadderData(long rid) {
        Iterator<CrossLadderData> iterator = ranks.iterator();
        CrossLadderData ladderData = null;
        while (iterator.hasNext()) {
            CrossLadderData data = iterator.next();
            if (data.getRid() == rid) {
                ladderData = data;
                break;
            }
        }
        return ladderData;
    }

    public List<CrossLadderData> getCrossLadderData(Collection<Long> rids) {
        List<CrossLadderData> list = new ArrayList<>();
        if (CollectionUtil.isEmpty(rids)) {
            return list;
        }
        Iterator<CrossLadderData> iterator = ranks.iterator();
        while (iterator.hasNext()) {
            CrossLadderData data = iterator.next();
            if (rids.contains(data.getRid())) {
                list.add(data);
            }
            if (rids.size() == list.size()) {
                break;
            }
        }
        return list;
    }
}
