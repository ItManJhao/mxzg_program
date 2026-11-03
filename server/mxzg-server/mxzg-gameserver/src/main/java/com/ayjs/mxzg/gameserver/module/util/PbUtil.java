package com.ayjs.mxzg.gameserver.module.util;

import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.util.IThing;
import com.ayjs.mxzg.config.struct.GodAttr;
import com.ayjs.mxzg.config.struct.GodEquipBrief;
import com.ayjs.mxzg.config.struct.PetInfo;
import com.ayjs.mxzg.config.struct.TotemsInfo;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.domain.ShenBinEquip;
import com.ayjs.mxzg.gameserver.module.godequip.service.GodEquipService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroEquip;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroJewel;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroEvolve;
import com.ayjs.mxzg.gameserver.module.hero.struct.Talent;
import com.ayjs.mxzg.gameserver.module.reikiEquip.domain.ReikiEquip;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.protocol.CrusadeGroupShenBinGMsg;
import com.ayjs.mxzg.protocol.HeroGMsg;
import com.ayjs.mxzg.protocol.HeroGMsg.PSEquipData;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.PSJewelData;
import com.ayjs.mxzg.protocol.HeroPalaceGMsg;
import com.ayjs.mxzg.protocol.HeroShareGMsg;
import com.ayjs.mxzg.protocol.HeroShareGMsg.ResGodEquip;
import com.ayjs.mxzg.protocol.HeroTalentGMsg.PSHeroTalent;
import com.ayjs.mxzg.protocol.LoginGMsg;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSBackpackData;
import com.ayjs.mxzg.protocol.ReikiEquipGMsg;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * @description:封装一下重复性高的PB生成
 * @author: CWJ
 * @date: 2019/10/12 12:15
 */
public class PbUtil {

    public static List<ObjectGMsg.PSBackpackData> buildReward(Rewards rewards) {
        List<ObjectGMsg.PSBackpackData> result = new ArrayList<>();
        if (Objects.isNull(rewards) || Objects.isNull(rewards.getThingSet())) {
            return result;
        }
        rewards.getThingSet().asList().forEach(reward -> result.add(buildReward(reward)));
        return result;
    }

    public static List<ObjectGMsg.PSBackpackData> buildReward(List<? extends IThing> rewards) {
        List<ObjectGMsg.PSBackpackData> result = new ArrayList<>();
        rewards.forEach(reward -> result.add(buildReward(reward)));
        return result;
    }

    public static PSBackpackData buildReward(IThing reward) {
        PSBackpackData.Builder builder = PSBackpackData.newBuilder();
        builder.setNum(reward.getNum());
        builder.setType(reward.getThingId());
        return builder.build();
    }


    public static LoginGMsg.GResError builderError(int code, List<String> params) {
        LoginGMsg.GResError.Builder builder = LoginGMsg.GResError.newBuilder();
        builder.setError(code);
        if (Objects.nonNull(params)) {
            builder.addAllParams(params);
        }
        return builder.build();
    }

    public static PSEquipData buildEquip(HeroEquip equip) {
        PSEquipData.Builder builder = PSEquipData.newBuilder();
        builder.setEquipId(equip.getId());
        builder.setEquipType(equip.getSysId());
        builder.setPlace(equip.getPlace());
        builder.setSoulLv(equip.getSoulLv());
        return builder.build();
    }

    public static PSJewelData buildJewel(HeroJewel jewel) {
        PSJewelData.Builder builder = PSJewelData.newBuilder();
        builder.setJewelId(jewel.getId());
        builder.setJewelType(jewel.getSysId());
        builder.setPlace(jewel.getPlace());
        return builder.build();
    }

    public static PSHeroTalent serializeTalent(Talent talent) {
        PSHeroTalent.Builder builder = PSHeroTalent.newBuilder();
        builder.setSlot(talent.getSort());
        builder.setSkillId(talent.getSkillId());
        builder.setLevel(talent.getLevel());
        return builder.build();
    }

    public static ObjectGMsg.PSMapData builderMap(int key, int value) {
        ObjectGMsg.PSMapData.Builder builder = ObjectGMsg.PSMapData.newBuilder();
        builder.setKey(key);
        builder.setValue(value);
        return builder.build();
    }

