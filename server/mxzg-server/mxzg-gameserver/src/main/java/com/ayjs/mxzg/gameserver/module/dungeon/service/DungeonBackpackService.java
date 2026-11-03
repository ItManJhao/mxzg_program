package com.ayjs.mxzg.gameserver.module.dungeon.service;

import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.dungeon.dao.DungeonBackpackDao;
import com.ayjs.mxzg.gameserver.module.dungeon.domain.DungeonBackpack;
import com.ayjs.mxzg.protocol.DungeonGMsg.GResDungeonPropsList;
import com.ayjs.mxzg.protocol.DungeonGMsg.PSDungeonPropsData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class DungeonBackpackService {
    @Autowired
    private DungeonBackpackDao dungeonBackpackDao;
    @Autowired
    private ContextManager contextManager;

    /**
     * 扣地牢道具
     */
    public boolean delitem(long rid, int item_id, int num) {
        DungeonBackpack backpack = selectItem(rid, item_id);
        if (backpack == null) {
            // 不存在该类型道具
            return false;
        } else {
            if (backpack.getNum() < num) {
                return false;
            } else {
                backpack.setNum(backpack.getNum() - num);
                //记录已使用次数
                backpack.setUseNum(backpack.getUseNum() + num);
                dungeonBackpackDao.update(backpack);
                return true;
            }
        }
    }

    /**
     * 加地牢道具
     *
     * @param rid
     * @param item_id
     * @param item_num
     * @return
     */
    public void addItem(long rid, int item_id, int item_num) {
        if (item_id == 0) {
            return;
        }
        List<DungeonBackpack> list = selectList(rid);
        DungeonBackpack dungeonBackpack = null;
        for (DungeonBackpack model : list) {
            if (model.getItemId() == item_id) {
                dungeonBackpack = model;
            }
        }//end for
        if (dungeonBackpack == null) {
            dungeonBackpack = new DungeonBackpack();
            dungeonBackpack.setRid(rid);
            dungeonBackpack.setItemId(item_id);
            dungeonBackpack.setNum(item_num);
            dungeonBackpackDao.add(dungeonBackpack);
        } else {
            dungeonBackpack.setNum(dungeonBackpack.getNum() + item_num);
            dungeonBackpackDao.update(dungeonBackpack);
        }
        getDungeonBackpack(rid);
    }

    /**
     * 重置庇护所道具使用数量
     *
     * @param rid
     */
    public void resetBackPack(long rid) {
        List<DungeonBackpack> list = selectList(rid);
        List<DungeonBackpack> updateList = new ArrayList<>();
        for (DungeonBackpack backPack : list) {
            if (backPack.getUseNum() != 0) {
                backPack.setUseNum(0);
                updateList.add(backPack);
            }
        }
        if (!updateList.isEmpty()) {
            dungeonBackpackDao.update(updateList);
        }
    }


    /**
     * 查询地牢背包所有道具
     *
     * @param rid
     */
    public List<DungeonBackpack> selectList(long rid) {
        return dungeonBackpackDao.list("rid", rid);
    }

    public DungeonBackpack selectItem(long rid, long itemId) {
        DungeonBackpack model = null;
        for (DungeonBackpack backpack : selectList(rid)) {
            if (backpack.getItemId() == itemId) {
                model = backpack;
            }
        }
        return model;
    }


    public void getDungeonBackpack(long rid) {
        GResDungeonPropsList.Builder builder = GResDungeonPropsList.newBuilder();
        for (DungeonBackpack model : selectList(rid)) {
            if (model.getNum() <= 0) {
                continue;
            }
            PSDungeonPropsData.Builder data = PSDungeonPropsData.newBuilder();
            data.setItemType(model.getItemId());
            data.setItemNum(model.getNum());
            data.setCurUseNum(model.getUseNum());
            builder.addList(data);
        }
        contextManager.write(rid, CmdCode._24007, builder.build());
    }
}
