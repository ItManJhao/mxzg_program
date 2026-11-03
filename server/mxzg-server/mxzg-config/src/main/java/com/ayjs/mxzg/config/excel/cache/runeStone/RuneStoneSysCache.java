package com.ayjs.mxzg.config.excel.cache.runeStone;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.runeStone.CRuneStone;

/**
 * @Author: CWJ
 * @Date: 2020/7/29
 **/
public class RuneStoneSysCache extends BaseExcelCache<CRuneStone> {

    @Override
    public String getFileName() {
        return "runestone";
    }

    public CRuneStone getByIntensify(int kind, int quality, int intensify) {
        return getAll().stream().filter(config -> config.getQuality() == kind && config.getKind() == kind
                && config.getIntensify() == intensify).findFirst().orElse(null);
    }
}
