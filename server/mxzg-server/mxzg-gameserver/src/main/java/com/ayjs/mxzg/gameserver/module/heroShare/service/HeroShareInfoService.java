package com.ayjs.mxzg.gameserver.module.heroShare.service;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.util.StrUtil;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.GodAttr;
import com.ayjs.mxzg.config.struct.GodEquipBrief;
import com.ayjs.mxzg.config.struct.JewelInfo;
import com.ayjs.mxzg.config.struct.PetInfo;
import com.ayjs.mxzg.config.struct.TotemsInfo;
import com.ayjs.mxzg.gameserver.module.chat.event.ChatDeleteEvent;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquip;
import com.ayjs.mxzg.gameserver.module.godequip.service.GodEquipService;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroEquip;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroJewel;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroMagicWand;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroEquipService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroJewelService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroMagicWandService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.Talent;
import com.ayjs.mxzg.gameserver.module.heroShare.dao.HeroShareInfoDao;
import com.ayjs.mxzg.gameserver.module.heroShare.domain.HeroShareInfo;
import com.ayjs.mxzg.gameserver.module.heroShare.struct.HeroShareRuneInfo;
import com.ayjs.mxzg.gameserver.module.marquee.constant.NoticeIdx;
import com.ayjs.mxzg.gameserver.module.pet.domain.Pet;
import com.ayjs.mxzg.gameserver.module.pet.service.PetService;
import com.ayjs.mxzg.gameserver.module.reikiEquip.domain.ReikiEquip;
import com.ayjs.mxzg.gameserver.module.reikiEquip.service.ReikiEquipService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.rune.domain.RuneInfo;
import com.ayjs.mxzg.gameserver.module.rune.service.RuneInfoService;
import com.ayjs.mxzg.gameserver.module.server.constant.ServerParamType;
import com.ayjs.mxzg.gameserver.module.server.domain.ServerParam;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.totems.domain.Totems;
import com.ayjs.mxzg.gameserver.module.totems.service.TotemsService;
import com.ayjs.mxzg.gameserver.module.tweakCube.service.TweakCubeService;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteEquipInfo;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteGodAttr;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteGodAttr.RemoteGodAttrBuilder;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteGodEquip;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteGodEquip.RemoteGodEquipBuilder;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteHeroInfo;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteJewelInfo;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteRuneInfo;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteRuneSkill;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteTalentInfo;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.function.Supplier;
import java.util.stream.Collectors;

/**
 * @author hyx
 */
@Service
@Observer
@Slf4j
public class HeroShareInfoService implements Lifecycle {

    @Autowired
    private HeroService heroService;
    @Autowired
    private HeroShareInfoDao heroShareInfoDao;
    @Autowired
    private HeroEquipService heroEquipService;
    @Autowired
    private RuneInfoService runeInfoService;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private ServerParamService serverParamService;
    @Autowired
    private HeroJewelService heroJewelService;
    @Autowired
    private GodEquipService godEquipService;
    @Autowired
    private ReikiEquipService reikiEquipService;
    @Autowired
    private PetService petService;
    @Autowired
    private TotemsService totemsService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private TweakCubeService tweakCubeService;
    @Autowired
    private HeroMagicWandService heroMagicWandService;


    //缓存本服的英雄分享id
    private CopyOnWriteArraySet<String> shareList = new CopyOnWriteArraySet<>();

    /**
     * 查询某个分享的英雄数据
     *
     * @param shareId 英雄分享表的主键id
     * @return
     */
    public HeroShareInfo get(String shareId) {
        HeroShareInfo heroShareInfo = heroShareInfoDao.get(shareId);
        Asserts.notNull(heroShareInfo, ErrorCode.HERO_SHARE_MIRROR.getValue(),
                StrUtil.format("英雄分享不存在。shareId:{}", shareId));
        return heroShareInfo;
    }

