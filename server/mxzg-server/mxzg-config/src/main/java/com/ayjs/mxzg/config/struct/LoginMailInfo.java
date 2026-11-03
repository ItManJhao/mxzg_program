package com.ayjs.mxzg.config.struct;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LoginMailInfo {

    private int num;//已发送次数
    private int sendTime;//上一次发送时间

}
