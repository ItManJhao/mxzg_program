//
//  UserSetting.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "UserSetting.h"
#include "../Data/Player.h"

int setting_version = 20140923; // 随便改个数字，就能使之前老玩家的user_setting文件过期

UserSetting::UserSetting() {
	reset();
}

void UserSetting::setUserId(const char* s) {
    setString(user_id, s, MIN(strlen(s), sizeof(user_id) - 1) );
}

void UserSetting::setUpdateUrl(const char* s) {
    setString(update_url, s, MIN(strlen(s), sizeof(update_url) - 1));
}

void UserSetting::setImageUrlMD5(const char* s) {
    setString(image_url_md5, s, sizeof(image_url_md5) - 1);
}

void UserSetting::setString(char* str, const char* s, int size) {
    memcpy(str, s, size);
    str[size] = '\0';
    
//    memset(str, 0, size);
//    int len = (int) strlen(s);
//    if (len > size - 1) {
//        len = size - 1;
//    }
//    memcpy(str, s, len);
}

void UserSetting::reset() {
    ver = setting_version;
    
    music_visible = true;
    sound_visible = true;
    music_percent = 100;
	sound_percent = 100;
	lang = 1;
    
	memset(user_id, 0, sizeof(user_id));
    memset(server_name, '\0', sizeof(server_name));
	memset(update_url, 0, sizeof(update_url));
    
	server_id = 0;
	client_version = 0;
    
    is_turn_on_notification = true;
    
    memset(image_url_md5, 0, sizeof(image_url_md5));
    
    platform_type = -1;

    clan_chat_read_time = 0;
    memset(friends_chat_read_time, 0, sizeof(friends_chat_read_time));
    
    dungeon_visit_level = 0;

    refresh_shop_pvp_time = 0;
    memset(shop_pvp_list, 0, sizeof(shop_pvp_list));
    
    refresh_pub_limit_time = 0;
    pub_limit_count = 0;
    
    refresh_shop_limit_time = 0;
    shop_limit_num = 0;
}

#pragma mark ----------

UserSettingManager::UserSettingManager() {
    setting_path = FileUtils::getInstance()->getWritablePath();
    setting_path.append("setting.mini");
    reload();
    reloadBagRepotPosMap();
}

const char* UserSettingManager::getPath()
{
    return setting_path.c_str();
}

void UserSettingManager::reload() {
    FILE* f = fopen(getPath(), "rb+");
    if (f == NULL) {
        return;
    }
    fread(&user_setting, sizeof(user_setting), 1, f);
    fclose(f);
    
    if (user_setting.ver != setting_version) {
        // 重置
        user_setting.reset();
        save();
    }
}

void UserSettingManager::save() {
    FILE* f = fopen(getPath(), "wb+");
    if (f == NULL) {
        return;
    }
    fwrite(&user_setting, sizeof(user_setting), 1, f);
    fclose(f);
}

UserState* UserSettingManager::getUserState(int64_t rid)
{
    map<int64_t, UserState>::iterator iter = settingMap.find(rid);
    
    if (!settingMap.size() || iter == settingMap.end()) {   // 如果没有数据则加载一次
        reloadStateMap();
    }
    
    iter = settingMap.find(rid);
    if (iter != settingMap.end()) {
        return &(iter->second);
    }
    
    iter = settingMap.find(Player::instance()->role_id);
    return &(iter->second);
}

void UserSettingManager::reloadStateMap()
{
    // 清除数据
    settingMap.clear();
    
    // 配置路径
    string name = getPath();
    name += "UserState";
    
    // 从文件中加载
    FILE* f = fopen(name.c_str(), "rb+");
    if (f != NULL)
    {
        fseek(f, 0L, SEEK_END);//文件指针置于结尾
        int64_t len1 = ftell(f);//获取结尾指针值
        fseek(f, 0L, SEEK_SET);//文件指针至于开头
        int64_t len2 = ftell(f);//获取开头指针值
        
        while ( len2 != len1 ) {
            UserState state;
        
            fread(&state, sizeof(UserState), 1, f);
            
            settingMap.insert(make_pair(state.role_id, state));
            
            len2 = ftell(f);
        }
        
        fclose(f);
    }
    
    // 加一个空的，用作初始状态
    if (settingMap.find(Player::instance()->role_id) == settingMap.end())
    {
        UserState stateZero;
        stateZero.role_id = Player::instance()->role_id;
        strcpy(stateZero.request_soldier, "");
        settingMap.insert(make_pair(stateZero.role_id, stateZero));
    }
}

