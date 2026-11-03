package com.ayjs.mxzg.tools.client.simulator;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class ServerDetail {
    private int sid;// 服务器id
    private String s_name;// 服务器名
    private String s_u;// 服务器url host
    private int s_p;// 服务器端口
    private int is_comd;
    private String msg;


    private int is_new;
    private int s_s;
    private int det;
    private int sort;

    @Override
    public String toString() {
        return getSid() + "-" + getS_name() + "-" + getS_u() + "-" + getS_s();
    }
}
