package com.ayjs.mxzg.largecross.module.robot.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.config.excel.cache.ServerLadderRobotLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.ServerLadderRobotNameSysCache;
import com.ayjs.mxzg.config.excel.cache.ServerLadderRobotShowSysCache;
import com.ayjs.mxzg.config.excel.cache.ServerLadderRobotSysCache;
import com.ayjs.mxzg.config.excel.entity.CServerLadderRobot;
import com.ayjs.mxzg.config.excel.entity.CServerLadderRobotName;
import com.ayjs.mxzg.largecross.module.robot.dao.LargeCrossRobotDao;
import com.ayjs.mxzg.largecross.module.robot.domain.LargeCrossRobot;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.template.language.LanguageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 跨服机器人
 */
@Service
public class LargeCrossRobotService implements Lifecycle {

    @Autowired
    private LargeCrossRobotDao largeCrossRobotDao;
    @Autowired
    private ServerLadderRobotLevelSysCache serverLadderRobotLevelSysCache;
    @Autowired
    private ServerLadderRobotNameSysCache serverLadderRobotNameSysCache;
    @Autowired
    private ServerLadderRobotShowSysCache serverLadderRobotShowSysCache;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private ServerLadderRobotSysCache serverLadderRobotSysCache;
    @Autowired
    private LanguageHelper languageHelper;

    public List<LargeCrossRobot> getAllRobot() {
        return largeCrossRobotDao.listAll();
    }

    public LargeCrossRobot getRobot(long robotRid) {
        return largeCrossRobotDao.get(robotRid);
    }


    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("ROBOT");
    }

    @Override
    public void start() throws Exception {
        init();
    }

    /**
     * 初始化
     */
    public void init() {
        List<LargeCrossRobot> crossLadderRobots = largeCrossRobotDao.listAll();
        if (CollectionUtil.isEmpty(crossLadderRobots)) {

            List<LargeCrossRobot> robotList = serverLadderRobotLevelSysCache.getAll().stream().map(robotLevel -> {
                LargeCrossRobot robot = new LargeCrossRobot();
                robot.setRid(robotLevel.getTeam());
                robot.setLevel(robotLevel.getLevel());
                robot.setHeadId(serverLadderRobotShowSysCache.randomHead());
                robot.setImageId(serverLadderRobotShowSysCache.randomImage());
                robot.setNick(randomName());
                List<CServerLadderRobot> defRobots = serverLadderRobotSysCache.getTeam((int) robot.getRid());
                robot.setFighting(battleTemplate.computeMonsterStrength(defRobots));
                return robot;
            }).collect(Collectors.toList());
            largeCrossRobotDao.add(robotList);
        }
    }

    public void reset() {
        List<LargeCrossRobot> crossLadderRobots = largeCrossRobotDao.listAll();
        if (CollectionUtil.isEmpty(crossLadderRobots)) {
            init();
        } else {
            crossLadderRobots.forEach(robot -> {
            	robot.setHeadId(serverLadderRobotShowSysCache.randomHead());
                robot.setImageId(serverLadderRobotShowSysCache.randomImage());
                List<CServerLadderRobot> defRobots = serverLadderRobotSysCache.getTeam((int) robot.getRid());
                robot.setFighting(battleTemplate.computeMonsterStrength(defRobots));
            });
            largeCrossRobotDao.update(crossLadderRobots);
        }
    }

    /**
     * 随机机器人名
     * @return
     */
    public String randomName(){
        CServerLadderRobotName randomFirstName = serverLadderRobotNameSysCache.getRandomName(1);// 姓
        CServerLadderRobotName randomSecondName = serverLadderRobotNameSysCache.getRandomName(2);// 名
        String name = "";
        if (Objects.nonNull(randomFirstName)){
            name += languageHelper.getLanguageBy(randomFirstName);
        }
        if (Objects.nonNull(randomSecondName)){
            name += languageHelper.getLanguageBy(randomSecondName);
        }
        return name;
    }

}
