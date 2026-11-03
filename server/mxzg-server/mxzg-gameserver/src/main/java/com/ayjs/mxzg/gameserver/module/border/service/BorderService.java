package com.ayjs.mxzg.gameserver.module.border.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.BorderSysCache;
import com.ayjs.mxzg.config.excel.entity.CBorder;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.border.constant.BorderActiveType;
import com.ayjs.mxzg.gameserver.module.border.dao.BorderDao;
import com.ayjs.mxzg.gameserver.module.border.domain.Border;
import com.ayjs.mxzg.protocol.BroderGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/10/28
 **/
@Service
@Observer
public class BorderService {
    @Autowired
    private BorderDao borderDao;
    @Autowired
    private BorderSysCache borderSysCache;
    @Autowired
    private ContextManager contextManager;

    public List<Border> getBorders(long rid) {
        return borderDao.list("rid", rid);
    }

    public Border load(long rid, int idx) {
        Border border = getBorders(rid).stream().filter(borderTemp -> borderTemp.getConfigId() == idx).findFirst().orElse(null);
        if (border == null) {
            border = new Border();
            border.setConfigId(idx);
            border.setRid(rid);
            borderDao.add(border);
        }
        return border;
    }

    public Border get(long rid, int idx) {
        return getBorders(rid).stream().filter(borderTemp -> borderTemp.getConfigId() == idx).findFirst().orElse(null);
    }

    public void update(Border border) {
        borderDao.update(border);
    }

    public BroderGMsg.PSBorderUnit builderUnit(Border border) {
        BroderGMsg.PSBorderUnit.Builder builder = BroderGMsg.PSBorderUnit.newBuilder();
        builder.setId(border.getConfigId());
        builder.setActiveState(border.isActive() ? 1 : 0);
        return builder.build();
    }

    /***
     * 激活头像框
     * @param rid
     * @param idx
     * @param type
     */
    public void activeBorder(long rid, int idx, BorderActiveType type) {
        CBorder config = borderSysCache.getOrThrow(idx);
        Asserts.isTrue(config.getActive_type() == type.getType(), String.format("激活类型不满足，配置id[%s],激活类型[%s],选择的激活类型[%s]", idx, config.getActive_type(), type.getType()));
        Border border = load(rid, idx);
        Asserts.isTrue(!border.isActive(), String.format("头像框[%s]已激活，不能重复激活！", idx));

        border.setExpireTime(config.getLimit_time());
        update(border);

        BroderGMsg.GResActiveBorder.Builder builder = BroderGMsg.GResActiveBorder.newBuilder();
        builder.setUnit(builderUnit(border));

        contextManager.write(rid, CmdCode._32002, builder.build());
    }

    //事件监听
}
