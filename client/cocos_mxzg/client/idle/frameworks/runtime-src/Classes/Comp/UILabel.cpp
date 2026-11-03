//
//  UILabel.cpp
//  ClickerHeroes
//
//  Created by conix on 3/7/16.
//
//

#include "UILabel.h"
#include "../Model/Game.h"
#include "../Model/Utils.h"
#include "../Animation/ShaderFactory.h"
#include "../Config/LanguageTable.h"
#include "../Model/LuaManager.h"
#include "../Common/CommonDefine.h"

#define PROPERTY_FONTNAME "fontName"
#define PROPERTY_FONTSIZE "fontSize"


std::string UILabelTTF::DEFAULT_FONT_NAME = FONT_DEFAULT_NAME_BOLD;

UILabel::UILabel() {
    
}

UILabel* UILabel::createWithSystemFont(const std::string &text,
                                       const std::string &font,
                                       float fontSize,
                                       const Size& dimensions,
                                       TextHAlignment hAlignment,
                                       TextVAlignment vAlignment) {
    
    UILabel* p = new UILabel();
    if (p && p->init(text, font, fontSize, dimensions, hAlignment, vAlignment)) {
        p->autorelease();
    } else {
        delete p;
        p = NULL;
    }
    return p;
}

UILabel *UILabel::createWithBMFont(const std::string& bmfontFilePath, const std::string& text,
                          const TextHAlignment& hAlignment , int maxLineWidth ,
                          const Vec2& imageOffset) {
    
    auto ret = new (std::nothrow)UILabel();
    
    if (ret && ret->setBMFontFilePath(bmfontFilePath,imageOffset))
    {
        ret->setMaxLineWidth(maxLineWidth);
        ret->setString(text);
        ret->autorelease();
        
        return ret;
    }
    
    delete ret;
    return nullptr;
}

bool UILabel::init(const std::string &text,
                   const std::string &font,
                   float fontSize,
                   const Size& dimensions,
                   TextHAlignment hAlignment,
                   TextVAlignment vAlignment) {
    setString(text);
    setSystemFontName(font);
    setSystemFontSize(fontSize);
    setDimensions(dimensions.width, dimensions.height);
    setAlignment(hAlignment, vAlignment);
    
    return true;
}

void UILabel::runActionFromTo(int64_t from, int64_t to, float duration) {
    unschedule(schedule_selector(UILabel::updateStringNum));
    
    this->from = from;
    this->to = to;
    this->cur_times = 0;
    this->total_times = 5000;
    
    schedule(schedule_selector(UILabel::updateStringNum), duration / 10000);
}

void UILabel::updateStringNum(float delay) {
    if (cur_times == total_times) {
        setString(StringUtil::convertIntScientific(to));
        
        unschedule(schedule_selector(UILabel::updateStringNum));
    } else {
        cur_times++;
        setString(StringUtil::convertIntScientific((to - from) * cur_times / total_times + from));
    }
}

UILabelTimeCountdown::UILabelTimeCountdown() {
    
}

