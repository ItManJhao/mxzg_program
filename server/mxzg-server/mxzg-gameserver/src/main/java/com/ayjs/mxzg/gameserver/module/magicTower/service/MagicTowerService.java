package com.ayjs.mxzg.gameserver.module.magicTower.service;

import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.TitleSysCache;
import com.ayjs.mxzg.config.excel.cache.magicTower.MagicTowerConst;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.CTitle;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.TitleType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.magicTower.dao.MagicTowerDao;
import com.ayjs.mxzg.gameserver.module.magicTower.dao.MagicTowerLevelDao;
import com.ayjs.mxzg.gameserver.module.magicTower.dao.MagicTowerRoadDao;
import com.ayjs.mxzg.gameserver.module.magicTower.domain.MagicTower;
import com.ayjs.mxzg.gameserver.module.magicTower.domain.MagicTowerLevel;
import com.ayjs.mxzg.gameserver.module.magicTower.domain.MagicTowerRoad;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.module.title.service.TitleSystemService;
import com.ayjs.mxzg.protocol.MagicTowerGMsg;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2021/6/18
 **/
@Service
public class MagicTowerService implements IRechargeBuyingService {
    @Autowired
    private MagicTowerDao magicTowerDao;
    @Autowired
    private MagicTowerConst godRelicConst;
    @Autowired
    private MagicTowerLevelDao magicTowerLevelDao;
    @Autowired
    private MagicTowerRoadDao magicTowerRoadDao;
    @Autowired
    private TitleSystemService titleSystemService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private TitleSysCache titleSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ContextManager contextManager;

    public MagicTower load(long rid) {
        MagicTower magicTower = magicTowerDao.get(rid);
        if (magicTower == null) {
            magicTower = new MagicTower();
            magicTower.setRid(rid);
            magicTower.setMaxLevel(0);
            magicTower.setResetTime(LocalDate.now());
            magicTower.setBuyCount(0);
            magicTower.setCanChallengeCount(godRelicConst.getMagicTowerDailyFreeTimes());
            magicTowerDao.add(magicTower);
        }
        if (!LocalDate.now().isEqual(magicTower.getResetTime())) {
            magicTower.setBuyCount(0);
            magicTower.setCanChallengeCount(godRelicConst.getMagicTowerDailyFreeTimes());
            magicTower.setResetTime(LocalDate.now());
            magicTowerDao.update(magicTower);
        }
        return magicTower;
    }

    public List<MagicTowerLevel> loadAllMagicTowerLevel(long rid) {
        return magicTowerLevelDao.list("rid", rid);
    }

    public void update(MagicTowerLevel magicTowerLevel) {
        magicTowerLevelDao.update(magicTowerLevel);
    }

    public MagicTowerLevel loadLevel(long rid, int level) {
        MagicTowerLevel magicTowerLevel = loadAllMagicTowerLevel(rid).stream().filter(temp -> temp.getLevel() == level).findFirst().orElse(null);
        if (magicTowerLevel == null) {
            magicTowerLevel = new MagicTowerLevel();
            magicTowerLevel.setRid(rid);
            magicTowerLevel.setLevel(level);
            magicTowerLevelDao.add(magicTowerLevel);
        }
        return magicTowerLevel;
    }


    public void update(MagicTower magicTower) {
        magicTowerDao.update(magicTower);
    }

    public List<MagicTower> getAll() {
        return magicTowerDao.listAll();
    }

    public void updateList(List<MagicTowerLevel> update) {
        magicTowerLevelDao.update(update);
    }

    public MagicTowerRoad getMagicTowerRoadByRid(long rid) {
        MagicTowerRoad towerRoad = magicTowerRoadDao.get(rid);
        if (towerRoad == null) {
            towerRoad = new MagicTowerRoad();
            towerRoad.setRid(rid);
            magicTowerRoadDao.add(towerRoad);
        }
        return towerRoad;
    }

    public void updateMagicTowerRoad(MagicTowerRoad magicTowerRoad) {
        magicTowerRoadDao.update(magicTowerRoad);
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.MAGIC_TOWER_KING;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        MagicTower magicTower = load(rid);
        int sumStar = magicTower.getSumStar();
        MagicTowerRoad towerRoad = getMagicTowerRoadByRid(rid);
        return (towerRoad.getKingState() == 0 && sumStar >= systemSysCache.getMagicTowerKingGiftStar());
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        MagicTowerRoad towerRoad = getMagicTowerRoadByRid(rid);
        towerRoad.setKingState(1);
        updateMagicTowerRoad(towerRoad);
        // 更新玩家称号
        CTitle ctitle = titleSysCache.getOrThrow(systemSysCache.getMagicTowerKingTitleId());
        titleSystemService.provideTitle(rid, TitleType.MAGIC_TOWER, ctitle);

        ImmutableList<ImmutableThing> reward = cBuyGem.getItem();
        if (isGm) {
            thingService.add(rid, reward, GameEvent.GM);
        } else {
            thingService.add(rid, reward, GameEvent.MAGIC_TOWER_KING_GIFT);
        }
        // 同步信息
        MagicTowerGMsg.GResMagicTowerRoadInfo.Builder proto = MagicTowerGMsg.GResMagicTowerRoadInfo.newBuilder();
        proto.addAllNormalList(new ArrayList<>(towerRoad.getNormalSet()));
        proto.addAllKingList(new ArrayList<>(towerRoad.getKingSet()));
        proto.setState(towerRoad.getKingState());
        contextManager.write(rid, CmdCode._76542, proto.build());
    }

    public List<ObjectGMsg.PSMapData> convertPbList(Map<Integer, Integer> map) {
        List<ObjectGMsg.PSMapData> list = new ArrayList<>(map.size());
        map.forEach((key, value) -> {
            ObjectGMsg.PSMapData.Builder item = ObjectGMsg.PSMapData.newBuilder();
            item.setKey(key);
            item.setValue(value);
            list.add(item.build());
        });
        return list;
    }
}
