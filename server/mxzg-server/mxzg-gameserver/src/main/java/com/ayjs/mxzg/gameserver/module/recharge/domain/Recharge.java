/**
 *
 */
package com.ayjs.mxzg.gameserver.module.recharge.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "recharge", comment = "充值记录")
@Getter
@Setter
public class Recharge extends AbstractEntity {
    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "订单ID")
    private long id;
    @Column(name = "rid", readOnly = true, comment = "角色ID")
    private long rid;
    @Column(name = "product_id", comment = "商品ID")
    private int productId;
    @Column(name = "product_code", comment = "商品编码")
    private String productCode = "";
    @Column(name = "product_type", comment = "商品类型，0游戏内商品充值，1游戏币充值")
    private int productType;
    @Column(name = "platform_order_id", comment = "回调时的平台订单号")
    private String platformOrderId = ""; 
    @Column(name = "callback_time", comment = "回调时间")
    private int callback_time;
    @Column(name = "pre_money", comment = "下单充值金额，以分为单位")
    private long preMoney;
    @Column(name = "status", comment = "订单状态，0未处理，1成功，2失败")
    private int status;
    @Column(name = "pay_money", comment = "实际支付充值金额，以分为单位")
    private long payMoney;
    @Column(name = "platform", comment = "平台信息")
    private String platform = "";
    @Column(name = "server_id", comment = "服务器ID")
    private int serverId;
    @Column(name = "give_state", comment = "发货状态，0未处理，1验证一致发货成功，2验证不一致发货成功，3失败")
    private int giveState;
    @Column(name = "time", comment = "订单创建时间")
    private int time;
    @Column(name = "give_time", comment = "发货时间")
    private int giveTime;
    @Column(name = "is_test", comment = "是否测试订单，0正常订单，1测试订单")
    private int isTest;
    @Column(name = "role_lv", comment = "角色等级")
    private int roleLv;

    @Column(name = "game_coin", comment = "商品类型product_type=1时真实购买的游戏币")
    private int gameCoin;
    @Column(name = "extra_game_coin", comment = "商品类型product_type=1时赠送的游戏币")
    private int extraCameCoin;
    @Column(name = "states_money", comment = "地区货币数量")
    private long statesMoney;
    @Column(name = "states_money_unit", comment = "地区货币单位")
    private int statesMoneyUnit;

    @Column(name = "extra_info")
    private String extraInfo = "";
    @Column(name = "sign", comment = "签名信息")
    private String sign = "";
    @Column(name = "cli_extra_info")
    private String cliExtraInfo = "";
    @Column(name = "local_sign", comment = "本服计算的签名信息")
    private String localSign = "";
    @Column(name = "sign_str", comment = "签名用的字符串")
    private String signStr = "";
    @Column(name = "pay_usd_cent", comment = "实际支付的金额美分用于对账")
    private long payUsdCent;

}
