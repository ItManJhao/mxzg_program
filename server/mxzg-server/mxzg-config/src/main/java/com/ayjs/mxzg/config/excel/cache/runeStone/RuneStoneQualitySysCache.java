package com.ayjs.mxzg.config.excel.cache.runeStone;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.runeStone.CRuneStoneQuality;

/**
 * 符石品质配置表
 *
 * @Author: CWJ
 * @Date: 2020/7/29
 **/
public class RuneStoneQualitySysCache extends BaseExcelCache<CRuneStoneQuality> {

    @Override
    public String getFileName() {
        return "runestonequality";
    }
}
