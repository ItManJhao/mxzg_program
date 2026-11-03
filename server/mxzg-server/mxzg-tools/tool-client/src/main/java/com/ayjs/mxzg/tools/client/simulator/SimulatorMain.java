package com.ayjs.mxzg.tools.client.simulator;

import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandlerRegistry;
import com.ayjs.mxzg.tools.client.client.base.ProtocolRegistry;
import com.ayjs.mxzg.tools.client.simulator.ui.ClientUI;
import com.ayjs.mxzg.tools.client.stresstest.StressTestConfig;
import lombok.extern.slf4j.Slf4j;

/**
 * 客户端主类
 *
 * @author tangyangbo 2019/7/22 16:45
 */
@Slf4j
public class SimulatorMain {


    public static void main(String[] args) {
        // 测试服配置信息
        String stressTestPath = null;
        if (args == null || args.length == 0) {
            stressTestPath = "stress-test.properties";
        } else {
            stressTestPath = args[0];
        }
        log.error(">>>>" + stressTestPath);
        StressTestConfig.init(stressTestPath);
        ProtocolRegistry.init();
        ClientResponseHandlerRegistry.init();
        ServerInfoService.init();
        ClientUI.getInstance().init();
    }
}
