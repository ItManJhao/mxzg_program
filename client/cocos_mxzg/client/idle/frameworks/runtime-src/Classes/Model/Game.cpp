//
//  Game.cpp
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#include "Game.h"



#include "../Data/Player.h"
#include "../Data/RoleData.h"

#include "SimpleAudioEngine.h"
#include "../AutoRun/NetManager.h"
#include "../Comp/UIMessageBox.h"
#include "Utils.h"
#include "UserSetting.h"

#include "../Config/LanguageTable.h"

#include "../AppDelegate.h"
#include "../Ctrl/Scene/TownSceneCtr.h"
#include "../Platform/PlatformInit.h"

#include "../AutoRun/CommonRunner.h"
//#include "../Ctrl/Layer/GuideCtr.h"
#include "../Model/LuaManager.h"
#include "../Platform/SocialPlatform.h"

//#include "platform/ios/CCEAGLView-ios.h"


bool Game::is_online = false;
bool Game::is_stop_game = false;
bool Game::is_login = false;
bool Game::is_in_pay = false;
bool Game::is_need_recharge_check = false;
int64_t Game::server_version = 0;
int64_t Game::client_version = 0;
bool Game::config_loaded = false;
int32_t Game::goto_main_scene_time = 0;

string Game::music_playing = "";
Game::Game() {
    push_token = "";
    server_lastest_time = 0;
    client_lastest_time = 0;
    
    latest_touch = 0;
    
    zone = 0;
    
    game_impl = createGameImpl();
}

Game::~Game() {
    CC_SAFE_DELETE(game_impl);
}

int Game::getServerTime() {
    return static_cast<int>(getServerMillisecond() / 1000);
}

// 获取服务端精确时间(毫秒量级)
int64_t Game::getServerMillisecond() {
    return server_lastest_time - client_lastest_time + millisecond();
}

void Game::setServerTime(int64_t server_time) {
    client_lastest_time = millisecond();
    server_lastest_time = server_time;
}

void Game::onInconsistentData() {
    stopTheGame();
    
    LanguageTable* language_config = LanguageTable::instance();
    UIMessageBox::create(language_config->getLanguage(110022),
                         language_config->getLanguage(110021),
                         language_config->getLanguage(110023),
                         CC_CALLBACK_1(Game::reLogin, this))->show();
}

void Game::onOffline() {
    stopTheGame();
    
    LanguageTable* language_config = LanguageTable::instance();
    const char* title = language_config->getLanguage(110011);
    if (strcmp(title, "") == 0) {
//        // TEST
//        return;
        UIMessageBox::create(StringUtils::format("Unable to connect with the server. Check your internet connection and try again, error code : %d", UserSettingManager::instance()->user_setting.server_id).c_str(),
                             "Connection error",
                             "Try again",
                             CC_CALLBACK_1(Game::reLogin, this))->show();
    } else {
        const char* error_code = StringUtils::format("%s%d", language_config->getLanguage(17), UserSettingManager::instance()->user_setting.server_id).c_str();
        UIMessageBox::create(StringUtils::format("%s %s", language_config->getLanguage(110012), error_code).c_str(),
                             title,
                             language_config->getLanguage(110013),
                             CC_CALLBACK_1(Game::reLogin, this))->show();
    }
}

void Game::reLogin(int button_index) {
    CocosDenshion::SimpleAudioEngine::getInstance()->stopBackgroundMusic(true);
    CocosDenshion::SimpleAudioEngine::getInstance()->stopAllEffects();
//    if (button_index == 0) {
//        LoginCtr::instance()->autoLogin();
//    } else {
//        ChooseServerCtr::instance()->open();
//    }
    
    stopTheGame();
    is_login = false;
    
    CSJson::Value json;
    json["status"] = 10;
    auto is_change = LuaManager::instance()->executeGlobalBoolFunctionReturn("changeToLogoSceneCtr", json);
    if (is_change) {
//        LogoSceneCtr::instance()->enter();
    }
}

