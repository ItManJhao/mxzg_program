package com.ayjs.mxzg.gameserver.module.hero.struct;

/**
 * 英雄皮肤
 */
public class FashionData {

    private int fashionId;

    private int level;

    /**
     * 激活途径 0为永久激活，1为期限激活
     */
    private int status;

    /**
     * 到期时间
     */
    private int timeLimit;

    public int getLevel() {
        return level;
    }

    public int getFashionId() {
        return fashionId;
    }

    public void setFashionId(int fashionId) {
        this.fashionId = fashionId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getTimeLimit() {
        return timeLimit;
    }

    public void setTimeLimit(int timeLimit) {
        this.timeLimit = timeLimit;
    }

    public void setLevel(int level) {
        this.level = level;
    }
}
