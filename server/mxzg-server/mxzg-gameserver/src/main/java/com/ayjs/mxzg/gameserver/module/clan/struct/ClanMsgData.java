package com.ayjs.mxzg.gameserver.module.clan.struct;

import lombok.Data;

/**
 * 公会日志实体类
 */
@Data
public class ClanMsgData {

    //1. 同意成员申请 2. 退出军团 3. 管理员踢掉成员 4. 成员被升职  5.降职 6.加入军团 8：击杀的副本boss类型；9：进行捐献类型 10：会长职位自动转让
    private int infoType;

    //详细操作类型 。例：升降职：填写升降职的职位。击杀BOSS：填写BOSS配置表的编号ID而非类型ID。捐献：填写捐献类型
    private int position;

    //记录时间
    private long time;

    //被操作人ID
    private long memberId;

    //被操作人名字
    private String memberName;

    //操作人ID
    private long managerId;

    //操作人姓名
    private String managerName;

}
