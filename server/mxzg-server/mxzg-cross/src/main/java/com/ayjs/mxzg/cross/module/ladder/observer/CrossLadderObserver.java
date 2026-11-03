package com.ayjs.mxzg.cross.module.ladder.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.crossservice.event.CrossRegroupEvent;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.cross.module.ladder.service.CrossLadderService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

@Slf4j
@Observer
public class CrossLadderObserver {

    @Autowired
    private CrossLadderService crossLadderService;
    @Autowired
    private CrossServerGroupService crossServerGroupService;
    @Autowired
    private MessageHelper messageHelper;

    @Subscribe
    public void onEvent(CrossRegroupEvent event) {
        log.info("CrossLadderObserver 服务器重组");
        crossLadderService.backupCrossLadder("CrossRegroup");
        crossLadderService.clearAllCrossLadderData();

        crossLadderService.pushAllCrossLadderToServer(0);
        crossLadderService.printCrossLadder("CrossLadderObserver CrossRegroupEvent");

    }

}
