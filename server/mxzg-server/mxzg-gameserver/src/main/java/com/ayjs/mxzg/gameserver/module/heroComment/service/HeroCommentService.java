package com.ayjs.mxzg.gameserver.module.heroComment.service;

import com.ayjs.mxzg.gameserver.module.heroComment.dao.HeroCommentDao;
import com.ayjs.mxzg.gameserver.module.heroComment.domain.HeroComment;
import com.ayjs.mxzg.message.module.heroComment.dao.CrossHeroCommentDao;
import com.ayjs.mxzg.message.module.heroComment.domain.CrossHeroComment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @Author: CWJ
 * @Date: 2020/6/11
 **/
@Service
public class HeroCommentService {

    @Autowired
    private HeroCommentDao heroCommentDao;
    @Autowired
    private CrossHeroCommentDao crossHeroCommentDao;

    public HeroComment load(long rid) {
        HeroComment heroComment = heroCommentDao.get(rid);
        if (heroComment == null) {
            heroComment = new HeroComment();
            heroComment.setRid(rid);
            heroCommentDao.add(heroComment);
        }
        return heroComment;
    }

    public CrossHeroComment getCrossHeroComment(int heroType) {
        return crossHeroCommentDao.get(heroType);
    }

    public void update(HeroComment heroComment) {
        heroCommentDao.update(heroComment);
    }
}