    /**
     * 添加分享英雄镜像
     *
     * @param rid
     * @param heroId
     */
    public HeroShareInfo add(long rid, long heroId) {
        HeroShareInfo heroShareInfo = buildShare(rid, heroId);
        heroShareInfoDao.addOrUpdate(heroShareInfo);
        shareList.add(heroShareInfo.getId());
        return heroShareInfo;
    }

    public HeroShareInfo buildShare(long rid, long heroId) {
        HeroShareInfo heroShareInfo = new HeroShareInfo();
        //英雄数据
        Hero hero = heroService.getHero(rid, heroId);
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄{%s}不存在或被分解。", heroId));
        heroShareInfo.setId(newHeroShareId(heroId));
        int[] tweakCubeLvAndStage = tweakCubeService.getTweakCubeLvAndStage(hero);
        heroShareInfo.setHeroLevel(tweakCubeLvAndStage[0]);
        heroShareInfo.setHeroStage(tweakCubeLvAndStage[1]);
        heroShareInfo.setHeroStar(hero.getStar());
        heroShareInfo.setHeroType(hero.getType());
        heroShareInfo.setHeroFighting(hero.getFighting());
        heroShareInfo.setFashionId(hero.getFashionId());
        heroShareInfo.setReikiPlaces(hero.getReikiPlaces());

        //进化
        heroShareInfo.getHeroEvolve().setType(hero.getEvolve().getType());
        heroShareInfo.getHeroEvolve().setLevel(hero.getEvolve().getLevel());

        //四维数据
        QueryHeroCommand command = QueryHeroCommand.createOf(hero);
        commandBus.invoke(command);
        command.getHeroDo().initAttribute();
        heroShareInfo.setHeroAtk(command.getHeroDo().getAttribute(AttributeType.ATTACK));
        heroShareInfo.setHeroHp(command.getHeroDo().getAttribute(AttributeType.MAX_HP));
        heroShareInfo.setHeroDef(command.getHeroDo().getAttribute(AttributeType.DEFENSE));
        heroShareInfo.setHeroAgl(command.getHeroDo().getAttribute(AttributeType.SPEED));

        //装备数据
        List<HeroEquip> equipList = heroEquipService.getHeroEquips(rid, hero.getId());
        for (HeroEquip heroEquip : equipList) {
            EquipInfo equipInfo = new EquipInfo();
            equipInfo.setEquipId(heroEquip.getSysId());
            equipInfo.setSoulLv(heroEquip.getSoulLv());
            equipInfo.setPos(heroEquip.getPlace());
            heroShareInfo.getEquipInfoList().add(equipInfo);
        }
        //符文数据
        List<RuneInfo> runeList = runeInfoService.getRuneOnHero(rid, hero.getId());
        for (RuneInfo rune : runeList) {
            HeroShareRuneInfo heroShareRuneInfo = new HeroShareRuneInfo();
            heroShareRuneInfo.setRuneType(rune.getTypeId());
            heroShareRuneInfo.setAbilityId(rune.getAbilityId());
            heroShareRuneInfo.getSkillList().addAll(rune.getSkillMap().values());
            heroShareInfo.getRuneInfoList().add(heroShareRuneInfo);
        }
        //宝石
        List<HeroJewel> jewelList = heroJewelService.getHeroParts(rid, hero.getId());
        for (HeroJewel heroJewel : jewelList) {
            JewelInfo info = new JewelInfo();
            info.setPos(heroJewel.getPlace());
            info.setJewelId(heroJewel.getSysId());
            heroShareInfo.getJewels().add(info);
        }
        //天赋
        for (Talent talent : hero.getTalents().values()) {
            //需要对天赋数据进行一次拷贝
            Talent info = new Talent();
            info.setSort(talent.getSort());
            info.setSkillId(talent.getSkillId());
            info.setLevel(talent.getLevel());
            heroShareInfo.getTalents().add(talent);
        }
        //神装
        List<GodEquip> godEquipList = godEquipService.getHeroEquips(rid, hero.getId());
        for (GodEquip godEquip : godEquipList) {
            GodEquipBrief info = new GodEquipBrief();
            info.setSysId(godEquip.getSysId());
            for (GodAttr godAttr : godEquip.getAttrs()) {
                GodAttr copy = new GodAttr();
                copy.setSort(godAttr.getSort());
                copy.setSysId(godAttr.getSysId());
                copy.setLevel(godAttr.getLevel());
                info.getAttrs().add(copy);
            }
            heroShareInfo.getGodEquips().add(info);
        }
        //灵器
        List<ReikiEquip> reikiEquipList = reikiEquipService.heroReikiEquip(rid, heroId);
        for (ReikiEquip reikiEquip : reikiEquipList) {
            heroShareInfo.getReikiEquips().add(reikiEquip.getSysId());
        }
        //宠物
        Pet pet = petService.getHeroCarryPet(rid, heroId);
        if (pet != null) {
            heroShareInfo.getPetInfo().setPetLevel(pet.getLevel());
            heroShareInfo.getPetInfo().setSysId(pet.getSysId());
        }
        //图腾
        Totems totems = totemsService.getTotems_byHero(rid, heroId);
        heroShareInfo.getTotemsInfo().setRid(rid);//没有图腾也要设置角色和英雄
        heroShareInfo.getTotemsInfo().setHeroId(heroId);
        if (totems != null) {
            heroShareInfo.getTotemsInfo().setLevel(totems.getLevel());
            heroShareInfo.getTotemsInfo().setSysId(totems.getTotems_id());
            heroShareInfo.getTotemsInfo().setQuality(totems.getQuality());
            int openTotemsHeroStar = systemSysCache.getOpenTotemsHeroStar();
            int openTotemsRoleLevel = systemSysCache.getOpenTotemsRoleLevel();
            Role role = roleService.getOrThrow(rid);
            boolean isOpen = false;
            if (role.getLevel() >= openTotemsRoleLevel && hero.getStar() >= openTotemsHeroStar) {
                isOpen = true;
            }
            heroShareInfo.getTotemsInfo().setOpen(isOpen);
        }
        // 魔杖
        HeroMagicWand heroMagicWand = heroMagicWandService.getMagicWandByHeroId(rid, heroId);
        HeroMagicWand heroShareMagic = heroShareInfo.getHeroMagicWand();
        heroShareMagic.setRid(rid);
        heroShareMagic.setHeroId(heroId);
        if (Objects.nonNull(heroMagicWand)) {
            heroShareMagic.setId(heroMagicWand.getId());
            heroShareMagic.setTypeId(heroMagicWand.getTypeId());
            heroShareMagic.setType(heroMagicWand.getType());
            heroShareMagic.setRare(heroMagicWand.getRare());
            heroShareMagic.setStrengthen(heroMagicWand.getStrengthen());
            heroShareMagic.setWash_times(heroMagicWand.getWash_times());
            heroShareMagic.setBase_attrs(heroMagicWand.getBase_attrs());
            heroShareMagic.setRandom_attrs(heroMagicWand.getRandom_attrs());
            heroShareMagic.setWash_attrs(heroMagicWand.getWash_attrs());
        }
        return heroShareInfo;
    }

