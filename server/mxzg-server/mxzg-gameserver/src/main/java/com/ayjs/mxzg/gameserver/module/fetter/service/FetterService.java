package com.ayjs.mxzg.gameserver.module.fetter.service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.ayjs.mxzg.gameserver.module.fetter.dao.FetterGoddess2Dao;
import com.ayjs.mxzg.gameserver.module.fetter.dao.FetterGoddessDao;
import com.ayjs.mxzg.gameserver.module.fetter.domain.FetterGoddess;
import com.ayjs.mxzg.gameserver.module.fetter.domain.FetterGoddess2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.config.excel.cache.GoddessResetSysCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessMission;
import com.ayjs.mxzg.config.excel.entity.CGoddessReset;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.fetter.constant.GoddessResetResult;
import com.ayjs.mxzg.gameserver.module.fetter.dao.FetterTaskRewardDao;
import com.ayjs.mxzg.gameserver.module.fetter.domain.FetterTaskReward;
import com.ayjs.mxzg.gameserver.module.role.constant.RoleParamType;
import com.ayjs.mxzg.gameserver.module.role.domain.RoleParam;
import com.ayjs.mxzg.gameserver.module.role.service.RoleParamService;
import com.ayjs.mxzg.gameserver.module.targetCounter.service.TargetCounterService;
import com.ayjs.mxzg.protocol.FetterGMsg;
import com.ayjs.mxzg.protocol.FetterGMsg.PSFetterData;

@Service
public class FetterService {

    @Autowired
    private FetterTaskRewardDao fetterTaskRewardDao;
    @Autowired
    private FetterGoddess2Dao fetterGoddess2Dao;
    @Autowired
    private FetterGoddessDao fetterGoddessDao;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private RoleParamService roleParamService;
    @Autowired
    private GoddessResetSysCache goddessResetSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private TargetCounterService targetCounterService;

    public FetterGoddess2 load(long rid) {
        FetterGoddess2 fetterGoddess2 = fetterGoddess2Dao.get(rid);
        if (fetterGoddess2 == null) {
            fetterGoddess2 = new FetterGoddess2();

            //加载旧数据
            List<FetterGoddess> all = fetterGoddessDao.select(rid);
            int oldMaxL = 1;
            int oldMaxExp = 0;
            int oldMaxSkillL = 1;
            int oldMaxUpLimitL = 0;
            int oldMaxRefineL = 0;
            int oldMaxSoulL = 0;
            Set<Integer> set = new HashSet<>();
            for (FetterGoddess fetterGoddess : all) {
                oldMaxL = Math.max(oldMaxL, fetterGoddess.getLevel());
                oldMaxExp = Math.max(oldMaxExp, fetterGoddess.getExp());
                oldMaxSkillL = Math.max(oldMaxSkillL, fetterGoddess.getSkillLevel());
                oldMaxUpLimitL = Math.max(oldMaxUpLimitL, fetterGoddess.getUplimitLevel());
                oldMaxRefineL = Math.max(oldMaxRefineL, fetterGoddess.getRefineLevel());
                oldMaxSoulL = Math.max(oldMaxSoulL, fetterGoddess.getSoulLevel());
                set.add(fetterGoddess.getGoddessType());
            }

            fetterGoddess2.setRid(rid);
            fetterGoddess2.setLevel(oldMaxL);
            fetterGoddess2.setExp(oldMaxExp);
            fetterGoddess2.setSkillLevel(oldMaxSkillL);
            fetterGoddess2.setRefineLevel(oldMaxRefineL);
            fetterGoddess2.setUplimitLevel(oldMaxUpLimitL);
            fetterGoddess2.setSoulLevel(oldMaxSoulL);
            if (set.size() != 0) {
                fetterGoddess2.getActiveType().addAll(set);
            }

            fetterGoddess2Dao.add(fetterGoddess2);
        }
        return fetterGoddess2;
    }

    public void update(FetterGoddess2 fetterGoddess2) {
        fetterGoddess2Dao.update(fetterGoddess2);
    }

