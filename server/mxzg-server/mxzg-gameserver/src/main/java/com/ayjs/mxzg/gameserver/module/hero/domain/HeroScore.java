/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 * 英雄评分
 */
@Entity
@Table(name = "hero_score", comment = "英雄评分表")
@Getter
@Setter
public class HeroScore extends AbstractEntity {
    @Id
    @Column(name = "id", comment = "英雄类型")
    private long id;
    @Column(name = "score", comment = "总评分")
    private int score;
    @Column(name = "level", comment = "等级评分")
    private int level;
    @Column(name = "star", comment = "星级评分")
    private int star;
    @Column(name = "equip", comment = "装备评分")
    private int equip;
    @Column(name = "grade", comment = "阶级评分")
    private int grade;
    @Column(name = "fetter", comment = "羁绊女神评分")
    private int fetter;
    @Column(name = "clan_skill", comment = "联盟科技评分")
    private int clanSkill;
    @Column(name = "runes", comment = "精灵符文评分")
    private int runes;

}
