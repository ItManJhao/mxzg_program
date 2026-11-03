//
//  TownSceneCtr.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "TownSceneCtr.h"
#include "../../Model/Utils.h"
#include "../../Person/Unit.h"
#include "../../Animation/ActionFactory.h"

TownScene::TownScene() {
//    scroll_view = NULL;
    menu_scene = NULL;
    
    space = 7.0f;
}

void TownScene::onNodeLoaded(Node *pNode, NodeLoader *pNodeLoader) {
//    setTouchEnabled(false);
    
    // 设置场景层的大小
    Size win_size = Director::getInstance()->getWinSize();
    setContentSize(win_size);
    
    // 添加遮罩层
    SpriteFrameCache *cache = SpriteFrameCache::getInstance();
    cache->addSpriteFramesWithFile("ccbi-res/main-scene.plist");
    Sprite *mask = Sprite::createWithSpriteFrame(cache->getSpriteFrameByName("main-scene/mask.png"));
    addChild(mask);
    mask->setScaleX(win_size.width / mask->getContentSize().width * 1.1f);
    mask->setScaleY(win_size.height / mask->getContentSize().height * 1.1f);
    mask->setPosition(Point(win_size.width / 2, win_size.height / 2));
    
//    // 设置滚动视图
//    scroll_view = UIScrollViewZoom::create();
//    scroll_view->setViewSize(win_size);
//    scroll_view->setBounceable(false);
////    scroll_view->setTouchPriority(1);
//    addChild(scroll_view, -1);
    
//    // 加地图背景
//    Texture2D::setDefaultAlphaPixelFormat(Texture2D::PixelFormat::RGB565);
//    
//    for (int i = 0; i < 4; i++) {
//        Sprite* bg = Sprite::create(StringUtils::format("ccbi-res/map-bg-main-%02d.jpg", i));
//        bg->setAnchorPoint(Point::ZERO);
//        bg->setScale(2);
//        bg->setPosition(Point(4096 * (i % 2), 2296 * (1 - i / 2)));
//        scroll_view->getContainer()->addChild(bg);
//    }
//    
//    Texture2D::setDefaultAlphaPixelFormat(Texture2D::PixelFormat::RGBA4444);
    
//    scroll_view->setContentSize(Size(4096 + 3056, 3072 + 2296));
//
//    // 地图缩放参数设置
//    scroll_view->setMinScale(win_size.height / scroll_view->getContentSize().height);
//    scroll_view->setMaxScale(0.61);
//    scroll_view->setShowMaxScale(0.6);
//    scroll_view->setMinScale(0.29);
//    scroll_view->setShowMinScale(0.3);
//    scroll_view->setZoomScale(0.3);
//
//    float x = (scroll_view->getViewSize().width - scroll_view->getContentSize().width * scroll_view->getZoomScale()) / 2;
//    float y = (scroll_view->getViewSize().height - scroll_view->getContentSize().height * scroll_view->getZoomScale()) / 2;
//    scroll_view->setContentOffset(Point(x, y));
}

void TownScene::initForMainScene() {
    
}

void TownScene::initForBattleScene() {
    
}

void TownScene::setViewToCenterWithPos(Point pos) {
    // TEST
    return;
//    // 获取目标在屏幕上的位置
//    Size win_size = Director::getInstance()->getWinSize();
//
//    Point offset = scroll_view->getContentOffset();
//
//    Point des = Point(offset.x + win_size.width / 2 - pos.x, offset.y + win_size.height / 2 - scroll_view->getPosition().y / 2 - pos.y);
//    des = checkScrollViewOffset(des);
//
//    if (!des.equals(scroll_view->getContentOffset()) && !scroll_view->getContainer()->getActionByTag(111111)) {
//        // 用于解决这个动画和指引移动建筑到中央的叠加导致的错位问题
//        ActionInterval* move = MoveTo::create(0.5f, des);
//        move->setTag(111110);
//        scroll_view->getContainer()->stopActionByTag(111110);
//        scroll_view->getContainer()->runAction(move);
//    }
}

// 判断所给坐标是否越界
Point TownScene::checkScrollViewOffset(Point pos) {
//    float scale = scroll_view->getZoomScale();
//    Size win_size = Director::getInstance()->getWinSize();
//
//    if (pos.x > 0) {
//        pos.x = 0;
//    } else if (pos.x < -scroll_view->getContentSize().width * scale + win_size.width) {
//        pos.x = -scroll_view->getContentSize().width * scale + win_size.width;
//    }
//    if (pos.y > 0) {
//        pos.y = 0;
//    } else if (pos.y < -scroll_view->getContentSize().height * scale + win_size.height - scroll_view->getPosition().y) {
//        pos.y = -scroll_view->getContentSize().height * scale + win_size.height - scroll_view->getPosition().y;
//    }
//
//    return pos;
}

void TownScene::initMenuScene(UIMenuScene* ms) {
//    menu_scene = ms;
//    menu_scene->setPosition(Point::ZERO);
//    scroll_view->getContainer()->addChild(menu_scene, -1);
//    menu_scene->initMenu();
}

#pragma mark -----------------

TownSceneCtr::TownSceneCtr() {
    
}

TownSceneCtr::~TownSceneCtr() {
    
}

TownScene* TownSceneCtr::getTownScene() {
    return (TownScene*)layer;
}

void TownSceneCtr::enter() {
    SceneCtr::enter();
}

void TownSceneCtr::didEnter() {
    SceneCtr::didEnter();
//    getTownScene()->scroll_view->setZoomScaleInDuration(1, 0.6);
}
