package com.ayjs.mxzg.gameserver.module.hero.service;


import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.config.excel.constant.HeroConst;
import com.ayjs.mxzg.config.excel.constant.HeroPrayerConst;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.dao.HeroPrayerDao;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroPrayer;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSummonEvent;
import com.ayjs.mxzg.gameserver.module.hero.struct.SummonType;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.protocol.HeroPrayerGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 英雄祈愿
 *
 * @author hyx
 */
@Observer
@Service
public class HeroPrayerService implements IRechargeBuyingService {

    @Autowired
    private HeroPrayerDao heroPrayerDao;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private ThingService thingService;

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.HERO_SUMMON;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        HeroPrayer heroPrayer = this.select(rid);
        if (heroPrayer.getPrayerPrivilege() == 1) {
            return false;
        }
        return true;
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        HeroPrayer heroPrayer = this.select(rid);
        heroPrayer.setPrayerPrivilege(1);
        heroPrayer.setEnd_time(DateTimeUtil.currentSecond() + TimeConstants.ONE_DAY_SECOND * HeroPrayerConst.HERO_PRAYER_DURATION);
        this.update(heroPrayer);
        this.sendHeroPrayerData(heroPrayer);
    }

    /**
     * 获取英雄祈愿数据
     *
     * @param rid
     * @return
     */
    public HeroPrayer select(long rid) {
        HeroPrayer heroPrayer = heroPrayerDao.get(rid);
        if (heroPrayer == null) {
            heroPrayer = new HeroPrayer();
            heroPrayer.setRid(rid);
            heroPrayerDao.add(heroPrayer);
        }
        //若特权已经结束，便更新状态
        if (heroPrayer.getPrayerPrivilege() == 1 &&
                heroPrayer.getEnd_time() < DateTimeUtil.currentSecond()) {
            heroPrayer.setPrayerPrivilege(0);
            heroPrayer.setEnd_time(0);
            heroPrayerDao.update(heroPrayer);
        }
        return heroPrayer;
    }

    public void update(HeroPrayer heroPrayer) {
        heroPrayerDao.update(heroPrayer);
    }

    /**
     * 发送英雄祈愿数据
     *
     * @param heroPrayer
     */
    public void sendHeroPrayerData(HeroPrayer heroPrayer) {
        HeroPrayerGMsg.GResHeroPrayerData.Builder builder = HeroPrayerGMsg.GResHeroPrayerData.newBuilder();

        builder.setPrivilege(heroPrayer.getPrayerPrivilege());
        builder.setEndTime(heroPrayer.getEnd_time());

        contextManager.write(heroPrayer.getRid(), CmdCode._4201, builder.build());
    }

    /**
     * 监听英雄召唤
     *
     * @param event
     */
    @Subscribe
    public void listen(HeroSummonEvent event) {
        if (event.getType() == SummonType.HIGH) {//必须为高级召唤
            HeroPrayer heroPrayer = this.select(event.getRid());
            long addItemNum = event.getSummonCount();//当前高超次数
            if (heroPrayer.getPrayerPrivilege() != 1) {//未开通特权道具不能超上限
                long itemCount = thingService.getCount(event.getRid(), ItemType.IT_PRAYER);
                if (itemCount + addItemNum > HeroConst.ADV_SUMMON_WISH_TIME) {
                    addItemNum = HeroConst.ADV_SUMMON_WISH_TIME - itemCount;
                }
            }
            if (addItemNum > 0) {
                ImmutableThing immutableThing = ImmutableThing.of(ItemType.IT_PRAYER, addItemNum);
                thingService.add(event.getRid(), immutableThing, GameEvent.HERO_SUMMON_AWARD, NoticeType.SLIENT);
            }
        }
    }
}
