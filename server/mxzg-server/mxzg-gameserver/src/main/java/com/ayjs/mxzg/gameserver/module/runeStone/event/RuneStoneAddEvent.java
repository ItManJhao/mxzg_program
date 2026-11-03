package com.ayjs.mxzg.gameserver.module.runeStone.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.runeStone.domain.RuneStone;
import lombok.Value;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/7/29
 **/
@Value(staticConstructor = "of")
public class RuneStoneAddEvent {
    private List<RuneStone> adds;
    private GameEvent event;
}