    /**
     * 将羁绊女神数据转化为前端所需格式
     *
     * @return
     */
    public PSFetterData transformGoddess(FetterGoddess2 goddess, int type) {
        PSFetterData.Builder model = PSFetterData.newBuilder();
        model.setType(type);
        model.setLevel(goddess.getLevel());
        model.setExp(goddess.getExp());
        model.setUplimitLevel(goddess.getUplimitLevel());
        model.setRefineLevel(goddess.getRefineLevel());
        model.setSkillLevel(goddess.getSkillLevel());
        model.setSoulLevel(goddess.getSoulLevel());
        model.setWashLevel(goddess.getWashLevel());
        return model.build();
    }

    /**
     * 新增某个羁绊女神
     *
     * @param rid
     * @param goddessType
     * @return
     */
    public FetterGoddess2 insertFetterGoddess(long rid, int goddessType) {
        FetterGoddess2 fetterGoddess = load(rid);
        fetterGoddess.getActiveType().add(goddessType);
        update(fetterGoddess);
        return fetterGoddess;
    }

    /**
     * 修改羁绊任务领取状态
     *
     * @param task
     */
    public void updateFetterTaskReward(FetterTaskReward task) {
        fetterTaskRewardDao.update(task);
    }

    /**
     * 查询某个羁绊任务数据
     *
     * @param rid
     * @return
     */
    public FetterTaskReward getFetterTask(long rid) {
        FetterTaskReward fetter = fetterTaskRewardDao.get(rid);
        if (fetter == null) {
            fetter = new FetterTaskReward();
            fetter.setRid(rid);
            fetter.setTaskId(new ArrayList<>());
            fetter.setGoddessReset(1);
            fetterTaskRewardDao.add(fetter);
        }
        if (fetter.getContracts() == null) {
            fetter.setContracts(new HashSet<>());
            fetterTaskRewardDao.update(fetter);
        }
        if (fetter.getGoddessReset() == 0) {
            RoleParam roleParam = roleParamService.get(rid, RoleParamType.GODDESS_RESET);
            if (roleParam != null) {
                fetter.setGoddessReset(roleParam.parseJson(Integer.class));
            }
            fetterTaskRewardDao.update(fetter);
        }
        return fetter;
    }

    public void updateFetterTask(long rid, List<CGoddessMission> goddessMissionList) {
        FetterGMsg.GResFetterUpProgress.Builder builder = FetterGMsg.GResFetterUpProgress.newBuilder();
        goddessMissionList.stream().forEach(config -> {
            FetterGMsg.PSFetterProgress.Builder data = FetterGMsg.PSFetterProgress.newBuilder();
            data.setIdx(config.getIdx());
            data.setNum((int) targetCounterService.calcTaskCount(rid, config.getTask()));
            builder.addProgressList(data);
        });
        contextManager.write(rid, CmdCode._28001, builder.build());
    }

    /**
     * 重置女神验证
     *
     * @param rid
     * @param fetterGoddess
     */
    public int checkRemoveGoddess(long rid, FetterGoddess2 fetterGoddess) {
        if (fetterGoddess == null) {
            return GoddessResetResult.GODDESS.getType();
        }
        if (fetterGoddess.getExp() == 0 && fetterGoddess.getLevel() == 1 && fetterGoddess.getSkillLevel() == 1
                && fetterGoddess.getRefineLevel() == 0 && fetterGoddess.getUplimitLevel() == 0) {
            return GoddessResetResult.GODDESS_LEVEL.getType();
        }
        FetterTaskReward fetterTaskReward = this.getFetterTask(rid);
        CGoddessReset cModel = null;
        List<CGoddessReset> resetList = goddessResetSysCache.getAll();
        for (CGoddessReset cGoddessReset : resetList) {
            if (fetterTaskReward.getGoddessReset() >= cGoddessReset.getTimes_low() && fetterTaskReward.getGoddessReset() <= cGoddessReset.getTimes_up()) {
                cModel = cGoddessReset;
            }
        }
        thingService.cost(rid, cModel.getNeed(), GameEvent.GODDESS_RESET_COST);

        fetterTaskReward.setGoddessReset(fetterTaskReward.getGoddessReset() + 1);
        this.updateFetterTaskReward(fetterTaskReward);

        return GoddessResetResult.ACHIEVE.getType();
    }

}
