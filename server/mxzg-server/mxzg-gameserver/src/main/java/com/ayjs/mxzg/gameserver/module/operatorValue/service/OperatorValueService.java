package com.ayjs.mxzg.gameserver.module.operatorValue.service;

import com.ayjs.mxzg.gameserver.module.operatorValue.constant.OperatorType;
import com.ayjs.mxzg.gameserver.module.operatorValue.dao.OperatorValueDao;
import com.ayjs.mxzg.gameserver.module.operatorValue.domain.OperatorValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/14 10:41
 */
@Service
public class OperatorValueService {

    @Autowired
    OperatorValueDao operatorValueDao;

    public int getCount(long rid, int type) {
        OperatorValue operatorValue = operatorValueDao.getOperatorValueByType(rid, type);
        return operatorValue == null ? 0 : operatorValue.getCount();
    }

    /***
     * 加载操作计数实体，没有对象的时候，会创建对象
     * @param rid
     * @param type
     * @return
     */
    public OperatorValue load(long rid, int type) {
        OperatorValue operatorValue = operatorValueDao.getOperatorValueByType(rid, type);
        if (operatorValue == null) {
            operatorValue = new OperatorValue();
            operatorValue.setType(type);
            operatorValue.setRid(rid);
            if (type == OperatorType.ROLE_LEVEL.getType() || type == OperatorType.TOWER_STAGE.getType()) {
                operatorValue.setCount(1);
            }
            operatorValueDao.add(operatorValue);
        }
        return operatorValue;
    }

    /***
     * 增加计数
     * @param rid
     * @param type
     * @param addValue
     * @return
     */
    public int addProcess(long rid, OperatorType type, int addValue) {
        OperatorValue operatorValue = load(rid, type.getType());
        int newValue = operatorValue.addProcess(addValue);
        operatorValueDao.update(operatorValue);
        return newValue;
    }

    /***
     *  设置数量
     * @param rid
     * @param type
     * @param newValue
     * @return
     *          增加值
     */
    public int setProcess(long rid, OperatorType type, int newValue) {
        OperatorValue operatorValue = load(rid, type.getType());
        int addValue = newValue - operatorValue.getCount();
        operatorValue.setCount(newValue);
        operatorValueDao.update(operatorValue);
        return addValue;
    }
}
