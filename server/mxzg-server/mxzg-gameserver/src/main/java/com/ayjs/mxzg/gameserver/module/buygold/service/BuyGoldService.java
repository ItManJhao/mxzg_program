package com.ayjs.mxzg.gameserver.module.buygold.service;

import com.ayjs.mxzg.config.excel.cache.BuyGoldCostSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.gameserver.module.buygold.dao.BuyGoldDao;
import com.ayjs.mxzg.gameserver.module.buygold.domain.BuyGold;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class BuyGoldService {

    @Autowired
    private BuyGoldDao buyGoldDao;
    @Autowired
    SystemSysCache systemSysCache;
    @Autowired
    private BuyGoldCostSysCache buyGoldCostSysCache;

    /**
     * 刷新容错秒数
     */
    private final static int FAULT_TOLERANCE_SECONDS = 2;

    /**
     * 查询角色点金数据
     *
     * @return
     */
    public BuyGold getBuyGold(long rid) {
        BuyGold buyGold = buyGoldDao.get(rid);
        if (Objects.isNull(buyGold)) {
            buyGold = createBuyGold(rid);
        }
        if (needToRefresh(buyGold)) {
            refresh(buyGold);
        }
        return buyGold;
    }

    private BuyGold createBuyGold(long rid) {
        BuyGold buyGold = new BuyGold();
        buyGold.setRid(rid);
        Map<Integer, Integer> buyInfo = new HashMap<>();
        buyGoldCostSysCache.getAll().forEach(cBuyGoldCost -> {
            buyInfo.put(cBuyGoldCost.getType(), 0);
        });
        buyGold.setBuyInfo(buyInfo);
        buyGold.setNextRefreshTime(getNextRefreshTime());
        buyGoldDao.add(buyGold);
        return buyGold;
    }

    /**
     * 刷新信息
     */
    private void refresh(BuyGold buyGold) {
        buyGold.setNextRefreshTime(getNextRefreshTime());
        Map<Integer, Integer> infoMap = buyGold.getBuyInfo();
        for (Integer type : infoMap.keySet()) {
            infoMap.put(type, 0);
        }
        buyGoldDao.update(buyGold);
    }

    /**
     * 获得下次刷新时间
     */
    private LocalDateTime getNextRefreshTime() {
        LocalDate date = LocalDate.now();
        List<LocalTime> bugGoldRefreshList = systemSysCache.getBugGoldRefreshList();

        LocalDateTime now = LocalDateTime.now();
        for (LocalTime localTime : bugGoldRefreshList) {
            LocalDateTime dateTime = LocalDateTime.of(date, localTime);
            if (now.isBefore(dateTime)) {
                return dateTime;
            }
        }

        return LocalDateTime.of(date.plusDays(1), bugGoldRefreshList.get(0));
    }

    /**
     * 是否需要刷新
     */
    private boolean needToRefresh(BuyGold info) {
        return !info.getNextRefreshTime().isAfter(LocalDateTime.now());
    }

    /**
     * 修改点金
     *
     * @param buyGolde
     */
    public void updateBuyGold(BuyGold buyGolde) {
        buyGoldDao.update(buyGolde);
    }
}