    /**
     * 英雄分享
     *
     * @param id
     */
    private void deleteHeroShare(String id) {
        HeroShareInfo heroShareInfo = heroShareInfoDao.get(id);
        if (heroShareInfo != null) {
            heroShareInfoDao.remove(heroShareInfo);
        }
    }

    /**
     * cm
     * 监听聊天记录清除。删除分享英雄数据
     *
     * @param event
     */
    @Subscribe
    public void listen(ChatDeleteEvent event) {
        try {
            if (event.getResChat().getIdx() == NoticeIdx.HERO_SHARE_CLAN
                    || event.getResChat().getIdx() == NoticeIdx.HERO_SHARE_WORLD
                    || event.getResChat().getIdx() == NoticeIdx.HERO_SHARE_KF) {

                String shareId = event.getResChat().getParams(2);
                this.deleteHeroShare(shareId);

                shareList.remove(shareId);
            }
        } catch (Exception e) {
            log.warn("英雄分享数据清除报错，找不到分享的英雄数据，shareId:{}", event.getResChat().getIdx());
        }
    }

    private String newHeroShareId(long heroId) {
        return heroId + "" + System.currentTimeMillis();
    }

    private ServerParam getServerParam() {
        return serverParamService.getOrCreate(ServerParamType.HERO_SHARE_REDIS_ID_LIST, (Supplier<ArrayList>) ArrayList::new);
    }

