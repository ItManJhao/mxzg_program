package com.ayjs.mxzg.center.module.crossHeroComment.dao;

import com.ayjs.mxzg.center.module.crossHeroComment.domain.CrossHeroTypeComment;
import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import org.springframework.stereotype.Repository;

/**
 * mysql 数据库存储体，应为redis没有做物理缓存
 *
 * @Author: CWJ
 * @Date: 2020/6/15
 **/
@Repository
public class CrossHeroTypeCommentDao extends BaseRepository<CrossHeroTypeComment> {
}
