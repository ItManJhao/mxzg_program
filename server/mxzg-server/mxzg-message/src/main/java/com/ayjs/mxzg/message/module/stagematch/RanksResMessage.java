package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

import java.util.Collections;
import java.util.List;

/**
 * 请求排行榜信息
 */
@Value(staticConstructor = "of")
public class RanksResMessage implements RemoteMessage {

    /** 等級信息列表 */
    private List<RankDto> ranks;

    /**
     * 获取排行榜
     * @return
     */
    public List<RankDto> getRanks(){
        return ranks == null ? Collections.emptyList() : ranks;
    }

}