void Game::setResLogin() {
    NetManager::instance()->last_send_login = 0;
}

string Game::getDeviceString() {
    return game_impl->getDeviceString();
}

float Game::getReverseScale() {
    return 0.5;
//    return 1;
//    return Director::getInstance()->getOpenGLView()->getFrameSize().height >= 1080 ? 0.5 : 1.0;
}

cocos2d::Rect Game::getEGLViewRect() {
    GLView* gl_view = Director::getInstance()->getOpenGLView();
    cocos2d::Rect rect = cocos2d::Rect::ZERO;
	rect.size = gl_view->getFrameSize();
    rect.size.width /= gl_view->getScaleX();
    rect.size.height /= gl_view->getScaleY();
    return game_impl->getEGLViewRect();
}

float Game::getNotchHeight() {
    return game_impl->getNotchHeight();
}

DeviceOrientation Game::getDeviceOrientation() {
    return (DeviceOrientation)game_impl->getDeviceOrientation();
}

void Game::orientationChange(int32_t orientation) {
    
//    auto guide_ctr = GuideCtr::instance();
//    if (guide_ctr) {
//        auto guide_data = guide_ctr->getGuideDataByStep(guide_ctr->getStepNum());
//        if (guide_data && guide_data->type != "WaitMission") {
//            return;
//        }
//    }
    
    auto eventDispatcher = cocos2d::Director::getInstance()->getEventDispatcher();
    cocos2d::EventCustom event(DEVICE_ORIENTATION_CHANGE);
    event.setUserData(&orientation);
    eventDispatcher->dispatchEvent(&event);
}


void Game::playBackgroundMusic(const char *path) {
    if (music_playing.compare(path) != 0) {
        music_playing = path;
        
        auto audio = CocosDenshion::SimpleAudioEngine::getInstance();
        audio->stopBackgroundMusic();
        audio->playBackgroundMusic(path, true);
    }
}

void Game::setBackgroundMusicVisible(bool visible) {
    UserSettingManager* setting_manager = UserSettingManager::instance();
    setting_manager->user_setting.music_visible = visible;
    setting_manager->save();
    
    if (visible) {
        CocosDenshion::SimpleAudioEngine::getInstance()->setBackgroundMusicVolume(setting_manager->user_setting.music_percent / 100.0f);
    } else {
        CocosDenshion::SimpleAudioEngine::getInstance()->setBackgroundMusicVolume(0);
    }
}

void Game::setBackgroundMusicVolume(int32_t  volume) {
    UserSettingManager* setting_manager = UserSettingManager::instance();
    setting_manager->user_setting.music_visible = true;
    setting_manager->user_setting.music_percent = volume;
    setting_manager->save();
    if (volume <= 5) {
        CocosDenshion::SimpleAudioEngine::getInstance()->setBackgroundMusicVolume(0.0001f); CocosDenshion::SimpleAudioEngine::getInstance()->setBackgroundMusicVolume(0);
    } else if (volume >= 95) {
        CocosDenshion::SimpleAudioEngine::getInstance()->setBackgroundMusicVolume(0.9999f); CocosDenshion::SimpleAudioEngine::getInstance()->setBackgroundMusicVolume(1);
    } else {
        CocosDenshion::SimpleAudioEngine::getInstance()->setBackgroundMusicVolume(volume / 100.0f);
    }
}

bool Game::getBackgroundMusicVisible() {
    return UserSettingManager::instance()->user_setting.music_visible;
}

int32_t Game::getBackgroundMusicVolume() {
    return UserSettingManager::instance()->user_setting.music_percent;
}

void Game::stopBackgroundMusic() {
    music_playing = "";
    CocosDenshion::SimpleAudioEngine::getInstance()->stopBackgroundMusic(true);
}

void Game::preloadEffect(const char *path) {
    auto file = FileUtils::getInstance()->fullPathForFilename(path);
    CocosDenshion::SimpleAudioEngine::getInstance()->preloadEffect(file.c_str());
}

