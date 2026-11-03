/****************************************************************************
 Copyright (c) 2017-2018 Xiamen Yaji Software Co., Ltd.
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#include "AppDelegate.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "cocos2d.h"
#include "scripting/lua-bindings/manual/lua_module_register.h"


// #define USE_AUDIO_ENGINE 1
#define USE_SIMPLE_AUDIO_ENGINE 1


#if USE_AUDIO_ENGINE && USE_SIMPLE_AUDIO_ENGINE
#error "Don't use AudioEngine and SimpleAudioEngine at the same time. Please just select one in your game!"
#endif

#if USE_AUDIO_ENGINE
#include "audio/include/AudioEngine.h"
using namespace cocos2d::experimental;
#elif USE_SIMPLE_AUDIO_ENGINE
#include "audio/include/SimpleAudioEngine.h"
using namespace CocosDenshion;
#endif


#include "Model/Game.h"
#include "Model/UserSetting.h"
#include "Platform/PlatformInit.h"
#include "Platform/SocialPlatform.h"

#include "Config/VersionTable.h"

#include "Model/LuaManager.h"
#include "LuaManual/LuaManual.h"

#include "Model/ResManager.h"
#include "Common/CommonDefine.h"


#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    #ifndef FEIFAN_SDK
        #include "bugly/CrashReport.h"
        #include "bugly/lua/BuglyLuaAgent.h"
    #endif
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS) 
    #include "CrashReport.h"
    #include "BuglyLuaAgent.h"
#endif

// TEST
#include "Net/Protocol/ProtocolResponse.h"
#include "Model/ByteArray.h"
#include "Model/Maths.h"


#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    #include "LuaManual/pb-android.c"
#else
    #include "LuaManual/pb-ios.mm"
#endif



#if (CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
#include "AutomationManager.h"
#endif



#define PACKAGE_RES_VERSION "43"

USING_NS_CC;
using namespace std;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
#if USE_AUDIO_ENGINE
    AudioEngine::end();
#elif USE_SIMPLE_AUDIO_ENGINE
    SimpleAudioEngine::end();
#endif

#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
    // NOTE:Please don't remove this call if you want to debug with Cocos Code IDE
    RuntimeEngine::getInstance()->end();
#endif

}

// if you want a different context, modify the value of glContextAttrs
// it will affect all platforms
void AppDelegate::initGLContextAttrs()
{
    // set OpenGL context attributes: red,green,blue,alpha,depth,stencil,multisamplesCount
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};
    
    GLView::setGLContextAttrs(glContextAttrs);
}

// if you want to use the package manager to install more packages, 
// don't modify or remove this function
static int register_all_packages()
{
    return 0; //flag for packages manager
}

static int lua_module_manual_register(lua_State* L)
{
    register_all_cpp_manual(L);
    return 0;
}

bool AppDelegate::applicationDidFinishLaunching()
{
    

//    Texture2D::setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA4444);
    // set default FPS
    Director::getInstance()->setAnimationInterval(1.0 / 60.0f);
    Director::getInstance()->setClearColor(Color4F(0, 0, 0, 0));
    
    // register lua module
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);

//  Init the Bugly
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    #ifndef FEIFAN_SDK
        CrashReport::initCrashReport("1f9982182c", false);
        BuglyLuaAgent::registerLuaExceptionHandler(engine);
    #endif
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    CrashReport::initCrashReport("af993c42ae", false);
    BuglyLuaAgent::registerLuaExceptionHandler(engine);
#endif

    lua_State* L = engine->getLuaStack()->getLuaState();
    lua_module_register(L);
    lua_module_manual_register(L);
    register_all_packages();
    luaopen_pb(L);

    // 避免在汇编中能直接搜索到秘钥
    srand((int) time(NULL));
    const char* k = "1a4c5d4b5efabc19a80a8b5c2e4f3a6b7d8e0f1b4c5a6c2ffdd6b9b3d1c5aa7c77b";
    string key = "";
    string sign = "";
    string res_sign = "";

    key = key + k[4] + k[3] + k[6] + k[2] + k[1] + k[10] + k[11] + k[15] + k[17] + k[13] + k[20];
    sign = sign + k[3] + k[15] + k[14] + k[7] + k[4] + k[9] + k[23] + k[25] + k[1] + k[7] + k[8];
    res_sign = res_sign + k[9] + k[2] + k[7] + k[7] + k[18] + k[16] + k[12] + k[4] + k[9] + k[12] + k[5];

    //log("key = %s, sign = %s", key.c_str(), sign.c_str());
    LuaStack* stack = engine->getLuaStack();
    int32_t rand_num = rand() % 10;
    for (int i = 0; i < 20 + rand_num; i++)
    {
        // 避免在setXXTEAKeyAndSign处可以直接获得秘钥
        stack->setXXTEAKeyAndSign("LuaKey1998", strlen("LuaKey1998"), "LuaSign1998", strlen("LuaSign1998"));
    }
    stack->setXXTEAKeyAndSign(key.c_str(), key.length(), sign.c_str(), sign.length());
    auto res_manager = ResManager::instance();
    res_manager->setDecodeKey(key, res_sign);
    res_manager->initMap();

    auto director = Director::getInstance();
    auto glview = director->getOpenGLView();
    director->setOpenGLView(glview);
    
    Game* game = Game::instance();
    game->confirmDevice();
    CCLOG("device: %d, %d", game->device, game->d_wth);
    
    UserSettingManager* setting_manager = UserSettingManager::instance();
    auto music_visible = setting_manager->user_setting.music_visible;
    auto sound_visible = setting_manager->user_setting.sound_visible;
    
    game->setBackgroundMusicVolume(setting_manager->user_setting.music_percent);
    game->setEffectsVolume(setting_manager->user_setting.sound_percent);
    
    game->setBackgroundMusicVisible(music_visible);
    game->setEffectsVisible(sound_visible);
    
    // 资源目录设置
    vector<string> search_dirs;
    
    auto win_size = Director::getInstance()->getWinSize();
    auto ratio = win_size.height / win_size.width;
    if (ratio <= 1.34) {
        glview->setDesignResolutionSize(768, 1280, ResolutionPolicy::FIXED_HEIGHT);
    } else {
        glview->setDesignResolutionSize(640, 1280, ResolutionPolicy::FIXED_HEIGHT);
    }
    
    // 资源目录设置
    FileUtils* file_utils = FileUtils::getInstance();
    auto writable_path = file_utils->getWritablePath();
    
    // 删除旧文件
    auto old_version = UserDefault::getInstance()->getStringForKey("package_version", "-1");
    if (old_version != PACKAGE_RES_VERSION) {
        FileUtils::getInstance()->removeDirectory(writable_path + res_manager->decodeFilename("res"));
        FileUtils::getInstance()->removeDirectory(writable_path + res_manager->decodeFilename("src"));
        FileUtils::getInstance()->removeFile(writable_path + res_manager->decodeFilename("version.rvs.pre"));
        FileUtils::getInstance()->removeFile(writable_path + res_manager->decodeFilename("resversionex.rvs"));
        FileUtils::getInstance()->removeFile(writable_path + res_manager->decodeFilename("resversionex.rvs.pre"));
        UserDefault::getInstance()->setStringForKey("package_version", PACKAGE_RES_VERSION);
    }

    res_manager->copyInitRes();
    
    
    vector<string> searchPath = file_utils->getSearchPaths();
    searchPath.insert(searchPath.begin(), writable_path);
    file_utils->setSearchPaths(searchPath);
    engine->executeScriptFile("src/main.lua");
    
    LuaManager::instance()->executeGlobalAutoFunction("resetSearchPath", [&](LuaStack * ls) {
        return 0;
    });
    
    setting_manager->user_setting.platform_type = 0;
    VersionTable::instance()->reload();

    
    // 获取安装包bundle id
    Game::instance()->updatePushId();
    glClearColor(0, 0, 0, 0);
    
    
    #if defined(COCOS2D_DEBUG) && (COCOS2D_DEBUG > 0)
        Director::getInstance()->setDisplayStats(true);
    #endif
    
    // 平台初始化
    PlatformInit::init();
    
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
    AutomationManager::instance()->listenerFileSave();
#endif

//    auto str_aa = Director::getInstance()->getTextureCache()->getCachedTextureInfo();
//    str_aa = "";
    return true;
}

// This function will be called when the app is inactive. Note, when receiving a phone call it is invoked.
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();

#if USE_AUDIO_ENGINE
    AudioEngine::pauseAll();
#elif USE_SIMPLE_AUDIO_ENGINE
    
    // ios10有bug。切换到后台音效就播放不了了
    #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        SimpleAudioEngine::getInstance()->stopAllEffects();
    #else
        SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
        SimpleAudioEngine::getInstance()->pauseAllEffects();
    #endif
    
//    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
//    SimpleAudioEngine::getInstance()->pauseAllEffects();
    // fix
#endif
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();

#if USE_AUDIO_ENGINE
    AudioEngine::resumeAll();
#elif USE_SIMPLE_AUDIO_ENGINE
//    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
//    SimpleAudioEngine::getInstance()->resumeAllEffects();
    // fix
//    SimpleAudioEngine::getInstance()->resumeAllEffects();
    #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        SimpleAudioEngine::getInstance()->resumeAllEffects();
    #else
        SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
        SimpleAudioEngine::getInstance()->resumeAllEffects();
    #endif
#endif
}
