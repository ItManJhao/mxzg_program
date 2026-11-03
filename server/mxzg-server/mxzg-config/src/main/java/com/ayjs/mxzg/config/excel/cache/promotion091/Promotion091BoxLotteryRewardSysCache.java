package com.ayjs.mxzg.config.excel.cache.promotion091;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion091.CPromotion091BoxLotteryReward;
import lombok.Getter;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Component
public class Promotion091BoxLotteryRewardSysCache extends BaseExcelCache<CPromotion091BoxLotteryReward> {
    @Getter
    private CPromotion091BoxLotteryReward hitConfig;

    @Override
    protected void loadAfterReady() {
        hitConfig = getAll().stream().filter(config -> config.getNeed_count() > 0).findFirst().orElse(null);
    }

    @Override
    public String getFileName() {
        return "promotion091boxlotteryreward";
    }
}
