package com.ayjs.mxzg.gameserver.module.push.timer;

import com.ayjs.mxzg.gameserver.module.push.service.PushNotificationService;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class PushNotificationTimer extends AbstractCronTask {

    @Autowired
    private PushNotificationService pushNotificationService;

    @Override
    public Object identity() {
        return "PushNotificationTimer";
    }

    @Override
    public String expression() {
        return "0 0/1 * * * ?";
    }

    @Override
    public void run() {
        try {
            pushNotificationService.checkAndSendPush();
//            System.out.println("231111433432423***********");
        } catch (Exception e){
            e.printStackTrace();
        }
    }
}