void Game::preloadBackgroundMusic(const char *path) {
    auto file = FileUtils::getInstance()->fullPathForFilename(path);
    CocosDenshion::SimpleAudioEngine::getInstance()->preloadBackgroundMusic(file.c_str());
}


void Game::playEffect(const char *path, bool frequently) {
    int64_t now = millisecond();
    map<string, int64_t>::iterator iter = Game::instance()->play_times.find(path);
    if (!frequently && iter != Game::instance()->play_times.end()) {
        if (now - iter->second < 60/*100*/) {
            return;
        }
    }
    Game::instance()->play_times[path] = now;
    CocosDenshion::SimpleAudioEngine::getInstance()->playEffect(path, false);
}

void Game::setEffectsVisible(bool visible) {
    if (visible) {
        setEffectsVolume(100);
//        CocosDenshion::SimpleAudioEngine::getInstance()->setEffectsVolume(setting_manager->user_setting.sound_percent / 100.0f);
    } else {
        setEffectsVolume(0);
//        CocosDenshion::SimpleAudioEngine::getInstance()->setEffectsVolume(0);
    }
    
    UserSettingManager* setting_manager = UserSettingManager::instance();
    setting_manager->user_setting.sound_visible = visible;
    setting_manager->save();
}

void Game::setEffectsVolume(int32_t volume) {
    UserSettingManager* setting_manager = UserSettingManager::instance();
    setting_manager->user_setting.sound_visible = true;
    setting_manager->user_setting.sound_percent = volume;
    setting_manager->save();
    if (volume <= 5) {
        CocosDenshion::SimpleAudioEngine::getInstance()->setEffectsVolume(0.0001f); CocosDenshion::SimpleAudioEngine::getInstance()->setEffectsVolume(0);
    } else if (volume >= 95) {
        CocosDenshion::SimpleAudioEngine::getInstance()->setEffectsVolume(0.9999f); CocosDenshion::SimpleAudioEngine::getInstance()->setEffectsVolume(1);
    } else {
        CocosDenshion::SimpleAudioEngine::getInstance()->setEffectsVolume(volume / 100.0f);
    }
}

bool Game::getEffectsVisible() {
    return UserSettingManager::instance()->user_setting.sound_visible;
}

int32_t Game::getEffectsVolume() {
    return UserSettingManager::instance()->user_setting.sound_percent;
}

bool Game::isKeyBoardShown() {
//    auto glview = cocos2d::Director::getInstance()->getOpenGLView();
//    CCEAGLView* egl_view = (CCEAGLView*)glview->getEAGLView();
//    
//    return egl_view->isKeyboardShown();
    return false;
}

void Game::shutDownKeyBoard() {
//    auto glview = cocos2d::Director::getInstance()->getOpenGLView();
//    CCEGLView* egl_view = (CCEAGLView*)glview->getEAGLView();
//    
//    if (egl_view->isKeyboardShown()) {
//        egl_view->findAndResignFirstResponder();
//    }
}

int64_t Game::millisecond() {
    struct timeval now;
    gettimeofday(&now, nullptr);
    return (int64_t)now.tv_sec * 1000 + (int64_t)now.tv_usec / 1000;
}

int Game::second() {
    struct timeval now;
    gettimeofday(&now, NULL);
    return (int)now.tv_sec;
}

int64_t Game::makeId() {
    struct timeval now;
    gettimeofday(&now, NULL);
    int64_t t = (int64_t)now.tv_sec * 100 + (int64_t)now.tv_usec;
    t = t % 100000000000000l;
    t = t * 100 + rand() % 100;
    return t;
}

string Game::makeLuaId() {
    auto str_id = StringUtils::format("%lld", Game::makeId());
    return str_id;
}

void Game::downloadApp() {
	UserSettingManager* us_manager = UserSettingManager::instance();
    game_impl->openUrl(us_manager->user_setting.update_url);
}

