package com.ayjs.mxzg.cross.module.teamArena.event;

import com.ayjs.mxzg.cross.module.teamArena.domain.CrossArenaTeam;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2020/4/13
 **/
@Value(staticConstructor = "of")
public class TeamArenaScoreChangeEvent {
    private CrossArenaTeam team;
    private boolean pullToServer;
}
