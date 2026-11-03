package com.ayjs.mxzg.gameserver.remote.center;

import com.ayjs.mxzg.message.center.CenterServerMessage;
import com.ayjs.rpc.client.AbstractSpringClient;
import org.springframework.stereotype.Component;

@Component
public class CenterClient extends AbstractSpringClient<CenterServerMessage> {

}
