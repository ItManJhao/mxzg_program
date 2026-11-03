package com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.service;


import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.dao.ShenBinCoreDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.dao.ShenBinEquipDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.domain.ShenBinCore;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.domain.ShenBinEquip;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Observer
@Service
public class ShenBinService {

    @Autowired
    private ThingService thingService;
    @Autowired
    private ShenBinCoreDao shenBinCoreDao;
    @Autowired
    private ShenBinEquipDao shenBinEquipDao;

    public List<ShenBinEquip> getShenBinEquips(long rid, int job) {
        List<ShenBinEquip> list = getRoleShenBin(rid);
        List<ShenBinEquip> result = new ArrayList<>();
        for (ShenBinEquip part : list) {
            if (part.getJob() == job) {
                result.add(part);
            }
        }
        return result;
    }

    //获取神兵准备
    public ShenBinEquip getShenBinEquip(long rid, int job, int place) {
        List<ShenBinEquip> list = getRoleShenBin(rid);
        for (ShenBinEquip part : list) {
            if (part.getJob() == job && part.getPlace() == place) {
                return part;
            }
        }
        return addShenBinEquip(rid, job, place);
    }

    //新增神兵装备
    private ShenBinEquip addShenBinEquip(long rid, int job, int place) {
        ShenBinEquip shenBinEquip = new ShenBinEquip();
        shenBinEquip.setRid(rid);
        shenBinEquip.setJob(job);
        shenBinEquip.setPlace(place);
        shenBinEquip.setSysId(-1);//没有装备默认-1
        shenBinEquipDao.add(shenBinEquip);
        return shenBinEquip;
    }

    //重置神兵装备
    public void resetShenBinEquip(long rid, int job) {
        List<ShenBinEquip> list = getRoleShenBin(rid);
        List<ShenBinEquip> listRe = new ArrayList<>();
        for (ShenBinEquip part : list) {
            if (part.getJob() == job) {
                part.setSysId(-1);
                listRe.add(part);
            }
        }
        shenBinEquipDao.update(listRe);
    }


    //更新神兵装备
    public void updateShenBinEquip(ShenBinEquip shenBinEquip) {
        shenBinEquipDao.update(shenBinEquip);
    }

    public List<ShenBinEquip> getRoleShenBin(long rid) {
        return shenBinEquipDao.list("rid", rid);
    }

    //获取角色的神兵核心
    public ShenBinCore getRoleShenBinCore(long rid, int job) {
        List<ShenBinCore> list = shenBinCoreDao.list("rid", rid);
        for (ShenBinCore temp : list) {
            if (temp.getJob() == job) {
                return temp;
            }
        }
        ShenBinCore shenBinCore = new ShenBinCore();
        shenBinCore.setRid(rid);
        shenBinCore.setJob(job);
        shenBinCore.setCoreLv(1);//默认1级
        shenBinCoreDao.add(shenBinCore);
        return shenBinCore;
    }

    public Map<Integer, Integer> getShenBinJobCores(long rid) {
        List<ShenBinCore> list = shenBinCoreDao.list("rid", rid);
        Map<Integer, Integer> shenBinJobCores = new HashMap<>();
        for (ShenBinCore temp : list) {
            shenBinJobCores.put(temp.getJob(), temp.getCoreLv());
        }
        return shenBinJobCores;
    }

    //更新神兵核心
    public void updateRoleShenBinCore(ShenBinCore shenBinCore) {
        shenBinCoreDao.update(shenBinCore);
    }

}
