package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion067WeekendKoiSysCache;
import com.ayjs.mxzg.config.excel.constant.PromotionConst;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion067WeekendKoi;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion067WeekendKoiDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion067WeekendKoiSysInfoDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion067WeekendKoi;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion067WeekendKoiSysInfo;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.WeekendKoiEvent;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.ZeroTimeEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.promotion067GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


/**
 * @author hyx
 */

@Service
@Observer
public class Promotion067WeekendKoiService extends BasePromotionService<Promotion067WeekendKoi> implements IRechargeBuyingService {

    @Autowired
    private Promotion067WeekendKoiDao promotion067WeekendKoiDao;
    @Autowired
    private Promotion067WeekendKoiSysInfoDao promotion067WeekendKoiSysInfoDao;
    @Autowired
    private Promotion067WeekendKoiSysCache promotion067WeekendKoiSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private MailService mailService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private RoleService roleService;

    private static String UPDATE_SYS_INFO = "UPDATE_SYS_INFO";


    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.ZHOU_MO_JIN_LI;
    }

    @Override
    protected void resetOnNewTurns(Promotion067WeekendKoi promotion, PromotionControl control) {
        promotion.setBlessingNum(0);
        promotion.setBuyNum(0);
        promotion.getShowMap().clear();
    }

    @Override
    public IRepository<Promotion067WeekendKoi> getRepository() {
        return promotion067WeekendKoiDao;
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.WEEKEND_KOI;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return false;
        }
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        CPromotion067WeekendKoi cPromotion067WeekendKoi = promotion067WeekendKoiSysCache.getTurnsMap(promotionControl.getTurns());
        if (cPromotion067WeekendKoi.getProduct_id() != productId) {
            return false;
        }

        if (DateTimeUtil.currentSecond() > promotionControl.getStartTime() + PromotionConst.WEEKEND_KOI_BUY_END_TIME) {
            return false;
        }

        Promotion067WeekendKoi promotion067WeekendKoi = this.getPromotionInfo(rid);
        return promotion067WeekendKoi.getBuyNum() < cPromotion067WeekendKoi.getBuy_limit();
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        Promotion067WeekendKoi promotion067WeekendKoi = this.getPromotionInfo(rid);
        promotion067WeekendKoi.setBuyNum(promotion067WeekendKoi.getBuyNum() + 1);
        this.update(promotion067WeekendKoi);

        Promotion067WeekendKoiSysInfo promotion067WeekendKoiSysInfo = this.getPromotionSysInfo();
        promotion067WeekendKoiSysInfo.getBuyList().add(rid);
        this.updateSysInfo(promotion067WeekendKoiSysInfo);

        if (isGm) {
            thingService.add(rid, cBuyGem.getItem(), GameEvent.GM);
        } else {
            thingService.add(rid, cBuyGem.getItem(), GameEvent.PROMOTION_WEEKEND_KOI_BUY_PRODUCT);
        }

        promotion067GMsg.GResBuyProduct.Builder builder = promotion067GMsg.GResBuyProduct.newBuilder();
        builder.setBuyLimit(promotion067WeekendKoi.getBuyNum());
        contextManager.write(rid, CmdCode._13284, builder.build());

    }


    public Promotion067WeekendKoiSysInfo getPromotionSysInfo() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        Promotion067WeekendKoiSysInfo sysInfo = promotion067WeekendKoiSysInfoDao.get(1);
        if (sysInfo == null) {
            synchronized (InternerPool.intern(UPDATE_SYS_INFO, 1)) {
                sysInfo = promotion067WeekendKoiSysInfoDao.get(1);
                if (sysInfo == null) {
                    sysInfo = new Promotion067WeekendKoiSysInfo();
                    sysInfo.setStartTime(promotionControl.getStartTime());
                    sysInfo.setTurns(promotionControl.getTurns());
                    sysInfo.setPhase(1);
                    promotion067WeekendKoiSysInfoDao.add(sysInfo);
                }
            }
        }
        if (sysInfo.getTurns() != promotionControl.getTurns() || sysInfo.getStartTime() != promotionControl.getStartTime()) {
            synchronized (InternerPool.intern(UPDATE_SYS_INFO, 1)) {
                if (sysInfo.getTurns() != promotionControl.getTurns() || sysInfo.getStartTime() != promotionControl.getStartTime()) {
                    sysInfo.getBlessingRecords().clear();
                    sysInfo.getBuyList().clear();
                    sysInfo.setStartTime(promotionControl.getStartTime());
                    sysInfo.setTurns(promotionControl.getTurns());
                    sysInfo.setPhase(sysInfo.getPhase() + 1);
                    sysInfo.setKoi(0);
                    this.updateSysInfo(sysInfo);
                }
            }
        }
        return sysInfo;
    }

    public void updateSysInfo(Promotion067WeekendKoiSysInfo sysInfo) {
        promotion067WeekendKoiSysInfoDao.update(sysInfo);
    }

    public void update(Promotion067WeekendKoi promotion067WeekendKoi) {
        promotion067WeekendKoiDao.update(promotion067WeekendKoi);
    }

    public void sendKoiReward() {
        if (promotionControlService.isPromotionRunning(thisPromotionType())) {
            Promotion067WeekendKoiSysInfo sysInfo = this.getPromotionSysInfo();
            PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
            if (!sysInfo.getBuyList().isEmpty() && sysInfo.getKoi() == 0 &&
                    promotionControl.getStartTime() + PromotionConst.WEEKEND_KOI_LOTTERY_KOI_TIME <= DateTimeUtil.currentSecond()) {
                //获奖玩家
                long rid = RandomUtil.getRand(sysInfo.getBuyList());
                sysInfo.setKoi(rid);
                this.updateSysInfo(sysInfo);

                CPromotion067WeekendKoi cPromotion067WeekendKoi = promotion067WeekendKoiSysCache.getTurnsMap(sysInfo.getTurns());
                Mail mail = mailService.newMailNoTitle(rid, MailScene.WEEKEND_KOI, null,
                        cPromotion067WeekendKoi.getKoi_reward(), GameEvent.PROMOTION_WEEKEND_KOI_REWARD);
                mailService.insert(mail);

                Role role = roleService.getOrThrow(rid);
                promotion067GMsg.GResKoiNick.Builder builder = promotion067GMsg.GResKoiNick.newBuilder();
                builder.setKoiNick(role.getNick());
                contextManager.writeAll(CmdCode._13283, builder.build());

                eventBus.post(WeekendKoiEvent.of(rid));
            }
        }
    }


}

