//
//  UIMenuItem.cpp
//  ClickerHeroes
//
//  Created by Conix on 16-3-2.
//
//

#include "UIMenuItem.h"
#include "../../Model/Utils.h"
#include "../../Model/LuaManager.h"
#include "../../Config/LanguageTable.h"
#include "../UILabel.h"


#define UNSELECT_ACTION_TAG 900000

UIMenuItemImage::UIMenuItemImage() {
    can_run_select_action = true;
    o_scale = 0;
}

UIMenuItemImage::~UIMenuItemImage() {
}

UIMenuItemImage* UIMenuItemImage::create()
{
    UIMenuItemImage *pRet = new UIMenuItemImage();
    if (pRet && pRet->init())
    {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

UIMenuItemImage* UIMenuItemImage::createWithSpriteFrameName(const char *normalImage, const char *selectedImage, const char *disabledImage, ccMenuCallback callback) {
    UIMenuItemImage *pRet = new UIMenuItemImage();
    if (pRet && pRet->initWithSpriteFrameName(normalImage, selectedImage, disabledImage, callback))
    {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

bool UIMenuItemImage::initWithNormalImage(const char *normalImage, const char *selectedImage, const char *disabledImage, ccMenuCallback callback) {
    Node *normalSprite = NULL;
    Node *selectedSprite = NULL;
    Node *disabledSprite = NULL;
    
    if (normalImage) {
        normalSprite = Sprite::create(normalImage);
    }
    
    if (selectedImage) {
        selectedSprite = Sprite::create(selectedImage);
    }
    
    if(disabledImage) {
        disabledSprite = Sprite::create(disabledImage);
    }
    return initWithNormalSprite(normalSprite, selectedSprite, disabledSprite, callback);
}

bool UIMenuItemImage::initWithSpriteFrameName(const char *normalImage, const char *selectedImage, const char *disabledImage, ccMenuCallback callback) {
    Node *normalSprite = NULL;
    Node *selectedSprite = NULL;
    Node *disabledSprite = NULL;
    
    if (normalImage) {
        normalSprite = Sprite::createWithSpriteFrameName(normalImage);
    }
    if (selectedImage) {
        selectedSprite = Sprite::createWithSpriteFrameName(selectedImage);
    }
    if(disabledImage) {
        disabledSprite = Sprite::createWithSpriteFrameName(disabledImage);
    }
    return initWithNormalSprite(normalSprite, selectedSprite, disabledSprite,  callback);
}

void UIMenuItemImage::selected() {
    stopActionByTag(UNSELECT_ACTION_TAG);
    
    MenuItemImage::selected();
    
    if (!can_run_select_action) {
        return;
    }
    
    if (o_scale <= 0) {
        o_scale = getScaleX();
    }
    this->setScale(0.96 * o_scale);
}

void UIMenuItemImage::unselected() {
    unselected(false);
}

void UIMenuItemImage::unselected(bool is_long_press) {
    MenuItem::unselected();
    
    if (!can_run_select_action) {
        unselectedActionEnd();
        return;
    }
    
    auto unselected_action = getActionByTag(UNSELECT_ACTION_TAG);
    if (is_long_press) {
        if (unselected_action == NULL) {
            unselected_action = Sequence::create(ScaleTo::create(0.12, 1.1 * o_scale),
                                                 ScaleTo::create(0.12, 1.0 * o_scale),
                                                 CallFunc::create(CC_CALLBACK_0(UIMenuItemImage::unselectedActionEndForLongPress, this)),
                                                 NULL);
            unselected_action->setTag(UNSELECT_ACTION_TAG);
            runAction(unselected_action);
        }
    } else {
        if (unselected_action) {
            stopActionByTag(UNSELECT_ACTION_TAG);
//            stopAction(unselected_action);
        }
        unselected_action = Sequence::create(ScaleTo::create(0.12, 1.1 * o_scale),
                                             ScaleTo::create(0.12, 1.0 * o_scale),
                                             CallFunc::create(CC_CALLBACK_0(UIMenuItemImage::unselectedActionEnd, this)),
                                             NULL);
        
        if (_normalImage) {
            _normalImage->setVisible(true);
        }
        
        if (_selectedImage) {
            _selectedImage->setVisible(false);
        }
        unselected_action->setTag(UNSELECT_ACTION_TAG);
        runAction(unselected_action);
    }
}

void UIMenuItemImage::unselectedActionEndForLongPress() {
//    unselected_action = NULL;
}

void UIMenuItemImage::unselectedActionEnd() {
//    unselected_action = NULL;
    
    if (isEnabled() && _normalImage) {
        _normalImage->setVisible(true);
        
        if (_selectedImage) {
            _selectedImage->setVisible(false);
        }
        
        if (_disabledImage) {
            _disabledImage->setVisible(false);
        }
    }
}

void UIMenuItemImage::activate() {
    MenuItemImage::activate();
//    Game::playEffect("music/button-click.wav");
    LuaManager::instance()->executeGlobalAutoFunction("itemActivate", [&](LuaStack * ls) {
        return 0;
    });
}

void UIMenuItemImage::setEnableAction(bool e) {
    can_run_select_action = e;
}

//CCSprite* UIMenuItemImage::createHightlightSprite(const char* image_file) {
//    CCImage *finalImage = new CCImage();
//    finalImage->initWithImageFile(image_file, CCImage::kFmtPng);
//    unsigned char *pData = finalImage->getData();
//    int iIndex = 0;
//    for (int i = 0; i < finalImage->getHeight(); i++)
//    {
//        for (int j = 0; j < finalImage->getWidth(); j++)
//        {
//            // highlight
//            int iRPos = iIndex;
//            
//            int r = pData[iIndex];
//            iIndex++;
//            int g = pData[iIndex];
//            iIndex++;
//            int b = pData[iIndex];
//            iIndex++;
//            int a = pData[iIndex];
//            iIndex++;
//            
//            if (a == 0) {
//                continue;
//            }
//            
//            /*
//            // 黑白
//            int c = (r + g + b) / 3;
//            r = g = b = c;
//            */
//            
//            
//            // 增加对比度
//            r += (r - 128) * 0.2;
//            g += (g - 128) * 0.2;
//            b += (b - 128) * 0.2;
//            
//            // 加亮
//            r += 50;
//            g += 50;
//            b += 50;
//            
//            // 修正
//            if (r < 0) {
//                r = 0;
//            }
//            if (g < 0) {
//                g = 0;
//            }
//            if (b < 0) {
//                b = 0;
//            }
//            if (a < 0) {
//                a = 0;
//            }
//            
//            if (r > 255) {
//                r = 255;
//            }
//            if (g > 255) {
//                g = 255;
//            }
//            if (b > 255) {
//                b = 255;
//            }
//            if (a > 255) {
//                a = 255;
//            }
//            
//            //CCLOG("%d, %d, %d, %d", r, g, b, a);
//            
//            pData[iRPos + 0] = (unsigned char)r;
//            pData[iRPos + 1] = (unsigned char)g;
//            pData[iRPos + 2] = (unsigned char)b;
//            pData[iRPos + 3] = (unsigned char)a;
//        }
//    }
//    
//    CCTexture2D *texture = new CCTexture2D;
//    texture->initWithImage(finalImage);
//    
//    CCSprite* sprite = CCSprite::createWithTexture(texture);
//    
//    finalImage->release();
//    texture->release();
//    
//    return sprite;
//}
//
//CCSprite* UIMenuItemImage::createTransparentSprite(const char* image_file) {
//    CCImage *finalImage = new CCImage();
//    finalImage->initWithImageFile(image_file, CCImage::kFmtPng);
//    unsigned char *pData = finalImage->getData();
//    int iIndex = 0;
//    for (int i = 0; i < finalImage->getHeight(); i++)
//    {
//        for (int j = 0; j < finalImage->getWidth(); j++)
//        {
//            // White Transparent
//            int iRPos = iIndex;
//            
//            iIndex += 3;
//            int a = pData[iIndex];
//            iIndex++;
//            
//            if (a == 0) {
//                continue;
//            }
//            
//            a -= 200;
//            if (a < 0) {
//                a = 0;
//            }
//            
//            int r = a;
//            int g = a;
//            int b = a;
//                        
//            pData[iRPos + 0] = (unsigned char)r;
//            pData[iRPos + 1] = (unsigned char)g;
//            pData[iRPos + 2] = (unsigned char)b;
//            pData[iRPos + 3] = (unsigned char)a;
//        }
//    }
//    
//    CCTexture2D *texture = new CCTexture2D;
//    texture->initWithImage(finalImage);
//    
//    CCSprite* sprite = CCSprite::createWithTexture(texture);
//    
//    finalImage->release();
//    texture->release();
//    
//    return sprite;
//}

#pragma mark ------------------

UIMenuItemLabel::UIMenuItemLabel() {
    type = 0;
    label = NULL;
}

UIMenuItemLabel::~UIMenuItemLabel() {
}

UIMenuItemLabel* UIMenuItemLabel::create(const char* normal, const char* selected, const char* text, ccMenuCallback callback, short type) {
	UIMenuItemLabel *pRet = new UIMenuItemLabel();
    pRet->type = type;
    if (pRet && pRet->initNode(normal, selected, NULL, text, callback, type)) {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

UIMenuItemLabel* UIMenuItemLabel::create(const char* normal, const char* selected, const char* disabled, const char* text, ccMenuCallback callback, short type) {
	UIMenuItemLabel *pRet = new UIMenuItemLabel();
    pRet->type = type;
    if (pRet && pRet->initNode(normal, selected, disabled, text, callback, type)) {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

bool UIMenuItemLabel::initNode(const char* normal, const char* selected, const char* disabled, const char* text, ccMenuCallback callback, short type) {
    Node* normalSprite = NULL;
    Node* selectedSprite = NULL;
    Node* disabledSprite = NULL;
    
	normalSprite = Sprite::createWithSpriteFrameName(normal);
    
    if (selected) {
        selectedSprite = Sprite::createWithSpriteFrameName(selected);
    }
    if (disabled) {
        disabledSprite = Sprite::createWithSpriteFrameName(disabled);
    }
    
    bool b = initWithNormalSprite(normalSprite, selectedSprite, disabledSprite, callback);
    
    this->type = type;
    setLabelText(text);

    return b;
}

void UIMenuItemLabel::onNodeLoaded(Node* pNode, NodeLoader* pNodeLoader) {
	// 根据tag找语言包获取文字
//    if (getTag() > 0) {
//        const char* text = LanguageTable::instance()->getLanguage(getTag());
//        setLabelText(text);
//    }
}

Label* UIMenuItemLabel::getLabel() {
    return label;
}

void UIMenuItemLabel::setLabelText(string text) {
    if (text.length() > 0) {
        float reverse_scale = Game::instance()->getReverseScale();
        if (!label) {
            if (type == 1) {
                label = Label::createWithTTF(text, UILabelTTF::DEFAULT_FONT_NAME, 20);
                label->setColor(Color3B(255, 255, 204));
                label->setScale(1 / reverse_scale);
//                label->enableShadow(Color4B::BLACK, Size(1 / reverse_scale, -1 / reverse_scale));
            } else if (type == 2) {
                label = Label::createWithTTF(text, UILabelTTF::DEFAULT_FONT_NAME, 20);
                label->setColor(Color3B(247, 231, 88));
                label->setScale(1 / reverse_scale);
//                label->enableShadow(Color4B::BLACK, Size(1 / reverse_scale, -1 / reverse_scale));
            } else if (type == 3) {
                label = Label::createWithBMFont("font/yellow-80.fnt", text);
                label->setScale((1.0 + (0.5 + -reverse_scale)) * 2);
            } else if (type == 4) {
                label = Label::createWithBMFont("font/yellow-60.fnt", text);
                label->setScale((1.0 + (0.5 + -reverse_scale)) * 2);
            } else if (type == 5) {
//                label = Label::createWithBMFont("font/blue-60.fnt", text);
//                label->setScale((1.0 + (0.5 + -reverse_scale)) * 2);
                label = Label::createWithTTF(text, UILabelTTF::DEFAULT_FONT_NAME, 60);
                label->setTextColor(Color4B(252, 241, 208, 255));
                label->setScale(0.5);
//                label->enableShadow(Color4B::BLACK, Size(1, -1), 2);
            } else {
                label = Label::createWithTTF(text, UILabelTTF::DEFAULT_FONT_NAME, 60);
                label->setTextColor(Color4B(252, 241, 208, 255));
                label->setScale(0.5);
//                label->enableShadow(Color4B::BLACK, Size(1, -1), 2);
            }
            label->setPosition(Point(getContentSize().width / 2, getContentSize().height / 2));
            addChild(label, 1);
        } else {
            label->setString(text);
        }
        
    } else {
        if (label) {
            label->removeFromParent();
            label = NULL;
        }
    }
}

string UIMenuItemLabel::getLabelText() {
    if (label) {
        return label->getString();
    }
    return "";
}

void UIMenuItemLabel::setLabelColor(const Color3B& color) {
	if (label) {
		label->setColor(color);
	}
}

void UIMenuItemLabel::setTextColor(const Color4B& color) {
    if (label) {
        label->setTextColor(color);
    }
}

void UIMenuItemLabel::setLabelFont(string font_name)
{
    if (label) {
        label->setSystemFontName(font_name);
    }
}

void UIMenuItemLabel::setLabelSize(float fontSize) {
    if (label) {
        switch (type) {
            case 1:
            case 2:
                label->setSystemFontSize(fontSize);
                break;
            default:
            {
                auto ttfConfig = label->getTTFConfig();
                ttfConfig.fontSize = fontSize;
                label->setTTFConfig(ttfConfig);
            }
                break;
        }
    }
}

void UIMenuItemLabel::setLabelOffset(const Point offset) {
    if (label) {
        label->setPosition(Point(getContentSize().width / 2 + offset.x / getScaleX(), getContentSize().height / 2 + offset.y / getScaleY()));
    }
}

void UIMenuItemLabel::setLabelShadow(const Color4B& shadowColor,const Size &offset, int blurRadius) {
    if (label) {
        label->enableShadow(shadowColor, offset, blurRadius);
    }
}

void UIMenuItemLabel::setLabelOutLine(const Color4B& color, int outlineSize)
{
    if (label) {
        label->enableOutline(color, outlineSize);
    }
}

void UIMenuItemLabel::setLabelScale(float scale)
{
    if (label) {
        label->setScale(scale);
    }
}

void UIMenuItemLabel::setType(short type) {
    this->type = type;
}

void UIMenuItemLabel::updateImagesVisibility() {
    UIMenuItemImage::updateImagesVisibility();
//    if (label) {
//        if (isEnabled()) {
//        if (type == 1) {
//            label->setColor(Color3B(255, 255, 204));
//        } else if (type == 2) {
//            label->setColor(Color3B(247, 231, 88));
//        } else {
//            label->setColor(Color3B(247, 231, 110));
//        }
//        } else {
//            label->setColor(Color3B::GRAY);
//        }
//    }
}

void UIMenuItemLabelLoader::onHandlePropTypeInteger(Node * pNode, Node * pParent, const char* pPropertyName, int pInteger, CCBReader * pCCBReader) {
    if (strcmp(pPropertyName, "type") == 0) {
        ((UIMenuItemLabel*) pNode)->setType(pInteger);
    } else {
        NodeLoader::onHandlePropTypeInteger(pNode, pParent, pPropertyName, pInteger, pCCBReader);
    }
}

void UIMenuItemLabelLoader::onHandlePropTypeString(cocos2d::Node * pNode, cocos2d::Node * pParent, const char* pPropertyName, const char * pString, CCBReader * ccbReader)
{
    auto item = ((UIMenuItemLabel*) pNode);
    if (!item->getLabel()) {
        item->setLabelText(" ");
    }
    
    if (strcmp(pPropertyName, "text") == 0) {
        item->setLabelText(pString);
    } else if (strcmp(pPropertyName, "tcolor") == 0)  {
        CSJson::Reader reader;
        CSJson::Value json;
        string tmp_string;
        if (reader.parse(pString, json)) {
            auto data = json;
            item->setTextColor(Color4B(data[0].asInt(), data[1].asInt(), data[2].asInt(), data[3].asInt()));
        }
    } else if (strcmp(pPropertyName, "shadow") == 0) {
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
            item->setLabelShadow(shadowColor, offset, blurRadius);
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
            item->setLabelOutLine(outlineColor, outlineSize);
        }
        
    } else if (strcmp(pPropertyName, "size") == 0) {
        item->setLabelSize(atoi(pString));
    } else if (strcmp(pPropertyName, "toffset") == 0) {
        CSJson::Reader reader;
        CSJson::Value json;
        string tmp_string;
        if (reader.parse(pString, json)) {
            item->setLabelOffset(Point(json[0].asFloat(), json[1].asFloat()));
        }
    } else if (strcmp(pPropertyName, "customs") == 0) {
        LuaManager::instance()->executeGlobalAutoFunction("nodeCustoms", [&](LuaStack * ls) {
            ls->pushObject(item, "UIMenuItemLabel");
            ls->pushString(pString);
            return 2;
        });
    } else {
        NodeLoader::onHandlePropTypeString(pNode, pParent, pPropertyName, pString, ccbReader);
    }
}


#pragma mark ------------------

UIMenuItemCheckBox* UIMenuItemCheckBox::create() {
    UIMenuItemCheckBox *pRet = new UIMenuItemCheckBox();
    if (pRet && pRet->init()) {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

UIMenuItemCheckBox* UIMenuItemCheckBox::create(const char* normal, const char* selected, ccMenuCallback callback) {
    UIMenuItemCheckBox *pRet = new UIMenuItemCheckBox();
    if (pRet && pRet->initNode(normal, selected, callback)) {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

bool UIMenuItemCheckBox::initNode(const char* normal, const char* selected, ccMenuCallback callback) {
    Node* normalSprite = NULL;
    Node* selectedSprite = NULL;
    
    normalSprite = Sprite::createWithSpriteFrameName(normal);
    
    if (selected) {
        selectedSprite = Sprite::createWithSpriteFrameName(selected);
    }
    
    bool b = initWithNormalSprite(normalSprite, selectedSprite, NULL, callback);
    
    return b;
}

void UIMenuItemCheckBox::selected() {
    stopActionByTag(UNSELECT_ACTION_TAG);
//    stopAction(unselected_action);
    
    if (_normalImage) {
        if (_disabledImage) {
            _disabledImage->setVisible(false);
        }
        
        if (_selectedImage) {
            _normalImage->setVisible(!isSelected());
            _selectedImage->setVisible(isSelected());
        } else {
            _normalImage->setVisible(true);
        }
    }
    
    if (o_scale <= 0) {
        o_scale = getScale();
    }
    this->setScale(0.96 * o_scale);
}

void UIMenuItemCheckBox::unselected() {
    auto unselected_action = Sequence::create(ScaleTo::create(0.1, 1.1 * o_scale),
                                         ScaleTo::create(0.1, 1.0 * o_scale),
                                         CallFunc::create(CC_CALLBACK_0(UIMenuItemCheckBox::unselectedActionEnd, this)),
                                         NULL);
    unselected_action->setTag(UNSELECT_ACTION_TAG);
    runAction(unselected_action);
}

void UIMenuItemCheckBox::unselectedActionEnd() {
//    unselected_action = NULL;
}

void UIMenuItemCheckBox::activate() {
    setChecked(!isSelected());
    
    UIMenuItemImage::activate();
}

bool UIMenuItemCheckBox::isChecked() {
    return isSelected();
}

void UIMenuItemCheckBox::setChecked(bool checked) {
    if (isSelected() == checked || !isEnabled()) {
        return;
    }
    
    _selected = checked;
    
    if (_normalImage) {
        if (_disabledImage) {
            _disabledImage->setVisible(false);
        }
        
        if (_selectedImage) {
            _normalImage->setVisible(!_selected);
            _selectedImage->setVisible(_selected);
        } else {
            _normalImage->setVisible(true);
        }
    }
}

#pragma mark ------------------

UIMenuItemRadio::UIMenuItemRadio() {
    friend_menu = NULL;
    
    target = NULL;
    func = NULL;
}

void UIMenuItemRadio::activate() {
    
    if (target && func) {
        if (!(target->*func)(this)) {
            return;
        }
    }
    
    setChecked(true);
    
    Node* parent = getParent();
    if (!parent) {
        return;
    }
    
    Vector<Node*>& children = parent->getChildren();
    for (auto child : children) {
        UIMenuItemRadio* item = dynamic_cast<UIMenuItemRadio*>(child);
        if (item && item != this) {
            item->setChecked(false);
        }
    }
    
    
    if (friend_menu) {
        Vector<Node*>& children = friend_menu->getChildren();
        for (auto child : children) {
            UIMenuItemRadio* item = dynamic_cast<UIMenuItemRadio*>(child);
            if (item && item != this) {
                item->setChecked(false);
            }
        }
    }
    
    
    UIMenuItemImage::activate();
}

void UIMenuItemRadio::setConditionFunction(Ref* target, SEL_Check func) {
    this->target = target;
    this->func = func;
}

#pragma mark ------------------

UIMenuItemTab::UIMenuItemTab() {
    label = NULL;
    is_reset_order = true;
}

UIMenuItemTab::~UIMenuItemTab() {
    
}

UIMenuItemTab* UIMenuItemTab::create(const char* normal, const char* selected, const char* text, float scale, ccMenuCallback callback) {
    UIMenuItemTab *pRet = new UIMenuItemTab();
    if (pRet && pRet->initWithSpriteFrameName(normal, selected, NULL, callback)) {
        pRet->setScale(scale);
        pRet->setLabelText(text);
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

void UIMenuItemTab::onNodeLoaded(Node* pNode, NodeLoader* pNodeLoader) {
    // 根据tag找语言包获取文字
//    if (getTag() > 0) {
//        const char* text = LanguageTable::instance()->getLanguage(getTag());
//        setLabelText(text);
//    }
}

Label* UIMenuItemTab::getLabel() {
    return label;
}

void UIMenuItemTab::selected() {
    if (_normalImage) {
        if (_disabledImage) {
            _disabledImage->setVisible(false);
        }
        
        if (_selectedImage) {
            _normalImage->setVisible(!_selected);
            _selectedImage->setVisible(_selected);
        } else {
            _normalImage->setVisible(true);
        }
    }
    
    o_color = getColor();
    if (!_selected) {
        Color3B color = o_color;
        color.r = color.r - 50 > 0 ? color.r - 50 : 0;
        color.g = color.g - 50 > 0 ? color.g - 50 : 0;
        color.b = color.b - 50 > 0 ? color.b - 50 : 0;
        this->setColor(color);
    }
}

void UIMenuItemTab::unselected() {
    this->setColor(o_color);
}
void UIMenuItemTab::setChecked(t_bool checked) {
    UIMenuItemRadio::setChecked(checked);
    if (checked && is_reset_order) {
        Node* p = getParent();
        if (p) {
            p->reorderChild(this, getLocalZOrder());
        }
    }
}

void UIMenuItemTab::resetOrder(bool b) {
    is_reset_order = b;
}


void UIMenuItemTab::setLabelText(const string& text) {
    if (text != "") {
        if (!label) {
            label = Label::createWithTTF(text, UILabelTTF::DEFAULT_FONT_NAME, 40);
            label->setScale(0.5);
            label->setPosition(Point(getContentSize().width / 2, getContentSize().height / 2));
            addChild(label, 1);
        } else {
            label->setString(text);
        }
    } else {
        if (label) {
            label->removeFromParent();
            label = NULL;
        }
    }
}

void UIMenuItemTab::setLabelOffset(Vec2 offset) {
    if (label) {
        label->setPosition(Point(getContentSize().width / 2 + offset.x, getContentSize().height / 2 + offset.y));
    }
}


string UIMenuItemTab::getLabelText() {
    if (label) {
        return label->getString();
    }
    return "";
}

void UIMenuItemTab::setLabelScale(float scaleX, float scaleY)
{
    label->setScale(scaleX, scaleY);
}


void UIMenuItemTab::setLabelColor(const Color3B &color)
{
    if (label) {
        label->setColor(color);
    }
}

void UIMenuItemTab::setTextColor(const Color4B& color)
{
    if (label) {
        label->setTextColor(color);
    }
}



void UIMenuItemTabLoader::onHandlePropTypeString(cocos2d::Node * pNode, cocos2d::Node * pParent, const char* pPropertyName, const char * pString, CCBReader * ccbReader)
{
    auto item = ((UIMenuItemTab*) pNode);
    if (!item->getLabel()) {
        item->setLabelText(" ");
    }
    
    if (strcmp(pPropertyName, "text") == 0) {
        item->setLabelText(pString);
    } else if (strcmp(pPropertyName, "tcolor") == 0)  {
        CSJson::Reader reader;
        CSJson::Value json;
        string tmp_string;
        if (reader.parse(pString, json)) {
            auto data = json;
            item->setTextColor(Color4B(data[0].asInt(), data[1].asInt(), data[2].asInt(), data[3].asInt()));
        }
    }  else if (strcmp(pPropertyName, "shadow") == 0) {
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
            
            auto label = item->getLabel();
            if (label) {
                label->enableShadow(shadowColor, offset, blurRadius);
            }
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
            auto label = item->getLabel();
            if (label) {
                label->enableOutline(outlineColor, outlineSize);
            }
        }
        
    } else if (strcmp(pPropertyName, "size") == 0) {
        auto label = item->getLabel();
        int32_t fontSize = atoi(pString);
        if (label) {
            auto ttfConfig = label->getTTFConfig();
            ttfConfig.fontSize = fontSize;
            label->setTTFConfig(ttfConfig);
        }
    } else if (strcmp(pPropertyName, "toffset") == 0) {
        CSJson::Reader reader;
        CSJson::Value json;
        string tmp_string;
        if (reader.parse(pString, json)) {
            item->setLabelOffset(Point(json[0].asFloat(), json[1].asFloat()));
        }
    } else {
        NodeLoader::onHandlePropTypeString(pNode, pParent, pPropertyName, pString, ccbReader);
    }
}

#pragma mark ------------------

UIMenuItemIcon::UIMenuItemIcon()
: spr_icon(NULL)
{
    item_id = 0;
    icon_scale = 1;
    
    cur_statue = -1;
}

UIMenuItemIcon::~UIMenuItemIcon() {
    
}

UIMenuItemIcon* UIMenuItemIcon::create(const char* normal, const char* selected, ccMenuCallback callback, const char* str_statue_icon, ...) {
    va_list args;
    va_start(args,str_statue_icon);
    
    UIMenuItemIcon *pRet = UIMenuItemIcon::createWithStrIcon(normal, selected, callback, str_statue_icon, args);
    
    va_end(args);
    
    return pRet;
}

UIMenuItemIcon* UIMenuItemIcon::createWithStrIcon(const char* normal, const char* selected, ccMenuCallback callback, const char* str_statue_icon, va_list args) {
    UIMenuItemIcon *pRet = new UIMenuItemIcon();
    if (pRet && pRet->initWithSpriteFrameName(normal, selected, NULL, callback)) {
        pRet->initIconStr(str_statue_icon, args);
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

void UIMenuItemIcon::initIconStr(const char* str_statue_icon, ...) {
    va_list args;
    va_start(args,str_statue_icon);
    
    initIconStr(str_statue_icon, args);
    
    va_end(args);
}

void UIMenuItemIcon::initIconStr(const char* str_statue_icon, va_list args) {
    cur_statue = -1;
    vec_str_statue_icon.clear();
    
    vec_str_statue_icon.push_back(str_statue_icon);
    const char* i = va_arg(args, const char*);
    while(i) {
        vec_str_statue_icon.push_back(i);
        i = va_arg(args, const char*);
    }
    
    setIconWithIndex(0);
}

void UIMenuItemIcon::setIconWithIndex(int32_t index) {
    if (index < 0 || index >= vec_str_statue_icon.size()) {
        return;
    }
    
    if (cur_statue == index) {
        return;
    }
    
    cur_statue = index;
    
    if (spr_icon) {
        spr_icon->removeFromParentAndCleanup(true);
        spr_icon = NULL;
    }
    
    if (index > vec_str_statue_icon.size() - 1 ||
        !vec_str_statue_icon.at(index) ||
        strcmp(vec_str_statue_icon.at(index), "") == 0) {
        return;
    }
    
    spr_icon = Sprite::createWithSpriteFrameName(vec_str_statue_icon.at(index));
    spr_icon->setScale(icon_scale);
    spr_icon->setPosition(getContentSize().width / 2, getContentSize().height / 2);
    addChild(spr_icon);
}

void UIMenuItemIcon::setIcon(const char* str_statue_icon) {
    initIconStr(str_statue_icon);
}

void UIMenuItemIcon::setIconOffset(Point offset) {
    if (spr_icon) {
        spr_icon->setPosition(getContentSize().width / 2 + offset.x, getContentSize().height / 2 + offset.y);
    }
}

void UIMenuItemIcon::setIconScale(float scale) {
    icon_scale = scale;
    if (spr_icon) {
        spr_icon->setScale(icon_scale);
    }
}

void UIMenuItemIcon::setItemId(int64_t item_id) {
    this->item_id = item_id;
}

int64_t UIMenuItemIcon::getItemId() {
    return item_id;
}

#pragma mark ------------------

UIMenuItemScale9Sprite::UIMenuItemScale9Sprite()
: spr_bg(NULL)
{
    
}

UIMenuItemScale9Sprite::~UIMenuItemScale9Sprite() {
    
}

UIMenuItemScale9Sprite* UIMenuItemScale9Sprite::create(string str_bg, Rect rect_bg, Size btn_size, ccMenuCallback callback) {
    UIMenuItemScale9Sprite *pRet = new UIMenuItemScale9Sprite();
    if (pRet && pRet->initWithCallback(callback)) {
        pRet->initDone(str_bg, rect_bg, btn_size);
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

void UIMenuItemScale9Sprite::initDone(string str_bg, Rect rect_bg, Size btn_size) {
    // 设置大小
    setContentSize(btn_size);
    
    // 设置背景
    spr_bg = cocos2d::ui::Scale9Sprite::createWithSpriteFrameName(str_bg, rect_bg);
    spr_bg->setContentSize(btn_size);
    spr_bg->setAnchorPoint(Point(0.5, 0.5));
    spr_bg->setPosition(btn_size.width / 2, btn_size.height / 2);
    addChild(spr_bg, -1);
}
