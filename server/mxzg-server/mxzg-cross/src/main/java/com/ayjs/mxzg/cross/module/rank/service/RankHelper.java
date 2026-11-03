package com.ayjs.mxzg.cross.module.rank.service;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.crossservice.dao.CrossServerGroupDao;
import com.ayjs.mxzg.cross.module.rank.service.impl.CrossCruGroupHurtPService;
import com.ayjs.mxzg.cross.module.rank.service.impl.CrossCruGroupHurtService;
import com.ayjs.mxzg.cross.module.rank.service.impl.CrossCruGroupItemPService;
import com.ayjs.mxzg.cross.module.rank.service.impl.CrossCruGroupItemService;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @Author: CWJ
 * @Date: 2019/12/19
 **/
@Controller
public class RankHelper implements IRegister<ICrossRankService> {

    private Map<CrossRankType, ICrossRankService> map = new ConcurrentHashMap<>();

    @Autowired
    private CrossServerGroupDao crossServerGroupDao;
    @Autowired
    private MessageHelper messageHelper;

    @Override
    public void registerBean(ICrossRankService bean) {
        ICrossRankService old = map.put(bean.getRankType(), bean);
        if (Objects.nonNull(old)) {
            throw new RuntimeException(String.format("对象重复{%s}-{%s}", old.getClass().getName(), bean.getClass().getName()));
        }
    }

    public ICrossRankService getService(CrossRankType type) {
        return map.get(type);
    }

    /***
     * 推送所有排行榜到游戏服
     */
    public void pullToGame() {
        map.values().forEach(service -> service.pullToAllGame());
    }

    //清楚讨伐团排行榜数据
    public void clearCruGroupRankData(){
        CrossCruGroupHurtPService crossCruGroupHurtPService = (CrossCruGroupHurtPService) getService(CrossRankType.CRUGROUP_HURTP);
        crossCruGroupHurtPService.clear();
        CrossCruGroupHurtService crossCruGroupHurtService = (CrossCruGroupHurtService) getService(CrossRankType.CRUGROUP_HURT);
        crossCruGroupHurtService.clear();
        CrossCruGroupItemPService crossCruGroupItemPService = (CrossCruGroupItemPService) getService(CrossRankType.CRUGROUP_ITEMP);
        crossCruGroupItemPService.clear();
        CrossCruGroupItemService crossCruGroupItemService = (CrossCruGroupItemService) getService(CrossRankType.CRUGROUP_ITEM);
        crossCruGroupItemService.clear();
    }

}
