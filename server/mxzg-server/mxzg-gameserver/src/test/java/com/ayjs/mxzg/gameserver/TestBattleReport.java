package com.ayjs.mxzg.gameserver;

import cn.hutool.core.util.ZipUtil;
import com.ayjs.mxzg.common.util.FileUtils;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.google.protobuf.InvalidProtocolBufferException;
import lombok.extern.slf4j.Slf4j;

/**
 * 解析二进制战报文件
 */
@Slf4j
public class TestBattleReport {

    public static void main(String[] args) {

        byte[] bytes = FileUtils.getBytes("/Users/tangyangbo/Downloads/20210625160147_1016_ARENA_266.bin");
        if (bytes != null) {
            try {
                BattleGMsg.BattleReport report = BattleGMsg.BattleReport.parseFrom(ZipUtil.unZlib(bytes));

                log.debug(GJsonUtils.toJson(report));
            } catch (InvalidProtocolBufferException e) {
                e.printStackTrace();
            }
        }
    }
}