UILabelTimeCountdown *UILabelTimeCountdown::create(int32_t time,
                                                   const std::string& font,
                                                   float fontSize, string str_1, string str_2) {
    
    UILabelTimeCountdown *pRet = new UILabelTimeCountdown();
    if (pRet && pRet->init(time, font, fontSize, str_1, str_2)) {
        pRet->autorelease();
        
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return nullptr;
}

bool UILabelTimeCountdown::init(int32_t time,
                                const std::string &font,
                                float fontSize, string str_1, string str_2) {
    
    this->time = time;
    
    string str;
    this->str_1 = str_1;
    this->str_2 = str_2;
    if (time - Game::instance()->getServerTime() < 0) {
        str = this->str_1;
    } else {
        str = this->str_2 + convertIntToTimeEN(time - Game::instance()->getServerTime());
    }
    
    setString(str);
    setSystemFontName(font);
    setSystemFontSize(fontSize);
    
    return true;
}


void UILabelTimeCountdown::runTimeCountdown() {
    
    if (time - Game::instance()->getServerTime() > 0) {
        schedule(CC_SCHEDULE_SELECTOR(UILabelTimeCountdown::updateStringNum), 0.1f);
    }
}

void UILabelTimeCountdown::setTime(int32_t time) {
    this->time = time;
}

void UILabelTimeCountdown::updateStringNum(float delay) {
    string str;
    if (time - Game::instance()->getServerTime() == 0) {
        unschedule(CC_SCHEDULE_SELECTOR(UILabelTimeCountdown::updateStringNum));
        str = str_1;
    } else {
        str = str_2 + convertIntToTimeEN(time - Game::instance()->getServerTime());
        
    }
    
    setString(str);
}

string UILabelTimeCountdown::convertIntToTimeEN(uint32_t num, const char* space) {
//    LanguageTable* language_table =  LanguageTable::instance();
//    const char* s = language_table->getLanguage(417);
//    const char* m = language_table->getLanguage(416);
//    const char* h = language_table->getLanguage(415);
//    const char* d = language_table->getLanguage(414);
    const char* s = "秒";
    const char* m = "分";
    const char* h = "小时";
    const char* d = "天";
    
    if (num <= 0) {
        return StringUtils::format("0%s", s);
    } else if (num < 60) {
        return StringUtils::format("%d%s", num, s);
    } else if (num < 3600) {
        if (num % 60 == 0) {
            return StringUtils::format("%d%s", num/60, m);
        } else {
            return StringUtils::format("%d%s%s%d%s", num/60, m, space, num % 60, s);
        }
    } else if (num < 86400) {
        if ((num % 3600) / 60 == 0) {
            return StringUtils::format("%d%s", num/3600, h);
        } else {
            return StringUtils::format("%d%s%s%d%s", num / 3600, h, space, (num % 3600) / 60, m);
        }
    } else {
        if ((num % 86400) / 3600 == 0) {
            return StringUtils::format("%d%s", num / 86400, d);
        } else {
            return StringUtils::format("%d%s%s%d%s", num / 86400, d, space, (num % 86400) / 3600, h);
        }
    }
}


bool UILabelTTF::init()
{
    if (!Label::init()) return false;
    
//    auto gl_program = ShaderFactory::instance()->getGLProgram(ST_POSITION_TEXTURE_DEFAULT_HIGHP);
//    setGLProgram(gl_program);
    return true;
}


void UILabelTTF::setDefaultFontName(string fontName)
{
    DEFAULT_FONT_NAME = fontName;
}

void UILabelTTF::setFontSize(float size)
{
    cocos2d::TTFConfig ttfconfig = this->getTTFConfig();
    ttfconfig.fontSize = size;
    this->setTTFConfig(ttfconfig);
}


std::vector<std::string> UILabelTTF::getCustom() {
    return vec_custom;
}

void UILabelTTF::setCustom(std::vector<std::string> code) {
    this->vec_custom = code;
}

void UILabelTTF::clearCustom() {
    this->vec_custom.clear();
}

void UILabelTTFLoader::onHandlePropTypeFontTTF(Node * pNode, Node * pParent, const char * pPropertyName, const char * pFontTTF, CCBReader * ccbReader)
{
    if(strcmp(pPropertyName, PROPERTY_FONTNAME) == 0) {
        cocos2d::TTFConfig ttfconfig;
//        ttfconfig.fontFilePath = "font/";
//        ttfconfig.fontFilePath += pFontTTF;
        ttfconfig.fontFilePath += UILabelTTF::DEFAULT_FONT_NAME;
        ((UILabelTTF *)pNode)->setTTFConfig(ttfconfig);
//        ((Label *)pNode)->setSystemFontName(pFontTTF);
    } else {
//        NodeLoader::onHandlePropTypeFontTTF(pNode, pParent, pPropertyName, pFontTTF, ccbReader);
    }
    
//    if (pNode->getTag() != -1) {
//        ((UILabelTTF *)pNode)->setString(LanguageTable::instance()->getLanguage(pNode->getTag()));
//    }
}

void UILabelTTFLoader::onHandlePropTypeFloatScale(cocos2d::Node * pNode, cocos2d::Node * pParent, const char * pPropertyName, float pFloatScale, CCBReader * ccbReader)
{
    if(strcmp(pPropertyName, PROPERTY_FONTSIZE) == 0) {
//        cocos2d::TTFConfig ttfconfig = ((UILabelTTF *)pNode)->getTTFConfig();
//        ttfconfig.fontSize = pFloatScale;
//        ((UILabelTTF *)pNode)->setTTFConfig(ttfconfig);
//        ((Label *)pNode)->setSystemFontSize(pFloatScale);
        ((UILabelTTF *)pNode)->setFontSize(pFloatScale);
    } else {
        NodeLoader::onHandlePropTypeFloatScale(pNode, pParent, pPropertyName, pFloatScale, ccbReader);
    }
}


void UILabelTTFLoader::onHandlePropTypeString(cocos2d::Node * pNode, cocos2d::Node * pParent, const char* pPropertyName, const char * pString, CCBReader * ccbReader)
{
    auto label = ((UILabelTTF*) pNode);
    
    if (strcmp(pPropertyName, "shadow") == 0) {
        CSJson::Reader reader;
        CSJson::Value json;
        string tmp_string;
        if (reader.parse(pString, json)) {
            Color4B shadowColor = Color4B::BLACK;
            Size offset = Size(2,-2);
            int blurRadius = 0;
            if (json.isMember("color")) {
                auto data = json["color"];
                shadowColor = Color4B(data[0].asInt(), data[1].asInt(), data[2].asInt(), data[3].asInt());
            }
            
            if (json.isMember("offset")) {
                auto data = json["offset"];
                offset = Size(data[0].asInt(), data[1].asInt());
            }
            
            if (json.isMember("blur")) {
                blurRadius = json["blur"].asInt();
            }
            label->enableShadow(shadowColor, offset, blurRadius);
        }
    } else if (strcmp(pPropertyName, "outline") == 0) {
        CSJson::Reader reader;
        CSJson::Value json;
        string tmp_string;
        if (reader.parse(pString, json)) {
            Color4B outlineColor = Color4B::BLACK;
            int outlineSize = 0;
            if (json.isMember("color")) {
                auto data = json["color"];
                outlineColor = Color4B(data[0].asInt(), data[1].asInt(), data[2].asInt(), data[3].asInt());
            }
            
            if (json.isMember("size")) {
                outlineSize = json["size"].asInt();
            }
            label->enableOutline(outlineColor, outlineSize);
        }
    } else if (string(pPropertyName).substr(0, sizeof("customs") - 1) == "customs") {
        LuaManager::instance()->executeGlobalAutoFunction("nodeCustoms", [&](LuaStack * ls) {
            ls->pushObject(label, "UILabelTTF");
            ls->pushString(pString);
            return 2;
        });
    } else {
        NodeLoader::onHandlePropTypeString(pNode, pParent, pPropertyName, pString, ccbReader);
    }
}
