package com.ayjs.mxzg.config.excel.cache.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion069RechargeGift;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Component
@Getter
public class Promotion069RechargeGiftSysCache extends BaseExcelCache<CPromotion069RechargeGift> {

    /**
     * 不同档位的充值要求
     */
    private Map<Integer, List<CPromotion069RechargeGift>> rechargeMap;

    @Override
    protected void loadAfterReady() {
        this.rechargeMap = this.fillListMap(CPromotion069RechargeGift::getType);
    }

    public List<CPromotion069RechargeGift> getConfigList(int type) {
        return rechargeMap.get(type);
    }

    /**
     * 获取不同充值档的充值金额
     *
     * @param type
     * @return
     */
    public int getRecharge(int type) {
        List<CPromotion069RechargeGift> configList = getConfigList(type);
        return configList.get(0).getRecharge();
    }

    /**
     * 获取不同充值档的持续时间
     *
     * @param type
     * @return
     */
    public int getDay(int type) {
        List<CPromotion069RechargeGift> configList = getConfigList(type);
        return configList.stream().mapToInt(CPromotion069RechargeGift::getNeed_day).max().getAsInt();
    }

    @Override
    public String getFileName() {
        return "promotionrechargegift";
    }


}
