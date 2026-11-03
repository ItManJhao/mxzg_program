/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.PromotionControlSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.ILoopingPromotionCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion067WeekendKoiSysCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionControl;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.PromotionControlDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.web.event.PromotionChangeEvent;
import com.ayjs.mxzg.gameserver.web.event.ServerOpenTimeResetEvent;
import com.ayjs.mxzg.protocol.PromotionNewGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @author YY
 *
 */
@Slf4j
@Service
@Observer
public class PromotionControlService implements Lifecycle {

    @Autowired
    private PromotionControlDao promotionControlDao;
    @Autowired
    private PromotionControlSysCache promotionControlSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ServerParamService serverParamService;
    @Autowired
    private ContextManager contextManager;
    /*  @Autowired
      private Promotion067WeekendKoiService promotion067WeekendKoiService;*/
    @Autowired
    private Promotion067WeekendKoiSysCache promotion067WeekendKoiSysCache;

    private Map<PromotionType, ILoopingPromotionCache> loopCacheMap = new HashMap<>();

    public PromotionControl getControl(PromotionType type) {
        if (type.getOpenType() == 0) {
            return null;
        }
        return promotionControlDao.get("type", type.getId());
    }

    public List<PromotionControl> getAllPromotion() {
        return promotionControlDao.listAll();
    }

    public void updateControl(PromotionControl entity) {
        promotionControlDao.update(entity);
    }

    public void updateControls(List<PromotionControl> list) {
        promotionControlDao.update(list);
    }

    /**
     * 获取所有正在进行或将要开启的活动
     * @return
     */
    public List<PromotionControl> getAllWillRun() {
        int nowTime = TimeDateUtil.getCurrentTimeInt();
        List<PromotionControl> result = new ArrayList<>();
        for (PromotionControl control : getAllPromotion()) {
            if ((control.getStartTime() <= nowTime && nowTime <= control.getClearTime()) || control.getStartTime() > nowTime) {
                result.add(control);
            }
        }
        return result;
    }

    /**
     * 是否可以记录活动数据
     * @param rid
     * @param promotionType
     * @return
     */
    public boolean canRecordPromotionData(long rid, PromotionType promotionType) {
        if (!isPromotionRecording(promotionType)) {
            return false;
        }
        CPromotionControl cControl = promotionControlSysCache.getOrThrow(promotionType.getId());
        if (cControl == null) {
            return false;
        }
        Role role = roleService.getOrThrow(rid);
        return role.getLevel() > cControl.getOpen_level();
    }

    /**
     * 活动数据是否还可以记录
     * @param promotionType
     * @return
     */
    public boolean isPromotionRecording(PromotionType promotionType) {
        PromotionControl control = getControl(promotionType);
        if (control == null) {
            return false;
        }
        if (serverParamService.getOpenDays() < control.getLimitDays()) {
            return false;
        }
        int nowTime = TimeDateUtil.getCurrentTimeInt();
        if (control.getStartTime() <= nowTime && nowTime <= control.getEndTime()) {
            return true;
        }
        return false;
    }

