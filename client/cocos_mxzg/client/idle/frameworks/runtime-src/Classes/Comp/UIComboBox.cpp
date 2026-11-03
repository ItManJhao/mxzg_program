//
//  UIComboBox.cpp
//  Editorer
//
//  Created by windy on 2017/9/30.
//

#include "UIComboBox.h"



UIComboBox::UIComboBox(UIComboBoxDelegate* pDelegate)
: delegate(pDelegate)
, main_menu(NULL)
, scroll_view(NULL)
, node_bg(NULL)
, select_index(-1)
{
    
}


UIComboBox* UIComboBox::create(UIComboBoxDelegate* pDelegate) {
    UIComboBox* pRef = new (std::nothrow) UIComboBox(pDelegate);
    if ( pRef && pRef->init() ) {
        pRef->autorelease();
        return pRef;
    }
    CC_SAFE_DELETE(pRef);
    return NULL;
}

bool UIComboBox::init(){
    if ( ! Layer::init() ) return false;
    setIgnoreAnchorPointForPosition(false);
    
    main_menu = UIMenu::create();
    main_menu->setPosition(Vec2::ZERO);
    addChild(main_menu);
    
    auto listener = EventListenerTouchOneByOne::create();
    listener->setSwallowTouches(true);
    listener->onTouchBegan = CC_CALLBACK_2(UIComboBox::onTouchBegan, this);
    listener->onTouchMoved = CC_CALLBACK_2(UIComboBox::onTouchMoved, this);
    listener->onTouchEnded = CC_CALLBACK_2(UIComboBox::onTouchEnded, this);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener, this);
    
    return true;
}

bool UIComboBox::onTouchBegan(Touch *touch, Event *event) {
    if ( scroll_view ) {
        Vec2 point = this->convertToNodeSpace(touch->getLocation());
        bool b = scroll_view->getBoundingBox().containsPoint(point);
        if ( ! b ) {
            this->visibleScrollView(false);
        }
        return b;
    }
    return false;
}

void UIComboBox::onTouchEnded(Touch *touch, Event *event) {
    
}

void UIComboBox::reloadData() {
    if ( delegate ) {
        // main_menu->removeAllChildren();
        auto children = main_menu->getChildren();
        for (int i = 0 ; i < children.size() ; ++i)
        {
            auto* child = children.at(i);
            child->setVisible(false);
            child->runAction(RemoveSelf::create());
        }
        
        
        auto* item_normal = delegate->comboBoxItemNormal(this, select_index);
        item_normal->setCallback(CC_CALLBACK_1(UIComboBox::onNormal, this));
        item_normal->setPosition(item_normal->getContentSize() * 0.5 * item_normal->getScale());
        main_menu->addChild(item_normal);
        
        setContentSize(item_normal->getContentSize() * item_normal->getScale());
        
        // 激活状态下.刷新下拉列表
        if ( scroll_view )
        {
            updateScrollView();
        }
    }
}

void UIComboBox::visibleScrollView(bool visible)
{
    if ( visible ) {
        if ( ! scroll_view ) {
            if (delegate) {
                delegate->comboBoxDidActivat(this);
            }
            
            updateScrollView();
            
            if ( delegate && scroll_view ) {
                delegate->comboBoxActivated(this, scroll_view);
            }
        }
    } else {
        if ( scroll_view ) {
            scroll_view->setVisible(false);
            scroll_view->runAction(RemoveSelf::create());
            scroll_view = NULL;
        }
        
        if ( node_bg ) {
            node_bg->setVisible(false);
            node_bg->runAction(RemoveSelf::create());
            node_bg = NULL;
        }
    }
}

void UIComboBox::setDelegate(UIComboBoxDelegate* pDelegate)
{
    delegate = pDelegate;
}

void UIComboBox::updateScrollView()
{
    if ( ! delegate ) {
        return;
    }
    if ( scroll_view ) {
        scroll_view->setVisible(false);
        scroll_view->runAction(RemoveSelf::create());
        scroll_view = NULL;
    }
    
    if ( node_bg ) {
        node_bg->setVisible(false);
        node_bg->runAction(RemoveSelf::create());
        node_bg = NULL;
    }
    
    scroll_view = cocos2d::extension::ScrollView::create();
    scroll_view->setDirection(cocos2d::extension::ScrollView::Direction::VERTICAL);
    addChild(scroll_view, 1);
    
    UIMenu* menu = UIMenu::create();
    menu->setIsTouchInsideNode(scroll_view);
    menu->setSwallowsTouches(false);
    menu->setPosition(Vec2::ZERO);
    scroll_view->setContainer(menu);
    
    ssize_t item_number = delegate->numberOfItemsInComboBox(this);
    float item_height = delegate->itemHeightForComboBox(this);
    Size view_size = delegate->dropDownSizeForComboBox(this);
    Vec2 offset = delegate->scrollViewOffsetForComboBox(this);
    scroll_view->setViewSize(Size(view_size.width , MIN(item_number * item_height, view_size.height)));
    scroll_view->setPosition(getContentSize().width * 0.5 - scroll_view->getViewSize().width * 0.5 + offset.x, -scroll_view->getViewSize().height + offset.y);
    scroll_view->setContentSize(Size(scroll_view->getViewSize().width, MAX(item_number * item_height, scroll_view->getViewSize().height)));
    scroll_view->setContentOffset(Vec2(0, scroll_view->getViewSize().height - scroll_view->getContentSize().height));
    
    for (ssize_t i = 0 ; i < item_number ; ++i)
    {
        MenuItem* item = delegate->comboBoxItemAtIndex(this, i);
        item->setCallback(CC_CALLBACK_1(UIComboBox::onItem, this));
        item->setPosition(scroll_view->getViewSize().width * 0.5,
                          scroll_view->getContentSize().height - (i + 0.5) * item_height);
        item->setTag((int)i);
        menu->addChild(item);
    }
    
    node_bg = delegate->scrollViewBgForComboBox(this, scroll_view, scroll_view->getViewSize());
    if ( node_bg ) {
        node_bg->setPosition(scroll_view->getPosition() + scroll_view->getViewSize() * 0.5);
        addChild(node_bg);
    }
    
}


void UIComboBox::onItem(Ref* pSender)
{
    MenuItem* item = (MenuItem*)pSender;
    if ( ! scroll_view || ! scroll_view->isNodeVisible(item) ) {
        return;
    }
    
    select_index = item->getTag();
    delegate->comboBoxItemTouched(this, item , select_index);
    visibleScrollView(false);
    reloadData();
}

void UIComboBox::onNormal(Ref* pSender)
{
    visibleScrollView( ! scroll_view );
}

ssize_t UIComboBox::getSelected() {
    return select_index;
}

void UIComboBox::setSelect(ssize_t index, bool v) {
    ssize_t item_number = delegate->numberOfItemsInComboBox(this);
    if (index < 0 || index >= item_number ) {
        select_index = -1;
        reloadData();
        return;
    }
    select_index = index;
    visibleScrollView(v);
    reloadData();
}



