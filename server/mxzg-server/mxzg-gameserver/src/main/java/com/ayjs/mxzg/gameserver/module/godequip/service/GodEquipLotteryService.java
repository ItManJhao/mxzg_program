package com.ayjs.mxzg.gameserver.module.godequip.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentLotterySysCache;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentLotteryTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion010PrivilegeGiftSysCache;
import com.ayjs.mxzg.config.excel.constant.GodEquipConst;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentLottery;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentLotteryType;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion010PrivilegeGift;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.godequip.dao.GodEquipInfoDao;
import com.ayjs.mxzg.gameserver.module.godequip.dao.GodEquipSysInfoDao;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquipLotteryInfo;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquipSysInfo;
import com.ayjs.mxzg.gameserver.module.godequip.struct.GodEquipRecord;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PrivilegeType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PrivilegeGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.BuyPrivilegeEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion010PrivilegeGiftService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.GodEquipGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 神装抽奖
 *
 * @author hyx
 */
@Service
@Observer
public class GodEquipLotteryService {

    @Autowired
    private GodEquipInfoDao godEquipInfoDao;
    @Autowired
    private GodEquipSysInfoDao godEquipSysInfoDao;
    @Autowired
    private GodEquipmentLotterySysCache godEquipmentLotterySysCache;
    @Autowired
    private GodEquipmentLotteryTypeSysCache godEquipmentLotteryTypeSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private Promotion010PrivilegeGiftService promotion010PrivilegeGiftService;
    @Autowired
    private Promotion010PrivilegeGiftSysCache promotion010PrivilegeGiftSysCache;
    @Autowired
    private MailService mailService;

    /**
     * 获取个人神装数据
     *
     * @param rid
     * @return
     */
    public GodEquipLotteryInfo select(long rid) {
        GodEquipLotteryInfo godEquipLotteryInfo = godEquipInfoDao.get(rid);
        if (godEquipLotteryInfo == null) {
            godEquipLotteryInfo = new GodEquipLotteryInfo();
            godEquipLotteryInfo.setRid(rid);
            godEquipInfoDao.add(godEquipLotteryInfo);
        }
        if (godEquipLotteryInfo.getPrivilege() == 1) {
            PrivilegeGift privilegeGift = promotion010PrivilegeGiftService.getPrivilegeGift(rid, PrivilegeType.GOD_EQUIP);
            if (privilegeGift.getActive() == 0) {
                godEquipLotteryInfo.setPrivilege(0);
                this.sendPrivilegeExpiresMail(godEquipLotteryInfo);
                this.update(godEquipLotteryInfo);
            }
            this.sendPrivilegeRewardMail(godEquipLotteryInfo);
        }
        return godEquipLotteryInfo;
    }

    /**
     * 查询系统的所有探宝记录
     *
     * @return
     */
    public GodEquipSysInfo selectSysLottery() {
        List<GodEquipSysInfo> list = godEquipSysInfoDao.listAll();
        if (list == null) {
            list = new ArrayList<>();
        }
        if (list.size() == 0) {
            GodEquipSysInfo godEquipSysInfo = new GodEquipSysInfo();
            godEquipSysInfoDao.add(godEquipSysInfo);
            list = godEquipSysInfoDao.listAll();
        }
        return list.get(0);
    }

    public void update(GodEquipLotteryInfo godEquipLotteryInfo) {
        godEquipInfoDao.update(godEquipLotteryInfo);
    }


    public void update(GodEquipSysInfo godEquipSysInfo) {
        godEquipSysInfoDao.update(godEquipSysInfo);
    }

