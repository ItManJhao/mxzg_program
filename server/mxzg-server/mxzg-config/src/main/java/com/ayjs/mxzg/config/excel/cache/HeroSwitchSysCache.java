package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CHeroSwitch;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class HeroSwitchSysCache extends BaseExcelCache<CHeroSwitch> {

    private Map<Integer, Map<Integer, CHeroSwitch>> heroSwitchMap;

    @Override
    public String getFileName() {
        return "heroswitch";
    }

    @Override
    protected void loadAfterReady() {
        Map<Integer, Map<Integer, CHeroSwitch>> heroSwitchMapTemp = new HashMap<>();
        for (CHeroSwitch heroSwatch : getAll()) {
            Map<Integer, CHeroSwitch> timesMap = heroSwitchMapTemp.computeIfAbsent(heroSwatch.getElem(), k -> new HashMap<>());
            timesMap.put(heroSwatch.getStar(), heroSwatch);
        }
        heroSwitchMap = heroSwitchMapTemp;
    }

    public CHeroSwitch getConfigOrThrow(int element, int heroStar){
        Map<Integer, CHeroSwitch> map = heroSwitchMap.get(element);
        ConfigAsserts.notNull(map,
                () -> String.format("CHeroSwatch配置数据不存在element:{%s},star:{%s}", element, heroStar));
        CHeroSwitch heroSwatch = map.get(heroStar);
        ConfigAsserts.notNull(map,
                () -> String.format("CHeroSwatch配置数据不存在element:{%s},star:{%s}", element, heroStar));
        return heroSwatch;
    }

}
