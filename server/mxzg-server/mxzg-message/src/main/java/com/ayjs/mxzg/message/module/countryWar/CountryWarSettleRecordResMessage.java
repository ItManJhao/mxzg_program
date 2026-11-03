package com.ayjs.mxzg.message.module.countryWar;

import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.rpc.RemoteMessage;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Getter
@Setter
public class CountryWarSettleRecordResMessage implements RemoteMessage {

    private int maxRound;

    private List<RankData> scoreRank = new ArrayList<>();

    private List<RankData> heroRank = new ArrayList<>();

    private List<RankData> killRank = new ArrayList<>();

    private List<RankData> damageRank = new ArrayList<>();


//    private String scoreRankStr;
//    private String heroRankStr;
//    private String killRankStr;


}
