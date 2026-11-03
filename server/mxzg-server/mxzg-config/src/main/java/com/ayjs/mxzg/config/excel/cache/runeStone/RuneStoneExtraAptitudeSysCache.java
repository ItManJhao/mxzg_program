package com.ayjs.mxzg.config.excel.cache.runeStone;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.runeStone.CRuneStoneExtraAptitude;

import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 符石额外属性
 *
 * @Author: CWJ
 * @Date: 2020/7/29
 **/
public class RuneStoneExtraAptitudeSysCache extends BaseExcelCache<CRuneStoneExtraAptitude> {

    private Map<String, CRuneStoneExtraAptitude> map;

    @Override
    protected void loadAfterReady() {
        map = getAll().stream().collect(Collectors.toMap(config -> buildKey(config.getQuality(), config.getJob(), config.getKind())
                , Function.identity()));
    }

    private String buildKey(int quality, int job, int kind) {
        return String.format("%s_%s_%s", quality, job, kind);
    }

    @Override
    public String getFileName() {
        return "runestoneextraaptitude";
    }

    public CRuneStoneExtraAptitude getByIndex(int quality, int job, int kind) {
        return map.get(buildKey(quality, job, kind));
    }
}
