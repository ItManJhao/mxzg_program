//
//  UIMenuItem.h
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#ifndef __ClickerHeroes__UIMenuItem__
#define __ClickerHeroes__UIMenuItem__

#include "../../Common/CommonDefine.h"
#include "../../Model/Game.h"

#include "editor-support/cocosbuilder/CocosBuilder.h"

using namespace cocosbuilder;

typedef bool (Ref::*SEL_Check)(Ref*);
#define check_selector(_SELECTOR) (SEL_Check)(&_SELECTOR)


class UIMenuItemImage : public MenuItemImage {
public:
    UIMenuItemImage();
    ~UIMenuItemImage();
    
    static UIMenuItemImage* create();
    static UIMenuItemImage* createWithSpriteFrameName(const char *normalImage, const char *selectedImage, const char *disabledImage, ccMenuCallback callback);
    
    bool initWithNormalImage(const char *normalImage, const char *selectedImage, const char *disabledImage, ccMenuCallback callback);
    virtual bool initWithSpriteFrameName(const char *normalImage, const char *selectedImage, const char *disabledImage, ccMenuCallback callback);
    
    virtual void selected();
    virtual void unselected();
    virtual void unselected(bool is_long_press);
    virtual void activate();
    virtual void setEnableAction(bool e);
        
protected:
    bool can_run_select_action;
    float o_scale;
    
    virtual void unselectedActionEnd();
    virtual void unselectedActionEndForLongPress();
    //    CCSprite* createHightlightSprite(const char* image_file);
    //    CCSprite* createTransparentSprite(const char* image_file);
};

class UIMenuItemImageLoader : public MenuItemImageLoader {
public:
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(UIMenuItemImageLoader, loader);
protected:
    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(UIMenuItemImage);
};

#pragma mark -------------

class UIMenuItemLabel : public UIMenuItemImage, public NodeLoaderListener {
public:
	UIMenuItemLabel();
    ~UIMenuItemLabel();

    CREATE_FUNC(UIMenuItemLabel);
    static UIMenuItemLabel* create(const char* normal, const char* selected, const char* text, ccMenuCallback callback, short type = 0);
    static UIMenuItemLabel* create(const char* normal, const char* selected, const char* disabled, const char* text, ccMenuCallback callback, short type = 0);

    virtual void onNodeLoaded(Node* pNode, NodeLoader* pNodeLoader);
    
    Label* getLabel();

    void setLabelText(string text);
    string getLabelText();
    void setLabelColor(const Color3B& color);
    void setTextColor(const Color4B& color);

    void setLabelFont(string font_name);
    void setLabelSize(float fontSize);
    void setLabelOffset(const Point offset);
    void setLabelShadow(const Color4B& shadowColor = Color4B::BLACK,const Size &offset = Size(2,-2), int blurRadius = 0);
    void setLabelOutLine(const Color4B& color = Color4B::BLACK, int outlineSize = 2);
    void setLabelScale(float scale);
    void setType(short type);
    
protected:
    short type;
    Label* label;

    virtual bool initNode(const char* normal, const char* selected, const char* disabled, const char* text, ccMenuCallback callback, short type);
    
    virtual void updateImagesVisibility();
};

class UIMenuItemLabelLoader : public MenuItemImageLoader {
public:
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(UIMenuItemLabelLoader, loader);
protected:
    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(UIMenuItemLabel);
    virtual void onHandlePropTypeInteger(Node * pNode, Node * pParent, const char* pPropertyName, int pInteger, CCBReader * pCCBReader);
    virtual void onHandlePropTypeString(cocos2d::Node * pNode, cocos2d::Node * pParent, const char* pPropertyName, const char * pString, CCBReader * ccbReader);
};

#pragma mark -------------

class UIMenuItemCheckBox : public UIMenuItemImage {
    
public:
    static UIMenuItemCheckBox* create();
    static UIMenuItemCheckBox* create(const char* normal, const char* selected, ccMenuCallback callback);
    
    virtual void selected();
    virtual void unselected();
    virtual void activate();
    virtual bool isChecked();
    virtual void setChecked(bool checked);
protected:
    virtual bool initNode(const char* normal, const char* selected, ccMenuCallback callback);
    
