package com.ayjs.mxzg.gameserver.module.pet.event;

import lombok.Value;

/**
 * 宠物更换事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class PetChangeEvent {

    private long rid;

    private long heroId;

    private long petId;

    private int status;//0:穿 1:卸

}
