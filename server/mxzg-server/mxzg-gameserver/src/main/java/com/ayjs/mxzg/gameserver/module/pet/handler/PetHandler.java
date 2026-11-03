package com.ayjs.mxzg.gameserver.module.pet.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.pet.PetLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.pet.PetSysCache;
import com.ayjs.mxzg.config.excel.constant.PetConst;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.excel.entity.pet.CPet;
import com.ayjs.mxzg.config.excel.entity.pet.CPetLevel;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.pet.domain.Pet;
import com.ayjs.mxzg.gameserver.module.pet.domain.PetIllustrate;
import com.ayjs.mxzg.gameserver.module.pet.event.PetChangeEvent;
import com.ayjs.mxzg.gameserver.module.pet.event.PetUpLevelEvent;
import com.ayjs.mxzg.gameserver.module.pet.service.PetService;
import com.ayjs.mxzg.protocol.PetGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * @author hyx
 */
@Component
public class PetHandler extends ProtocolHandler {

    @Autowired
    private PetService petService;
    @Autowired
    private PetLevelSysCache petLevelSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private HeroService heroService;
    @Autowired
    private PetSysCache petSysCache;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;

    /**
     * 获取宠物信息列表
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74100)
    public void sendPetDate(PlayerContext playerContext, PetGMsg.GReqPetInfoList msg) {
        PetGMsg.GResPetInfoList.Builder builder = PetGMsg.GResPetInfoList.newBuilder();
        List<Pet> petList = petService.getPetList(playerContext.getId());
        petList.forEach(pet -> {
            builder.addList(petService.builderPetInfo(pet));
        });
        playerContext.write(CmdCode._74100, builder.build());

    }

    /**
     * 宠物升级
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74101)
    public void upLevelPet(PlayerContext playerContext, PetGMsg.GReqPetUpLevel msg) {

        Pet pet = petService.getPet(playerContext.getId(), msg.getPetId());
        Asserts.notNull(pet, ErrorCode.PET_NOT_EXISTS.getValue(), String.format("宠物:{%s}不存在", msg.getPetId()));
        Asserts.isTrue(pet.getLevel() < petLevelSysCache.getPetMaxLevel(pet.getSysId()), ErrorCode.PET_LEVEL_MAX.getValue(),
                String.format("宠物等级已达上限{%s},petId{%s}", pet.getLevel(), pet.getId()));

        CPetLevel cPetLevel = petLevelSysCache.getPetConfig(pet.getSysId(), pet.getLevel());
        Asserts.isTrue(msg.getPetListList().size() == cPetLevel.getNeed_pet(), ErrorCode.PET_UP_LEVEL_NEED_NUM.getValue(),
                String.format("素材宠物数量不匹配,当前素材数量{%s}，所需数量{%s}", msg.getPetListList().size(), cPetLevel.getNeed_pet()));

        List<Pet> delPetList = new ArrayList<>();
        for (long petId : msg.getPetListList()) {
            Pet material = petService.getPet(playerContext.getId(), petId);
            Asserts.isTrue(msg.getPetId() != petId, ErrorCode.PET_NOT_UP_LEVEL_REWARD.getValue(),
                    "宠物本体不可用作升级材料");
            Asserts.notNull(material, ErrorCode.PET_NOT_EXISTS.getValue(), String.format("宠物:{%s}不存在", petId));
            Asserts.isTrue(material.getHeroId() == 0, ErrorCode.PET_NOW_CARRY_HERO.getValue(),
                    String.format("当前宠物携带在英雄身上,不可用作升级素材,{%s}", material.getHeroId()));
            Asserts.isTrue(pet.getSysId() == material.getSysId(), ErrorCode.PET_UP_LEVEL_NEED_TYPE.getValue(),
                    String.format("素材宠物类型不匹配,当前升级类型{%s},当前素材类型{%s}", pet.getSysId(), material.getSysId()));
            delPetList.add(material);
        }

        thingService.cost(playerContext.getId(), cPetLevel.getCost(), GameEvent.PET_UP_LEVEL_COST);

        petService.deleteList(delPetList, GameEvent.PET_UP_LEVEL_COST);

        pet.setLevel(pet.getLevel() + 1);
        petService.updatePet(pet);

        PetGMsg.GResPetUpLevel.Builder builder = PetGMsg.GResPetUpLevel.newBuilder();
        builder.setPet(petService.builderPetInfo(pet));
        playerContext.write(CmdCode._74101, builder.build());

        eventBus.post(PetUpLevelEvent.of(playerContext.getId(), pet.getId()));
    }

    /**
     * 宠物携带
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74102)
    public void heroCarryPet(PlayerContext playerContext, PetGMsg.GReqCarryPet msg) {
        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄{%s}不存在", msg.getHeroId()));

        Asserts.isTrue(hero.getStar() >= PetConst.OPEN_PET_HERO_STAR, ErrorCode.HERO_STAR_NOT_OPEN_NEED.getValue(),
                String.format("英雄星级未达携带要求:{%s},需求星级:{%s}", hero.getStar(), PetConst.OPEN_PET_HERO_STAR));

        Pet pet = petService.getPet(playerContext.getId(), msg.getPetId());
        Asserts.notNull(pet, ErrorCode.PET_NOT_EXISTS.getValue(), String.format("宠物不存在:{%s}", msg.getPetId()));
        Asserts.isTrue(pet.getHeroId() == 0, ErrorCode.PET_NOW_CARRY_HERO.getValue(),
                String.format("宠物已携带在英雄身上，不可重复携带,heroID:{%S}", pet.getHeroId()));

        CPet cPet = petSysCache.getOrThrow(pet.getSysId());
        CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
        Asserts.isTrue(cPet.getElem() == cHeroType.getElem(), ErrorCode.PET_ELEM_DISAFFINITY.getValue(),
                String.format("英雄元素：{%s}和宠物元素:{%s}的元素不一致", cHeroType.getElem(), cPet.getElem()));

        PetGMsg.GResCarryPet.Builder builder = PetGMsg.GResCarryPet.newBuilder();
        //查看英雄是否已携带宠物
        Pet nowPet = petService.getHeroCarryPet(playerContext.getId(), msg.getHeroId());
        if (nowPet != null) {
            nowPet.setHeroId(0);
            petService.updatePet(nowPet);
            builder.setOldPet(nowPet.getId());
        }

        pet.setHeroId(msg.getHeroId());
        petService.updatePet(pet);

        builder.setHeroId(msg.getHeroId());
        builder.setPet(petService.builderPetInfo(pet));
        playerContext.write(CmdCode._74102, builder.build());

        eventBus.post(PetChangeEvent.of(playerContext.getId(), msg.getHeroId(), msg.getPetId(), 0));
    }

    /**
     * 宠物卸下
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74103)
    public void heroDisboardPet(PlayerContext playerContext, PetGMsg.GReqDisboardPet msg) {
        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄{%s}不存在", msg.getHeroId()));

        Pet pet = petService.getPet(playerContext.getId(), msg.getPetId());
        Asserts.notNull(pet, ErrorCode.PET_NOT_EXISTS.getValue(), String.format("宠物:{%s}不存在", msg.getPetId()));
        Asserts.isTrue(pet.getHeroId() > 0, ErrorCode.PET_NOT_CARRY.getValue(), String.format("当前宠物未携带在英雄身上{%s}", pet.getId()));

        Pet nowPet = petService.getHeroCarryPet(playerContext.getId(), msg.getHeroId());
        Asserts.notNull(nowPet, ErrorCode.HERO_NOT_CARRY_PET.getValue(), String.format("当前英雄:{%s}未携带宠物", msg.getHeroId()));
        Asserts.isTrue(nowPet.getId() == pet.getId(), ErrorCode.HERO_CARRY_PET_DISAFFINITY.getValue(),
                String.format("英雄携带宠物Id:{%s}与要卸下的宠物ID{%s}不相同", nowPet.getId(), pet.getId()));

        pet.setHeroId(0);
        petService.updatePet(pet);

        PetGMsg.GResDisboardPet.Builder builder = PetGMsg.GResDisboardPet.newBuilder();
        builder.setHeroId(msg.getHeroId());
        builder.setPetId(msg.getPetId());
        playerContext.write(CmdCode._74103, builder.build());

        eventBus.post(PetChangeEvent.of(playerContext.getId(), msg.getHeroId(), msg.getPetId(), 1));
    }

    /**
     * 宠物图鉴
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74104)
    public void sendPetIllustrate(PlayerContext playerContext, PetGMsg.GReqPetIllustrate msg) {

        PetIllustrate petIllustrate = petService.getPetIllustrate(playerContext.getId());

        PetGMsg.GResPetIllustrate.Builder builder = PetGMsg.GResPetIllustrate.newBuilder();
        builder.addAllPetTypes(petIllustrate.getUnlockList());
        playerContext.write(CmdCode._74104, builder.build());
    }
}
