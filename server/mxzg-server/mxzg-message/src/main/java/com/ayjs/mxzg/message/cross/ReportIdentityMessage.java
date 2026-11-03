package com.ayjs.mxzg.message.cross;

import com.ayjs.mxzg.message.center.CenterServerMessage;
import lombok.Value;

import java.util.List;

/**
 * 报告信息
 */
@Value(staticConstructor = "of")
public class ReportIdentityMessage implements CenterServerMessage {

    /**
     * 当前通道的服务器id列表
     */
    private List<Integer> serverIds;

}
