package com.ayjs.mxzg.config.excel.cache;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.entity.CServerLadderRobotShow;

import cn.hutool.core.collection.CollectionUtil;

@Component
public class ServerLadderRobotShowSysCache extends BaseExcelCache<CServerLadderRobotShow> {

    private Map<Integer, List<CServerLadderRobotShow>> robotShowMap;

    public static int HEAD_TYPE = 1;// 头像id
    public static int IMAGE_TYPE = 2;// 形象id

    @Override
    public String getFileName() {
        return "serverladderrobotshow";
    }

    @Override
    protected void loadAfterReady() {
        this.robotShowMap = this.fillListMap(CServerLadderRobotShow::getType);
    }

    private int random(int type) {
    	List<CServerLadderRobotShow> robotShows = robotShowMap.get(type);
    	if (CollectionUtil.isEmpty(robotShows)) {
            return 0;
        }
    	CServerLadderRobotShow show = RandomUtil.getRand(robotShows);
    	return show.getImage();
    }
    
    public int randomHead() {
    	return random(HEAD_TYPE);
    }
    
    public int randomImage() {
    	return random(IMAGE_TYPE);
    }
}
