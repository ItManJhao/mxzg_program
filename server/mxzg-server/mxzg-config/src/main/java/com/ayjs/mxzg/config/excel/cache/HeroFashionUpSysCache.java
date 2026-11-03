package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CHeroFashionUp;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * 皮肤（时装）升级
 *
 * @author hyx
 */
@Component
public class HeroFashionUpSysCache extends BaseExcelCache<CHeroFashionUp> {

    private Map<Integer, Map<Integer, CHeroFashionUp>> map;

    @Override
    public String getFileName() {
        return "herofashionup";
    }

    @Override
    protected void loadAfterReady() {
        this.map = this.fillTwoLayerMap(CHeroFashionUp::getFashion_id, CHeroFashionUp::getLevel);
    }

    /**
     * 根据皮肤和等级获取皮肤属性
     *
     * @param fashionId
     * @param level
     * @return
     */
    public CHeroFashionUp getHeroFashionUp(int fashionId, int level) {
        Map<Integer, CHeroFashionUp> levelMap = map.get(fashionId);
        ConfigAsserts.notNull(levelMap, () -> String.format("无法加载herofashionup表{%s}的皮肤", fashionId));
        CHeroFashionUp cHeroFashionUp = levelMap.get(level);
        ConfigAsserts.notNull(cHeroFashionUp, () -> String.format("无法加载herofashionup表{%s}皮肤{%s}等级的属性", fashionId, level));
        return cHeroFashionUp;
    }

    /**
     * 根据皮肤id获取指定皮肤最大等级
     *
     * @param fashionId
     * @return
     */
    public int getMaxLevel(int fashionId) {
        int maxLevel = 0;

        Map<Integer, CHeroFashionUp> levelMap = map.get(fashionId);
        ConfigAsserts.notNull(levelMap, () -> String.format("无法加载herofashionup表{%s}的皮肤", fashionId));

        for (Integer key : levelMap.keySet()) {
            if (key > maxLevel) {
                maxLevel = key;
            }
        }
        return maxLevel;
    }

}
