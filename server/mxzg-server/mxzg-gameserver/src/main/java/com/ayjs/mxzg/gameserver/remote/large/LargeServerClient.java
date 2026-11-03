package com.ayjs.mxzg.gameserver.remote.large;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import com.ayjs.rpc.client.AbstractSpringClient;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/6/19
 **/
@Component
public class LargeServerClient extends AbstractSpringClient<LargeCrossMessage> {
}