    /**
     * 神装探宝
     *
     * @param lotteryInfo
     * @param lotteryType
     * @return
     */
    public void godEquipLottery(GodEquipLotteryInfo lotteryInfo, int lotteryType) {

        //神装探宝扣除
        this.costGodEquipLottery(lotteryInfo, lotteryType);
        //神装配置
        List<CGodEquipmentLottery> godEquipmentLotteries = new ArrayList<>();
        //奖励内容
        List<ImmutableThing> rewardList = new ArrayList<>();

        for (int i = 1; i <= lotteryType; i++) {
            //抽奖次数加1
            lotteryInfo.setLotteryCount(lotteryInfo.getLotteryCount() + 1);
            //奖池
            List<CGodEquipmentLottery> lotteryList;
            //若是玩家触发每N抽必出条件（最大优先级）
            if (lotteryInfo.getLotteryCount() >= GodEquipConst.godEquipmentLotteryGuarantee) {
                lotteryList = godEquipmentLotterySysCache.getAllGuaranteeList();
                lotteryInfo.setLotteryCount(0);
            } else {
                //根据星级获得奖池
                CGodEquipmentLotteryType randomOne = DropUtil.randomDrop(godEquipmentLotteryTypeSysCache.getAll(),
                        CGodEquipmentLotteryType::getIdx, CGodEquipmentLotteryType::getWeight);
                lotteryList = godEquipmentLotterySysCache.getNormalList(randomOne.getType());

                //添加特殊奖励进奖池
                List<CGodEquipmentLottery> specialList = godEquipmentLotterySysCache.getSpecialList(randomOne.getType());
                for (CGodEquipmentLottery config : specialList) {
                    //当前记录特殊次数
                    int num = lotteryInfo.getLotteryRefresh().getOrDefault(config.getIdx(), 0);
                    if (num >= config.getShow_min()) {
                        lotteryList.add(config);
                    }
                    //该道具处于此轮必出状态
                    if (config.getShow_max() > 0 && num >= config.getShow_max()) {
                        lotteryList.clear();
                        lotteryList.add(config);
                        break;
                    }
                }
            }

            CGodEquipmentLottery cGodEquipmentLottery = DropUtil.randomDrop(lotteryList);
            //若是特殊道具将其次数归0
            if (cGodEquipmentLottery.getShow_min() > 0 || cGodEquipmentLottery.getShow_max() > 0) {
                lotteryInfo.getLotteryRefresh().put(cGodEquipmentLottery.getIdx(), 0);
            }

            //将其他特殊道具的次数加1
            for (CGodEquipmentLottery config : godEquipmentLotterySysCache.getAllSpecialList()) {
                if (config.getIdx() != cGodEquipmentLottery.getIdx()) {
                    int num = lotteryInfo.getLotteryRefresh().getOrDefault(config.getIdx(), 0);
                    lotteryInfo.getLotteryRefresh().put(config.getIdx(), num + 1);
                }
            }

            godEquipmentLotteries.add(cGodEquipmentLottery);
            rewardList.addAll(cGodEquipmentLottery.getReward());
        }

        thingService.add(lotteryInfo.getRid(), rewardList, GameEvent.GOD_EQUIP_LOTTERY_REWARD);

        //增加神装探宝记录
        this.addLotteryInfo(godEquipmentLotteries, lotteryInfo);
    }

    /**
     * 神装控宝扣除
     *
     * @param lotteryInfo
     * @param lotteryType
     */
    private void costGodEquipLottery(GodEquipLotteryInfo lotteryInfo, int lotteryType) {
        //若时使用免费抽机会
        if (lotteryType == 1 && lotteryInfo.getFreeTime() < DateTimeUtil.dayBreak()) {
            lotteryInfo.setFreeTime(DateTimeUtil.currentSecond());
        } else {//扣道具处理
            List<ImmutableThing> cost;
            if (lotteryType == 1) {
                cost = GodEquipConst.godEquipmentLotteryOneItem;
            } else {
                cost = GodEquipConst.godEquipmentLotteryTenItem;
            }
            //检查探宝道具现有数量
            int costItem = GodEquipConst.godEquipmentLotteryOneItem.get(0).getItem_type();
            long itemCount = thingService.getCount(lotteryInfo.getRid(), costItem);
            //若数量不足则用钻石
            if (itemCount < cost.get(0).getItem_num()) {
                if (lotteryType == 1) {
                    cost = GodEquipConst.godEquipmentLotteryOneGem;
                } else {
                    cost = GodEquipConst.godEquipmentLotteryTenGem;
                }
            }
            thingService.cost(lotteryInfo.getRid(), cost, GameEvent.GOD_EQUIP_LOTTERY);
        }
    }

    /**
     * 增加神装探宝记录
     *
     * @param lotteryList
     * @param godEquipLotteryInfo
     */
    private void addLotteryInfo(List<CGodEquipmentLottery> lotteryList, GodEquipLotteryInfo godEquipLotteryInfo) {

        Role role = roleService.getOrThrow(godEquipLotteryInfo.getRid());
        //检查是否有需要添加的公告记录
        List<GodEquipRecord> recordList = new ArrayList<>();
        for (CGodEquipmentLottery config : lotteryList) {
            if (config.getNotice_show() == 1) {
                GodEquipRecord godEquipRecord = new GodEquipRecord();
                godEquipRecord.setItemType(config.getReward().get(0).getItem_type());
                godEquipRecord.setItemNum(config.getReward().get(0).getItem_num());
                godEquipRecord.setName(role.getNick());
                recordList.add(godEquipRecord);
            }
        }

        //添加公告
        if (recordList.size() > 0) {
            godEquipLotteryInfo.getRecords().addAll(recordList);
            while (godEquipLotteryInfo.getRecords().size() > GodEquipConst.godEquipmentLotteryRecordPerson) {
                godEquipLotteryInfo.getRecords().remove(0);
            }

            //增加系统神装探宝记录
            this.addSysLotteryInfo(recordList);
        }
    }

