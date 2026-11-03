package com.ayjs.mxzg.config.excel.cache.promotion;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.util.StrUtil;
import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion052DevelopGift;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.Objects;

@Component
public class Promotion052DevelopGiftSysCache extends BaseExcelCache<CPromotion052DevelopGift> {

    private Map<Integer, Map<Integer, CPromotion052DevelopGift>> map;

    @Override
    public String getFileName() {
        return "developgift";
    }

    @Override
    protected void loadAfterReady() {
        map = this.fillTwoLayerMap(CPromotion052DevelopGift::getType, CPromotion052DevelopGift::getLevel);
    }

    public CPromotion052DevelopGift getDevelopGift(int type, int level) {
        Map<Integer, CPromotion052DevelopGift> developGiftMap = map.get(type);
        ConfigAsserts.isTrue(CollectionUtil.isNotEmpty(developGiftMap),
                () -> StrUtil.format("develop gift Promotion052DevelopGiftSysCache is null type:{}", type));
        CPromotion052DevelopGift cPromotion052DevelopGift = developGiftMap.get(level);

        ConfigAsserts.isTrue(Objects.nonNull(cPromotion052DevelopGift),
                () -> StrUtil.format("develop gift Promotion052DevelopGiftSysCache is null type:{},level:{}", type, level));
        return cPromotion052DevelopGift;
    }
}
