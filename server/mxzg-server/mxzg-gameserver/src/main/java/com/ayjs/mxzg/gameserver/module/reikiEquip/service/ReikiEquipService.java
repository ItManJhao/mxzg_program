package com.ayjs.mxzg.gameserver.module.reikiEquip.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.reikiEquip.dao.ReikiEquipDao;
import com.ayjs.mxzg.gameserver.module.reikiEquip.domain.ReikiEquip;
import com.ayjs.mxzg.gameserver.module.reikiEquip.event.ReikiEquipAddEvent;
import com.ayjs.mxzg.gameserver.module.reikiEquip.event.ReikiEquipDelEvent;
import com.ayjs.mxzg.gameserver.module.reikiEquip.event.ReikiEquipStatusChangeEvent;
import com.ayjs.mxzg.gameserver.module.reikiEquip.event.ReikiEquipUpStarEvent;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.ReikiEquipGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 灵器
 *
 * @author hyx
 */
@Service
@Observer
public class ReikiEquipService {

    @Autowired
    private ReikiEquipDao reikiEquipDao;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private HeroService heroService;


    public List<ReikiEquip> selectAll(long rid) {
        return reikiEquipDao.list("rid", rid);
    }


    public ReikiEquip select(long rid, long equipId) {
        ReikiEquip reikiEquip = reikiEquipDao.get(equipId);
        Asserts.isTrue(reikiEquip != null && reikiEquip.getRid() == rid, ErrorCode.REIKI_EQUIP_NOT_EXIST.getValue(),
                String.format("灵器{%s},rid:{%S}不存在", equipId, rid));
        return reikiEquip;
    }

    /**
     * 查询英雄装备灵器
     *
     * @param rid
     * @param heroId
     * @return
     */
    public List<ReikiEquip> heroReikiEquip(long rid, long heroId) {
        List<ReikiEquip> list = new ArrayList<>();
        if(heroId == 0) {
        	return list;
        }
        for (ReikiEquip reikiEquip : selectAll(rid)) {
            if (reikiEquip.getHeroId() == heroId) {
                list.add(reikiEquip);
            }
        }
        return list;
    }

    public ReikiEquip add(int sysId, long rid) {
        ReikiEquip reikiEquip = new ReikiEquip();
        reikiEquip.setHeroId(0);
        reikiEquip.setRid(rid);
        reikiEquip.setSysId(sysId);
        reikiEquipDao.add(reikiEquip);
        return reikiEquip;
    }

    /**
     * 灵器穿戴或卸下,卸下装备heroId = 0
     *
     * @param equipId
     * @param hero
     * @param type    0:穿戴 1:卸下
     */
    public void changeStatus(long equipId, Hero hero, int type) {
        ReikiEquip reikiEquip = select(hero.getRid(), equipId);
        if (type == 1) {
            reikiEquip.setHeroId(0);
        } else if (type == 0) {
            reikiEquip.setHeroId(hero.getId());
        }
        this.update(reikiEquip);

        //英雄战力变动
        heroService.computeStrength(hero, GameEvent.REIKI_EQUIP_CHANGE);
    }

    public void update(ReikiEquip reikiEquip) {
        reikiEquipDao.update(reikiEquip);
    }

    public void deletes(long rid, List<Long> list, GameEvent gameEvent) {
        List<ReikiEquip> reikiEquipList = new ArrayList<>();
        for (long id : list) {
            ReikiEquip reikiEquip = this.select(rid, id);
            reikiEquipList.add(reikiEquip);
        }
        reikiEquipDao.remove(reikiEquipList);
        eventBus.post(ReikiEquipDelEvent.of(rid, reikiEquipList, gameEvent));
    }

    public void delete(ReikiEquip reikiEquip, GameEvent gameEvent) {
        reikiEquipDao.remove(reikiEquip);
        List<ReikiEquip> reikiEquipList = new ArrayList<>();
        reikiEquipList.add(reikiEquip);
        eventBus.post(ReikiEquipDelEvent.of(reikiEquip.getRid(), reikiEquipList, gameEvent));
    }

    /**
     * 英雄删除，回收英雄身上灵器
     *
     * @param rid
     * @param list
     * @param gameEvent
     */
    public void cleanHeroReikiEquip(long rid, List<Hero> list, GameEvent gameEvent) {
        List<ReikiEquip> reikiEquipList = new ArrayList<>();
        for (Hero hero : list) {//将英雄身上的发灵器卸下
            for (ReikiEquip reikiEquip : this.heroReikiEquip(rid, hero.getId())) {
                reikiEquip.setHeroId(0);
                reikiEquipDao.update(reikiEquip);
                reikiEquipList.add(reikiEquip);
            }
        }
        //脱灵器将灵器放回背包
        if (!reikiEquipList.isEmpty()) {
            eventBus.post(ReikiEquipStatusChangeEvent.of(rid, reikiEquipList));
        }
    }

    @Subscribe
    public void listen(ReikiEquipStatusChangeEvent event) {
        ReikiEquipGMsg.GResAddReikiEquip.Builder builder = ReikiEquipGMsg.GResAddReikiEquip.newBuilder();
        for (ReikiEquip reikiEquip : event.getEquipIds()) {
            builder.addData(PbUtil.builderReikiEquip(reikiEquip));
        }
        contextManager.write(event.getRid(), CmdCode._70007, builder.build());
    }


    @Subscribe
    public void listen(ReikiEquipDelEvent event) {
        ReikiEquipGMsg.GResCostReikiEquip.Builder builder = ReikiEquipGMsg.GResCostReikiEquip.newBuilder();
        for (ReikiEquip reikiEquip : event.getList()) {
            builder.addReikiEquipIds(reikiEquip.getId());
        }
        contextManager.write(event.getRid(), CmdCode._70008, builder.build());
    }


    @Subscribe
    public void listen(ReikiEquipAddEvent event) {
        ReikiEquipGMsg.GResAddReikiEquip.Builder builder = ReikiEquipGMsg.GResAddReikiEquip.newBuilder();
        for (ReikiEquip equip : event.getList()) {
            builder.addData(PbUtil.builderReikiEquip(equip));
        }
        contextManager.write(event.getRid(), CmdCode._70007, builder.build());
    }

    @Subscribe
    public void listen(ReikiEquipUpStarEvent event) {
        ReikiEquip reikiEquip = this.select(event.getRid(), event.getEquipId());
        if (reikiEquip.getHeroId() > 0) {
            Hero hero = heroService.getHero(event.getRid(), reikiEquip.getHeroId());
            heroService.computeStrength(hero, GameEvent.REIKI_EQUIP_COMBINE);
        }
    }

}