    public static HeroPalaceGMsg.PSRoleSimpleInfo.Builder builderRoleInfo(Role role) {
        HeroPalaceGMsg.PSRoleSimpleInfo.Builder builder = HeroPalaceGMsg.PSRoleSimpleInfo.newBuilder();
        builder.setLevel(role.getLevel());
        builder.setNick(role.getNick());
        builder.setPlayerId(role.getId());
        builder.setHeadId(role.getHeadId());
        builder.setBorderId(role.getBorderId());
        builder.setServerId(role.getServerId());
        builder.setClanId(role.getClanId());
        builder.setImageId(role.getImageId());
        builder.setFighting(role.getFighting());
        //TODO 公会名
//        builder.setFighting().
        return builder;
    }


    public static ResGodEquip buildGodEquip(GodEquipBrief godEquip) {
        ResGodEquip.Builder builder = ResGodEquip.newBuilder();
        builder.setSysId(godEquip.getSysId());
        for (GodAttr godAttr : godEquip.getAttrs()) {
            builder.addAttrs(GodEquipService.buildGodAttr(godAttr));
        }
        return builder.build();
    }

    public static ReikiEquipGMsg.PSReikiEquipData builderReikiEquip(ReikiEquip reikiEquip) {
        ReikiEquipGMsg.PSReikiEquipData.Builder builder = ReikiEquipGMsg.PSReikiEquipData.newBuilder();
        builder.setReikiEquipId(reikiEquip.getId());
        builder.setSysId(reikiEquip.getSysId());
        builder.setHeroId(reikiEquip.getHeroId());
        return builder.build();
    }

    public static HeroGMsg.PSHeroEvolve builderEvolve(HeroVo heroVo) {
        return builderEvolve(heroVo.getEvolve().getType(), heroVo.getEvolve().getLevel());
    }

    public static HeroGMsg.PSHeroEvolve builderEvolve(Hero hero) {
        return builderEvolve(hero.getEvolve().getType(), hero.getEvolve().getLevel());
    }

    public static HeroGMsg.PSHeroEvolve builderEvolve(int evolveType, int level) {
        HeroGMsg.PSHeroEvolve.Builder builder = HeroGMsg.PSHeroEvolve.newBuilder();
        builder.setType(evolveType);
        builder.setLevel(level);
        return builder.build();
    }

    public static HeroGMsg.PSHeroEvolve builderEvolve(HeroEvolve heroEvolve) {
        HeroGMsg.PSHeroEvolve.Builder builder = HeroGMsg.PSHeroEvolve.newBuilder();
        builder.setType(heroEvolve.getType());
        builder.setLevel(heroEvolve.getLevel());
        return builder.build();
    }

    public static HeroShareGMsg.ResPetInfo builderPet(PetInfo petInfo) {
        HeroShareGMsg.ResPetInfo.Builder builder = HeroShareGMsg.ResPetInfo.newBuilder();
        builder.setSysId(petInfo.getSysId());
        builder.setLevel(petInfo.getPetLevel());
        return builder.build();
    }

    public static HeroShareGMsg.ResTotemInfo builderTotems(TotemsInfo totemsInfo) {
        HeroShareGMsg.ResTotemInfo.Builder builder = HeroShareGMsg.ResTotemInfo.newBuilder();
        builder.setSysId(totemsInfo.getSysId());
        builder.setLevel(totemsInfo.getLevel());
        builder.setQuality(totemsInfo.getQuality());
        builder.setIsOpen(totemsInfo.isOpen());
        return builder.build();
    }


    public static CrusadeGroupShenBinGMsg.PSHoleData buildShenBinEquip(ShenBinEquip equip) {
        CrusadeGroupShenBinGMsg.PSHoleData.Builder builder = CrusadeGroupShenBinGMsg.PSHoleData.newBuilder();
        builder.setEquipId(equip.getId());
        builder.setEquipType(equip.getSysId());
        builder.setPlace(equip.getPlace());
        return builder.build();
    }

}
