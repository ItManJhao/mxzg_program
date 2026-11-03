package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CHeroFashion;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * 皮肤（时装）
 *
 * @author hyx
 */
@Component
public class HeroFashionSysCache extends BaseExcelCache<CHeroFashion> {

    private Map<Integer, List<CHeroFashion>> heroFashionMap;

    @Override
    public String getFileName() {
        return "herofashion";
    }

    @Override
    protected void loadAfterReady() {
        this.heroFashionMap = this.fillListMap(CHeroFashion::getHero_type);
    }

    public List<CHeroFashion> getHeroFashionList(int hero_type){
        return heroFashionMap.get(hero_type);
    }
}
