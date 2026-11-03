package com.ayjs.mxzg.config.excel.cache;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.entity.CServerLadderRobotName;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.Objects;

@Component
public class ServerLadderRobotNameSysCache extends BaseExcelCache<CServerLadderRobotName> {

    private Map<Integer, List<CServerLadderRobotName>> robotNameMap;
    // 姓
    private static int FIRST_NAME = 1;
    // 名
    private static int SECOND_NAME = 2;


    @Override
    public String getFileName() {
        return "serverladderrobotname";
    }

    @Override
    protected void loadAfterReady() {
        this.robotNameMap = this.fillListMap(CServerLadderRobotName::getType);
    }

    /**
     * type：1姓 2，名
     * @param type
     * @return
     */
    public CServerLadderRobotName getRandomName(int type){
        List<CServerLadderRobotName> nameList = robotNameMap.get(type);
        CServerLadderRobotName name = null;
        if (CollectionUtil.isNotEmpty(nameList)) {
            name = RandomUtil.getRand(nameList);
        }
        if (Objects.nonNull(name)) {
            return name;
        }
        return null;
    }
}
