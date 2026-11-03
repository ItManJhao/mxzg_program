/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.web.activity.config.IActivityConfig;
import lombok.Getter;
import lombok.Setter;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @author YY
 * 活动中玩家数据不能合并，因为每个正在进行的活动的轮次都是不一样的
 */
@Entity
@Table(name = "promotion_control", comment = "活动控制表", indexes = {
        @Index(name = "type", columnList = {"type"})}, cache = {@Cache(columns = "type")})
@Getter
@Setter
public class PromotionControl extends AbstractEntity {
    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "数据唯一ID")
    private long id;
    @Column(name = "type", comment = "活动类型", readOnly = true)
    private int type;
    @Column(name = "name", comment = "活动名字")
    private String name;
    @Column(name = "start_time", comment = "活动开启时间")
    private int startTime;
    @Column(name = "end_time", comment = "活动截止时间，在结束时间之前不再记录活动进度数据")
    private int endTime;
    @Column(name = "clear_time", comment = "活动结束时间，截止时间到结束时间之间还可以进行兑换、领取、查看")
    private int clearTime;
    @Column(name = "next_time", comment = "下一轮活动开始时间")
    private int nextTime;
    @Column(name = "turns", comment = "轮次")
    private int turns;
    @Column(name = "turns_time", comment = "本轮次的标记时间，玩家数据重置时判断")
    private int turnsTime;
    @Column(name = "extra_info", comment = "扩展信息，记录一些活动相关的数据", length = 2000)
    private String extraInfo;
    @Column(name = "status", comment = "本轮结算状态，0未结算，1已结算")
    private int status;
    @Column(name = "limit_days", comment = "开服多少开后开始计数")
    private int limitDays;
    @Column(name = "config", comment = "运营活动配置", length = 1024)
    private String config = "[]";//数组字符串

    private Map<Integer, IActivityConfig> configMap = null;

    public <T extends IActivityConfig> T getConfig(int idx, Class<T> clz) {
        return (T) getConfigMap().get(idx);
    }

    public Map<Integer, IActivityConfig> getConfigMap() {
        if (PromotionType.valueOf(type).getOpenType() != 2)
            throw new RuntimeException("非运营活动，不允许获取配置：" + type);
        if (configMap == null)
            configMap = JsonUtil.getList(config, PromotionType.valueOf(type).getClz()).stream().collect(Collectors.toMap(IActivityConfig::getId, Function.identity()));
        return configMap;
    }

    public void replaceConfig(List<? extends IActivityConfig> list) {
        configMap = JsonUtil.getList(config, PromotionType.valueOf(type).getClz()).stream().collect(Collectors.toMap(IActivityConfig::getId, Function.identity()));
    }

    public <T extends IActivityConfig> Collection<T> getAllConfig(Class<T> clz) {
        return (Collection<T>) getConfigMap().values();
    }

    public static void main(String[] args) {
        List<Integer> list = JsonUtil.getList("", Integer.class);
        System.out.println(JsonUtil.toJson(list));

    }
}
