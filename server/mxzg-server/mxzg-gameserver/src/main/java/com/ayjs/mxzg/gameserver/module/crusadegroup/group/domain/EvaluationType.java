package com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain;

import com.ayjs.mxzg.config.excel.constant.CrusadeGroupConst;

/**
 * 评价
 */
public enum  EvaluationType {

    /** 无 */
    NONE {
        @Override
        public boolean check(int fightRatio) {
            return false;
        }
    },

    /** 简单 */
    SIMPLE {
        @Override
        public boolean check(int fightRatio) {
            return fightRatio > 10000 + CrusadeGroupConst.EVALUATION_FIGHT_RATIO;
        }
    },

    /** 势均力敌 */
    EVENLY_MATCHED {
        @Override
        public boolean check(int fightRatio) {
            return fightRatio < 10000 + CrusadeGroupConst.EVALUATION_FIGHT_RATIO && fightRatio > 10000 - CrusadeGroupConst.EVALUATION_FIGHT_RATIO;
        }
    },

    /** 困难 */
    DIFFICULT {
        @Override
        public boolean check(int fightRatio) {
            return fightRatio < 10000 - CrusadeGroupConst.EVALUATION_FIGHT_RATIO;
        }
    },
    ;

    /**
     * 检测是否符合当前比例
     * @param fightRatio 万分比
     * @return
     */
    public abstract boolean check(int fightRatio);
}
