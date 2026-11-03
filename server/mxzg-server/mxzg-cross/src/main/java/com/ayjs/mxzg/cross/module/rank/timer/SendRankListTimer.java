package com.ayjs.mxzg.cross.module.rank.timer;

import com.ayjs.mxzg.cross.module.rank.service.RankHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;

/**
 * @Author: CWJ
 * @Date: 2019/12/19
 **/

@Controller
public class SendRankListTimer {

    @Autowired
    private RankHelper rankHelper;

    @Scheduled(cron = "0 */1 * * * ?")
    public void run() {
        rankHelper.pullToGame();
    }
}
