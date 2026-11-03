package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion037WishTimes;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion037WishTimesService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion037WishTimesConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion037GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Collection;
import java.util.Objects;
import java.util.Set;


/**
 * 许愿达标
 */
@Controller
public class Promotion037WishTimesHandler extends ProtocolHandler {

    @Autowired
    private Promotion037WishTimesService promotion037WishTimesService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private SystemSysCache systemSysCache;

    /**
     * 获取许愿池达标列表
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13090)
    public void blessingPoolLists(PlayerContext playerContext, Promotion037GMsg.GReqBlessingPoolLists msg) {
        Promotion037GMsg.GResBlessingPoolLists.Builder builder = Promotion037GMsg.GResBlessingPoolLists.newBuilder();
        PromotionControl control = promotionControlService.getControl(PromotionType.XU_YUAN_DA_BIAO);

        Promotion037WishTimes promotion037WishTimes = promotion037WishTimesService.getPromotionInfo(playerContext.getId());

        builder.setNvalue(promotion037WishTimes.getTimes());
        builder.setRound(promotion037WishTimes.getRound());

        Collection<Promotion037WishTimesConfig> configList = promotion037WishTimesService.selectConfigList();

        if (Objects.isNull(configList)) {
            return;
        }

        configList.forEach(config -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(config.getIdx());
            if (promotion037WishTimes.getRewardList().contains(config.getIdx())) {
                data.setValue(1);
            } else {
                data.setValue(0);
            }
            builder.addList(data);
        });

        playerContext.write(CmdCode._13090, builder.build());
    }

    @CMD(id = CmdCode._13092)
    public void blessingPoolGift(PlayerContext playerContext, Promotion037GMsg.GReqBlessingPoolGift msg) {
        Promotion037GMsg.GResBlessingPoolGift.Builder builder = Promotion037GMsg.GResBlessingPoolGift.newBuilder();

        if (!promotionControlService.isPromotionRunning(PromotionType.XU_YUAN_DA_BIAO)) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_TIME.getValue(), "PromotionType.XU_YUAN_DA_BIAO");
        }

        //获取玩家活动进度
        Promotion037WishTimes promotion037WishTimes =
                promotion037WishTimesService.getPromotionInfo(playerContext.getId());
        //已领取
        if (promotion037WishTimes.getRewardList().contains(msg.getIdx())) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_REWARD_ALREADY_GET.getValue(), "PromotionType.XU_YUAN_DA_BIAO");
        }
        //条件不足
        Promotion037WishTimesConfig config = promotion037WishTimesService.selectConfigOne(msg.getIdx());
        if (Objects.isNull(config) || promotion037WishTimes.getTimes() < config.getTimes()) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_NOT_PROGRESS.getValue(), "PromotionType.XU_YUAN_DA_BIAO");
        }

        Set<Integer> rewardList = promotion037WishTimes.getRewardList();
        rewardList.add(msg.getIdx());
        promotion037WishTimes.setRewardList(rewardList);
        // 判断活动轮
        if (promotion037WishTimes.getRound() < systemSysCache.getPromotionBlessPoolTargetRewardRound()) {
            //奖励全部领取后活动轮数加1
            boolean s = true;
            int maxTimes = 0;
            for (Promotion037WishTimesConfig times : promotion037WishTimesService.selectConfigList()) {
                if (!promotion037WishTimes.getRewardList().contains(times.getIdx())) {
                    s = false;
                    break;
                }
                if (maxTimes < times.getTimes()) {
                    maxTimes = times.getTimes();
                }
            }
            if (s) {
                promotion037WishTimes.setRound(promotion037WishTimes.getRound() + 1);
                promotion037WishTimes.setTimes(promotion037WishTimes.getTimes() - maxTimes);
                if (promotion037WishTimes.getRound() < systemSysCache.getPromotionBlessPoolTargetRewardRound()) {
                    promotion037WishTimes.getRewardList().clear();
                }
            }
        }
        promotion037WishTimesService.updatePromotion(promotion037WishTimes);

        thingService.add(playerContext.getId(), ImmutableThingUtil.fromJson(config.getReward()), GameEvent.CYCLE_PROMOTION, NoticeType.NORMAL);

        playerContext.write(CmdCode._13081, builder.build());
    }
}
