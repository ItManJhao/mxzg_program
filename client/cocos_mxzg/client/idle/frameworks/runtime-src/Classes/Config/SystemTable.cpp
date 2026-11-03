//
//  SystemTable.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "SystemTable.h"
#include "../Common/CSVFile.h"
#include "../Model/UserSetting.h"
#include "../Platform/PlatformInit.h"
#include "../Model/Game.h"

SystemConfig::SystemConfig() {
    
}

#pragma mark -------------

SystemTable::SystemTable() {
    file_name = "system.csv";
}

void SystemTable::reload() {
    CSVFile csv_reader;
    if (!csv_reader.Open(true, file_name.c_str())) {
        if (!csv_reader.OpenLocal(true, StringUtils::format("config/%s", file_name.c_str()).c_str())) {
            return;
        }
    }
    
    while(csv_reader.CSVReadNextRow()) {
        string key;
        SystemConfig cfg;
        csv_reader.CSVReadString("key", key);
        csv_reader.CSVRead("value", cfg.value);
        table[key] = cfg;
//        if (key.compare("online_limit_time") == 0) {
//            csv_reader.CSVRead("value", config.online_limit_time);
//        }
    }
}

SystemConfig* SystemTable::getConfig(const char* key)
{
    auto iter = table.find(key);
    if(iter != table.end()){
        return &iter->second;
    }
    return NULL;
}


#pragma mark -------------

GamePluginTable::GamePluginTable() {
    file_name = "gameplugin.csv";
    memset(data, 0, sizeof(data));
}


void GamePluginTable::reload() {
    memset(data, 0, sizeof(data));
    
    string data_path = "9tmp.txt";
    data_path = FileUtils::getInstance()->getWritablePath() + data_path;
    
    
    FILE* f = fopen(data_path.c_str(), "rb+");
    if (f) {
        fread(data, sizeof(data), 1, f);
        fclose(f);
    }
    
    int first = 0;
    memcpy(&first, data, 2);
    
    if (first <= 0) {
        memset(data, 0, sizeof(data));
        // 读文件不成功，读csv
        CSVFile csv_reader;
        if (csv_reader.Open(true, file_name.c_str())) {
            
            char* offset = data;
            
            while(csv_reader.CSVReadNextRow()) {
                string name;
                csv_reader.CSVReadString("name", name);

                short len = name.length() * 2;
                char* buffer = (char*) malloc(len);
				char* buf_offset = buffer;
                const char* char_arr = name.c_str();

				for (int i = 0; i < name.length(); i++) {
					char cha = char_arr[i];

					char rnd = rand() % 128;
					memcpy(buf_offset, &rnd, 1);
					buf_offset += 1;

					cha = cha ^ rnd;
					//CCLOG("encode %d: %s -> %d", i, &cha, cha);
					memcpy(buf_offset, &cha, 1);
					buf_offset += 1;
				}
                
                memcpy(offset, &len, 2);
                offset += 2;
                memcpy(offset, buffer, len);
                offset += len;

                free(buffer);
            }
            
            FILE* f = fopen(data_path.c_str(), "wb+");
            if (f == NULL) {
                return;
            }
            fwrite(data, sizeof(data), 1, f);
            fclose(f);
            
            // 删除csv文件
            string del = FileUtils::getInstance()->getWritablePath() + file_name;
            remove(del.c_str());
        } else {
            
            // 重新加载游戏、下载配置
            UserSettingManager* sm = UserSettingManager::instance();
            sm->user_setting.client_version = 0;
            sm->save();
            
            PlatformInit::init();
        }
    }
}

vector<string> GamePluginTable::getList() {
    vector<string> list;
    char* offset = data;
    while (1) {
        short len = 0;
        memcpy(&len, offset, 2);
        if (len <= 0) {
            break;
        }
        offset += 2;
        
        char* buffer = (char*) malloc(len);
        memcpy(buffer, offset, len);
        offset += len;

        char* offset = buffer;

        char* char_arr = (char*) malloc(len / 2 + 1);
        memset(char_arr, 0, len / 2 + 1);
		for (int i = 0; i < len; i += 2) {
			char rnd = 0;
			memcpy(&rnd, offset, 1);
			offset += 1;

			char cha;
			memcpy(&cha, offset, 1);
			offset += 1;
			cha = cha ^ rnd;

			//CCLOG("decode %d: %s -> %d", i, &cha, cha);
			char_arr[i / 2] = cha;
		}

        list.push_back(char_arr);
        free(char_arr);
        
        free(buffer);
    }
    
//    for (int i = 0; i < list.size(); i++) {
//        CCLOG("list[%d]: %s", i, list[i].c_str());
//    }
    
    return list;
}
