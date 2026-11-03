package com.ayjs.mxzg.gameserver.module.server.service;

import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.module.server.constant.ServerParamType;
import com.ayjs.mxzg.gameserver.module.server.dao.ServerParamDao;
import com.ayjs.mxzg.gameserver.module.server.domain.ServerParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.function.Supplier;

/**
 * 系统参数字典
 */
@Service
public class ServerParamService {

    @Autowired
    private ServerParamDao serverParamDao;

    /**
     * 获取字典数据
     *
     * @param serverParamType
     * @return
     */
    public ServerParam get(ServerParamType serverParamType) {
        return serverParamDao.get("spKey", serverParamType.getValue());
    }

    /**
     * 获取或者创建字典数据
     *
     * @param type
     * @param creator
     * @param <T>
     * @return
     */
    public <T> ServerParam getOrCreate(ServerParamType type, Supplier<T> creator) {
        ServerParam entity = get(type);
        if (entity != null) {
            return entity;
        }
        T data = creator.get();
        entity = ServerParam.of(type);
        entity.saveJson(data);
        add(entity);
        return entity;
    }

    /**
     * 保存字典数据
     *
     * @param type
     * @param supplier
     * @param <T>
     */
    public <T> void save(ServerParamType type, Supplier<T> supplier) {
        T data = supplier.get();
        ServerParam entity = get(type);
        if (entity == null) {
            entity = ServerParam.of(type);
            entity.saveJson(data);
            add(entity);
        } else {
            entity.saveJson(data);
            update(entity);
        }
    }

    /**
     * 添加字典数据
     *
     * @param serverParam
     */
    public void add(ServerParam serverParam) {
        serverParamDao.add(serverParam);
    }

    public void update(ServerParam serverParam) {
        serverParamDao.update(serverParam);
    }

    public int getServerStartTime() {
        ServerParam serverParam = get(ServerParamType.OPEN_SERVER_TIME);
        if (serverParam == null) {
            serverParam = new ServerParam();
            serverParam.setSpKey(ServerParamType.OPEN_SERVER_TIME.getValue());
            serverParam.setSpValue(DateTimeUtil.currentSecond() + "");
            serverParamDao.add(serverParam);
        }
        return Integer.parseInt(serverParam.getSpValue());
//        return Integer.valueOf(get(ServerParamType.OPEN_SERVER_TIME).getSpValue());
    }

    /***
     * 获取当前开服天数
     * @return
     */
    public int getOpenDays() {
        int openTime = getServerStartTime();
        openTime = DateTimeUtil.theDayBreak(openTime);
        return (int) Math.ceil((DateTimeUtil.currentSecond() - openTime) * 1.0 / TimeConstants.ONE_DAY_SECOND);
    }

    /**
     * 是否为新服
     *
     * @return
     */
    public boolean isNewServer() {
        ServerParam serverParam = this.get(ServerParamType.OPEN_SERVER_TIME);
        if (serverParam != null) {
            int currYear = TimeDateUtil.getYear(TimeDateUtil.getCurrentTime());
            int currMonth = TimeDateUtil.getMonthOfYear(TimeDateUtil.getCurrentTime());

            //开服时间是秒，需要转成毫秒
            long serverTime = JsonUtil.parseJson(serverParam.getSpValue(), Long.class);
            int serverYear = TimeDateUtil.getYear(serverTime * 1000l);
            int serverMonth = TimeDateUtil.getMonthOfYear(serverTime * 1000l);
            //开服当年当月
            if (currYear == serverYear && currMonth == serverMonth) {
                return true;
            }
        }
        return false;
    }
}
