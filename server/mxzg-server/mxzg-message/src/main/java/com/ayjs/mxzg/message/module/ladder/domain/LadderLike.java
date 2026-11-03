package com.ayjs.mxzg.message.module.ladder.domain;

import cn.hutool.core.util.StrUtil;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "ladder_like", comment = "天梯点赞数据")
@Getter
@Setter
public class LadderLike extends AbstractEntity {
    @Id
    @Column(name = "group_id_rank", comment = "分组id和排名id")
    private String groupIdAndRank;
    @Column(name = "rank", comment = "排名")
    private int rank;
    @Column(name = "like_num", comment = "点赞数量")
    private int likeNum;
    @Column(name = "rid", comment = "角色id")
    private long rid;
    @Column(name = "nick", comment = "角色名", length = 128)
    private String nick;
    @Column(name = "server_id", comment = "服务器id")
    private int serverId;
    @Column(name = "border_id", comment = "头像框id")
    private int borderId;
    @Column(name = "head_id", comment = "头像id")
    private int headId;
    @Column(name = "level", comment = "等级")
    private int level;
    @Column(name = "clan_id", comment = "公会id")
    private long clanId;
    @Column(name = "clan_name", comment = "公会名")
    private String clanName;
    @Column(name = "fighting", comment = "战力")
    private long fighting;
    @Column(name = "really_player", comment = "是否真实玩家")
    private boolean reallyPlayer;
    @Column(name = "image", comment = "形象")
    private int image;

    /**
     * 主键生成方法
     */
    public static String getKey(int groupId, int rank) {
        return StrUtil.join(":", groupId, rank);
    }
}
