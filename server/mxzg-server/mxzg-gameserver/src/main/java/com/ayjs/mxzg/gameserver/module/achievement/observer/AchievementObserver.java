//package com.ayjs.mxzg.gameserver.module.achievement;
//
//import com.ayjs.mxzg.common.event.annotation.Observer;
//import com.ayjs.mxzg.common.event.annotation.Subscribe;
//import com.ayjs.mxzg.gameserver.module.achievement.service.AchievementService;
//import com.ayjs.mxzg.gameserver.module.operatorValue.event.OperatorValueChangeEvent;
//import com.ayjs.mxzg.gameserver.module.role.domain.Role;
//import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.beans.factory.annotation.Autowired;
//
///**
// * @description:
// * @author: CWJ
// * @date: 2019/10/13 22:07
// */
//@Observer
//@Slf4j
//public class AchievementObserver {
//
//    @Autowired
//    private RoleService roleService;
//    @Autowired
//    private AchievementService achievementService;
//
//    @Subscribe
//    public void operatorValue(OperatorValueChangeEvent event) {
//        long rid = event.getRid();
//        Role role = roleService.getOrThrow(rid);
//        if (role == null)
//            log.error("登录玩家不存在");
////        achievementService.getAllByRid(event.getRid());
//        achievementService.updateProcessValue(event.getRid(),event.getOperatorType(),event.getNewValue());
////        achievementService.get(event.getRid(event.getRid(),event.getOperatorType(),event.getNewValue()));
//    }
//}
