package com.ayjs.mxzg.largecross.module.stagematch.pinnacle.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.event.OpenPinnacleEvent;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.service.PinnacleCrossService;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.PinnacleOpenMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Slf4j
@Observer
@Component
public class PinnacleObserver {

    @Autowired
    private PinnacleCrossService pinnacleCrossService;
    @Autowired
    private MessageHelper messageHelper;

    /**
     * 开启巅峰赛
     * @param event
     */
    @Subscribe
    public void onOpenPinnacleEvent(OpenPinnacleEvent event){
        log.info("开启巅峰赛决赛");
        pinnacleCrossService.resetPinnacleTime();
        messageHelper.pushToAll(PinnacleOpenMessage.builder().build());
    }
}
