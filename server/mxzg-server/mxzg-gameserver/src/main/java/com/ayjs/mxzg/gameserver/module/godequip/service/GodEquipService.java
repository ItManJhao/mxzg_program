/**
 *
 */
package com.ayjs.mxzg.gameserver.module.godequip.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentRandomAbilitySysCache;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentSettypeSysCache;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentSysCache;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipment;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentRandomAbility;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentSettype;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.GodAttr;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.godequip.dao.GodEquipDao;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquip;
import com.ayjs.mxzg.gameserver.module.godequip.event.GodEquipAddEvent;
import com.ayjs.mxzg.gameserver.module.godequip.event.GodEquipChangeEvent;
import com.ayjs.mxzg.gameserver.module.godequip.event.GodEquipDeleteEvent;
import com.ayjs.mxzg.gameserver.module.godequip.struct.GodEquipSet;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.protocol.GodEquipGMsg;
import com.ayjs.mxzg.protocol.GodEquipGMsg.GResUpdateGodEquipOff;

/**
 * @author YY
 *
 */
@Observer
@Service
public class GodEquipService {

    @Autowired
    private GodEquipDao godEquipDao;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private HeroService heroService;

    public List<GodEquip> getEquips(long rid) {
        return godEquipDao.list("rid", rid);
    }

    /**
     * 获取某个英雄的装备
     * @param rid
     * @param heroId
     * @return
     */
    public List<GodEquip> getHeroEquips(long rid, long heroId) {
        List<GodEquip> list = new ArrayList<>();
        if(heroId == 0) {
        	return list;
        }
        for (GodEquip equip : this.getEquips(rid)) {
            if (equip.getHeroId() == heroId) {
                list.add(equip);
            }
        }
        return list;
    }

    /**
     * 获取玩家的某一件装备
     * @param rid
     * @param equipId
     * @return
     */
    public GodEquip getEquip(long rid, long equipId) {
        for (GodEquip equip : this.getEquips(rid)) {
            if (equip.getId() == equipId) {
                return equip;
            }
        }
        return null;
    }

    public GodEquip getPlaceEquip(long rid, long heroId, int place) {
        for (GodEquip equip : this.getEquips(rid)) {
            if (equip.getHeroId() == heroId && equip.getPlace() == place) {
                return equip;
            }
        }
        return null;
    }

    public void addEquips(List<GodEquip> equips, GameEvent gameEvent) {
        godEquipDao.add(equips);
        eventBus.post(GodEquipAddEvent.of(equips, gameEvent));
    }

    public void addEquip(GodEquip godEquip , GameEvent gameEvent){
        godEquipDao.add(godEquip);
        List<GodEquip> equips = new ArrayList<>();
        equips.add(godEquip);
        eventBus.post(GodEquipAddEvent.of(equips, gameEvent));
    }


    public void updateEquip(GodEquip equip) {
        godEquipDao.update(equip);
    }

    public void updateEquips(List<GodEquip> equips) {
        godEquipDao.update(equips);
    }

    public void deleteEquips(List<GodEquip> equips, GameEvent gameEvent) {
        godEquipDao.remove(equips);
        eventBus.post(GodEquipDeleteEvent.of(equips, gameEvent));
    }

    public void clearHeroPlaingParts(long rid, List<Hero> heroList, GameEvent gameEvent) {
        List<GodEquip> updatePartList = new ArrayList<>();
        for (Hero hero : heroList) {
            List<GodEquip> equips = this.getHeroEquips(rid, hero.getId());
            for (GodEquip equip : equips) {
                equip.setHeroId(0);
                updatePartList.add(equip);
            }
        }
        if (!updatePartList.isEmpty()) {
            this.updateEquips(updatePartList);
            //删除英雄后更新神装数据
            GResUpdateGodEquipOff.Builder builder = GResUpdateGodEquipOff.newBuilder();
            for (GodEquip godEquip : updatePartList) {
                builder.addEquipIds(godEquip.getId());
            }
            contextManager.write(rid, CmdCode._58006, builder.build());
        }
    }

    public GodEquipGMsg.PSGodEquip buildGodEquip(GodEquip equip) {
        GodEquipGMsg.PSGodEquip.Builder builder = GodEquipGMsg.PSGodEquip.newBuilder();
        builder.setId(equip.getId());
        builder.setHeroId(equip.getHeroId());
        builder.setPlace(equip.getPlace());
        builder.setSysId(equip.getSysId());
        for (GodAttr godAttr : equip.getAttrs()) {
            builder.addAttrs(buildGodAttr(godAttr));
        }
        for (GodAttr godAttr : equip.getWashAttrs()) {
            builder.addWashAttrs(buildGodAttr(godAttr));
        }
        builder.setWashNum(equip.getWashNum());
        return builder.build();
    }

