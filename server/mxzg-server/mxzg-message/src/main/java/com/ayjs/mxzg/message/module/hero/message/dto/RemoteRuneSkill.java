package com.ayjs.mxzg.message.module.hero.message.dto;

import lombok.Builder;
import lombok.Data;

/**
 * 符文技能
 */
@Builder
@Data
public class RemoteRuneSkill {
    private int sort;
    private int skillId;
    private int level;
}
