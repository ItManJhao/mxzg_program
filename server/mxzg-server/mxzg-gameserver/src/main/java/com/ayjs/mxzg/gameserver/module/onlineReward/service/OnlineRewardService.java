package com.ayjs.mxzg.gameserver.module.onlineReward.service;

import com.ayjs.mxzg.config.excel.cache.PromotionOnlineRewardSysCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionOnlineReward;
import com.ayjs.mxzg.gameserver.module.onlineReward.dao.OnlineRewardDao;
import com.ayjs.mxzg.gameserver.module.onlineReward.domain.OnlineReward;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/14 12:02
 */
@Service
public class OnlineRewardService {

    @Autowired
    private OnlineRewardDao onlineRewardDao;
    @Autowired
    private PromotionOnlineRewardSysCache promotionOnlineRewardSysCache;

    public OnlineReward getOnlineReward(long rid) {
        OnlineReward onlineReward = onlineRewardDao.get(rid);
        LocalDate localDate = LocalDate.now();
        if (onlineReward == null) {
            onlineReward = new OnlineReward();
            onlineReward.setRid(rid);
            onlineReward.setTodayOnlineTime(0);
            onlineReward.setOnlineTimeRefreshDate(localDate);
            onlineRewardDao.add(onlineReward);
        }
        if (Objects.isNull(onlineReward.getOnlineTimeRefreshDate())) {
            onlineReward.setOnlineTimeRefreshDate(localDate);
        }
        if (localDate.isAfter(onlineReward.getOnlineTimeRefreshDate())) {
            onlineReward.setOnlineTimeRefreshDate(localDate);
            onlineReward.setTodayOnlineTime(0);
        }

        return onlineReward;
    }

    public void updateOnlineReward(OnlineReward onlineReward) {
        onlineRewardDao.update(onlineReward);
    }

    public List<ObjectGMsg.PSMapData> getOnlineList(OnlineReward onlineReward) {
        List<ObjectGMsg.PSMapData> list = new ArrayList<>();
        for (CPromotionOnlineReward cModel : promotionOnlineRewardSysCache.getAll()) {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(cModel.getIdx());
            if (onlineReward.getRewards().contains(cModel.getIdx())) {
                data.setValue(1);
            } else {
                data.setValue(0);
            }
            list.add(data.build());
        }
        return list;
    }
}
