package com.ayjs.mxzg.config.excel.cache.shop;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.shop.CShopHeroSkin;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class ShopHeroSkinSysCache extends BaseExcelCache<CShopHeroSkin> {

    Map<Integer, CShopHeroSkin> productMap;

    @Override
    public String getFileName() {
        return "heroskinshop";
    }

    @Override
    protected void loadAfterReady() {
        productMap = fillOneLayerMap(CShopHeroSkin::getBuy_gem_id);
    }

    public CShopHeroSkin getHeroSkinByProductId(int productId) {
        CShopHeroSkin heroSkin = productMap.get(productId);
        ConfigAsserts.notNull(heroSkin, "配置表不存在该配置");
        return heroSkin;
    }
}
