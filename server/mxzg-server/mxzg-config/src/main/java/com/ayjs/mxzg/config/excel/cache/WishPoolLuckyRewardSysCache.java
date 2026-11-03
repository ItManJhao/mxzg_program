package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CWishPoolLuckyReward;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Comparator;

@Component
public class WishPoolLuckyRewardSysCache extends BaseExcelCache<CWishPoolLuckyReward> {

    @Getter
    private int maxLuckyValue;

    @Override
    protected void loadAfterReady() {
        maxLuckyValue = getAll().stream().max(Comparator.comparingInt(CWishPoolLuckyReward::getLucky_value_need)).get().getLucky_value_need();
    }

    @Override
    public String getFileName() {
        return "wishpoolluckyreward";
    }


}