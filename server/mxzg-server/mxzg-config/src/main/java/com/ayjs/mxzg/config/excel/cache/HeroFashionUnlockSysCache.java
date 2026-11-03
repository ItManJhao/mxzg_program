package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CHeroFashionUnlock;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * 皮肤（时装解锁）
 * @author hyx
 */
@Component
public class HeroFashionUnlockSysCache extends BaseExcelCache<CHeroFashionUnlock> {

    Map<Integer, List<CHeroFashionUnlock>> fashionMap;

    @Override
    public String getFileName() {
        return "herofashionunlock";
    }

    @Override
    protected void loadAfterReady() {
        fashionMap = fillListMap(CHeroFashionUnlock::getFashion_id);
    }

    public CHeroFashionUnlock getItemTypeByFashionId(int fashionId) {
        List<CHeroFashionUnlock> configList = fashionMap.get(fashionId);
        ConfigAsserts.notNull(configList, String.format("配置表中不存在{%s}", fashionId));
        return configList.stream().filter(config -> config.getFashion_id() == fashionId && config.getTime_limit() == 0).findFirst().orElse(null);
    }
}
