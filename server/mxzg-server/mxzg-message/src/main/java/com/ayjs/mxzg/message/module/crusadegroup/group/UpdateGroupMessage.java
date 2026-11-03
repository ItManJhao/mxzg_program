package com.ayjs.mxzg.message.module.crusadegroup.group;

import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

import java.util.Set;

/**
 * 结束报名
 */
@Value(staticConstructor = "valueOf")
public class UpdateGroupMessage implements RemoteMessage {

    /**
     * 軍團長
     */
    private long headId;
    /**
     * 指揮官
     */
    private Set<Long> commander;
}
