package com.ayjs.mxzg.gameserver.module.rank.service;

import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;

import java.util.List;

public interface IRankCGPlayerService<T> {
    /***
     * 展示列表
     * @return
     */
    public List<T> showRanks(int cgId, int count);

    /***
     * 自己的排行榜对象数据
     * @param rankId
     *          对象排行榜的实际排行id，比如工会排行就用工会id，玩家排行就用roleId
     * @return
     */
    public T selfRank(int cgId,long rankId);

    /**
     * 排行榜类型
     *
     * @return
     */
    public RankType getRankType();

    /***
     * 根据排名获取结构体
     * @param rank
     * @return
     */
    public Rank getRankEntity(int cgId, int rank);

    /***
     * 获取排名
     * @return
     */
    public int getRank(int cgId, long rankId);

    /***
     * 清空排行榜
     */
    public void clear();
}
