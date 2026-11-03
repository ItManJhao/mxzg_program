package com.ayjs.mxzg.gameserver.remote.cross;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.rpc.client.AbstractSpringClient;
import org.springframework.stereotype.Component;

/**
 * 跨服客户端
 */
@Component
public class CrossServerClient extends AbstractSpringClient<CrossMessage> {
}
