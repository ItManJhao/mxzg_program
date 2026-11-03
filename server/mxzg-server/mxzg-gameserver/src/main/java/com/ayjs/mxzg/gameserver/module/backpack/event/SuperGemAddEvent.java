/**
 *
 */
package com.ayjs.mxzg.gameserver.module.backpack.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import lombok.Value;

/**
 * 超级钻石增加
 * @author tangyangbo
 */
@Value(staticConstructor = "of")
public class SuperGemAddEvent {
    private long rid;
    private long addCount;
    private GameEvent gameEvent;
    private long curr;
}
