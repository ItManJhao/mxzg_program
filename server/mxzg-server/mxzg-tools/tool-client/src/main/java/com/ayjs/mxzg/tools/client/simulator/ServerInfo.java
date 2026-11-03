package com.ayjs.mxzg.tools.client.simulator;

import lombok.Data;

import java.util.List;

/**
 * 服务器信息
 *
 * @author tangyangbo 2019/10/9 11:48
 */
@Data
public class ServerInfo {
    private int big_server_id;
    private List<ServerDetail> data;

}
