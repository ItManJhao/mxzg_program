package com.ayjs.mxzg.gameserver.module.pet.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.pet.PetLevelSysCache;
import com.ayjs.mxzg.config.excel.constant.PetConst;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroComebackEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSwitchEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.pet.dao.PetDao;
import com.ayjs.mxzg.gameserver.module.pet.dao.PetIllustrateDao;
import com.ayjs.mxzg.gameserver.module.pet.domain.Pet;
import com.ayjs.mxzg.gameserver.module.pet.domain.PetIllustrate;
import com.ayjs.mxzg.gameserver.module.pet.event.PetAddEvent;
import com.ayjs.mxzg.gameserver.module.pet.event.PetChangeEvent;
import com.ayjs.mxzg.gameserver.module.pet.event.PetDelEvent;
import com.ayjs.mxzg.gameserver.module.pet.event.PetUpLevelEvent;
import com.ayjs.mxzg.protocol.PetGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 宠物
 *
 * @author hyx
 */
@Observer
@Service
public class PetService {

    @Autowired
    private PetIllustrateDao petIllustrateDao;
    @Autowired
    private PetDao petDao;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ThingService thingService;
    @Autowired
    private PetLevelSysCache petLevelSysCache;
    @Autowired
    private HeroService heroService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;


    public PetIllustrate getPetIllustrate(long rid) {
        PetIllustrate petIllustrate = petIllustrateDao.get(rid);
        if (petIllustrate == null) {
            petIllustrate = new PetIllustrate();
            petIllustrate.setRid(rid);
            petIllustrateDao.add(petIllustrate);
        }
        return petIllustrate;
    }

    public void updateIllustrate(PetIllustrate petIllustrate) {
        petIllustrateDao.update(petIllustrate);
    }

    public void addPet(Pet pet) {
        petDao.add(pet);
    }

    public void updatePet(Pet pet) {
        petDao.update(pet);
    }

    public List<Pet> getPetList(long rid) {
        return petDao.list("rid", rid);
    }

    public void deleteList(List<Pet> petList, GameEvent gameEvent) {
        petDao.remove(petList);
        long rid = petList.get(0).getRid();
        this.comeBackItem(rid, petList);
        eventBus.post(PetDelEvent.of(rid, petList, gameEvent));
    }

    public Pet getPet(long rid, long petId) {
        List<Pet> petList = getPetList(rid);
        Pet pet = null;
        for (Pet myPet : petList) {
            if (myPet.getId() == petId) {
                pet = myPet;
            }
        }
        return pet;
    }

    /**
     * 获取英雄身上携带的宠物
     *
     * @param rid
     * @param heroId
     * @return
     */
    public Pet getHeroCarryPet(long rid, long heroId) {
        Pet pet = null;
        for (Pet myPet : this.getPetList(rid)) {
            if (myPet.getHeroId() == heroId && heroId > 0) {
                pet = myPet;
            }
        }
        return pet;
    }

    /**
     * 英雄删除宠物返回
     *
     * @param rid
     * @param list
     * @param gameEvent
     */
    public void cleanHeroPet(long rid, List<Hero> list, GameEvent gameEvent) {
        for (Hero hero : list) {
            this.disboardPet(rid, hero.getId());
        }
    }

    public PetGMsg.PSPetInfo builderPetInfo(Pet pet) {
        PetGMsg.PSPetInfo.Builder data = PetGMsg.PSPetInfo.newBuilder();
        data.setHeroId(pet.getHeroId());
        data.setSysId(pet.getSysId());
        data.setLevel(pet.getLevel());
        data.setPetId(pet.getId());
        return data.build();
    }

    private void comeBackItem(long rid, List<Pet> petList) {
        List<ImmutableThing> rewardList = new ArrayList<>();
        for (Pet pet : petList) {
            petLevelSysCache.getAll().stream().filter(config -> config.getLevel() < pet.getLevel() &&
                    config.getId() == pet.getSysId()).forEach(config -> {
                rewardList.addAll(config.getCost());
            });
        }
        if (!rewardList.isEmpty()) {
            thingService.add(rid, ImmutableThingUtil.mergeThing(rewardList), GameEvent.PET_DEL_COME_BACK);
        }
    }

