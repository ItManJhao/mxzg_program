package com.ayjs.mxzg.message.module.countryWar;

import com.ayjs.mxzg.message.largecross.PlayerLargeCrossMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Getter
@Setter
public class CountryWarAttackReqMessage implements PlayerLargeCrossMessage {

    private long attackId;
    private int cityId;
    /***
     * 主服服务器id
     */
    private int serverId;

    /***
     * 更新battleVO
     */
    private String battleVo;

    @Override
    public long getRid() {
        return attackId;
    }
}
