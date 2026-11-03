package com.ayjs.mxzg.message.cross;

import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.rpc.RemoteMessage;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * 跨服重组消息
 */
@Getter
@AllArgsConstructor
public class CrossRegroupMessage implements RemoteMessage {

    /**
     * 流水号
     */
    private int serialNumber;

    /**
     * 跨服分组列表
     */
    private List<CrossGroup> crossGroups = new ArrayList<>();


    public static CrossRegroupMessage of(int serialNumber, List<CrossGroup> crossGroups) {
        return new CrossRegroupMessage(serialNumber, crossGroups);
    }

    /**
     * 获取分组数
     * @return
     */
    public int getGroupNum(){
        return CollectionUtils.isEmpty(crossGroups) ? 0 : crossGroups.size();
    }

    /**
     * 获取一个非null的分组列表
     * @return
     */
    public List<CrossGroup> getCrossGroups(){
        return crossGroups == null ? Collections.emptyList() : crossGroups;
    }

}
