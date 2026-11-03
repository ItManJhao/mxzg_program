package com.ayjs.mxzg.gameserver.web.activity.config;

/**
 * @Author: CWJ
 * @Date: 2019/11/21
 **/
public interface IActivityConfig {

    int getId();

    default int getPriority_status() {
        return 0;
    }

    default int getStar_server_day() {
        return 0;
    }

    default int getEnd_server_day() {
        return 99999;
    }
}
