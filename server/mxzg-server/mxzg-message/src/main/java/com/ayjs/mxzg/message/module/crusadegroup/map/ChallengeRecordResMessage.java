package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.dto.ChallengeRecord;
import lombok.Value;

import java.util.Collections;
import java.util.List;

/**
 * boss伤害列表
 */
@Value(staticConstructor = "valueOf")
public class ChallengeRecordResMessage implements CrusadeGroupMessage {

    private int territoryId; // 领地id

    private List<ChallengeRecord> records;

    /**
     * 获取记录
     * @return
     */
    public List<ChallengeRecord> getRecords() {
        return this.records == null ? Collections.emptyList() : this.records;
    }
}
