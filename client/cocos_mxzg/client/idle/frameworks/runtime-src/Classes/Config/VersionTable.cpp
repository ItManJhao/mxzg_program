//
//  VersionTable.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "VersionTable.h"
#include "../AutoRun/NetManager.h" 
#include "../Common/CSVFile.h"
#include "../Model/UserSetting.h"

VersionConfig::VersionConfig() {
	version = 0;
    download_urls = "";
	config_type = "";
	lang = 0;
}

#pragma mark -------------

VersionTable::VersionTable() {
    file_name = "version.csv";
}

void VersionTable::reload() {
    UserSettingManager* usm = UserSettingManager::instance();
    if (usm->user_setting.platform_type == -1) {
        CCLOG("VersionTable::reload: unset platform_type...");
        return;
    }
    
    CSVFile csv_reader;
    if (!csv_reader.Open(true, file_name.c_str())) {
        if (!csv_reader.OpenLocal(true, StringUtils::format("config/%s", file_name.c_str()).c_str())) {
            return;
        }
    }
    
    bool done = false;
    int i = -1;
    while (csv_reader.CSVReadNextRow()) {
        ++i;
        
    	if (i != usm->user_setting.platform_type) {
    		continue;
    	}
        
        csv_reader.CSVRead("version", config.version);
        csv_reader.CSVReadString("download_urls", config.download_urls);
        csv_reader.CSVReadString("config_type", config.config_type);
        csv_reader.CSVRead("lang", config.lang);
        csv_reader.CSVRead("run_guide", config.run_guide);

        string tmp;
        csv_reader.CSVReadString("platform_urls", tmp);
        
        config.platform_urls.clear();
        char* h = strtok((char*)tmp.c_str(), "|");
        config.platform_urls.push_back(h);
        while (1) {
            char* str_p = strtok(NULL, "|");
            if (!str_p || strcmp(str_p, "") == 0) {
                break;
            }
            config.platform_urls.push_back(str_p);
        }
        
        done = true;
        
        break;
    }
    
    if (!done) {
    	string s;
    	s.append("VersionConfigTable::reload: load ");
    	s.append(file_name);
    	s.append(" failed...");
    	CCLOG("reload failure:%s", s.c_str());
    }
}
