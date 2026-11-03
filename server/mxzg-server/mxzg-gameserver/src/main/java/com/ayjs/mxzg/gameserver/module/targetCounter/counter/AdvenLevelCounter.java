package com.ayjs.mxzg.gameserver.module.targetCounter.counter;

///**
// * @Author: CWJ
// * @Date: 2019/10/28
// **/
//@Service
//public class AdvenLevelCounter implements Counter {
//    @Autowired
//    private AdvenMissionService advenMissionService;
//
//    @Override
//    public TargetType thisType() {
//        return TargetType.ADVEN_LEVEL;
//    }
//
//    @Override
//    public int count(long rid, TargetStruct targetStruct) {
//        return advenMissionService.getAdvenMission(rid).getMissionId() - 1;
//    }
//
//    @Override
//    public long taskCount(long rid, TargetStruct targetStruct) {
//        return advenMissionService.getAdvenMission(rid, false).getMissionId() - 1;
//    }
//}