    /**
     * 添加系统神装探宝记录
     *
     * @param recordList
     */
    private void addSysLotteryInfo(List<GodEquipRecord> recordList) {
        //服务器记录
        GodEquipSysInfo godEquipSysInfo = this.selectSysLottery();
        godEquipSysInfo.getRecords().addAll(recordList);
        while (godEquipSysInfo.getRecords().size() > GodEquipConst.godEquipmentLotteryRecordSever) {
            godEquipSysInfo.getRecords().remove(0);
        }
        this.update(godEquipSysInfo);
    }

    /**
     * 昨天未领时补发
     *
     * @param godEquipLotteryInfo
     */
    private void sendPrivilegeRewardMail(GodEquipLotteryInfo godEquipLotteryInfo) {
        if (godEquipLotteryInfo.getPrivilege() == 1) {

            CPromotion010PrivilegeGift cPromotion010PrivilegeGift = promotion010PrivilegeGiftSysCache.getOrThrow(PrivilegeType.GOD_EQUIP.getValue());
            if (godEquipLotteryInfo.getReceiveDay() >= cPromotion010PrivilegeGift.getLimit_day()) {
                return;
            }

            int count = DateTimeUtil.apartDay(godEquipLotteryInfo.getReceiveTime(), DateTimeUtil.currentSecond()) - 1;
            if (count < 1) {
                return;
            }

            count = count + godEquipLotteryInfo.getReceiveDay() > cPromotion010PrivilegeGift.getLimit_day() ?
                    cPromotion010PrivilegeGift.getLimit_day() - godEquipLotteryInfo.getReceiveDay() : count;

            List<ImmutableThing> rewardList = ImmutableThingUtil.multiplyThing(cPromotion010PrivilegeGift.getItem(), count);

            this.sendMail(rewardList, godEquipLotteryInfo.getRid());

            godEquipLotteryInfo.setReceiveDay(godEquipLotteryInfo.getReceiveDay() + count);
            godEquipLotteryInfo.setReceiveTime(godEquipLotteryInfo.getReceiveTime() + TimeConstants.ONE_DAY_SECOND * count);
            this.update(godEquipLotteryInfo);
        }
    }

    /**
     * 到期邮件补发
     *
     * @param godEquipLotteryInfo
     */
    private void sendPrivilegeExpiresMail(GodEquipLotteryInfo godEquipLotteryInfo) {

        CPromotion010PrivilegeGift cPromotion010PrivilegeGift = promotion010PrivilegeGiftSysCache.getOrThrow(PrivilegeType.GOD_EQUIP.getValue());
        if (godEquipLotteryInfo.getReceiveDay() >= cPromotion010PrivilegeGift.getLimit_day()) {
            return;
        }

        int count = cPromotion010PrivilegeGift.getLimit_day() - godEquipLotteryInfo.getReceiveDay();

        List<ImmutableThing> rewardList = ImmutableThingUtil.multiplyThing(cPromotion010PrivilegeGift.getItem(), count);

        this.sendMail(rewardList, godEquipLotteryInfo.getRid());

        godEquipLotteryInfo.setReceiveDay(cPromotion010PrivilegeGift.getLimit_day());

    }

    private void sendMail(List<ImmutableThing> rewardList, long rid) {
        Mail mail = mailService.newMailNoTitle(rid, MailScene.GOD_EQUIP_PRIVILEGE, null, rewardList, GameEvent.GOD_EQUIP_PRIVILEGE_REWARD);
        mailService.insert(mail);
    }


    @Subscribe
    private void listen(BuyPrivilegeEvent event) {
        if (event.getPrivilegeType() == PrivilegeType.GOD_EQUIP) {

            GodEquipGMsg.GResGodEquipPrivilege.Builder builder = GodEquipGMsg.GResGodEquipPrivilege.newBuilder();
            builder.setBuyStatus(1);
            builder.setGetDay(0);
            contextManager.write(event.getRid(), CmdCode._58017, builder.build());

            GodEquipLotteryInfo godEquipLotteryInfo = this.select(event.getRid());
            godEquipLotteryInfo.setPrivilege(1);
            godEquipLotteryInfo.setReceiveDay(0);

            PrivilegeGift privilegeGift = promotion010PrivilegeGiftService.getPrivilegeGift(event.getRid(), PrivilegeType.GOD_EQUIP);
            godEquipLotteryInfo.setReceiveTime(privilegeGift.getBuyTime() - TimeConstants.ONE_DAY_SECOND);

            this.update(godEquipLotteryInfo);
        }
    }

}
