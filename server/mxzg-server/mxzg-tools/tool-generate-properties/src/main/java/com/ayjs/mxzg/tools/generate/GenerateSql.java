package com.ayjs.mxzg.tools.generate;

import cn.hutool.core.util.StrUtil;
import org.apache.commons.lang3.tuple.Pair;

import java.util.ArrayList;
import java.util.List;

public class GenerateSql {

    private final static String POINT = ".";


    public static void main(String[] args) {
        List<Pair<String, String>> sqlMap = initSqlMap();
        List<String> dbList = initDBList();
        sqlMap.forEach(entry -> {
            String table = entry.getKey();
            String baseSql = entry.getValue();
            dbList.forEach(db ->{
                System.out.println(StrUtil.format(baseSql, db + POINT + table));
            });
            System.out.println("");
        });

    }

    public static List<Pair<String, String>> initSqlMap() {
        List<Pair<String, String>> sqlMap = new ArrayList<>();
        // 商城配置改动刷新一遍商城
        sqlMap.add(Pair.of("shop", "DELETE FROM {} ;"));
        // 神装数据修复
        sqlMap.add(Pair.of("god_equip", "update {} set sys_id = sys_id - 2 where sys_id % 10 = 9;"));
        // 勇者试炼
        sqlMap.add(Pair.of("adven_mission", "update {} SET assist_hero='[]',select_assist='[]';"));
        sqlMap.add(Pair.of("adven_mission", "update {} set next_reset_time = next_reset_time - 86400 where next_reset_time > 0 ;"));
        sqlMap.add(Pair.of("adven_mission", "update {} set lv_time = lv_time - 86400 where lv_time > 0 ;"));
        // 阵容数据修复
        sqlMap.add(Pair.of("hero_line_up", "update {} set formation_id = 0;"));
        // 永恒梦境
        sqlMap.add(Pair.of("dreamland", "update {} SET assist_hero ='{\"id\":0,\"heroId\":0,\"pos\":0,\"level\":0,\"star\":0,\"stage\":0,\"status\":0,\"fashionId\":0,\"triggerTimes\":{},\"saveEnergy\":false,\"saveTriggerTimes\":false}',select_hero='{}';"));
        // 跨服天梯
        sqlMap.add(Pair.of("ladder_my_battle", "truncate table {};"));
        sqlMap.add(Pair.of("ladder_superior_battle", "truncate table {};"));
        // 组队竞技场
        sqlMap.add(Pair.of("arena_team_record", "truncate table {};"));
        sqlMap.add(Pair.of("arena_team_record_detail", "truncate table {};"));
        // 工会副本排行
        sqlMap.add(Pair.of("clan", "UPDATE {} set clan_dungeon_damage_list = '[]';"));
        // 庇护所
        sqlMap.add(Pair.of("dungeon_info", "UPDATE {} set time = 0;"));
        // 彩虹神殿记录
        sqlMap.add(Pair.of("rainbow_record", "truncate table {};"));
        sqlMap.add(Pair.of("champion_battle", "truncate table {};"));
        // 冠军赛
        sqlMap.add(Pair.of("champion_competitor", "truncate table {};"));
        sqlMap.add(Pair.of("champion_cross_report", "truncate table {};"));
        sqlMap.add(Pair.of("champion_player", "truncate table {};"));
        sqlMap.add(Pair.of("champion_robot", "truncate table {};"));
        sqlMap.add(Pair.of("champion_system", "truncate table {};"));
        // 战报分享
        sqlMap.add(Pair.of("video_hall", "truncate table {};"));
        sqlMap.add(Pair.of("video_role", "truncate table {};"));
        return sqlMap;
    }

    public static List<String> initDBList() {
        List<String> dataBaseList = new ArrayList<>();
        dataBaseList.add("mxzg_1001_data");
        dataBaseList.add("mxzg_1002_data");
        dataBaseList.add("mxzg_1003_data");
        dataBaseList.add("mxzg_1004_data");
        dataBaseList.add("mxzg_1005_data");
        dataBaseList.add("mxzg_1006_data");
        dataBaseList.add("mxzg_1007_data");
        dataBaseList.add("mxzg_1008_data");
        dataBaseList.add("mxzg_1009_data");
        dataBaseList.add("mxzg_1010_data");
        dataBaseList.add("mxzg_1011_data");
        dataBaseList.add("mxzg_1012_data");
        dataBaseList.add("mxzg_1013_data");
        return dataBaseList;
    }

}
