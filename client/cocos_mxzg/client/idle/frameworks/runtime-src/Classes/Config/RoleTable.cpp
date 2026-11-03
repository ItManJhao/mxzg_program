//
//  MainLevelTable.cpp
//  AVT
//
//  Created by windy on 17/10/14.
//
//

#include "RoleTable.h"
#include "../Common/CSVFile.h"


MainLevelTable::MainLevelTable()
{
    file_name = "mainlevel.csv";
}

void MainLevelTable::reload()
{
    table.clear();
    
    CSVFile csv_reader;
    if (!csv_reader.Open(true, file_name.c_str()))
    {
        if (!csv_reader.OpenLocal(true, StringUtils::format("config/%s", file_name.c_str()).c_str())) {
            return;
        }
    }
    
    while (csv_reader.CSVReadNextRow()) {
        MainLevelConfig obj;
        
        csv_reader.CSVRead("level", obj.level);
        csv_reader.CSVRead("exp", obj.exp);
        table[obj.level] = obj;
    }
}

MainLevelConfig* MainLevelTable::getConfig(int16_t level)
{
    map<int16_t,MainLevelConfig >::iterator iter = table.find(level);
    if (iter == table.end()) {
        return NULL;
    }
    return &iter->second;
}

int16_t MainLevelTable::getMaxLevel()
{
    return (int16_t)table.size();
}
