package com.ayjs.mxzg.config.struct;

import cn.hutool.core.collection.CollUtil;
import com.ayjs.mxzg.common.excel.ConfigNotFoundException;
import com.ayjs.mxzg.config.excel.cache.BuffArtSysCache;
import com.ayjs.mxzg.config.excel.cache.BuffSysCache;
import com.ayjs.mxzg.config.excel.cache.EquipmenttypeSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroSkillSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.ItemSysCache;
import com.ayjs.mxzg.config.excel.cache.RunesTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.excel.entity.CBuffArt;
import com.ayjs.mxzg.config.excel.entity.CEquipmenttype;
import com.ayjs.mxzg.config.excel.entity.CItem;
import com.ayjs.mxzg.config.excel.entity.CRunesType;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 配置检查
 *
 */
@Slf4j
@Component
public class ExcelCheckUtil {

    @Autowired
    private ItemSysCache itemSysCache;
    @Autowired
    private EquipmenttypeSysCache equipmenttypeSysCache;
    @Autowired
    private RunesTypeSysCache runesTypeSysCache;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private BuffSysCache buffSysCache;
    @Autowired
    private BuffArtSysCache buffArtSysCache;
    @Autowired
    private HeroSkillSysCache heroSkillSysCache;


    /**
     * 检查奖励,消耗 物品统一配置是否正确
     * @param list
     * @param idx
     * @param message      打印消息，可以输入对应的文件名
     * @param isCheckNull 是否允许为空
     * @return
     */
    public boolean checkImmutableThing(List<ImmutableThing> list, int idx, String message, boolean isCheckNull) {
        // 检查奖励配置是否正常
        try {
            if (CollUtil.isEmpty(list)) {
                if (isCheckNull) {
                    log.warn("idx:{} ImmutableThing list is null,{}", idx, message);
                }
                return !isCheckNull;
            }
            for (ImmutableThing thing : list) {
                int type = thing.getItem_type();
                CItem cItem = itemSysCache.getOrThrow(type);
                long itemNum = thing.getItem_num();
                if (itemNum <= 0) {
                    log.warn("idx:{} thing number less than 0,{}", idx, message);
                    return false;
                }
            }
        } catch (ConfigNotFoundException e) {
            log.warn("idx:{} ImmutableThing list is error,{}", idx, message);
            throw e;
        }
        return true;
    }

    public boolean checkImmutableThing(List<ImmutableThing> list, int idx, String message) {
        return checkImmutableThing(list, idx, message, true);
    }

    public boolean checkHeroExcel(int heroType){
        itemSysCache.getOrThrow(heroType);
        heroTypeSysCache.getOrThrow(heroType);
        return true;
    }

    public boolean checkAttrExcel(int idx,List<AttributeKind> list){
       for(AttributeKind attributeKind : list){
           AttributeType attributeType = AttributeType.valueOf(attributeKind.getType());
           if(Objects.isNull(attributeType)){
               log.warn("idx:{} attrType is{}",idx,attributeKind.getType());
               return false;
           }
       }
        return true;
    }

    public boolean checkEquipment(int idx,List<EquipInfo> list){
        for(EquipInfo equipInfo : list){
            CItem cItem = itemSysCache.getOrThrow(equipInfo.getEquipId());
            CEquipmenttype cEquipmenttype = equipmenttypeSysCache.getOrThrow(equipInfo.getEquipId());
            if(cEquipmenttype.getPlace() != equipInfo.getPos()){
                log.warn("装备部份不匹配，idx:{} equipId:{}",idx,equipInfo.getEquipId());
                return false;
            }
        }
        return true;
    }

    public boolean checkRune(int idx,List<RunesVo> list){
        for (RunesVo runesVo : list){
            CItem cItem = itemSysCache.getOrThrow(runesVo.getRunesId());
            CRunesType cRunesType = runesTypeSysCache.getByType(runesVo.getRunesId());
            if(Objects.isNull(cRunesType)){
                log.warn("符文不存在，idx:{},equipId:{}",idx,runesVo.getRunesId());
                return false;
            }
        }
        return true;
    }

    public boolean checkBUff(CBuffArt cBuffArt){
        List<Integer> buffList = buffSysCache.getAll().stream().map(CBuff::getIdx).collect(Collectors.toList());
        for(Integer idx : cBuffArt.getBuff_list()){
            if(!buffList.contains(idx)){
                log.warn("idx:{},不存在该类型BUFF:{}",cBuffArt.getIdx(),idx);
            }
        }
        /*for(CHeroSkill heroSkill : heroSkillSysCache.getAll()){
            for(Integer idx :heroSkill.getArt_list()){
                if(!atrList.contains(idx)){
                    log.warn("idx:{},不存在该类型atr:{}",cBuffArt.getIdx(),idx);
                }
            }
        }*/
        return true;
    }
}
