/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.MappedSuperclass;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;

/**
 * @author YY
 *
 */
@MappedSuperclass
public abstract class BaseRankablePormotion extends BaseLoopingPromotion {
    @Column(name = "rank_count", comment = "活动参与次数，排名的依据")
    private int rankCount;
    @Column(name = "rank_time", comment = "修改时间")
    private int rankTime;

    public int getRankCount() {
        return rankCount;
    }

    public void setRankCount(int rankCount) {
        this.rankCount = rankCount;
        this.rankTime = TimeDateUtil.getCurrentTimeInt();
    }

	public int getRankTime() {
		return rankTime;
	}

	public void setRankTime(int rankTime) {
		this.rankTime = rankTime;
	}
}
