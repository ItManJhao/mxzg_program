package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import org.apache.commons.lang3.StringUtils;

/**
 * 商城
 */
@Getter
public class CBuyGem implements BaseExcelModel {
    /**
     * 商品ID
     */
    private int idx;
    /**
     * 安卓商品编码， 注意：不能直接获取，要判断设备类型（1安卓，2 ios）
     */
    private String code;
    /**
     * ios商品编码， 注意：不能直接获取，要判断设备类型（1安卓，2 ios）
     */
    private String ios_code = "";
    /**
     * 测试用商品编码
     */
    private String test_code;
    /**
     * 金额，单位分
     */
    private int rmb;
    /**
     * 种类
     */
    private int kind;
    /**
     *
     */
    private ImmutableList<ImmutableThing> item;
    /**
     * 第一次购买时赠送
     */
    private ImmutableList<ImmutableThing> first_buy_reward;
    /**
     * 成长基金档次
     */
    private int level;
    /**
     * 0 无限制 1 每日 2 每周 3 每月 4 终身
     */
    private int limit_type;
    /**
     * limit_times控制这个N
     */
    private int limit_times;
    /**
     * 开启时间
     */
    private int begin_day;
    /**
     * 结束时间
     */
    private int last_day;
    /**
     *
     */
    private int tag_language;
    /**
     *
     */
    private int item_language;
    /**
     *
     */
    private int sequence;
    /**
     * VIP等级购买限制
     */
    private int vip_require;
    /**
     *
     */
    private int vip_exp;

    private int original_cost;
    /**
     * 图标
     */
    private String icon;

    private ImmutableList<ImmutableThing> clergy_gain;
    /**
     * 备注
     */
    private String note;

    @Override
    public int getExcelId() {
        return idx;
    }

    /**
     * 获取平台对应的商品编码
     * 若 ios_code 商品编号为空，则用 code
     *
     * @param platform 对应Role.java里面的platform 客户端类型：1，安卓,2，IOS
     * @return
     */
    public String getPlatformCode(int platform) {
        if (platform == 2) { // 2，IOS
            String iosCode = getIos_code();
            if (StringUtils.isBlank(iosCode)) {
                return getCode();
            }
            return iosCode;
        } else { // 1，安卓
            return getCode();
        }
    }
}
