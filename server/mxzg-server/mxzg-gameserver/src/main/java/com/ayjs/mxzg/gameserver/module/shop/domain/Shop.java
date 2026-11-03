package com.ayjs.mxzg.gameserver.module.shop.domain;


import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.Map;

/**
 * 商店
 */
@Entity
@Table(name = "shop", comment = "商店",
        indexes = {@Index(name = "rid", columnList = {"rid"})},
        cache = {@Cache(columns = "rid")})
@Getter
@Setter
public class Shop extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id")
    private long id;
    /**
     * rid
     */
    @Column(name = "rid", readOnly = true, comment = "角色id")
    private long rid;
    /**
     * type
     */
    @Column(name = "type", comment = "类型")
    private int type;
    /**
     * 商品信息idx->buy_num
     */
    @Column(name = "items", comment = "商品信息", length = 1024)
    private Map<Integer, Integer> items;
    /**
     * 刷新次数
     */
    @Column(name = "refresh_num", comment = "刷新次数")
    private int refreshNum;
    /**
     * 刷新次数refresh_num字段重置时间
     */
    @Column(name = "refresh_num_time", comment = "刷新次数重置时间")
    private int refreshNumTime;
    /**
     * 已免费刷新次数
     */
    @Column(name = "free_refresh_num", comment = "免费刷新次数")
    private int freeRefreshNum;
    /**
     * 下次刷新时间
     */
    @Column(name = "next_refresh_time", comment = "下次刷新时间")
    private int nextRefreshTime;

    /**
     * 上次免费次数时间
     */
    @Column(name = "last_free_time", comment = "上次免费次数时间")
    private int lastFreeTime;

    /**
     * 当前可使用的免费刷新次数
     */
    @Column(name = "curr_free_num", comment = "当前可使用的免费次数")
    private int currFreeNum;

    /**
     * 周限购商品次数刷新时间
     */
    @Column(name = "week_refresh_time",comment = "周限购商品次数刷新时间")
    private int weekRefreshTime;

    public void clearItems() {
        this.items.clear();
    }

    public int getFreeRefreshNum() {
        return freeRefreshNum;
    }

    public void setFreeRefreshNum(int freeRefreshNum) {
        this.freeRefreshNum = freeRefreshNum;
    }
}