void Game::openURL(const char* url) {
    game_impl->openUrl(url);
}

/*string Game::macAddress() {
    // NSLog(@"%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]);
    
	int mib[6];
	size_t len;
	char *buf;
	unsigned char* ptr;
	struct if_msghdr* ifm;
	struct sockaddr_dl* sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		printf("Error: if_nametoindex error\n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 1\n");
		return NULL;
	}
	
	if ((buf = (char*)malloc(len)) == NULL) {
		printf("Could not allocate memory. error!\n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 2\n");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
    
    char tmp[18] = {0};
    sprintf(tmp, "%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5));
    // sprintf(tmp, "%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5));
    string address = tmp;
    transform(address.begin(), address.end(), address.begin(), ::toupper);
    
	free(buf);
    
	return address;
}*/

string Game::deviceUUID() {
//     // TEST
//     return updateDeviceUUID();
    return game_impl->deviceUUID();
}

string Game::updateDeviceUUID() {
    return game_impl->updateDeviceUUID();
}

void Game::updatePushId() {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    string tmp = getBundleId();
    vector<string> result;
    StringUtil::splitStringIntoVector(result, SPLIT_CHAR, tmp);
    int result_size = (int)result.size();
    if (result_size > 0) {
        push_id = result[result_size - 1];
    }
#endif
}

string Game::getCurrentLanguageCodeFull()
{
    return game_impl->getCurrentLanguageCodeFull(); 
}



string Game::getVersion() {
    return game_impl->getVersion() /*+ "." + SVN_VERSION*/;
}

string Game::getBundleId() {
    return game_impl->getBundleId();
}


void Game::setClipboard(string str) {
    game_impl->setClipboard(str); 
}


void Game::checkNetwork(float delay) {
    t_int64 now = millisecond();
    
    // 判断是否长时间没操作
//    if (now - latest_touch > 450000) {
//        stopTheGame();
//        
//        LanguageTable* config = LanguageTable::instance();
//        UIMessageBox::create(config->getLanguage(900027),
//                             config->getLanguage(900026),
//                             config->getLanguage(900028),
//                             CC_CALLBACK_1(Game::reLogin, this))->show();
//        return;
//    }
//#if 0
//    // 判断是否登陆过期
//    if (loginExpired()) {
//        stopTheGame();
//
//        LanguageTable* language = LanguageTable::instance();
//        UIMessageBox::create(language->getLanguage(19),
//                             language->getLanguage(18),
//                             language->getLanguage(900028),
//                             CC_CALLBACK_1(Game::reLogin, this))->show();
//        return;
//    }
//#endif
    // 判断是否长时间没收到心跳包
    if (now - client_lastest_time > 40000 && !Game::is_in_pay) {
        stopCheckNetwork();
        NetManager::instance()->close();
    } else if (now - client_lastest_time >= 20000) {
        // 30秒发一次心跳包
//        ReqHeartbeat req;
//        NetManager::instance()->send(&req, sizeof(req));
        // 需要把上面的请求屏蔽
        LuaManager::instance()->executeGlobalAutoFunction("sendReqHeartbeat", [&](LuaStack * ls) {
            return 0;
        });
    }
}

void Game::startCheckNetwork() {
    stopCheckNetwork();
    
    latest_touch = millisecond();
    
    Director::getInstance()->getScheduler()->schedule(schedule_selector(Game::checkNetwork), this, 5, CC_REPEAT_FOREVER, 5, false);
    
    CommonRunner::instance()->start();
    
//    Director::getInstance()->getTouchDispatcher()->addTargetedDelegate(Game::instance(), -4, false);
}

void Game::stopCheckNetwork() {
    Director::getInstance()->getScheduler()->unschedule(schedule_selector(Game::checkNetwork), this);
    
    CommonRunner::instance()->stop();
    
//    Director::getInstance()->getTouchDispatcher()->removeDelegate(this);
}