    @Subscribe
    public void listen(PetAddEvent event) {
        PetIllustrate petIllustrate = this.getPetIllustrate(event.getRid());
        List<Integer> unlockIds = new ArrayList<>();
        PetGMsg.GResAddPetInfo.Builder builder = PetGMsg.GResAddPetInfo.newBuilder();
        for (Pet pet : event.getPetList()) {
            builder.addList(builderPetInfo(pet));
            //验证是否解锁新的图鉴
            if (!petIllustrate.getUnlockList().contains(pet.getSysId()) && !unlockIds.contains(pet.getSysId())) {
                unlockIds.add(pet.getSysId());
            }
        }
        contextManager.write(event.getRid(), CmdCode._74105, builder.build());

        //同步前端更新图鉴
        if (!unlockIds.isEmpty()) {
            petIllustrate.getUnlockList().addAll(unlockIds);
            this.updateIllustrate(petIllustrate);

            PetGMsg.GResPetIllustrate.Builder builder2 = PetGMsg.GResPetIllustrate.newBuilder();
            builder2.addAllPetTypes(petIllustrate.getUnlockList());
            contextManager.write(event.getRid(), CmdCode._74104, builder2.build());
        }

    }

    @Subscribe
    public void listen(PetDelEvent event) {
        PetGMsg.GResDelPetInfo.Builder builder = PetGMsg.GResDelPetInfo.newBuilder();
        for (Pet pet : event.getPets()) {
            builder.addPetIds(pet.getId());
        }
        contextManager.write(event.getRid(), CmdCode._74106, builder.build());
    }

    @Subscribe
    public void listen(PetChangeEvent event) {
        Hero hero = heroService.getHero(event.getRid(), event.getHeroId());
        heroService.computeStrength(hero, GameEvent.PET_CARRY_STATUS);
    }

    @Subscribe
    public void listen(PetUpLevelEvent event) {
        Pet pet = this.getPet(event.getRid(), event.getPetId());
        if (pet != null && pet.getHeroId() > 0) {
            Hero hero = heroService.getHero(event.getRid(), pet.getHeroId());
            heroService.computeStrength(hero, GameEvent.PET_UP_LEVEL);
        }
    }

    /**
     * 英雄置换
     *
     * @param event
     */
    @Subscribe
    public void listen(HeroSwitchEvent event) {
        //更换了英雄元素需要卸下英雄
        CHeroType oldHeroType = heroTypeSysCache.getOrThrow(event.getOriType());
        CHeroType newHeroType = heroTypeSysCache.getOrThrow(event.getHero().getType());
        if (oldHeroType.getElem() != newHeroType.getElem()) {
            this.disboardPet(event.getHero().getRid(), event.getHero().getId());
            heroService.computeStrength(event.getHero(), GameEvent.PET_CARRY_STATUS);
        }
    }

    /**
     * 英雄回退
     *
     * @param event
     */
    @Subscribe
    public void listen(HeroComebackEvent event) {
        if (event.getHero().getStar() < PetConst.OPEN_PET_HERO_STAR) {
            this.disboardPet(event.getHero().getRid(), event.getHero().getId());
            heroService.computeStrength(event.getHero(), GameEvent.PET_CARRY_STATUS);
        }
    }

    /**
     * 卸下宠物
     *
     * @param rid
     * @param heroId
     */
    private void disboardPet(long rid, long heroId) {
        Pet pet = this.getHeroCarryPet(rid, heroId);
        if (pet != null) {
            pet.setHeroId(0);
            this.updatePet(pet);
            PetGMsg.GResDisboardPet.Builder builder = PetGMsg.GResDisboardPet.newBuilder();
            builder.setHeroId(heroId);
            builder.setPetId(pet.getId());
            contextManager.write(rid, CmdCode._74103, builder.build());
        }
    }

}