    /**
     * 活动是否进行中
     * @param promotionType
     * @return
     */
    public boolean isPromotionRunning(PromotionType promotionType) {
        PromotionControl control = getControl(promotionType);
        if (control == null) {
            return false;
        }
        int nowTime = TimeDateUtil.getCurrentTimeInt();
        if (control.getStartTime() <= nowTime && nowTime <= control.getClearTime()) {
            return true;
        }
        return false;
    }

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._9, "PROMOTION_CONTROL");
    }

    @Override
    public void start() throws Exception {
        for (PromotionType promotionType : PromotionType.values()) {
            if (promotionType.getOpenType() == 1) {
                ILoopingPromotionCache loopingPromotionCache = null;
                try {
                    loopingPromotionCache = SpringProxy.getBean(promotionType.getLoopCacheClz());
                } catch (Exception e) {
                    log.error("获取活动{}编号{}的循环配置时发生异常", promotionType.getName(), promotionType.getId());
                }
                Asserts.notNull(loopingPromotionCache, ErrorCode.PROMOTION_LOOP_MISS.getValue(), "活动循环配置未找到" + promotionType);
                loopCacheMap.put(promotionType, loopingPromotionCache);
            }
        }

        int serverOpenTime = serverParamService.getServerStartTime();

        int serverOpenZero = TimeDateUtil.getSomedayZeroInt(serverOpenTime);

        List<PromotionControl> promotionList = getAllPromotion();
        Map<Integer, PromotionControl> promotionMap = ListMapUtil.listToMap(promotionList, PromotionControl::getType);

        List<PromotionControl> newPromotions = new ArrayList<>();
        for (PromotionType type : PromotionType.values()) {
            if (promotionMap.containsKey(type.getId())) {
                continue;
            }
            if (type.getOpenType() == 0) {
                //系统功能不插入活动
                continue;
            }
            PromotionControl control = new PromotionControl();
            control.setType(type.getId());
            control.setName(type.getName());
            if (type.getOpenType() == 1) {
                initControlByConfig(serverOpenZero, type, control);
            } else if (type.getOpenType() == 2) {
                //运营数据从运营后台开启
            }
            newPromotions.add(control);
        }
        if (!newPromotions.isEmpty()) {
            promotionControlDao.add(newPromotions);
        }
    }


    public void runForPromotion() {
        int nowTime = TimeDateUtil.getCurrentTimeInt();

        List<PromotionControl> updateList = null;

        for (PromotionControl control : getAllPromotion()) {
            try {
                PromotionType promotionType = PromotionType.valueOf(control.getType());
                if (promotionType == null) {
                    continue;
                }
                if (promotionType.getOpenType() == 0) {
                    //只处理循环活动和月度活动
                    continue;
                }
                if (nowTime > control.getClearTime() && control.getStatus() == 0) {
                    control.setStatus(1);
                    promotionControlDao.update(control);
                    BasePromotionService<?> baseService = BasePromotionService.getPromotionService(promotionType);
                    if (baseService != null) {
                        baseService.handleOnPromotionClear(control);
                    } else {
                        log.error("没有找到活动{}{}的服务器类", promotionType.getId(), promotionType.getName());
                    }
                }
                if (promotionType.getOpenType() == 1 && nowTime > control.getNextTime()) {
                    CPromotionControl cControl = promotionControlSysCache.getOrThrow(control.getType());
                    ILoopingPromotionCache loopingPromotionCache = null;
                    try {
                        loopingPromotionCache = loopCacheMap.get(promotionType);
                    } catch (Exception e) {
                        log.warn("活动{}编号{}未找到对应的循环配置数据，以原来的轮次开启新一轮活动", promotionType.getName(), promotionType.getId());
                    }
                    if (loopingPromotionCache == null) {
                        continue;
                    }

                    if (cControl.getCycle_type() == 0) {
//    					0.所有已配置的轮次开过后，不再循环开启
                        if (loopingPromotionCache != null) {
                            if (control.getTurns() < loopingPromotionCache.getMaxTurns()) {
                                control.setTurns(control.getTurns() + 1);
                            } else {
                                continue;
                            }
                        }
                    } else if (cControl.getCycle_type() == 1) {
//    					1.最后一轮结束后以最后一轮配置开启新一轮
                        if (loopingPromotionCache != null) {
                            if (control.getTurns() < loopingPromotionCache.getMaxTurns()) {
                                control.setTurns(control.getTurns() + 1);
                            }
                        }
                    } else if (cControl.getCycle_type() == 2) {
//    					2.最后一轮结束后重新从第一轮开始循环
                        if (loopingPromotionCache != null) {
                            if (control.getTurns() < loopingPromotionCache.getMaxTurns()) {
                                control.setTurns(control.getTurns() + 1);
                            } else {
                                control.setTurns(1);
                            }
                        }
                    }

                    control.setStartTime(control.getNextTime());
                    control.setEndTime(control.getStartTime() + cControl.getTime() * TimeDateUtil.ONEDAYINT);
                    control.setClearTime(control.getEndTime() + cControl.getClean_time() * TimeDateUtil.ONEDAYINT);
                    control.setNextTime(control.getClearTime() + cControl.getInterval_time() * TimeDateUtil.ONEDAYINT);
                    control.setTurnsTime(control.getStartTime());
                    control.setExtraInfo("");
                    control.setStatus(0);
                    BasePromotionService<?> basePromotionService = BasePromotionService.getPromotionService(promotionType);
                    if (basePromotionService != null) {
                        basePromotionService.handleOnPromotionNewTurns(control);
                    }
                    if (updateList == null) {
                        updateList = new ArrayList<>();
                    }
                    updateList.add(control);
                } else if (promotionType.getOpenType() == 2 && nowTime > control.getNextTime()) {
                    control.setStartTime(control.getNextTime());
                    control.setTurnsTime(control.getStartTime());
                    control.setNextTime(Integer.MAX_VALUE);
                    if (control.getStatus() != 0) {//未结算时，不重新开活动，
                        control.setStatus(0);
                        control.setExtraInfo("");
                        BasePromotionService<?> basePromotionService = BasePromotionService.getPromotionService(promotionType);
                        if (basePromotionService != null) {
                            basePromotionService.handleOnPromotionNewTurns(control);
                        }
                    }
                    if (updateList == null) {
                        updateList = new ArrayList<>();
                    }
                    updateList.add(control);
                }
            } catch (Exception e) {
                log.error("活动" + control.getType() + "出现异常", e);
            }
        }
        if (updateList != null) {
            promotionControlDao.update(updateList);
        }
    }

    @Subscribe
    public void resetServerTime(ServerOpenTimeResetEvent event) {
        int serverOpenZero = TimeDateUtil.getSomedayZeroInt(event.getServerTime());

        List<PromotionControl> promotionList = getAllPromotion();
        Map<Integer, PromotionControl> promotionMap = ListMapUtil.listToMap(promotionList, PromotionControl::getType);

        List<PromotionControl> updatePromotions = new ArrayList<>();

        for (PromotionType type : PromotionType.values()) {
            if (type.getOpenType() == 0) {
                //系统功能不插入活动
                continue;
            }

            PromotionControl control = promotionMap.get(type.getId());
            if (control == null) {
                continue;
            }

            if (type.getOpenType() == 1) {
                initControlByConfig(serverOpenZero, type, control);
                BasePromotionService<?> basePromotionService = BasePromotionService.getPromotionService(type);
                if (basePromotionService != null) {
                    basePromotionService.handleOnPromotionNewTurns(control);
                }
                updatePromotions.add(control);
            } else if (type.getOpenType() == 2) {
                //运营数据从运营后台开启
            }
        }

        if (!updatePromotions.isEmpty()) {
            promotionControlDao.update(updatePromotions);
        }
        log.info("活动时间重置，{}", event.getServerTime());
    }

    private void initControlByConfig(int serverOpenZero, PromotionType type, PromotionControl control) {
        CPromotionControl cControl = promotionControlSysCache.getOrThrow(type.getId());
        //配置表里面的是开服后第几天开启，第一天开启，表示现在开服当天就开启
        int openStartTime = serverOpenZero + (cControl.getOpen_server_day() - 1) * TimeDateUtil.ONEDAYINT;
        control.setStartTime(openStartTime);
        //若限制活动开启时间段
        if (cControl.getOpen_time_limit() > 0) {
            control.setStartTime(this.getStartTime(openStartTime, cControl.getOpen_time_limit()));
            if (control.getStartTime() < openStartTime) {
                control.setStartTime(control.getStartTime() + TimeDateUtil.ONEWEEKINT);
            }
        }
        control.setEndTime(control.getStartTime() + cControl.getTime() * TimeDateUtil.ONEDAYINT);
        control.setClearTime(control.getEndTime() + cControl.getClean_time() * TimeDateUtil.ONEDAYINT);
        control.setNextTime(control.getClearTime() + cControl.getInterval_time() * TimeDateUtil.ONEDAYINT);
        control.setTurns(1);
        control.setTurnsTime(control.getStartTime());
        control.setExtraInfo("");
        control.setStatus(0);
    }

    /**
     * 活动更改同步前端
     * @param event
     */
    @Subscribe
    public void promotionChange(PromotionChangeEvent event) {
        PromotionNewGMsg.GResActivityConfigHadUpdate.Builder builder = PromotionNewGMsg.GResActivityConfigHadUpdate.newBuilder();
        builder.addIds(event.getIdx());
        contextManager.writeAll(CmdCode._20103, builder.build());
    }

    /**
     * 获取活动集
     * @param idxList
     * @return
     */
    public List<PromotionControl> selectPromotionList(List<Integer> idxList) {
        List<PromotionControl> promotionControlList = new ArrayList<>();

        idxList.forEach(idx -> {
            PromotionType promotionType = PromotionType.valueOf(idx);
            if (!Objects.isNull(promotionType)) {
                PromotionControl promotionControl = this.getControl(promotionType);
                if (promotionControl != null) {
                    promotionControlList.add(promotionControl);
                }
            }
        });

        return promotionControlList;
    }

    private int getStartTime(int openStartTime, int limitDay) {
        int day = DateTimeUtil.getDayOfWeek(openStartTime) == 0 ? 7 : DateTimeUtil.getDayOfWeek(openStartTime);
        if (day > limitDay) {
            while (day != limitDay) {
                openStartTime -= TimeConstants.ONE_DAY_SECOND;
                day = DateTimeUtil.getDayOfWeek(openStartTime);
            }
        } else if (day < limitDay) {
            while (day != limitDay) {
                openStartTime += TimeConstants.ONE_DAY_SECOND;
                day = DateTimeUtil.getDayOfWeek(openStartTime);
            }
        }
        return openStartTime;
    }
}
