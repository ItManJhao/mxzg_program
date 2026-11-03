package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CHeroBack;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Component
public class HeroBackSysCache extends BaseExcelCache<CHeroBack> {

    private Map<String, CHeroBack> heroBackMap;

    @Override
    public String getFileName() {
        return "heroback";
    }

    @Override
    protected void loadAfterReady() {
        heroBackMap = getAll().stream().collect(Collectors.toMap(config -> builderKey(config.getStar(), config.getElem(), config.getEvolve_level()),
                Function.identity()));
    }

    private String builderKey(int star, int elem, int evolveLv) {
        return String.format("{%s}_{%s}_{%s}", star, elem, evolveLv);
    }

    public CHeroBack getConfigOrThrow(int element, int heroStar, int evolveLevel) {
        CHeroBack config = heroBackMap.get(builderKey(heroStar, element, evolveLevel));
        ConfigAsserts.notNull(config,
                () -> String.format("CHeroBack配置数据不存在element:{%s},star:{%s},evolveLevel:{%s}", element, heroStar, evolveLevel));
        return config;
    }

}
