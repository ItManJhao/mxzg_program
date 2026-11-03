//
//  UILabel.h
//  ClickerHeroes
//
//  Created by conix on 3/7/16.
//
//

#ifndef UILabel_h
#define UILabel_h

#include "../Common/CommonDefine.h"
#include "editor-support/cocosbuilder/CocosBuilder.h"


using namespace cocosbuilder;


class UILabel : public Label {
public:
    UILabel();
    
    static UILabel* createWithSystemFont(const std::string& text,
                                         const std::string& font, float fontSize,
                                         const Size& dimensions = Size::ZERO,
                                         TextHAlignment hAlignment = TextHAlignment::LEFT,
                                         TextVAlignment vAlignment = TextVAlignment::TOP);
    
    static UILabel *createWithBMFont(const std::string& bmfontFilePath, const std::string& text,
                                     const TextHAlignment& hAlignment = TextHAlignment::LEFT, int maxLineWidth = 0,
                                     const Vec2& imageOffset = Vec2::ZERO);
    
    void runActionFromTo(int64_t from, int64_t to, float duration);
    
private:
    int64_t from;
    int64_t to;
    int cur_times;
    int total_times;
    
    bool init(const std::string &text,
              const std::string &font,
              float fontSize,
              const Size& dimensions,
              TextHAlignment hAlignment,
              TextVAlignment vAlignment);
    
    void updateStringNum(float delay);
};
#pragma mark ------抽奖倒计时lbl-----
class UILabelTimeCountdown : public Label{
public:
    UILabelTimeCountdown();
    
    static UILabelTimeCountdown *create(int32_t time,
                                        const std::string& font,
                                        float fontSize, string str_1, string str_2);
    bool init(int32_t time,
              const std::string &font,
              float fontSize, string str_1, string str_2);
    void runTimeCountdown();
    void setTime(int32_t time);
private:
    void updateStringNum(float delay);
    string convertIntToTimeEN(uint32_t num, const char* space = " ");
private:
    int32_t time;  // 抽奖的时间戳
    
    string str_1;  // 倒计时完成时文本
    string str_2;   // 倒计时进行时文本
};



class UILabelTTF : public Label
{
public:
    UILabelTTF(){};
    CREATE_FUNC(UILabelTTF);
    virtual bool init() override;
    
//    CC_SYNTHESIZE(, code, Code);
    static void setDefaultFontName(string fontName);
    
    std::vector<std::string> getCustom();
    void setCustom(std::vector<std::string> custom);
    void clearCustom();
    void setFontSize(float size);
public:
    std::vector<std::string> vec_custom;
    static std::string DEFAULT_FONT_NAME;
};

class UILabelTTFLoader : public LabelTTFLoader
{
public:
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(UILabelTTFLoader, loader);
protected:
    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(UILabelTTF);
    
    virtual void onHandlePropTypeFontTTF(Node * pNode, Node * pParent, const char * pPropertyName, const char * pFontTTF, CCBReader * ccbReader);
    
    virtual void onHandlePropTypeFloatScale(cocos2d::Node * pNode, cocos2d::Node * pParent, const char * pPropertyName, float pFloatScale, CCBReader * ccbReader);
    virtual void onHandlePropTypeString(cocos2d::Node * pNode, cocos2d::Node * pParent, const char* pPropertyName, const char * pString, CCBReader * ccbReader);
};

#endif /* UILabel_h */
