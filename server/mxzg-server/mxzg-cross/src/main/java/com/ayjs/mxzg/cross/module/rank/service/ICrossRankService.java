package com.ayjs.mxzg.cross.module.rank.service;

import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.rpc.server.Connection;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/12/19
 **/
public interface ICrossRankService<T> {

    CrossRankType getRankType();

    /***
     * 获取排行榜所有对象
     * @return
     */
    List<T> getAll(int serverGroup);

    /***
     * 根据排名获取对象
     * @param rank
     * @return
     */
    RankData getRank(int serverGroup, int rank);

    void pullToAllGame();

    void pullToGame(int serverId, Connection connection);
}
