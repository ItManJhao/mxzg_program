package com.ayjs.mxzg.message.module.stagematch.preliminaries;

import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

import java.util.Collections;
import java.util.List;

/**
 * 获取天梯榜
 */
@Value(staticConstructor = "of")
public class LeaderBoardResMessage implements RemoteMessage {

    private List<RankDto> ranking;

    public List<RankDto> getRanking(){
        return this.ranking == null ? Collections.emptyList() : this.ranking;
    }

}
