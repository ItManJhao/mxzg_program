package com.ayjs.mxzg.gameserver.module.clan.struct;


import lombok.Data;

/**
 * 公会技能实体类
 * @author hyx
 */
@Data
public class ClanSkillData {

    private int skillType;//技能点亮类型当，即前点亮的位置。最大为6

    private int level;//技能等级。1 ~ 40

    private int profession;//技能职业类型

}
