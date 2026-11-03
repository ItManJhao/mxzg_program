package com.ayjs.mxzg.gameserver.module.dungeon.struct;

/**
 * 庇护所队伍英雄实体类
 */
public class DungeonHeroLineupHp {

    private long herdId;

    private long nowHp;

    private long maxHp;

    private int index;//英雄索引(位置)

    public long getHerdId() {
        return herdId;
    }

    public void setHerdId(long herdId) {
        this.herdId = herdId;
    }

    public long getNowHp() {
        return nowHp;
    }

    public void setNowHp(long nowHp) {
        this.nowHp = nowHp;
    }

    public long getMaxHp() {
        return maxHp;
    }

    public void setMaxHp(long maxHp) {
        this.maxHp = maxHp;
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }
}
