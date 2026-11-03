package com.ayjs.mxzg.largecross.module.stagematch.battle.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.OpponentGroupHolder;
import com.ayjs.mxzg.largecross.servergroup.event.CrossRegroupEvent;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author meiyc
 */
@Observer
public class StageMatchObserver {

    @Autowired
    private OpponentGroupHolder opponentGroupHolder;

    @Subscribe
    public void onCrossRegroupEvent(CrossRegroupEvent event){
        opponentGroupHolder.initGroupInfo();
        opponentGroupHolder.initOpponent();
        opponentGroupHolder.initLadder();
    }
}
