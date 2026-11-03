package com.ayjs.mxzg.gameserver.module.heroComment.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/6/11
 **/
@Table(name = "hero_comment", comment = "英雄评论数据")
@Getter
@Setter
@Entity
public class HeroComment extends AbstractEntity {

    @Column(name = "rid")
    @Id
    private long rid;

    @Column(name = "like_hero", comment = "我喜欢的英雄")
    private Set<Integer> likeHero = new HashSet<>();

    @Column(name = "comments_like", comment = "评论的喜恶， 喜好状态：0或者不包含，未操作，1，喜欢，2讨厌")
    private Map<String, Integer> commentsLike = new HashMap<>();

    @Column(name = "comment_hero_count", comment = "评论某个英雄的次数")
    private Map<Integer, Integer> commentHeroCount = new HashMap<>();


}
