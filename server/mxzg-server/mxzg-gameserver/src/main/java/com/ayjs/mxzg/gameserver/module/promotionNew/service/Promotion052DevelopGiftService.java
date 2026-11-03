package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion052DevelopGiftSysCache;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion052DevelopGiftDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion052DevelopGift;
import com.ayjs.mxzg.protocol.Promotion052GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 超值养成礼包
 */
@Service
public class Promotion052DevelopGiftService {

    @Autowired
    private Promotion052DevelopGiftDao promotion052DevelopGiftDao;
    @Autowired
    private Promotion052DevelopGiftSysCache promotion052DevelopGiftSysCache;

    /**
     * 获取并且刷新数据
     */
    public Promotion052DevelopGift getAndRefresh(long rid) {
        Promotion052DevelopGift promotion052DevelopGift = promotion052DevelopGiftDao.get(rid);
//        LocalDate localDate = LocalDate.now();
        int dayBreak = DateTimeUtil.dayBreak();
        if (Objects.isNull(promotion052DevelopGift)) {
            promotion052DevelopGift = new Promotion052DevelopGift();
            promotion052DevelopGift.setRid(rid);
            promotion052DevelopGift.setGifts(new HashMap<>());
            promotion052DevelopGift.setRefreshDate(DateTimeUtil.tomorrowBreak());
            promotion052DevelopGift.setRefreshDateTime(LocalDate.now().plusDays(1));
            promotion052DevelopGiftDao.add(promotion052DevelopGift);
        } else {
            if (promotion052DevelopGift.getRefreshDate() <= 0) {
                LocalDate refreshDateTime = promotion052DevelopGift.getRefreshDateTime();
                promotion052DevelopGift.setRefreshDate(LocalDateTimeUtil.toEpochSecond(refreshDateTime));
            }
        }

        // 整天重置
        int refreshDate = promotion052DevelopGift.getRefreshDate();
        if (refreshDate <= dayBreak) {
            promotion052DevelopGift.setGifts(new HashMap<>());
            promotion052DevelopGift.setRefreshDate(DateTimeUtil.tomorrowBreak());
            promotion052DevelopGift.setRefreshDateTime(LocalDate.now().plusDays(1));
            update(promotion052DevelopGift);
        }

        return promotion052DevelopGift;
    }

    public void update(Promotion052DevelopGift promotion052DevelopGift) {
        promotion052DevelopGiftDao.update(promotion052DevelopGift);
    }

    public List<Promotion052GMsg.GResDevelopGiftData> serializeDevelopGiftData(Map<Integer, Integer> gifts) {
        return gifts.entrySet().stream().map(k -> serializeDevelopGift(k.getKey(), k.getValue())).collect(Collectors.toList());
    }

    public Promotion052GMsg.GResDevelopGiftData serializeDevelopGift(int type, int level) {
        Promotion052GMsg.GResDevelopGiftData.Builder builder = Promotion052GMsg.GResDevelopGiftData.newBuilder();
        builder.setType(type);
        builder.setLevel(level);
        return builder.build();
    }
}
