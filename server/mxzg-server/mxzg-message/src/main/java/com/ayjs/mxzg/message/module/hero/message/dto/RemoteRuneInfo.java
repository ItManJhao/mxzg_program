package com.ayjs.mxzg.message.module.hero.message.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Builder
@Data
public class RemoteRuneInfo {
    private int itemType;//类型
    private int abilityId;//属性id
    private List<RemoteRuneSkill> skill;    //技能
}