    public static GodEquipGMsg.PSGodAttr buildGodAttr(GodAttr godAttr) {
        GodEquipGMsg.PSGodAttr.Builder builder = GodEquipGMsg.PSGodAttr.newBuilder();
        builder.setSort(godAttr.getSort());
        builder.setSysId(godAttr.getSysId());
        builder.setLevel(godAttr.getLevel());
        builder.setLock(godAttr.getLock());
        return builder.build();
    }

    @Subscribe
    private void listen(GodEquipChangeEvent event) {
        heroService.computeStrength(event.getHero(), event.getGameEvent());
    }

    @Subscribe
    private void listen(GodEquipAddEvent event) {
        GodEquipGMsg.GResGodEquipAdd.Builder builder = GodEquipGMsg.GResGodEquipAdd.newBuilder();
        for (GodEquip godEquip : event.getEquips()) {
            builder.addEquips(buildGodEquip(godEquip));
        }
        contextManager.write(event.getEquips().get(0).getRid(), CmdCode._58014, builder.build());
    }

    @Subscribe
    private void listen(GodEquipDeleteEvent event) {
        GodEquipGMsg.GResGodEquipDelete.Builder builder = GodEquipGMsg.GResGodEquipDelete.newBuilder();
        for (GodEquip godEquip : event.getEquips()) {
            builder.addEquipIds(godEquip.getId());
        }
        contextManager.write(event.getEquips().get(0).getRid(), CmdCode._58015, builder.build());
    }
    
    @Autowired
    private GodEquipmentSysCache godEquipmentSysCache;
    @Autowired
    private GodEquipmentRandomAbilitySysCache godEquipmentRandomAbilitySysCache;
    @Autowired
    private GodEquipmentSettypeSysCache godEquipmentSettypeSysCache;
    
    
    public void addAttr(long rid, long heroId) {
    	List<GodEquip> godEquips = getHeroEquips(rid, heroId);
    	
    	Map<Integer, GodEquipSet> equipSetMap = new HashMap<>();
    	
    	for(GodEquip godEquip : godEquips) {
    		//基础属性
    		CGodEquipment cGodEquipment = godEquipmentSysCache.getOrThrow(godEquip.getSysId());
    		cGodEquipment.getAbility();//TODO 添加属性
    		//随机属性
    		for(GodAttr godAttr : godEquip.getAttrs()) {
    			CGodEquipmentRandomAbility cGodEquipmentRandomAbility = godEquipmentRandomAbilitySysCache.getAbility(godEquip.getPlace(), cGodEquipment.getStar(),
						godAttr.getSysId(), godAttr.getLevel());
    			if(cGodEquipmentRandomAbility == null) {
    				continue;
    			}
    			cGodEquipmentRandomAbility.getAbility();//TODO 添加属性
    		}
    		//统计套装属性
    		GodEquipSet godEquipSet = equipSetMap.get(cGodEquipment.getSettype());
    		if(godEquipSet == null) {
    			godEquipSet = new GodEquipSet();
    			godEquipSet.setType(cGodEquipment.getSettype());
    			godEquipSet.setStar(cGodEquipment.getStar());
    			equipSetMap.put(cGodEquipment.getSettype(), godEquipSet);
    		}
    		if(cGodEquipment.getStar() < godEquipSet.getStar()) {
    			godEquipSet.setStar(cGodEquipment.getStar());
    		}
    		godEquipSet.setNum(godEquipSet.getNum() + 1);
    	}
    	for(GodEquipSet equipSet : equipSetMap.values()) {
            List<CGodEquipmentSettype> cGodEquipmentSettypes = godEquipmentSettypeSysCache.getAbility(equipSet.getType(), equipSet.getStar(), equipSet.getNum());
            for (CGodEquipmentSettype cGodEquipmentSettype : cGodEquipmentSettypes) {
                cGodEquipmentSettype.getAbility();//TODO 添加属性
                if(cGodEquipmentSettype.getSkill() != 0) {
                    cGodEquipmentSettype.getSkill();//TODO 添加技能
                }
            }
    	}
    }
    
}
