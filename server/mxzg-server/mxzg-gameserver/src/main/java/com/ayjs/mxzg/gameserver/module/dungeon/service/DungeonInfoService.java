package com.ayjs.mxzg.gameserver.module.dungeon.service;


import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.config.excel.cache.ShelterEventGoldSysCache;
import com.ayjs.mxzg.config.excel.cache.ShelterEventSysCache;
import com.ayjs.mxzg.config.excel.cache.ShelterShopPrizeSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CShelterEvent;
import com.ayjs.mxzg.config.excel.entity.CShelterEventGold;
import com.ayjs.mxzg.config.excel.entity.CShelterShopPrize;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.dungeon.constant.DungeonEnum;
import com.ayjs.mxzg.gameserver.module.dungeon.dao.DungeonInfoDao;
import com.ayjs.mxzg.gameserver.module.dungeon.domain.DungeonInfo;
import com.ayjs.mxzg.gameserver.module.dungeon.struct.DungeonEarnings;
import com.ayjs.mxzg.gameserver.module.dungeon.struct.DungeonShopItem;
import com.ayjs.mxzg.gameserver.module.server.constant.ServerParamType;
import com.ayjs.mxzg.gameserver.module.server.domain.ServerParam;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.server.struct.ShelterStartTime;
import com.ayjs.mxzg.protocol.DungeonGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DungeonInfoService {
    @Autowired
    private DungeonInfoDao dungeonInfoDao;
    @Autowired
    private ShelterEventGoldSysCache shelterEventGoldSysCache;
    @Autowired
    SystemSysCache systemSysCache;
    @Autowired
    private ShelterShopPrizeSysCache shelterShopPrizeSysCache;
    @Autowired
    private ServerParamService serverParamService;
    @Autowired
    private DungeonService dungeonService;
    @Autowired
    private DungeonBackpackService dungeonBackpackService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private ShelterEventSysCache shelterEventSysCache;

    /**
     * 获取庇护所开启时间
     *
     * @return
     */
    public ServerParam getShelterStarTime() {
        ServerParam serverParam = serverParamService.get(ServerParamType.SHELTER_START_TIME);
        if (serverParam == null) {
            serverParam = new ServerParam();
            ShelterStartTime shelterStartTime = new ShelterStartTime();
            shelterStartTime.setStartTime(DateTimeUtil.dayBreak());
            shelterStartTime.setEndTime(DateTimeUtil.dayBreak() + systemSysCache.getShelterLastDay() * TimeConstants.ONE_DAY_SECOND);
            serverParam.saveJson(shelterStartTime);
            serverParam.setSpKey(ServerParamType.SHELTER_START_TIME.getValue());
            serverParamService.add(serverParam);
        } else {
            if (DateTimeUtil.currentSecond() >= serverParam.parseJson(ShelterStartTime.class).getEndTime()) {
                updateShelterStarTime(serverParam);
            }
        }
        return serverParam;
    }

    /**
     * 更新庇护所开启时间
     *
     * @param serverParam
     */
    public void updateShelterStarTime(ServerParam serverParam) {

        //一旦庇护所更改，但要前端刷新一次协议
        ShelterStartTime shelterStartTime = new ShelterStartTime();
        shelterStartTime.setStartTime(DateTimeUtil.dayBreak());
        shelterStartTime.setEndTime(DateTimeUtil.dayBreak() + systemSysCache.getShelterLastDay() * TimeConstants.ONE_DAY_SECOND);
        serverParam.saveJson(shelterStartTime);
        serverParamService.update(serverParam);

        DungeonGMsg.GResRemoveShelterInfo.Builder builder = DungeonGMsg.GResRemoveShelterInfo.newBuilder();
        contextManager.writeAll(CmdCode._24000, builder.build());
    }

    /**
     * 查询玩家庇护所信息
     *
     * @param rid
     * @return
     */
    public DungeonInfo select(long rid) {
        DungeonInfo model = dungeonInfoDao.get(rid);
        if (model == null) {
            model = insertDungeonInfo(rid);
            dungeonService.resetDungeon(model);
        }
        ServerParam entity = getShelterStarTime();
        if (model.getTime() < entity.parseJson(ShelterStartTime.class).getStartTime()) {
            resetDungeonInfo(model);
            dungeonService.resetDungeon(model);
            dungeonBackpackService.resetBackPack(rid);
        }
        return model;
    }

    /**
     * 新增角色庇护所个人信息
     *
     * @return
     */
    private DungeonInfo insertDungeonInfo(long rid) {
        DungeonInfo model = new DungeonInfo();
        model.setRid(rid);
        model.setStage(0);
        model.setNowStage(1);
        model.setGridType(RandomUtil.rand(1, DungeonEnum.GRID_TYPE1_MAX.getType() + 1));
        model.setTime(DateTimeUtil.currentSecond());
        model.setWinTimes(0);
        model.setEventMap(resetEventCount());
        dungeonInfoDao.add(model);
        return model;
    }

    private Map<Integer, Integer> resetEventCount() {
        Map<Integer, Integer> map = new HashMap<>();
        for (CShelterEvent cShelterEvent : shelterEventSysCache.getAll()) {
            map.put(cShelterEvent.getIdx(), 0);
        }
        return map;
    }

    /**
     * 更新庇护所个人数据
     *
     * @param entity
     */
    public void update(DungeonInfo entity) {
        dungeonInfoDao.update(entity);
    }

    public void updateList(List<DungeonInfo> list) {
        dungeonInfoDao.update(list);
    }

    /**
     * 庇护所金币事件计算
     *
     * @param stage
     * @return
     */
    public ImmutableThing dungeonGoldEven(int idx, int stage) {
        CShelterEventGold cShelterEventGold = shelterEventGoldSysCache.getOrThrow(idx);
        long gold = cShelterEventGold.getBase().get(0).getItem_num();
        long addGold = ImmutableThingUtil.multiplyThing(cShelterEventGold.getAdd(), stage).get(0).getItem_num();
        //金币加成
        ImmutableThing reward = ImmutableThing.of(ItemType.IT_GOLD, gold + addGold, 0);
        return reward;
    }

    /**
     * 重置庇护所数据
     */
    public void resetDungeonInfo(DungeonInfo dungeonInfo) {
        //更新庇护所个人信息
        dungeonInfo.setGridType(RandomUtil.rand(1, DungeonEnum.GRID_TYPE1_MAX.getType() + 1));
        dungeonInfo.setTime(DateTimeUtil.currentSecond());
        int newStage = dungeonInfo.getStage() - systemSysCache.getShelterLevelResetNum();
        dungeonInfo.setNowStage(newStage > 0 ? newStage + 1 : 1);
        dungeonInfo.setWinTimes(0);
        dungeonInfo.setEventMap(resetEventCount());
        dungeonInfo.getKillReward().clear();
        dungeonInfo.getBuff().clear();//清除BUFF
        dungeonInfo.getShopItemList().clear();//清除商品
        dungeonInfo.getEarningsList().clear();//清除收益
        dungeonInfo.getBattleMap().clear();//清除战斗队伍
        dungeonInfo.getFightingMap().clear();//清除英雄对应战力
        dungeonInfo.getEarningsList().clear();//清除地牢收益
        dungeonInfoDao.update(dungeonInfo);
    }

    /**
     * 获取所有
     *
     * @return
     */
    public List<DungeonInfo> selectAll() {
        return dungeonInfoDao.listAll();
    }

    /**
     * 新增庇护所商店商品
     *
     * @param rid
     * @param shop_id
     * @param num
     */
    public CShelterShopPrize insertShopCommodity(long rid, long shop_id, int num) {
        int maxIndex = selectMaxIndex(rid);
        DungeonInfo dungeonInfo = select(rid);
        List<CShelterShopPrize> list = shelterShopPrizeSysCache.getAll();
        CShelterShopPrize config = null;//只返回最后一个
        for (int i = 0; i < num; i++) {
            CShelterShopPrize cModel = DropUtil.randomDrop(list);
            DungeonShopItem item = new DungeonShopItem();
            item.setIndex(++maxIndex);
            item.setShopId(shop_id);
            item.setIsBuy(0);
            item.setItemId(cModel.getIdx());
            dungeonInfo.getShopItemList().add(item);
            config = cModel;
        }
        update(dungeonInfo);
        return config;
    }

    /**
     * 获取庇护所商店商品最大索引
     *
     * @param rid
     * @return
     */
    public int selectMaxIndex(long rid) {
        int maxIndex = 0;
        DungeonInfo dungeonInfo = select(rid);
        for (DungeonShopItem item : dungeonInfo.getShopItemList()) {
            if (item.getIndex() > maxIndex) {
                maxIndex = item.getIndex();
            }
        }
        return maxIndex;
    }

    /**
     * 添加庇护所收益
     *
     * @param rid
     * @param item_id
     * @param item_num
     */
    public void addDungeonItem(long rid, int item_id, long item_num) {
        if (item_id == 0) {
            return;
        }
        DungeonInfo dungeonInfo = select(rid);
        boolean f = true;
        for (DungeonEarnings earnings : dungeonInfo.getEarningsList()) {
            if (earnings.getItemType() == item_id) {
                f = false;
                earnings.setItemNum(earnings.getItemNum() + item_num);
            }
        }
        if (f) {
            DungeonEarnings earnings = new DungeonEarnings();
            earnings.setItemType(item_id);
            earnings.setItemNum(item_num);
            dungeonInfo.getEarningsList().add(earnings);
        }
        update(dungeonInfo);
    }

}
