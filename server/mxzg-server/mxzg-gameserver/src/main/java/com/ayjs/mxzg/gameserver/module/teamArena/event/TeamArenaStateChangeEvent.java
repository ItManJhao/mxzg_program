package com.ayjs.mxzg.gameserver.module.teamArena.event;

import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaState;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2020/4/15
 **/
@Value(staticConstructor = "of")
public class TeamArenaStateChangeEvent {

   private TeamArenaState teamArenaState;
}
