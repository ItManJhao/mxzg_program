package com.ayjs.mxzg.tools.client.simulator;

import lombok.Data;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/12/14
 **/
@Data
public class BigServerData {
    private List<BigServerInfo> data;

    public List<BigServerInfo> getData() {
        return data;
    }

    public void setData(List<BigServerInfo> data) {
        this.data = data;
    }
}
