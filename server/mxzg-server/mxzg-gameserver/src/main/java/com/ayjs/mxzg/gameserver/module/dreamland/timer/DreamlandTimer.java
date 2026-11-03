package com.ayjs.mxzg.gameserver.module.dreamland.timer;


import com.ayjs.mxzg.gameserver.module.dreamland.service.DreamlandService;
import com.ayjs.mxzg.gameserver.web.api.ChatApi;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


/**
 * @Author: CWJ
 * @Date: 2019/12/12
 **/
@Component
public class DreamlandTimer extends AbstractCronTask {

    @Autowired
    private DreamlandService dreamlandService;


    @Override
    public Object identity() {
        return "DREAMLAND_AUTO_BATTLE";
    }

    @Override
    public String expression() {
        return "0 */1 * * * ?";
    }

    @Override
    public void run() {
        dreamlandService.autoBattle();
    }


}
