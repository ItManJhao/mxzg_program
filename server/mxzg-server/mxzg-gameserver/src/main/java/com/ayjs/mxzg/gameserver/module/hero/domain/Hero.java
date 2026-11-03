/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.struct.HeroInfo;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroAwaken;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroEvolve;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroHexagram;
import com.ayjs.mxzg.gameserver.module.hero.struct.Talent;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "hero", comment = "英雄表", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Getter
@Setter
public class Hero extends AbstractEntity {
    @Id
    @LongIdGenerate
    @Column(name = "id")
    private long id;
    @Column(name = "rid", readOnly = true)
    private long rid;
    @Column(name = "type", comment = "配置表ID")
    private int type;
    @Column(name = "level", comment = "英雄等级")
    private int level;
    @Column(name = "star", comment = "英雄星级")
    private int star;
    @Column(name = "stage", comment = "英雄阶级")
    private int stage;
    @Column(name = "is_lock", comment = "是否已经锁定，0未锁定，1已锁定")
    private int isLock;
    @Column(name = "fighting", comment = "英雄战斗力")
    private int fighting;
    @Column(name = "create_time", comment = "英雄获得时间")
    private int createTime;
    @Column(name = "talents", comment = "天赋技能信息，位置信息_技能信息")
    private Map<Integer, Talent> talents = new HashMap<>();
    @Column(name = "fashion_id", comment = "当前穿戴的皮肤，不穿戴皮肤为0")
    private int fashionId;
    @Column(name = "atk", comment = "攻击力")
    private long atk;
    @Column(name = "def", comment = "防御力")
    private long def;
    @Column(name = "hp", comment = "血量")
    private long hp;
    @Column(name = "spd", comment = "速度")
    private long spd;
    @Column(name = "name", comment = "英雄名字，用于查看", nullable = true)
    private String name;
    @Column(name = "reiki_places", comment = "激活的灵器槽位")
    private List<Integer> reikiPlaces = new ArrayList<>();
    @Column(name = "evolve", comment = "进化数据")
    private HeroEvolve evolve = new HeroEvolve();
    @Column(name = "awaken", comment = "觉醒数据")
    private HeroAwaken awaken = new HeroAwaken();
    @Column(name = "HeroHexagram", comment = "六芒星")
    private List<HeroHexagram> hexagram = new ArrayList<>();
//    @Column(name = "rune_stone_equip", comment = "符石穿戴信息")
//    private Map<Integer, Long> runeStoneEquip = Maps.newHashMap();

    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }

    /**
     * 转换成HeroInfo
     * @return
     */
    public HeroInfo toHeroInfo() {
        return HeroInfo.valueOf(id, type, star, level, stage, 1);
    }

    /**
     * 是否有重复的技能
     * @param skillType
     * @return
     */
    public boolean isRepetitiveSkills(int skillType) {
        for (Talent talent : this.getTalents().values()) {
            if (talent.getSkillId() == skillType) {
                return true;
            }
        }
        return false;
    }

//    /***
//     * 符石位置是否开放
//     * @param place
//     * @return
//     */
//    public boolean runeStonePlaceOpen(int place) {
//        return runeStoneEquip.containsKey(place);
//    }
//
//    public Long equipRuneStone(int place, long runeStoneId) {
//        if (!runeStoneEquip.containsKey(place)) {
//            throw new RuntimeException("逻辑错误，位置未开放");
//        }
//        return runeStoneEquip.put(place, runeStoneId);
//    }
}
