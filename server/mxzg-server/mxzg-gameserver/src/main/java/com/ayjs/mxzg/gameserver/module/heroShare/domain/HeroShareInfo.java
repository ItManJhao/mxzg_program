package com.ayjs.mxzg.gameserver.module.heroShare.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.struct.*;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroMagicWand;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroEvolve;
import com.ayjs.mxzg.gameserver.module.hero.struct.Talent;
import com.ayjs.mxzg.gameserver.module.heroShare.struct.HeroShareRuneInfo;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * 英雄分享
 *
 * @author hyx
 */
@Entity
@Getter
@Setter
@Table(name = "hero_share_info", comment = "英雄分享数据")
public class HeroShareInfo extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "主键id")
    private String id;

    @Column(name = "hero_type", comment = "英雄类型")
    private int heroType;

    @Column(name = "hero_star", comment = "英雄星级")
    private int heroStar;

    @Column(name = "hero_stage", comment = "英雄品级")
    private int heroStage;

    @Column(name = "hero_level", comment = "英雄等级")
    private int heroLevel;

    @Column(name = "hero_fighting", comment = "英雄战力")
    private int heroFighting;

    @Column(name = "hero_atk", comment = "英雄攻击力")
    private long heroAtk;

    @Column(name = "hero_def", comment = "英雄防御力")
    private long heroDef;

    @Column(name = "hero_hp", comment = "英雄血量")
    private long heroHp;

    @Column(name = "hero_agl", comment = "英雄速度")
    private long heroAgl;

    @Column(name = "fashionId", comment = "英雄皮肤")
    private int fashionId;

    @Column(name = "reiki_places", comment = "激活的灵器槽位")
    private List<Integer> reikiPlaces = new ArrayList<>();

    @Column(name = "equip_list", comment = "装备列表")
    private List<EquipInfo> equipInfoList = new ArrayList<>();

    @Column(name = "rune_type", comment = "符文列表")
    private List<HeroShareRuneInfo> runeInfoList = new ArrayList<>();

    @Column(name = "jewels", comment = "装备列表")
    private List<JewelInfo> jewels = new ArrayList<>();

    @Column(name = "talents", comment = "天赋列表")
    private List<Talent> talents = new ArrayList<>();

    @Column(name = "god_equips", comment = "神装列表")
    private List<GodEquipBrief> godEquips = new ArrayList<>();

    @Column(name = "reiki_equips", comment = "灵器列表,保存灵器idx")
    private List<Integer> reikiEquips = new ArrayList<>();

    @Column(name = "pet_info", comment = "宠物信息")
    private PetInfo petInfo = new PetInfo();

    @Column(name = "hero_evolve", comment = "进化信息")
    private HeroEvolve heroEvolve = new HeroEvolve();

    @Column(name = "totems_info", comment = "图腾信息")
    private TotemsInfo totemsInfo = new TotemsInfo();

    @Column(name = "magic_info", comment = "魔杖信息")
    private HeroMagicWand heroMagicWand = new HeroMagicWand();
}