    virtual void unselectedActionEnd();
};

class UIMenuItemCheckBoxLoader : public MenuItemImageLoader
{
public:
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(UIMenuItemCheckBoxLoader, loader);
protected:
    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(UIMenuItemCheckBox);
};


#pragma mark -------------

class UIMenuItemRadio : public UIMenuItemCheckBox {
public:
    UIMenuItemRadio();
    CREATE_FUNC(UIMenuItemRadio);
    virtual void activate();
    
    Menu* friend_menu; // 关联的CCMenu，将会有自己的menu和这个friend_menu中选中唯一一个item
    
    void setConditionFunction(Ref* target, SEL_Check func);
    
protected:
    Ref* target;
    SEL_Check func;
};

class UIMenuItemRadioLoader : public MenuItemImageLoader
{
public:
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(UIMenuItemRadioLoader, loader);
protected:
    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(UIMenuItemRadio);
};


#pragma mark -------------

class UIMenuItemTab : public UIMenuItemRadio, public NodeLoaderListener {
protected:
    Color3B o_color;
    Label* label;
    bool is_reset_order;
public:
    UIMenuItemTab();
    ~UIMenuItemTab();
    CREATE_FUNC(UIMenuItemTab);
    static UIMenuItemTab* create(const char* normal, const char* selected, const char* text, float scale, ccMenuCallback callback);
    
    virtual void onNodeLoaded(Node* pNode, NodeLoader* pNodeLoader);

    Label* getLabel();

    virtual void selected();
    virtual void unselected();
    virtual void setChecked(bool checked);
    virtual void resetOrder(bool b);
    
    void setLabelText(const string& text);
    void setLabelOffset(Vec2 offset);

    string getLabelText();
    
    void setLabelScale(float scaleX, float scaleY);
    void setLabelColor(const Color3B& color);
    void setTextColor(const Color4B& color);
};

class UIMenuItemTabLoader : public MenuItemImageLoader
{
public:
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(UIMenuItemTabLoader, loader);
protected:
    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(UIMenuItemTab);
    virtual void onHandlePropTypeString(cocos2d::Node * pNode, cocos2d::Node * pParent, const char* pPropertyName, const char * pString, CCBReader * ccbReader);
};


#pragma mark -------------

class UIMenuItemIcon : public UIMenuItemImage {
protected:
    int64_t item_id;
    float icon_scale;
    
    int32_t cur_statue;
    vector<const char*> vec_str_statue_icon;
    
    Sprite* spr_icon;
    
public:
    UIMenuItemIcon();
    ~UIMenuItemIcon();
    CREATE_FUNC(UIMenuItemIcon);
    static UIMenuItemIcon* create(const char* normal, const char* selected, ccMenuCallback callback, const char* str_statue_icon, ...);
    static UIMenuItemIcon* createWithStrIcon(const char* normal, const char* selected, ccMenuCallback callback, const char* str_statue_icon, va_list args);
    
    void initIconStr(const char* str_statue_icon, ...);
    void initIconStr(const char* str_statue_icon, va_list args);
    void setIconWithIndex(int32_t index);
    void setIcon(const char* str_statue_icon);
    void setIconOffset(Point offset);
    void setIconScale(float scale);
    
    void setItemId(int64_t item_id);
    int64_t getItemId();
};

class UIMenuItemIconLoader : public MenuItemImageLoader
{
public:
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(UIMenuItemIconLoader, loader);
protected:
    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(UIMenuItemIcon);
};

#pragma mark -------------

class UIMenuItemScale9Sprite : public UIMenuItemImage {
protected:
    cocos2d::ui::Scale9Sprite* spr_bg;
    
public:
    UIMenuItemScale9Sprite();
    ~UIMenuItemScale9Sprite();
    CREATE_FUNC(UIMenuItemScale9Sprite);
    static UIMenuItemScale9Sprite* create(string str_bg, Rect rect_bg, Size btn_size, ccMenuCallback callback);
    
    void initDone(string str_bg, Rect rect_bg, Size btn_size);
};

#endif /* defined(__ClickerHeroes__UIMenuItem__) */


