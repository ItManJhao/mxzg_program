package com.ayjs.mxzg.gameserver.module.rank.service;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.service.impl.CrossCGHurtPRankService;
import com.ayjs.mxzg.gameserver.module.rank.service.impl.CrossCGHurtRankService;
import com.ayjs.mxzg.gameserver.module.rank.service.impl.CrossCGItemPRankService;
import com.ayjs.mxzg.gameserver.module.rank.service.impl.CrossCGItemRankService;
import com.ayjs.mxzg.gameserver.remote.cross.event.CrossConnectedEvent;
import com.ayjs.mxzg.message.module.rank.ReqCrossRankGetMessage;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2019/10/17
 **/
@Service
@Observer
@Slf4j
public class RankServiceProxy implements IRegister<IRankService<?>> {

    private Map<RankType, AbstractPlayerRankService> playerRankService = new HashMap<>();

    private Map<RankType, AbstractClanRankService> clanRankService = new HashMap<>();

    private Map<RankType, AbstractRankService> allRankService = new HashMap<>();
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerConfig serverConfig;
    //******** 讨伐团相关
    @Autowired
    private CrossCGItemRankService crossCGItemRankService;
    @Autowired
    private CrossCGItemPRankService crossCGItemPRankService;
    @Autowired
    private CrossCGHurtRankService crossCGHurtRankService;
    @Autowired
    private CrossCGHurtPRankService crossCGHurtPRankService;

    @Override
    public void registerBean(IRankService<?> bean) {
        if (bean instanceof AbstractPlayerRankService) {
            AbstractPlayerRankService old = playerRankService.put(bean.getRankType(), (AbstractPlayerRankService) bean);
            if (Objects.nonNull(old)) {
                throw new RuntimeException(String.format("排行榜类型冲突：{%s}-{%s}", bean.getClass().getName(), old.getClass().getName()));
            }
        }
        if (bean instanceof AbstractClanRankService) {
            AbstractClanRankService old2 = clanRankService.put(bean.getRankType(), (AbstractClanRankService) bean);
            if (Objects.nonNull(old2)) {
                throw new RuntimeException(String.format("排行榜类型冲突：{%s}-{%s}", bean.getClass().getName(), old2.getClass().getName()));
            }
        }
        if (bean instanceof AbstractRankService) {
            AbstractRankService old2 = allRankService.put(bean.getRankType(), (AbstractRankService) bean);
            if (Objects.nonNull(old2)) {
                throw new RuntimeException(String.format("排行榜类型冲突：{%s}-{%s}", bean.getClass().getName(), old2.getClass().getName()));
            }
        }
    }

    public AbstractPlayerRankService getPlayerRank(RankType rankType) {
        AbstractPlayerRankService rankService = playerRankService.get(rankType);
        Asserts.notNull(rankService, ErrorCode.ERROR_PARAM.getValue(), "没有找到" + rankType + "的玩家排行榜");
        return rankService;
    }

    public AbstractClanRankService getClanRank(RankType rankType) {
        AbstractClanRankService rankService = clanRankService.get(rankType);
        Asserts.notNull(rankService, ErrorCode.ERROR_PARAM.getValue(), "没有找到" + rankType + "的公会排行榜");
        return rankService;
    }

    /**
     * 获取服务类
     *
     * @param rankType
     * @return
     */
    public AbstractRankService<?> getRankService(RankType rankType) {
        AbstractRankService<?> rankService = allRankService.get(rankType);
        Asserts.notNull(rankService, ErrorCode.ERROR_PARAM.getValue(), "没有找到" + rankType + "的排行榜");
        return rankService;
    }

    /**
     * 向跨服请求排行榜数据
     *
     * @return
     */
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void getCrossRank(CrossConnectedEvent event) {
        for (RankType type : RankType.values()) {
            if (type.isCross()) {
                messageDispatcher.dispatch(ReqCrossRankGetMessage.createOf(type.getType(), serverConfig.getServerId()));
            }
        }
    }

    //清理讨伐团排行榜
    public void resetCGRank() {
        crossCGItemRankService.clear();
        crossCGItemPRankService.clear();
        crossCGHurtRankService.clear();
        crossCGHurtPRankService.clear();
    }
}