void UserSettingManager::saveStateMap()
{
    // 保存到文件
    string name = getPath();
    name += "UserState";
    
    FILE* f = fopen(name.c_str(), "wb+");
    if (f != NULL)
    {
        for (map<int64_t, UserState>::iterator iter = settingMap.begin(); iter != settingMap.end(); ++iter)
        {
            fwrite(&(iter->second), sizeof(UserState), 1, f);
        }
        
        fclose(f);
    }
}

void UserSettingManager::reloadBagRepotPosMap()
{
    // 清除数据
    settingMap.clear();
    
    // 配置路径
    string name = getPath();
    name += "BagItemPos";
    
    // 从文件中加载
    FILE* f = fopen(name.c_str(), "rb+");
    if (f != NULL)
    {
        fseek(f, 0L, SEEK_END);//文件指针置于结尾
        int64_t len1 = ftell(f);//获取结尾指针值
        fseek(f, 0L, SEEK_SET);//文件指针至于开头
        int64_t len2 = ftell(f);//获取开头指针值
        
        bag_mode_server_id = (int32_t)fread(&bag_mode_server_id, sizeof(bag_mode_server_id), 1, f);
        len2 = ftell(f);
        bag_mode_role_id = fread(&bag_mode_role_id, sizeof(bag_mode_role_id), 1, f);
        len2 = ftell(f);
        
        while ( len2 != len1 ) {
            BagItemPos pos;
            
            fread(&pos, sizeof(BagItemPos), 1, f);
            
            bag_report_pos_map.insert(make_pair(pos.building_id, pos));
            
            len2 = ftell(f);
        }
        
        fclose(f);
    }
}

void UserSettingManager::saveBagRepotPosMap()
{
    // 保存到文件
    string name = getPath();
    name += "BagItemPos";
    
    FILE* f = fopen(name.c_str(), "wb+");
    if (f != NULL)
    {
        fwrite(&bag_mode_server_id, sizeof(bag_mode_server_id), 1, f);
        fwrite(&bag_mode_role_id, sizeof(bag_mode_role_id), 1, f);
        for (map<int64_t, BagItemPos>::iterator iter = bag_report_pos_map.begin(); iter != bag_report_pos_map.end(); ++iter)
        {
            fwrite(&(iter->second), sizeof(BagItemPos), 1, f);
        }
        
        fclose(f);
    }
}

void UserSettingManager::setUserId(const char* user_id) {
    user_setting.setUserId(user_id);
}

string UserSettingManager::getUserId() {
    return user_setting.user_id;
}

void UserSettingManager::setServerId(int32_t server_id) {
    user_setting.server_id = server_id;
}

int32_t UserSettingManager::getServerId() {
    return user_setting.server_id;
}

void UserSettingManager::clear() {
	CCLOG("UserSettingManager::clear");
//    string path = getPath();
//    FILE* f = fopen(path.c_str(), "wb+");
//    if (f == NULL) {
//        return;
//    }
//    fwrite("", strlen(""), 1, f);
//    fclose(f);
    
	memset(user_setting.user_id, 0, sizeof(user_setting.user_id));
    user_setting.refresh_pub_limit_time = 0;
    user_setting.pub_limit_count = 0;
    
    user_setting.refresh_shop_limit_time = 0;
    user_setting.shop_limit_num = 0;
    save();

    //remove(path.c_str());

    string path_state = getPath();
    path_state.append("UserState");
    FILE* f_state = fopen(path_state.c_str(), "wb+");
    if (f_state == NULL) {
        return;
    }
    fwrite("", strlen(""), 1, f_state);
    fclose(f_state);
    
    string path_bag = getPath();
    path_bag.append("BagItemPos");
    FILE* f_bag = fopen(path_bag.c_str(), "wb+");
    if (f_bag == NULL) {
        return;
    }
    fwrite("", strlen(""), 1, f_bag);
    fclose(f_bag);
}
