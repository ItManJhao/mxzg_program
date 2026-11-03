package com.ayjs.mxzg.gameserver.module.skinshop.service;

import com.ayjs.mxzg.config.excel.cache.BuyGemSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroFashionUnlockSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopHeroSkinSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.CHeroFashionUnlock;
import com.ayjs.mxzg.config.excel.entity.shop.CShopHeroSkin;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.BackPackService;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroFashion;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroFashionService;
import com.ayjs.mxzg.gameserver.module.hero.struct.FashionData;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.skinshop.dao.SkinShopDao;
import com.ayjs.mxzg.gameserver.module.skinshop.domain.SkinShop;
import com.ayjs.mxzg.protocol.HeroSkinGMsg;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Service
public class SkinShopService implements IRechargeBuyingService {
    @Autowired
    private BackPackService backPackService;
    @Autowired
    private HeroFashionService heroFashionService;
    @Autowired
    private ShopHeroSkinSysCache shopHeroSkinSysCache;
    @Autowired
    private SkinShopDao skinShopDao;
    @Autowired
    private ThingService thingService;
    @Autowired
    private HeroFashionUnlockSysCache fashionUnlockSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private SystemSysCache systemSysCache;

    public List<Integer> getFashionByRid(long rid) {
        List<Integer> skins = new ArrayList<>();
        List<CShopHeroSkin> allConfigs = shopHeroSkinSysCache.getAll();
        allConfigs.forEach(fashion -> {
            int fashionId = fashion.getFashion_type();
            SkinShop skinShop = getSkinShopByRid(rid);
            // 已经购买
            if (skinShop.getBuySet().contains(fashionId)) {
                skins.add(fashionId);
                return;
            }
            // 背包存在该道具但未激活
            CHeroFashionUnlock unlockConfig = fashionUnlockSysCache.getItemTypeByFashionId(fashionId);
            if (Objects.nonNull(unlockConfig) && Objects.nonNull(backPackService.getBackPack(rid, unlockConfig.getItem_type()))) {
                skins.add(fashionId);
                return;
            }
            // 皮肤已经激活
            HeroFashion heroFashion = heroFashionService.selectAndRefresh(rid);
            FashionData fashionData = heroFashionService.selectFashionData(heroFashion, fashionId);
            if (Objects.nonNull(fashionData) && fashionData.getStatus() == 0) {
                skins.add(fashionId);
            }
        });
        return skins;
    }

    public SkinShop getSkinShopByRid(long rid) {
        SkinShop skinShop = skinShopDao.get(rid);
        if (skinShop == null) {
            skinShop = new SkinShop();
            skinShop.setRid(rid);
            skinShopDao.add(skinShop);
        }
        return skinShop;
    }

    public void update(SkinShop skinShop) {
        skinShopDao.update(skinShop);
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.FOREVER_HERO_SKIN;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        CShopHeroSkin config = shopHeroSkinSysCache.getHeroSkinByProductId(productId);
        List<Integer> allFashion = getFashionByRid(rid);
        boolean flag = true;
        for (Integer fashionId : allFashion) {
            if (fashionId == config.getFashion_type()) {
                flag = false;
                break;
            }
        }

        Role role = roleService.getOrThrow(rid);
        int level = role.getLevel();
        return (level > systemSysCache.getOpenSkinStoreLevel() && flag);
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        SkinShop skinShop = getSkinShopByRid(rid);
        ImmutableList<ImmutableThing> reward = cBuyGem.getItem();
        CShopHeroSkin cShopHeroSkin = shopHeroSkinSysCache.getHeroSkinByProductId(cBuyGem.getIdx());
        // 数据更新
        skinShop.getBuySet().add(cShopHeroSkin.getFashion_type());
        skinShopDao.update(skinShop);
        if(isGm) {
            thingService.add(rid, reward, GameEvent.GM);
        } else {
            thingService.add(rid, reward, GameEvent.FOREVER_HERO_SKIN_REWARD);
        }
        HeroSkinGMsg.GResHeroSkinList.Builder proto = HeroSkinGMsg.GResHeroSkinList.newBuilder();
        proto.addAllSkins(getFashionByRid(rid));
        contextManager.write(rid, CmdCode._76397, proto.build());
    }
}
