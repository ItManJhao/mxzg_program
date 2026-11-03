package com.ayjs.mxzg.message.module.stagematch.preliminaries;

import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

@Value(staticConstructor = "of")
public class PreliminariesLikeNumAddResMessage implements RemoteMessage {
        // 被点赞的数据刷新
        private RankDto rankDto;

}
