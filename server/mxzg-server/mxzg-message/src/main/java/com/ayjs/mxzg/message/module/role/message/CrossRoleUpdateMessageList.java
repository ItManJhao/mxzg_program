package com.ayjs.mxzg.message.module.role.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Value;

import java.util.List;

/**
 * 批量更新
 */
@Value(staticConstructor = "of")
public class CrossRoleUpdateMessageList implements CrossMessage {

    private List<CrossRoleUpdateMessage> list;
}
