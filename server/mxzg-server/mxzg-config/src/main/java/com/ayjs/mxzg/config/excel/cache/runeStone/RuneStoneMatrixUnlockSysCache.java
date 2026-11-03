package com.ayjs.mxzg.config.excel.cache.runeStone;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.runeStone.CRuneStoneMatrixUnlock;

/**
 * 符石阵法解锁
 * @Author: CWJ
 * @Date: 2020/7/29
 **/
public class RuneStoneMatrixUnlockSysCache extends BaseExcelCache<CRuneStoneMatrixUnlock> {

    @Override
    public String getFileName() {
        return "runestonematrixunlock";
    }
}
