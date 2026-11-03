package com.ayjs.mxzg.gameserver.module.onlineReward.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.config.excel.cache.PromotionOnlineRewardSysCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionOnlineReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.monthCard.constant.MonthCardType;
import com.ayjs.mxzg.gameserver.module.monthCard.domain.MonthCard;
import com.ayjs.mxzg.gameserver.module.monthCard.serice.MonthCardService;
import com.ayjs.mxzg.gameserver.module.onlineReward.domain.OnlineReward;
import com.ayjs.mxzg.gameserver.module.onlineReward.service.OnlineRewardService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.OnlineRewardGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;


@Controller
@Slf4j
public class OnlineRewardHandler extends ProtocolHandler {

    @Autowired
    private OnlineRewardService onlineRewardService;
    @Autowired
    private PromotionOnlineRewardSysCache promotionOnlineRewardSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private MonthCardService monthCardService;
    @Autowired
    private MailService mailService;


    /**
     * 获取在线时长列表
     *
     * @param playerContext
     * @param msg
     */
  /*  @CMD(id = CmdCode._25001)
    public void onlineRewardList(PlayerContext playerContext, OnlineRewardGMsg.GReqInitOnlineRewardData msg) {
        *//*OnlineRewardGMsg.GResInitOnlineRewardData.Builder builder
                = OnlineRewardGMsg.GResInitOnlineRewardData.newBuilder();
        OnlineReward onlineReward = onlineRewardService.getOnlineReward(playerContext.getId());
        builder.setOnlineTime(onlineReward.getOnlineTime());
        builder.addAllIdxList(getOnlineList(onlineReward));
        playerContext.write(CmdCode._25001, builder.build());*//*
    }*/


    /**
     * 领取在线时长奖励
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._25002)
    public void getOnlineRewardList(PlayerContext playerContext, OnlineRewardGMsg.GReqInitOnlineReward msg) {
        OnlineRewardGMsg.GResInitOnlineReward.Builder builder = OnlineRewardGMsg.GResInitOnlineReward.newBuilder();

        OnlineReward onlineReward = onlineRewardService.getOnlineReward(playerContext.getId());

        Asserts.isTrue(!onlineReward.getRewards().contains(msg.getIdx()), ErrorCode.REWARD_REPEAT_GET.getValue(), "idx: " + msg.getIdx());

        Role role = roleService.getOrThrow(playerContext.getId());

        int time = 0;
        for (CPromotionOnlineReward config : promotionOnlineRewardSysCache.getAll()) {
            if (config.getIdx() <= msg.getIdx()) {
                time += config.getTime();
            }
        }

        int nowOnlineTime = (int) (onlineReward.getOnlineTime() + (DateTimeUtil.millisTime() - role.getLastLoginTime()) / TimeConstants.ONE_SECOND_MILLIS);

        Asserts.isTrue(time < nowOnlineTime, ErrorCode.ONLINE_TIME_SHORTAGE.getValue(), "need onlineTime: "
                + time + " not onlineTime: " + nowOnlineTime + " rid : " + playerContext.getId());

        CPromotionOnlineReward cModel = promotionOnlineRewardSysCache.getOrThrow(msg.getIdx());
        Set<Integer> idxList = onlineReward.getRewards();
        idxList.add(msg.getIdx());
        onlineRewardService.updateOnlineReward(onlineReward);

        ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
        data.setKey(msg.getIdx());
        data.setValue(1);
        builder.setIdxList(data);

        ImmutableList<ImmutableThing> thingRewards = cModel.getReward();
        Rewards rewards = thingService.add(playerContext.getId(), thingRewards, GameEvent.ONLINE_TIME, NoticeType.NORMAL);
        for (Hero hero : rewards.getHeroes()) {
            builder.setHero(heroService.buildHero(hero));
        }
        playerContext.write(CmdCode._25002, builder.build());

        //验证是否要邮件补发
        //奖励领取完且开通月卡
        if(onlineReward.getRewards().size() == promotionOnlineRewardSysCache.getAll().size() &&
                checkMonthCard(playerContext.getId())){
            List<ImmutableThing> rewardList = new ArrayList<>();
            for(CPromotionOnlineReward reward : promotionOnlineRewardSysCache.getAll()){
                if(reward.getOnce_again() == 1 && !onlineReward.getOnceAgainList().contains(reward.getIdx())){
                    rewardList.addAll(reward.getReward());
                    onlineReward.getOnceAgainList().add(reward.getIdx());
                }
            }
            if(rewardList.size() > 0){
                Mail mail = mailService.newMailNoTitle(playerContext.getId(), MailScene.ONLINE_REWARD,null,
                        ImmutableThingUtil.mergeThing(rewardList),GameEvent.ONLINE_TIME);
                mailService.insert(mail);
                onlineRewardService.updateOnlineReward(onlineReward);
            }
        }
    }

    /**
     * 在线奖励再次领取
     *
     * @param msg
     * @param playerContext
     */
    @CMD(id = CmdCode._25003)
    public void onceAgainOnlineReward( PlayerContext playerContext,OnlineRewardGMsg.GReqOnceAgainOnlineReward msg) {
        OnlineRewardGMsg.GResOnceAgainOnlineReward.Builder builder = OnlineRewardGMsg.GResOnceAgainOnlineReward.newBuilder();

        CPromotionOnlineReward cModel = promotionOnlineRewardSysCache.getOrThrow(msg.getIdx());
        Asserts.isTrue(cModel.getOnce_again() == 1, ErrorCode.REWARD_NOT_ONCE_AGAIN.getValue(), "该奖励不能再次领取，idx:" + msg.getIdx());

        OnlineReward onlineReward = onlineRewardService.getOnlineReward(playerContext.getId());
        Asserts.isTrue(!onlineReward.getOnceAgainList().contains(msg.getIdx()), ErrorCode.REWARD_REPEAT_GET.getValue(), "idx: " + msg.getIdx());

        //首次奖励领取完毕方可领取第二次奖励
        Asserts.isTrue(onlineReward.getRewards().contains(msg.getIdx()), ErrorCode.FIRST_REWARD_NOT_GET.getValue(), "idx: " + msg.getIdx());

        Asserts.isTrue(checkMonthCard(playerContext.getId()), ErrorCode.MONTH_CARD_PAST_DUE.getValue(), "当前尚未开通月卡或月卡已过期");

        onlineReward.getOnceAgainList().add(msg.getIdx());
        onlineRewardService.updateOnlineReward(onlineReward);

        builder.setIdx(msg.getIdx());

        ImmutableList<ImmutableThing> thingRewards = cModel.getReward();
        Rewards rewards = thingService.add(playerContext.getId(), thingRewards, GameEvent.ONLINE_TIME, NoticeType.NORMAL);
        for (Hero hero : rewards.getHeroes()) {
            builder.setHero(heroService.buildHero(hero));
        }

        playerContext.write(CmdCode._25003, builder.build());
    }

    /**
     * 是否有月卡在有效期
     * @param rid
     * @return
     */
    private boolean checkMonthCard(long rid){
        MonthCard monthCard = null;
        for (MonthCardType monthCardType : MonthCardType.values()) {
            monthCard = monthCardService.getByType(rid, monthCardType);
            if (monthCard != null && monthCard.getStartTime() > 0 && monthCard.getEndTime() >= DateTimeUtil.currentSecond())
                return true;
        }
        return false;
    }

}
