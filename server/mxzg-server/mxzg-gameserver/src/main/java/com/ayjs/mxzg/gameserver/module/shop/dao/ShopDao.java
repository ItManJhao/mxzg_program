package com.ayjs.mxzg.gameserver.module.shop.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.shop.domain.Shop;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 商店
 */
@Repository
public class ShopDao extends BaseRepository<Shop> {

    public List<Shop> getShops(long rid) {
        return list("rid", rid);
    }
}