void Game::stopTheGame() {
    stopCheckNetwork();
    
    is_stop_game = true;
    
//    Director::getInstance()->getTouchDispatcher()->removeAllDelegates(); // 移除全部点击事件处理
    
    Player::instance()->release();
    RoleData::instance()->release();
    
    // 停止socket网络管理
    NetManager::instance()->stop();
    NetManager::instance()->close();
}

void Game::confirmDevice() {
	device = DEVICE_INVALID;

    cocos2d::Size frame_size = Director::getInstance()->getOpenGLView()->getFrameSize();

	vector< pair<cocos2d::Size, DeviceType> > size_to_device;
	size_to_device.push_back(make_pair(cocos2d::Size(2048, 1536), DEVICE_IPAD_HD));
	size_to_device.push_back(make_pair(cocos2d::Size(1024, 768), DEVICE_IPAD));
	size_to_device.push_back(make_pair(cocos2d::Size(480, 320), DEVICE_IPHONE_3));
	size_to_device.push_back(make_pair(cocos2d::Size(960, 640), DEVICE_IPHONE_4));
    size_to_device.push_back(make_pair(cocos2d::Size(1136, 640), DEVICE_IPHONE_5));
    size_to_device.push_back(make_pair(cocos2d::Size(1334, 750), DEVICE_IPHONE_6));
    size_to_device.push_back(make_pair(cocos2d::Size(2208, 1242), DEVICE_IPHONE_6_PLUS));
	size_to_device.push_back(make_pair(cocos2d::Size(800, 480), DEVICE_800_480));
	size_to_device.push_back(make_pair(cocos2d::Size(854, 480), DEVICE_854_480));
	size_to_device.push_back(make_pair(cocos2d::Size(960, 540), DEVICE_960_540));
	size_to_device.push_back(make_pair(cocos2d::Size(1280, 720), DEVICE_1280_720));
	size_to_device.push_back(make_pair(cocos2d::Size(1280, 768), DEVICE_1280_768));
	size_to_device.push_back(make_pair(cocos2d::Size(1280, 800), DEVICE_1280_800));
	size_to_device.push_back(make_pair(cocos2d::Size(1800, 1080), DEVICE_1800_1080));
	size_to_device.push_back(make_pair(cocos2d::Size(1920, 1080), DEVICE_1920_1080));
	size_to_device.push_back(make_pair(cocos2d::Size(1920, 1152), DEVICE_1920_1152));
	size_to_device.push_back(make_pair(cocos2d::Size(1920, 1200), DEVICE_1920_1200));
	size_to_device.push_back(make_pair(cocos2d::Size(2560, 1440), DEVICE_2560_1440));
	size_to_device.push_back(make_pair(cocos2d::Size(2560, 1600), DEVICE_2560_1600));
    
    stable_sort(size_to_device.begin(), size_to_device.end(), Game::widthAndHeightCompare);
    
    device = size_to_device[0].second;
    
    d_wth = D_WTH_167;
    float wth = roundf(100 * size_to_device[0].first.height / size_to_device[0].first.width);
    if (wth == 133) {
        d_wth = D_WTH_133;
    } else if (wth == 150) {
        d_wth = D_WTH_150;
    } else if (wth == 178) {
        d_wth = D_WTH_178;
    } else if (wth == 167) {
        d_wth = D_WTH_167;
    } else if (wth == 160) {
        d_wth = D_WTH_160;
    }
}

