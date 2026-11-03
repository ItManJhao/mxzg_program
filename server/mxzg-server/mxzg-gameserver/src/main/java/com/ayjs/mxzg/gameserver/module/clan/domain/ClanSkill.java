/**
 *
 */
package com.ayjs.mxzg.gameserver.module.clan.domain;

import java.util.HashMap;
import java.util.Map;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.clan.struct.ClanSkillData;

import lombok.Getter;
import lombok.Setter;

/**
 * 公会技能表
 * @author hyx
 */
@Entity
@Table(name = "clan_skill", comment = "公会技能表")
@Getter
@Setter
public class ClanSkill extends AbstractEntity {

    @Id
    @Column(name = "rid", readOnly = true)
    private long rid;

    @Column(name = "skill_reset", comment = "技能重置次数")
    private int skillReset;

    @Column(name = "skill", comment = "公会技能")
    private Map<Integer, ClanSkillData> skillList = new HashMap<>();
    
    @Column(name = "version_reset", comment = "版本重置标记，1从5职业改成了4职业，需要返回职业5消耗资源")
    private int versionReset;

}
