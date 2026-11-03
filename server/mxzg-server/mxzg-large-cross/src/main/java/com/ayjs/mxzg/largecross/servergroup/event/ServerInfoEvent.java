package com.ayjs.mxzg.largecross.servergroup.event;

import lombok.Value;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/5/23
 **/
@Value(staticConstructor = "of")
public class ServerInfoEvent {
    private int severId;
    private List<Integer> serverIds;
}