bool Game::widthAndHeightCompare(pair<cocos2d::Size, DeviceType> t1, pair<cocos2d::Size, DeviceType> t2) {
	cocos2d::Size frame_size = Director::getInstance()->getOpenGLView()->getFrameSize();
    float wth_frame = roundf(100 * frame_size.width / frame_size.height) / 100; // 当前宽高比
    
    float wth_define1 = roundf(100 * t1.first.width / t1.first.height) / 100; // 设定可选的宽高比
    float wth_define2 = roundf(100 * t2.first.width / t2.first.height) / 100; // 设定可选的宽高比
    
    float tmp1 = abs(wth_define1 - wth_frame);
    float tmp2 = abs(wth_define2 - wth_frame);
    
    if (tmp1 == tmp2) {
        // 宽高比差值一样，宽高相对当前值比较接近的排在前面
        float a1 = abs(t1.first.width - frame_size.width);
        float a2 = abs(t1.first.height - frame_size.height);
        
        float b1 = abs(t2.first.width - frame_size.width);
        float b2 = abs(t2.first.height - frame_size.height);
        
        return a1 + a2 < b1 + b2;
    } else {
        // 宽高比差值小的排前面
        return tmp1 < tmp2;
    }
}

int Game::getNetworkState() {
	return game_impl->getNetworkState();
}

void Game::showExitTheGame() {
	stopTheGame();

    LanguageTable* language_config = LanguageTable::instance();

    string title = language_config->getLanguage(7001136);
    if (title.compare("") == 0) {
    	title = "Plug-ins Detection";
    }

    string content = language_config->getLanguage(7001137);
	if (content.compare("") == 0) {
		content = "System detects that you are using plug-ins. Game will exit in %d seconds.";
	}

	string btn = language_config->getLanguage(7001138);
	if (btn.compare("") == 0) {
		btn = "Exit Game";
	}

	UIMessageBox::create(StringUtils::format(content.c_str(), 5).c_str(),
						 title.c_str(),
						 btn.c_str(),
						 ccMessageCallback(Game::exitTheGameNoParam))->show();

	Director::getInstance()->getScheduler()->schedule(schedule_selector(Game::exitTheGame), this, 0, 0, 5, false);

}

void Game::exitTheGame(float delay) {
    exitTheGameNoParam();
}

void Game::exitTheGameNoParam(int button_index) {
    Director::getInstance()->getScheduler()->unschedule(schedule_selector(Game::exitTheGame), Game::instance());
    Game::instance()->stopTheGame();
    
    Game::instance()->game_impl->exitTheGame();
}

void Game::updateEncodeKey() {
//    unsigned char tmp_key[] = RES_ENCODE_KEY;
//
//    memset(encode_key, 0, sizeof(encode_key));
//    memcpy(encode_key, tmp_key, sizeof(tmp_key));
//    CCLOG("encode key:%s", encode_key);
//
//    for (int i = 0; i < 32; i++) {
//        int rand_1 = rand() % 16;
//        int rand_2 = rand() % 16 + 16;
//
//        unsigned char tmp = encode_key[rand_1];
//        encode_key[rand_1] = encode_key[rand_2];
//        encode_key[rand_2] = tmp;
//    }
//
//    CCLOG("update key:%s", encode_key);
}

unsigned char* Game::getEncodeKey() {
//    CCLOG("get key:%s", encode_key);
    return encode_key;
}

string Game::getDeviceLanguage() {
    return game_impl->getDeviceString();
}

string Game::getDeviceToken() {
//    return push_token;
//    return game_impl->getDeviceToken();
    return SocialPlatform::instance()->getDeviceToken();
}

void Game::updateXingeToken(string token)
{
    this->push_token = token;
    
    CSJson::Value json;
    json["token"] = this->push_token;
    LuaManager::instance()->executeGlobalBoolFunctionReturn("updateXingeToken", json);
}


void Game::sendLog(const char* content) {
//    PlatformApi* api = PlatformApi::create();
//    
//    map<string, string> params;
//    params["action"] = "game.clientLog";
//    params["log"] = content;
//    
//    api->sendGet(params);
}

bool Game::isInVisible(Node* node)
{
    // scene是没有parent的
    if (!node) {
        return true;
    }
    
    auto visible = node->isVisible();
    if (!visible) {
        return false;
    }
    
    auto parent = node->getParent();
    if (parent && !parent->isVisible()) {
        return false;
    }
    
    return isInVisible(parent);
}



