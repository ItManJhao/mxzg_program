package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CHeroHexagram;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @Author CJX
 * @Date 2021/5/20
 */

@Component
public class HeroHexagramSysCache extends BaseExcelCache<CHeroHexagram> {
    private Map<Integer, Map<Integer, CHeroHexagram>> map;

    @Override
    public String getFileName() {
        return "herohexagram";
    }

    @Override
    protected void loadAfterReady() {
        super.loadAfterReady();
        map = fillTwoLayerMap(CHeroHexagram::getType, CHeroHexagram::getLevel);
    }

    /**
     * 根据六芒星类型和等级获取配置
     * @param type
     * @param level
     * @return
     */
    public CHeroHexagram getHeroHexagram(int type, int level) {
        Map<Integer, CHeroHexagram> levelMap = map.get(type);
        ConfigAsserts.notNull(levelMap, () -> String.format("无法加载{%s}表{%s}的类型", getFileName(), type));
        CHeroHexagram cHeroHexagram = levelMap.get(level);
        ConfigAsserts.notNull(cHeroHexagram, String.format("无法加载{%s}表{%s}类型{%s}等级的属性", getFileName(), type, level));
        return cHeroHexagram;
    }
}
