package com.ayjs.mxzg.gameserver.module.rank.service;

import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/10/16
 **/
public interface IRankService<T> {
    /***
     * 展示列表
     * @return
     */
    List<T> showRanks(int count);

    /***
     * 自己的排行榜对象数据
     * @param rankId
     *          对象排行榜的实际排行id，比如工会排行就用工会id，玩家排行就用roleId
     * @return
     */
    T selfRank(long rankId);

    /**
     * 排行榜类型
     *
     * @return
     */
    RankType getRankType();

    /***
     * 根据排名获取结构体
     * @param rank
     * @return
     */
    Rank getRankEntity(int rank);

    /***
     * 获取排名
     * @return
     */
    int getRank(long rankId);

    /***
     * 清空排行榜
     */
    void clear();
}
