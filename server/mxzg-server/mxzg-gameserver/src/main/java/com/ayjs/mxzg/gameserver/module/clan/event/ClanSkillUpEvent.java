package com.ayjs.mxzg.gameserver.module.clan.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import lombok.Value;

/**
 * 公会技能升级
 *
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class ClanSkillUpEvent {
    private long rid;
    private int occupation;
    private GameEvent gameEvent;
}
