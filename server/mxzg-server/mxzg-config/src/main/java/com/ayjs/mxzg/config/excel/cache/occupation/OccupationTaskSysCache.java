package com.ayjs.mxzg.config.excel.cache.occupation;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.occupation.COccupationTask;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class OccupationTaskSysCache extends BaseExcelCache<COccupationTask> {

    private Map<Integer, List<COccupationTask>> occupationTemplateMap_ocId;

    //key:taskType (TargetType type)  value:任务集合
    private Map<Integer, List<COccupationTask>> occupationTemplateMap_taskType;

    @Override
    public String getFileName() {
        return "crusadegroupoccupationtask";
    }

    @Override
    protected void loadAfterReady() {
        this.occupationTemplateMap_ocId = this.fillListMap(COccupationTask::getOc_id);
        Map<Integer, List<COccupationTask>> temp = new HashMap<>();
        for (COccupationTask template : this.getAll()) {
            int taskType = template.getTask().getType().getValue();
            List<COccupationTask> list = temp.get(taskType);
            if (list == null) {
                list = new ArrayList<>();
                temp.put(taskType, list);
            }
            list.add(template);
        }
        this.occupationTemplateMap_taskType = temp;
    }


    /**
     * 根据职级id获取职级任务模板
     *
     * @param ocId
     * @return
     */
    public List<COccupationTask> getCOccupationTaskTemplate_ocId(int ocId) {
        if (!occupationTemplateMap_ocId.containsKey(ocId)) {
            return null;
        }
        return new ArrayList<>(occupationTemplateMap_ocId.get(ocId));
    }

    /**
     * 根据任务类型获取任务模板集合
     *
     * @param taskType
     * @return
     */
    public List<COccupationTask> getCOccupationTaskTemplate_taskType(int taskType) {
        if (!occupationTemplateMap_taskType.containsKey(taskType)) {
            return null;
        }
        return new ArrayList<>(occupationTemplateMap_taskType.get(taskType));
    }

//    /**
//     * 根据职级id和任务类型获取职级任务模板
//     *
//     * @param ocId
//     * @param type
//     * @return
//     */
//    public List<COccupationTaskTemplate> getCOccupationTaskTemplate_ocId(int ocId, TargetType type) {
//        if (!occupationTemplateMap_ocId.containsKey(ocId)) {
//            return null;
//        }
//        List<COccupationTaskTemplate> list = occupationTemplateMap_ocId.get(ocId);
//        List<COccupationTaskTemplate> listRe = new ArrayList<>();
//        for (COccupationTaskTemplate template : list) {
//            if (template.getTask().getType() == type) {
//                listRe.add(template);
//            }
//        }
//        return listRe;
//    }
}
