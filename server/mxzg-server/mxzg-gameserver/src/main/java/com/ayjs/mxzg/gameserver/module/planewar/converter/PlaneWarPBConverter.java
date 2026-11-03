package com.ayjs.mxzg.gameserver.module.planewar.converter;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.planewar.PlaneWarInformationSysCache;
import com.ayjs.mxzg.config.excel.entity.planewar.CPlaneWarLevel;
import com.ayjs.mxzg.gameserver.module.planewar.domain.PlaneWar;
import com.ayjs.mxzg.gameserver.module.planewar.service.PlaneWarService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PrivilegeType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PrivilegeGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion010PrivilegeGiftService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.PlaneWarGMsg;
import com.ayjs.mxzg.protocol.PvpGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.List;
import java.util.Objects;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/9/16
 **/
@Component
public class PlaneWarPBConverter {

    @Autowired
    private PlaneWarService planeWarService;
    @Autowired
    private Promotion010PrivilegeGiftService promotion010PrivilegeGiftService;
    @Autowired
    private PlaneWarInformationSysCache planeWarInformationSysCache;

    public ObjectGMsg.PSMapData builderMap(int key, int value) {
        ObjectGMsg.PSMapData.Builder builder = ObjectGMsg.PSMapData.newBuilder();
        builder.setKey(key);
        builder.setValue(value);
        return builder.build();
    }

    public PlaneWarGMsg.GResPlaneWarData builderData(PlaneWar planeWar) {
        PlaneWarGMsg.GResPlaneWarData.Builder builder = PlaneWarGMsg.GResPlaneWarData.newBuilder();
        builder.setChallengeCount(planeWarService.getRemainingChallengeCount(planeWar));
        builder.setRemainingBuyCount(planeWarService.getBuyMaxCount(planeWar.getRid()) - planeWar.getHadBuyCount());

        Set<Integer> openElement = planeWarInformationSysCache.getOpenElement(LocalDate.now().getDayOfWeek().getValue());
        openElement.forEach((element) -> {
            builder.addPassLevelInfo(builderMap(element, planeWar.getPassLevelInfo().getOrDefault(element, 0)));
        });

        builder.setMaxChallengeCount(planeWarService.getFreeMaxCount(planeWar.getRid()));
        PrivilegeGift privilegeGift = promotion010PrivilegeGiftService.getPrivilegeGift(planeWar.getRid(), PrivilegeType.PLANE_WAR);
        builder.setPrivilegeExpireTime(Objects.isNull(privilegeGift) || privilegeGift.getEndTime() <= TimeDateUtil.getCurrentTimeInt() ? -1 :
                privilegeGift.getEndTime());
        builder.setTurn(planeWarService.getTurn().getTurn());
        builder.setHadBuyCount(planeWar.getHadBuyCount());
        return builder.build();
    }

    public PlaneWarGMsg.GResPlaneWarChallenge builderChallenge(PlaneWar planeWar, BattleResult battleResult, CPlaneWarLevel config) {
        PlaneWarGMsg.GResPlaneWarChallenge.Builder builder = PlaneWarGMsg.GResPlaneWarChallenge.newBuilder();
        builder.setReport(battleResult.getReport());
        if (battleResult.isWin()) {
            builder.addAllReward(PbUtil.buildReward(config.getReward()));
        }
        builder.setIdx(config.getIdx());

        Set<Integer> openElement = planeWarInformationSysCache.getOpenElement(LocalDate.now().getDayOfWeek().getValue());
        openElement.forEach((element) -> {
            builder.addPassLevelInfo(builderMap(element, planeWar.getPassLevelInfo().getOrDefault(element, 0)));
        });
        return builder.build();
    }

    public PlaneWarGMsg.GResPlaneWarSweep builderSweep() {
        return PlaneWarGMsg.GResPlaneWarSweep.getDefaultInstance();
    }

    public PlaneWarGMsg.GResPlaneWarBuyCount builderBuyCount(PlaneWar planeWar) {
        PlaneWarGMsg.GResPlaneWarBuyCount.Builder builder = PlaneWarGMsg.GResPlaneWarBuyCount.newBuilder();
        builder.setRemainingBuyCount(planeWarService.getRemainingBuyCount(planeWar));
        builder.setChallengeCount(planeWarService.getRemainingChallengeCount(planeWar));
        builder.setHadBuyCount(planeWar.getHadBuyCount());
        return builder.build();
    }

    public PlaneWarGMsg.GResPlaneWarRank builderRank(List<PvpGMsg.PSRankPlayerData> rankList, PvpGMsg.PSRankPlayerData self) {
        PlaneWarGMsg.GResPlaneWarRank.Builder builder = PlaneWarGMsg.GResPlaneWarRank.newBuilder();
        builder.addAllList(rankList);
        builder.setSelfData(self);
        return builder.build();
    }
}
