package com.ayjs.mxzg.gameserver.module.backpack.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.gameserver.module.backpack.dao.BackPackDao;
import com.ayjs.mxzg.gameserver.module.backpack.domain.BackPack;

/**
 * @author YY
 */
@Service
public class BackPackService {
    @Autowired
    private BackPackDao backPackDao;

    public List<BackPack> getBagList(long rid) {
        return backPackDao.list("rid", rid);
    }

    public BackPack getBackPack(long rid, int itemId) {
        for (BackPack backPack : getBagList(rid)) {
            if (backPack.getItemId() == itemId) {
                return backPack;
            }
        }
        return null;
    }

    public Map<Integer, BackPack> getBackPack(long rid) {
        Map<Integer, BackPack> backPackMap = new HashMap<>();
        for (BackPack backPack : getBagList(rid)) {
            backPackMap.put(backPack.getItemId(), backPack);
        }
        return backPackMap;
    }

    public void addBackPack(BackPack backPack) {
        backPackDao.add(backPack);
    }

    public void addBackPacks(List<BackPack> backPacks) {
        backPackDao.add(backPacks);
    }

    public void delBackPack(BackPack backPack) {
        backPackDao.remove(backPack);
    }

    public void delBackPacks(List<BackPack> backPacks) {
        backPackDao.remove(backPacks);
    }

    public void updateBackPack(BackPack backPack) {
        backPackDao.update(backPack);
    }

    public void updateBackPacks(List<BackPack> backPacks) {
        backPackDao.update(backPacks);
    }
}
