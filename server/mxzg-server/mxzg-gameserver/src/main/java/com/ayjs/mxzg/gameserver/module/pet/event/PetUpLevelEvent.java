package com.ayjs.mxzg.gameserver.module.pet.event;

import lombok.Value;

@Value(staticConstructor = "of")
public class PetUpLevelEvent {

    private long rid;

    private long petId;

}
