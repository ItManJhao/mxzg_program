/**
 *
 */
package com.ayjs.mxzg.gameserver.module.godequip.handler;

import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.constant.GodEquipConst;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquipLotteryInfo;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquipSysInfo;
import com.ayjs.mxzg.gameserver.module.godequip.service.GodEquipLotteryService;
import com.ayjs.mxzg.gameserver.module.godequip.struct.GodEquipRecord;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.worldLevel.manager.WorldLevelManager;
import com.ayjs.mxzg.protocol.GodEquipGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.protocol.GodEquipGMsg.GReqLotteryGodEquip;
import com.ayjs.mxzg.protocol.GodEquipGMsg.GReqScanGodEquipLottery;
import com.ayjs.mxzg.protocol.GodEquipGMsg.GReqScanGodEquipRecord;
/**
 * @author hyx
 *
 */
@Controller
public class GodEquipLotteryHandler extends ProtocolHandler {

    @Autowired
    private GodEquipLotteryService godEquipLotteryService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private WorldLevelManager worldLevelManager;

    /**
     * 发送神装探宝数据
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._58007)
    public void scanLottery(PlayerContext playerContext, GReqScanGodEquipLottery msg) {
        GodEquipGMsg.GResScanGodEquipLottery.Builder builder = GodEquipGMsg.GResScanGodEquipLottery.newBuilder();

        GodEquipLotteryInfo godEquipLotteryInfo = godEquipLotteryService.select(playerContext.getId());
        builder.setLucky(godEquipLotteryInfo.getLotteryCount());
        builder.setRollNum(godEquipLotteryInfo.getFreeTime() > DateTimeUtil.dayBreak() ? 0 : 1);

        //获取系统的最后两条记录
        GodEquipSysInfo sysLottery = godEquipLotteryService.selectSysLottery();
        int length = sysLottery.getRecords().size();
        for (int i = length - 1; i >= 0; i--) {
            builder.addRecords(builderGodRecord(sysLottery.getRecords().get(i)));
            if (builder.getRecordsList().size() >= 2) {
                break;
            }
        }
        playerContext.write(CmdCode._58007, builder.build());
    }

    /**
     * 发送神装探宝记录
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._58008)
    public void scanLottery(PlayerContext playerContext, GReqScanGodEquipRecord msg) {
        GodEquipGMsg.GResScanGodEquipRecord.Builder builder = GodEquipGMsg.GResScanGodEquipRecord.newBuilder();

        //个人记录
        GodEquipLotteryInfo godEquipLotteryInfo = godEquipLotteryService.select(playerContext.getId());
        godEquipLotteryInfo.getRecords().forEach(godEquipRecord -> {
            builder.addRoleRecords(builderGodRecord(godEquipRecord));
        });

        //服务器记录
        GodEquipSysInfo sysLottery = godEquipLotteryService.selectSysLottery();
        sysLottery.getRecords().forEach(godEquipRecord -> {
            builder.addServerRecords(builderGodRecord(godEquipRecord));
        });

        playerContext.write(CmdCode._58008, builder.buildPartial());
    }

    private GodEquipGMsg.PSGodRecord builderGodRecord(GodEquipRecord godEquipRecord) {
        GodEquipGMsg.PSGodRecord.Builder builder = GodEquipGMsg.PSGodRecord.newBuilder();
        builder.setName(godEquipRecord.getName());
        builder.setItemType(godEquipRecord.getItemType());
        builder.setItemNum(godEquipRecord.getItemNum());
        return builder.build();
    }

    /**
     * 神装探宝
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._58009)
    public void scanLottery(PlayerContext playerContext, GReqLotteryGodEquip msg) {

        Role role = roleService.getOrThrow(playerContext.getId());
        Asserts.isTrue(role.getLevel() >= GodEquipConst.MAIN_LEVEL, ErrorCode.GODEQUIP_LEVEL_LACK.getValue(),
                "角色等级还未满足神装穿戴要求");
        Asserts.isTrue(worldLevelManager.getWorldLevel() >= GodEquipConst.WORLD_LEVEL, ErrorCode.GODEQUIP_WORLD_LACK.getValue(),
                "角色等级还未满足神装穿戴要求");

        Asserts.isTrue(msg.getType() == 1 || msg.getType() == 10, ErrorCode.GODEQUIP_LOTTERY_TYPE.getValue(),
                String.format("不存在此种类型的神装探宝，type:{%s}", msg.getType()));

        GodEquipLotteryInfo godEquipLotteryInfo = godEquipLotteryService.select(playerContext.getId());

        //抽奖处理
        godEquipLotteryService.godEquipLottery(godEquipLotteryInfo, msg.getType());

        //更新神装抽奖数据
        godEquipLotteryService.update(godEquipLotteryInfo);

        //返回数据处理
        GodEquipGMsg.GResLotteryGodEquip.Builder builder = GodEquipGMsg.GResLotteryGodEquip.newBuilder();
        builder.setType(msg.getType());
        playerContext.write(CmdCode._58009, builder.build());
    }
}
