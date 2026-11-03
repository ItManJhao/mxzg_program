package com.ayjs.mxzg.message.module.countryWar;

import com.ayjs.rpc.RemoteMessage;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Getter
@Setter
public class CountryWarRewardRecordResMessage implements RemoteMessage {

    private Map<Integer, Integer> cityReward = new HashMap<>();
    private Map<Integer, Integer> eventReward = new HashMap<>();
}
