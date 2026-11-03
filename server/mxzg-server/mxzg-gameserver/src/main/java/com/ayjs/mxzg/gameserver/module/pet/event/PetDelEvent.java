package com.ayjs.mxzg.gameserver.module.pet.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.pet.domain.Pet;
import lombok.Value;

import java.util.List;

/**
 * @author hyx
 */
@Value(staticConstructor = "of")
public class PetDelEvent {

    private long rid;

    private List<Pet> pets;

    private GameEvent gameEvent;

}
