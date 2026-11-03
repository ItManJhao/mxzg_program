package com.ayjs.mxzg.center.module.crossHeroComment.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.module.heroComment.struct.HeroCommentDetailData;
import lombok.Getter;
import lombok.Setter;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 * @Author: CWJ
 * @Date: 2020/6/15
 **/
@Entity
@Setter
@Getter
@Table(name = "cross_hero_type_comment", comment = "英雄被评论数据")
public class CrossHeroTypeComment extends AbstractEntity {

    @Id
    @Column(name = "hero_type", comment = "英雄类型")
    private int heroType;

    @Column(name = "comment_data_map", comment = "英雄评价")
    private ConcurrentMap<String, HeroCommentDetailData> commentDetailMap = new ConcurrentHashMap<>();

    @Column(name = "id_count", comment = "评论id计数")
    private long idCount;

    @Column(name = "like_count", comment = "点赞次数")
    private long likeCount;

}
