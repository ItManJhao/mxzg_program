package com.ayjs.mxzg.message.module.clan;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

/**
 * 上传公会数据
 *
 * @Author: CWJ
 * @Date: 2019/12/18
 **/
@Builder
@Getter
@Setter
public class UpdateCrossClanMessage implements CrossMessage {

    private long id;

    private String clanName;

    private int clanLevel;

    private long createTime;

    private long clanHeadRid;

    private String clanHeadName;

    private int clanIcon;

    private long clanFighting;

    private int serverId;

    private int serverOpenTime;
    /***
     * 是否移除
     */
    private boolean remove;

}
