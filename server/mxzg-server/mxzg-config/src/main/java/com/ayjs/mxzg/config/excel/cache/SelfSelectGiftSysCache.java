package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.common.excel.ConfigNotFoundException;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CSelfSelectGift;

import java.util.List;

@Component
public class SelfSelectGiftSysCache extends BaseExcelCache<CSelfSelectGift> {

    @Override
    public String getFileName() {
        return "selfselectgift";
    }


    /**
     * 根据礼包类型跟道具类型选择礼包
     * @param giftType
     * @param itemType
     * @return
     */
    public CSelfSelectGift getByOrThrow(int giftType, int itemType){
        List<CSelfSelectGift> gifts = getAll();
        for (CSelfSelectGift gift : gifts) {
            ImmutableThing thing = gift.getReward().get(0);
            if(gift.getType() == giftType && thing.getItem_type() == itemType){
                return gift;
            }
        }
        throw new ConfigNotFoundException(String.format("自选礼包配置不存在配置数据不存在giftType:{%s},itemType:{%s}",giftType, itemType));
    }

}