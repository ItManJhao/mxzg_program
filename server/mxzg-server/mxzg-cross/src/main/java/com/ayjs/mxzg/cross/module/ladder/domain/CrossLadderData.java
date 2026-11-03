package com.ayjs.mxzg.cross.module.ladder.domain;

import lombok.Getter;
import lombok.Setter;

import java.util.Objects;

/**
 * 天梯排名数据
 */
@Getter
@Setter
public class CrossLadderData {
    /**
     * 角色数据
     */
    private long rid;
    /**
     * 排名
     */
    private int rank;
    /**
     * 服务器id
     */
    private int sid;
    /**
     * 是否机器人，false机器人，true真人
     */
    private boolean reallyPlayer;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CrossLadderData that = (CrossLadderData) o;
        return rid == that.rid;
    }

    @Override
    public int hashCode() {
        return Objects.hash(rid);
    }
}
