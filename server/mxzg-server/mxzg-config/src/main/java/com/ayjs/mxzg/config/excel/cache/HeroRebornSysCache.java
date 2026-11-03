package com.ayjs.mxzg.config.excel.cache;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CHeroReborn;

@Component
public class HeroRebornSysCache extends BaseExcelCache<CHeroReborn> {

    private Map<Integer, Map<Integer, CHeroReborn>> heroRebornMap;

    @Override
    public String getFileName() {
        return "heroreborn";
    }

    @Override
    protected void loadAfterReady() {
        Map<Integer, Map<Integer, CHeroReborn>> heroRebornMapTemp = new HashMap<>();
        for (CHeroReborn cHeroReborn : getAll()) {
            Map<Integer, CHeroReborn> timesMap = heroRebornMapTemp.computeIfAbsent(cHeroReborn.getHero(), k -> new HashMap<>());
            timesMap.put(cHeroReborn.getStar(), cHeroReborn);
        }
        heroRebornMap = heroRebornMapTemp;
    }

    public CHeroReborn getConfig(int heroType,int heroStar){
        Map<Integer,CHeroReborn> map = heroRebornMap.get(heroType);
        ConfigAsserts.notNull(map,
                () -> String.format("CHeroReborn配置数据不存在type:{%s},star:{%s}", heroType, heroStar));
        CHeroReborn cHeroReborn = map.get(heroStar);
        ConfigAsserts.notNull(cHeroReborn,
                () -> String.format("CHeroReborn配置数据不存在type:{%s},star:{%s}", heroType, heroStar));
        return cHeroReborn;
    }

}
