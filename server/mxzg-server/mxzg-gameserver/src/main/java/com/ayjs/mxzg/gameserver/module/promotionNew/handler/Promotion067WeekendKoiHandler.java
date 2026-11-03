package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion067WeekendKoiPondSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion067WeekendKoiSysCache;
import com.ayjs.mxzg.config.excel.constant.PromotionConst;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion067WeekendKoi;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion067WeekendKoiPond;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion067WeekendKoi;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion067WeekendKoiSysInfo;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion067WeekendKoiService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.Promotion067WeekendKoiInfo;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.promotion067GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 周末锦鲤
 *
 * @author hyx
 */
@Controller
public class Promotion067WeekendKoiHandler extends ProtocolHandler {

    @Autowired
    private Promotion067WeekendKoiService promotion067WeekendKoiService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private Promotion067WeekendKoiPondSysCache promotion067WeekendKoiPondSysCache;
    @Autowired
    private Promotion067WeekendKoiSysCache promotion067WeekendKoiSysCache;

    @CMD(id = CmdCode._13280)
    public void sendWeekendKoiInfo(PlayerContext playerContext, promotion067GMsg.GReqWeekendKoiInfo msg) {

        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.ZHOU_MO_JIN_LI);

        Promotion067WeekendKoi promotion067WeekendKoi = promotion067WeekendKoiService.getPromotionInfo(playerContext.getId());

        promotion067GMsg.GResWeekendKoiInfo.Builder builder = promotion067GMsg.GResWeekendKoiInfo.newBuilder();
        builder.setTurns(promotionControl.getTurns());
        builder.setBlessingNum(promotion067WeekendKoi.getBlessingNum());
        builder.setBuyLimit(promotion067WeekendKoi.getBuyNum());

        Promotion067WeekendKoiSysInfo promotion067WeekendKoiSysInfo = promotion067WeekendKoiService.getPromotionSysInfo();
        if (promotion067WeekendKoiSysInfo.getKoi() > 0) {
            Role role = roleService.getOrThrow(promotion067WeekendKoiSysInfo.getKoi());
            builder.setKoiNick(role.getNick());
        }
        playerContext.write(CmdCode._13280, builder.build());
    }

    @CMD(id = CmdCode._13281)
    public void sendBlessingInfo(PlayerContext playerContext, promotion067GMsg.GReqBlessingInfo msg) {

        Promotion067WeekendKoiSysInfo promotion067WeekendKoiSysInfo = promotion067WeekendKoiService.getPromotionSysInfo();
        promotion067GMsg.GResBlessingInfo.Builder builder = promotion067GMsg.GResBlessingInfo.newBuilder();
        promotion067WeekendKoiSysInfo.getBlessingRecords().forEach(info -> {
            promotion067GMsg.PSBlessingData.Builder data = promotion067GMsg.PSBlessingData.newBuilder();
            data.setIdx(info.getIdx());
            Role role = roleService.getOrThrow(info.getRid());
            data.setNick(role.getNick());
            builder.addList(data);
        });
        playerContext.write(CmdCode._13281, builder.build());
    }

    @CMD(id = CmdCode._13282)
    public void useBlessing(PlayerContext playerContext, promotion067GMsg.GReqUseBlessing msg) {
        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.ZHOU_MO_JIN_LI),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动已结束");

        Promotion067WeekendKoi promotion067WeekendKoi = promotion067WeekendKoiService.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(promotion067WeekendKoi.getBlessingNum() < PromotionConst.WEEKEND_KOI_BLESSING_NUM,
                ErrorCode.WEEKEND_KOI_BLESSING.getValue(), "赐福次数超过赐福上限");

        Promotion067WeekendKoiSysInfo sysInfo = promotion067WeekendKoiService.getPromotionSysInfo();
        CPromotion067WeekendKoi cPromotion067WeekendKoi = promotion067WeekendKoiSysCache.getTurnsMap(sysInfo.getTurns());

        //获取奖池
        List<CPromotion067WeekendKoiPond> configList = promotion067WeekendKoiPondSysCache.getPond(cPromotion067WeekendKoi.getPond_type());
        configList = configList.stream().filter(config -> config.getShow_num() > promotion067WeekendKoi.getShowMap().getOrDefault(config.getIdx(), 0))
                .collect(Collectors.toList());

        thingService.cost(playerContext.getId(), PromotionConst.WEEKEND_KOI_BLESSING_COST, GameEvent.PROMOTION_WEEKEND_KOI_BLESSING_COST);

        //奖励
        CPromotion067WeekendKoiPond blessingConfig = DropUtil.randomDrop(configList, CPromotion067WeekendKoiPond::getDropId, CPromotion067WeekendKoiPond::getRate);

        promotion067WeekendKoi.getShowMap().put(blessingConfig.getIdx(), promotion067WeekendKoi.getShowMap().getOrDefault(blessingConfig.getIdx(), 0) + 1);
        promotion067WeekendKoi.setBlessingNum(promotion067WeekendKoi.getBlessingNum() + 1);
        promotion067WeekendKoiService.update(promotion067WeekendKoi);

        Promotion067WeekendKoiInfo info = new Promotion067WeekendKoiInfo();
        info.setIdx(blessingConfig.getIdx());
        info.setRid(playerContext.getId());
        sysInfo.getBlessingRecords().add(info);
        promotion067WeekendKoiService.updateSysInfo(sysInfo);

        thingService.add(playerContext.getId(), blessingConfig.getReward(), GameEvent.PROMOTION_WEEKEND_KOI_BLESSING_ADD, NoticeType.SLIENT);

        promotion067GMsg.GResUseBlessing.Builder builder = promotion067GMsg.GResUseBlessing.newBuilder();
        builder.setBlessingNum(promotion067WeekendKoi.getBlessingNum());
        builder.setIdx(blessingConfig.getIdx());
        for (ImmutableThing immutableThing : blessingConfig.getReward()) {
            builder.addItem(PbUtil.buildReward(immutableThing));
        }
        playerContext.write(CmdCode._13282, builder.build());


    }
}
