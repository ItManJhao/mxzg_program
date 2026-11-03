package com.ayjs.mxzg.center.module.crossHeroComment.service;

import com.ayjs.mxzg.center.module.crossHeroComment.domain.CrossHeroTypeComment;
import com.ayjs.mxzg.center.module.crossHeroComment.dao.CrossHeroTypeCommentDao;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.message.module.heroComment.dao.CrossHeroCommentDao;
import com.ayjs.mxzg.message.module.heroComment.domain.CrossHeroComment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @Author: CWJ
 * @Date: 2020/6/11
 **/
@Service
public class CrossHeroCommentService implements Lifecycle {

    public static final String HERO_LIKE_LOCK = "HERO_COMMENT";

    @Autowired
    private CrossHeroCommentDao crossHeroCommentDao;
    @Autowired
    private CrossHeroTypeCommentDao crossHeroTypeCommentDao;

    public CrossHeroTypeComment load(int heroType) {
        CrossHeroTypeComment crossHeroComment = crossHeroTypeCommentDao.get(heroType);
        if (crossHeroComment == null) {
            synchronized (InternerPool.intern(HERO_LIKE_LOCK, heroType)) {
                crossHeroComment = crossHeroTypeCommentDao.get(heroType);
                if (crossHeroComment == null) {
                    crossHeroComment = new CrossHeroTypeComment();
                    crossHeroComment.setHeroType(heroType);
                    crossHeroTypeCommentDao.add(crossHeroComment);
                }
            }
        }
        return crossHeroComment;
    }

    public void update(CrossHeroTypeComment entity) {
        crossHeroTypeCommentDao.update(entity);
        //更新redis数据
        updateToRedis(entity);
    }

    private void updateToRedis(CrossHeroTypeComment entity) {
        CrossHeroComment redisComment = new CrossHeroComment();
        redisComment.setHeroType(entity.getHeroType());
        redisComment.setCommentDetailMap(entity.getCommentDetailMap());
        redisComment.setLikeCount(entity.getLikeCount());
        crossHeroCommentDao.addOrUpdate(redisComment);
    }

    @Override
    public void start() throws Exception {
        //不做加回redis
//        crossHeroTypeCommentDao.listAll().forEach(this::updateToRedis);
    }

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("HERO_COMMENT");
    }
}
