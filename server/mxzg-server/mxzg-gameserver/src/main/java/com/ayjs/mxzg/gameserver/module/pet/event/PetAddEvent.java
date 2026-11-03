package com.ayjs.mxzg.gameserver.module.pet.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.pet.domain.Pet;
import lombok.Value;

import java.util.List;

/**
 * @author hyx
 */
@Value(staticConstructor = "of")
public class PetAddEvent {

    private long rid;

    private List<Pet> petList;

    private GameEvent gameEvent;

}
