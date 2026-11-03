package com.ayjs.mxzg.config.excel.cache.shop;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopLadder;
import org.springframework.stereotype.Component;

/**
 * 跨服天梯积分商店
 * @author hyx
 */
@Component
public class ShopLadderSysCache extends BaseExcelCache<CShopLadder> {

    @Override
    public String getFileName() {
        return "shopladder";
    }
}
