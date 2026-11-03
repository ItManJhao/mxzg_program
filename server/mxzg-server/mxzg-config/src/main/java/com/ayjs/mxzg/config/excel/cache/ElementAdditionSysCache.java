/**
 *
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CElementAddition;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;


/**
 * @author YY
 *
 */
@Component
public class ElementAdditionSysCache extends BaseExcelCache<CElementAddition> {

    private Multimap<Integer, CElementAddition> typeMapping = ArrayListMultimap.create();

    @Override
    public String getFileName() {
        return "elementaddition";
    }

    /**
     * 根据当前阵容获取激活的属性
     * @param currentTeam
     * @return
     */
    public List<CElementAddition> getElementAddition(List<Integer> currentTeam) {
        List<CElementAddition> additions = new ArrayList<>();
        Set<Integer> types = this.typeMapping.keySet();
        for (Integer type : types) {
            Collection<CElementAddition> typeAdditions = this.typeMapping.get(type);
            CElementAddition typeAdition = null;
            for (CElementAddition addition : typeAdditions) {
                Set<Integer> elementTypes = addition.getElementMap().keySet();
                boolean reach = true;
                for (int tp : elementTypes) {
                    int size = addition.getElementMap().get(tp).size();
                    int currentSize = (int) currentTeam.stream().filter(t -> t == tp).count();
                    if (currentSize < size) {
                        reach = false;
                        break;
                    }
                }
                if (reach) {
                    typeAdition = addition;
                }
            }
            if (typeAdition != null) {
                additions.add(typeAdition);
            }
        }

        return additions;
    }

    @Override
    protected void loadAfterReady() {
        List<CElementAddition> additions = getAll();
        Multimap<Integer, CElementAddition> typeMapping_ = ArrayListMultimap.create();
        for (CElementAddition addition : additions) {
            typeMapping_.put(addition.getType(), addition);
            Multimap<Integer, Integer> multimap = ArrayListMultimap.create();
            addition.getElements().forEach(element -> multimap.put(element, 0));
            addition.getElementMap().putAll(multimap);
        }
        typeMapping = typeMapping_;
    }

}
