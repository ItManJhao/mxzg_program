package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event;

import lombok.Value;

/**
 * 更新航行进度
 * @author hyx
 */
@Value(staticConstructor = "of")
public class SailingProgressEvent {

    private long rid;

}
