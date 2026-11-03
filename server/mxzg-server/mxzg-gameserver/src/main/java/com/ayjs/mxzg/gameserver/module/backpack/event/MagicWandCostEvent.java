package com.ayjs.mxzg.gameserver.module.backpack.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroMagicWand;
import lombok.Value;

import java.util.List;

@Value(staticConstructor = "of")
public class MagicWandCostEvent {
    long rid;
    List<HeroMagicWand> addIds;
    GameEvent gameEvent;
}
