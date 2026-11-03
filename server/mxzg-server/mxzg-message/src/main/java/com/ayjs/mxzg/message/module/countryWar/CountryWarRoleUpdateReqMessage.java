package com.ayjs.mxzg.message.module.countryWar;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import com.ayjs.mxzg.message.module.countryWar.dto.CountryWarRoleInfo;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Getter
@Setter
public class CountryWarRoleUpdateReqMessage implements LargeCrossMessage {
    private long rid;
    private int mainServerId;
    private CountryWarRoleInfo countryWarRoleInfo;
    private String battleVo;
    private boolean online;

}
