//
//  UIComboBox.h
//  Editorer
//
//  Created by windy on 2017/9/30.
//

#ifndef UIComboBox_h
#define UIComboBox_h

#include "cocos2d.h"
#include "../Common/CommonDefine.h"
#include "UIWindowLayer.h"
#include "Menu/UIMenu.h"
#include "Menu/UIMenuItem.h"

USING_NS_CC;
using namespace std;

class UIComboBox;
class UIComboBoxDelegate
{
public:
    virtual ~UIComboBoxDelegate() {}

    virtual void comboBoxItemTouched(UIComboBox* comboBox, MenuItem* item, ssize_t idx) = 0;
    
    virtual MenuItem* comboBoxItemAtIndex(UIComboBox* comboBox, ssize_t idx) = 0;
    
    virtual MenuItem* comboBoxItemNormal(UIComboBox* comboBox, ssize_t idx) = 0;
    
    virtual ssize_t numberOfItemsInComboBox(UIComboBox* comboBox) = 0;
    
    virtual float itemHeightForComboBox(UIComboBox* comboBox) {
        return 0;
    };
    
    virtual Size dropDownSizeForComboBox(UIComboBox* comboBox) {
        return Size::ZERO;
    };
    
    virtual Vec2 scrollViewOffsetForComboBox(UIComboBox* comboBox) {
        return Vec2::ZERO;
    };
    
    virtual void comboBoxDidActivat(UIComboBox* comboBox) {};
    
    virtual void comboBoxActivated(UIComboBox* comboBox, cocos2d::extension::ScrollView* scroll_view) {}
    
    virtual Node* scrollViewBgForComboBox(UIComboBox* comboBox, cocos2d::extension::ScrollView* scroll_view, Size view_size) { return NULL; }
};


// 注意事项
// create完要调用reloadData刷新.


class UIComboBox : public Layer {
public:
    UIComboBox(UIComboBoxDelegate* pDelegate);
    ~UIComboBox(){};
    static UIComboBox* create(UIComboBoxDelegate* pDelegate);
    virtual bool init();
    virtual bool onTouchBegan(Touch *touch, Event *event);
    virtual void onTouchMoved(Touch *touch, Event *event){};
    virtual void onTouchEnded(Touch *touch, Event *event);
    
    virtual void reloadData();
    virtual void updateScrollView();
    virtual void visibleScrollView(bool visible);
    virtual void setDelegate(UIComboBoxDelegate* pDelegate);

    virtual void onItem(Ref* pSender);
    virtual void onNormal(Ref* pSender);
    
    virtual ssize_t getSelected();
    virtual void setSelect(ssize_t index, bool v);
private:
    UIComboBoxDelegate* delegate;
    cocos2d::extension::ScrollView* scroll_view;
    Node* node_bg;
    UIMenu* main_menu;
    ssize_t select_index;
};

#endif /* UIComboBox_h */
