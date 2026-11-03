/**
 *
 */
package com.ayjs.mxzg.largecross.module.stagematch.battle.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.Opponent;
import org.springframework.stereotype.Repository;

/**
 * 对手信息
 */
@Repository
public class OpponentDao extends BaseRepository<Opponent> {

    /**
     * 获取对象，没有则创建
     * @param rid
     * @return
     */
    public Opponent getOrCreate(long rid){
        Opponent opponent = get(rid);
        if(opponent == null){
            opponent = Opponent.createOf(rid);
            opponent.initialize();
            add(opponent);
        }
        return opponent;
    }

}