    private void updateServerParam(CopyOnWriteArraySet<String> heroShareList) {
        ServerParam serverParam = getServerParam();
        serverParam.saveJson(heroShareList);
        serverParamService.update(serverParam);
    }

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._35, "HeroShareInfoService");
    }

    @Override
    public void stop() throws Exception {
        this.updateServerParam(shareList);
    }

    @Override
    public void start() throws Exception {
        List<String> heroShareList = JsonUtil.getList(this.getServerParam().getSpValue(), String.class);
        if (heroShareList.size() > 0) {
            heroShareList.forEach(this::deleteHeroShare);
        }
        this.updateServerParam(new CopyOnWriteArraySet<>());
    }

    public RemoteHeroInfo getRemoteHeroInfo(Hero hero) {
        RemoteHeroInfo.RemoteHeroInfoBuilder builder = RemoteHeroInfo.builder();
        builder.heroType(hero.getType());
        builder.star(hero.getStar());
        int[] tweakCubeLvAndStage = tweakCubeService.getTweakCubeLvAndStage(hero);
        builder.stage(tweakCubeLvAndStage[1]);
        builder.level(tweakCubeLvAndStage[0]);
        builder.fighting(hero.getFighting());
        builder.fashionId(hero.getFashionId());
        //四维数据
        QueryHeroCommand command = QueryHeroCommand.createOf(hero);
        commandBus.invoke(command);
        command.getHeroDo().initAttribute();
        builder.hp(command.getHeroDo().getAttribute(AttributeType.MAX_HP));
        builder.def(command.getHeroDo().getAttribute(AttributeType.DEFENSE));
        builder.atk(command.getHeroDo().getAttribute(AttributeType.ATTACK));
        builder.agl(command.getHeroDo().getAttribute(AttributeType.SPEED));
        builder.reiki_places(hero.getReikiPlaces());
        //宠物信息
        Pet pet = petService.getHeroCarryPet(hero.getRid(), hero.getId());
        if (pet != null) {
            PetInfo petInfo = new PetInfo();
            petInfo.setSysId(pet.getSysId());
            petInfo.setPetLevel(pet.getLevel());
            builder.pet(petInfo);
        }
        //图腾
        Totems totems = totemsService.getTotems_byHero(hero.getRid(), hero.getId());
        if (totems != null) {
            TotemsInfo totemsInfo = new TotemsInfo();
            totemsInfo.setSysId(totems.getTotems_id());
            totemsInfo.setLevel(totems.getLevel());
            totemsInfo.setQuality(totems.getQuality());
            totemsInfo.setRid(hero.getRid());
            totemsInfo.setHeroId(hero.getId());
            int openTotemsHeroStar = systemSysCache.getOpenTotemsHeroStar();
            int openTotemsRoleLevel = systemSysCache.getOpenTotemsRoleLevel();
            Role role = roleService.getOrThrow(hero.getRid());
            boolean isOpen = false;
            if (role.getLevel() >= openTotemsRoleLevel && hero.getStar() >= openTotemsHeroStar) {
                isOpen = true;
            }
            totemsInfo.setOpen(isOpen);
            builder.totemsInfo(totemsInfo);
        }
        return builder.build();
    }

    public List<RemoteEquipInfo> getRemoteEquipInfos(long rid, long heroId) {
        //装备数据
        List<HeroEquip> equipList = heroEquipService.getHeroEquips(rid, heroId);
        if (CollectionUtil.isEmpty(equipList)) {
            return Collections.emptyList();
        }
        return equipList.stream().map(heroEquip -> {
            RemoteEquipInfo.RemoteEquipInfoBuilder builder = RemoteEquipInfo.builder();
            builder.place(heroEquip.getPlace());
            builder.equipType(heroEquip.getSysId());
            return builder.build();
        }).collect(Collectors.toList());
    }

    public List<RemoteRuneInfo> getRemoteRuneInfos(long rid, long heroId) {
        //符文数据
        List<RuneInfo> runeInfoList = runeInfoService.getRuneOnHero(rid, heroId);
        if (CollectionUtil.isEmpty(runeInfoList)) {
            return Collections.emptyList();
        }

        return runeInfoList.stream().map(runeInfo -> {
            RemoteRuneInfo.RemoteRuneInfoBuilder builder = RemoteRuneInfo.builder();
            builder.itemType(runeInfo.getTypeId());
            builder.abilityId(runeInfo.getAbilityId());
            if (CollectionUtil.isNotEmpty(runeInfo.getSkillMap())) {
                List<RemoteRuneSkill> runeSkillList = runeInfo.getSkillMap().values().stream().map(runeSkill -> {
                    RemoteRuneSkill.RemoteRuneSkillBuilder skillBuild = RemoteRuneSkill.builder();
                    skillBuild.skillId(runeSkill.getSkillId());
                    skillBuild.sort(runeSkill.getSort());
                    skillBuild.level(runeSkill.getLevel());
                    return skillBuild.build();
                }).collect(Collectors.toList());
                builder.skill(runeSkillList);
            }
            return builder.build();
        }).collect(Collectors.toList());
    }

    public List<RemoteJewelInfo> getRemoteJewelInfo(long rid, long heroId) {
        List<HeroJewel> jewelList = heroJewelService.getHeroParts(rid, heroId);
        List<RemoteJewelInfo> jewels = new ArrayList<>();
        for (HeroJewel jewel : jewelList) {
            RemoteJewelInfo.RemoteJewelInfoBuilder builder = RemoteJewelInfo.builder();
            builder.pos(jewel.getPlace());
            builder.jewelType(jewel.getSysId());
            jewels.add(builder.build());
        }
        return jewels;
    }

    public List<RemoteTalentInfo> getRemoteTalentInfo(long rid, long heroId) {
        Hero hero = heroService.getHero(rid, heroId);
        List<RemoteTalentInfo> talents = new ArrayList<>();
        for (Talent talent : hero.getTalents().values()) {
            RemoteTalentInfo.RemoteTalentInfoBuilder builder = RemoteTalentInfo.builder();
            builder.sort(talent.getSort());
            builder.skillId(talent.getSkillId());
            builder.level(talent.getLevel());
            talents.add(builder.build());
        }
        return talents;
    }

    public List<RemoteGodEquip> getRemoteGodEquip(long rid, long heroId) {
        List<GodEquip> godEquipList = godEquipService.getHeroEquips(rid, heroId);
        List<RemoteGodEquip> godEquips = new ArrayList<>();
        for (GodEquip godEquip : godEquipList) {
            RemoteGodEquipBuilder builder = RemoteGodEquip.builder();
            builder.sysId(godEquip.getSysId());
            List<RemoteGodAttr> attrs = new ArrayList<>();
            for (GodAttr godAttr : godEquip.getAttrs()) {
                RemoteGodAttrBuilder model = RemoteGodAttr.builder();
                model.sort(godAttr.getSort());
                model.sysId(godAttr.getSysId());
                model.level(godAttr.getLevel());
                attrs.add(model.build());
            }
            builder.attrs(attrs);
            godEquips.add(builder.build());
        }
        return godEquips;
    }

    public List<Integer> getReikiEquip(long rid, long heroId) {
        List<Integer> list = new ArrayList<>();
        for (ReikiEquip reikiEquip : reikiEquipService.heroReikiEquip(rid, heroId)) {
            list.add(reikiEquip.getSysId());
        }
        return list;
    }

}
