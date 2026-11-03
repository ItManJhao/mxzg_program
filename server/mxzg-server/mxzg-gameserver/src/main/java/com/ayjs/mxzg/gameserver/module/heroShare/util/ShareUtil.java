/**
 *
 */
package com.ayjs.mxzg.gameserver.module.heroShare.util;

import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.JewelInfo;
import com.ayjs.mxzg.config.struct.RuneSkill;
import com.ayjs.mxzg.gameserver.module.heroShare.struct.HeroShareRuneInfo;
import com.ayjs.mxzg.gameserver.module.rune.service.RuneInfoService;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteEquipInfo;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteGodAttr;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteGodEquip;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteJewelInfo;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteRuneInfo;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteRuneSkill;
import com.ayjs.mxzg.message.module.hero.message.dto.RemoteTalentInfo;
import com.ayjs.mxzg.protocol.GodEquipGMsg.PSGodAttr;
import com.ayjs.mxzg.protocol.HeroJewelGMsg.PSJewelData;
import com.ayjs.mxzg.protocol.HeroShareGMsg.ResEquipInfo;
import com.ayjs.mxzg.protocol.HeroShareGMsg.ResGodEquip;
import com.ayjs.mxzg.protocol.HeroShareGMsg.ResRuneInfo;
import com.ayjs.mxzg.protocol.HeroTalentGMsg.PSHeroTalent;
import com.ayjs.mxzg.protocol.RuneGMsg.PSRuneSkill;

/**
 * @author YY
 *
 */
public class ShareUtil {

    public static ResEquipInfo buildEquip(RemoteEquipInfo equip) {
        ResEquipInfo.Builder builder = ResEquipInfo.newBuilder();
        builder.setPlace(equip.getPlace());
        builder.setEquipType(equip.getEquipType());
        return builder.build();
    }

    public static ResEquipInfo buildEquip(EquipInfo equip) {
        ResEquipInfo.Builder builder = ResEquipInfo.newBuilder();
        builder.setPlace(equip.getPos());
        builder.setEquipType(equip.getEquipId());
        builder.setSoulLv(equip.getSoulLv());
        return builder.build();
    }

    public static PSJewelData buildJewel(RemoteJewelInfo jewel) {
        PSJewelData.Builder builder = PSJewelData.newBuilder();
        builder.setJewelType(jewel.getJewelType());
        builder.setPlace(jewel.getPos());
        return builder.build();
    }

    public static PSJewelData buildJewel(JewelInfo jewel) {
        PSJewelData.Builder builder = PSJewelData.newBuilder();
        builder.setJewelType(jewel.getJewelId());
        builder.setPlace(jewel.getPos());
        return builder.build();
    }

    public static PSHeroTalent buildTalent(RemoteTalentInfo talent) {
        PSHeroTalent.Builder builder = PSHeroTalent.newBuilder();
        builder.setSlot(talent.getSort());
        builder.setSkillId(talent.getSkillId());
        builder.setLevel(talent.getLevel());
        return builder.build();
    }

    public static PSRuneSkill buildRuneSkill(RemoteRuneSkill skill) {
        PSRuneSkill.Builder builder = PSRuneSkill.newBuilder();
        builder.setSort(skill.getSort());
        builder.setLevel(skill.getLevel());
        builder.setSkillId(skill.getSkillId());
        return builder.build();
    }

    public static ResRuneInfo buildRune(HeroShareRuneInfo rune) {
        ResRuneInfo.Builder builder = ResRuneInfo.newBuilder();
        builder.setItemType(rune.getRuneType());
        builder.setAbilityId(rune.getAbilityId());
        for (RuneSkill runeSkill : rune.getSkillList()) {
            builder.addSkill(RuneInfoService.serializeRuneSkill(runeSkill));
        }
        return builder.build();
    }

    public static ResRuneInfo buildRune(RemoteRuneInfo rune) {
        ResRuneInfo.Builder builder = ResRuneInfo.newBuilder();
        builder.setItemType(rune.getItemType());
        builder.setAbilityId(rune.getAbilityId());
        for (RemoteRuneSkill skill : rune.getSkill()) {
            builder.addSkill(ShareUtil.buildRuneSkill(skill));
        }
        return builder.build();
    }

    public static ResGodEquip buildGodEquip(RemoteGodEquip equip) {
        ResGodEquip.Builder builder = ResGodEquip.newBuilder();
        builder.setSysId(equip.getSysId());
        if (equip.getAttrs() != null) {
            for (RemoteGodAttr attr : equip.getAttrs()) {
                PSGodAttr.Builder model = PSGodAttr.newBuilder();
                model.setSort(attr.getSort());
                model.setSysId(attr.getSysId());
                model.setLevel(attr.getLevel());
                builder.addAttrs(model.build());
            }
        }
        return builder.build();
    }
}
