package com.ayjs.mxzg.common.persistence;


import com.ayjs.mxzg.common.util.RandomUtil;

import java.time.LocalDateTime;

/**
 * 抽象数据实体
 */
public abstract class AbstractEntity {

    private volatile long _last_modified = 0L;

    public void setLastModifiedTimestamp() {
        if (_last_modified == 0) {
            //临时方案，零点数据库峰值太大，延迟update入库时间[00:00 到 00:03]分数据延迟几分钟入库
            LocalDateTime localDateTime = LocalDateTime.now();
            int minute = localDateTime.getMinute();
            int millis = 0;
            if (localDateTime.getHour() == 0 && minute <= 5) {
                if (minute <= 1) {
                    // 前三分钟数据，随机到1-6分钟内
                    millis = RandomUtil.rand(10000, 360000);
                } else {
                    // 第四分-第六分钟数据随机到后面三分钟
                    millis = RandomUtil.rand(240000, 420000);
                }
            }
            _last_modified = System.currentTimeMillis() + millis;
        }
    }

    public boolean isNeedSave(long delay, boolean force) {
        if (!force) {
            if (_last_modified == 0)
                return false;
            if (_last_modified + delay < System.currentTimeMillis()) {
                _last_modified = 0;
                return true;
            } else
                return false;
        } else {
            if (_last_modified != 0) {
                _last_modified = 0;
                return true;
            }
            return false;
        }
    }
}
