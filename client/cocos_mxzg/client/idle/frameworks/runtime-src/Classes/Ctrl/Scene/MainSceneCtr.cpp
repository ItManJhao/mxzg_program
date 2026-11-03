//
//  MainSceneCtr.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//
#include "MainSceneCtr.h"

//#include "../Layer/BattleEndCtr.h"
//#include "../../Model/BattleManager.h"

#include "../../Comp/UILabel.h"
#include "../../Comp/Menu/UIMenu.h"
#include "../../Comp/Menu/UIMenuRound.h"

#include "../../Animation/CCActionExt.h"
#include "../../Data/RoleData.h"
#include "../../Comp/MessageView.h"
#include "../../Animation/ShaderFactory.h"
#include "../../Model/UserSetting.h"
#include "../../Model/Maths.h"
#include "../../Model/Utils.h"

#include "../../Config/LanguageTable.h"
#include "../../Config/RoleTable.h"
#include "../../Config/SystemTable.h"
#include "../../Common/SingleInstance.h"
#include "../../Model/LuaManager.h"
#include "../../Net/Response/LuaResponse.h"
#include "../../Model/AssetManager.h"

#include "scripting/lua-bindings/manual/CCLuaEngine.h"


using namespace cocos2d::extension;

#pragma mark --------MainLayerBase---------
MSLayerBase::MSLayerBase() {
    
}

void MSLayerBase::initDone() {
    setContentSize(Director::getInstance()->getWinSize());
    setLocalZOrder(-1);
}

void MSLayerBase::remove() {
    removeFromParentAndCleanup(true);
}


#pragma mark --------MainScene---------

MainScene::MainScene()
: interval(0)
, cur_main_layer(NULL)
, tmp_main_layer(NULL)
, menu_scale(NULL)
, btn_main_city(NULL)
, btn_hero(NULL)
, btn_backpack(NULL)
, btn_battle(NULL)
, btn_clan(NULL)
, btn_dragon(NULL)
, btn_skin(NULL)
, main_layer(NULL)
, lbl_role_nick(NULL)
, lbl_level(NULL)
, lbl_attack(NULL)
, lbl_gold(NULL)
, lbl_gem(NULL)
//, lbl_exp(NULL)
, spr_head(NULL)
{
    
}

MainScene* MainScene::create() {
    MainScene * ptr = new(std::nothrow) MainScene;
    if(ptr != NULL && ptr->init()) {
        ptr->onNodeCreated();
        ptr->autorelease();
        return ptr;
    }
    CC_SAFE_DELETE(ptr);
    return NULL;
}

void MainScene::onNodeCreated() {
    // 设置场景层的大小
    Size win_size = Director::getInstance()->getWinSize();
    setContentSize(win_size);
    
    // 获取刘海高度
    float notch_height = Game::instance()->getNotchHeight();
    float reverse_scale = Game::instance()->getReverseScale();
    
    MainSceneCtr* main_ctr = MainSceneCtr::instance();
    
    SpriteFrameCache *sfc = SpriteFrameCache::getInstance();
    sfc->addSpriteFramesWithFile("ccbi-res/main-scene.plist");
    sfc->addSpriteFramesWithFile("ccbi-res/common-ui.plist");
    sfc->addSpriteFramesWithFile("ccbi-res/head-icon.plist");
    sfc->addSpriteFramesWithFile("ccbi-res/backpack.plist");

    // 加入主场景其他元素
    main_layer = Layer::create();
    main_layer->setAnchorPoint(Point::ZERO);
    main_layer->setPosition(Point::ZERO);
    main_layer->setName("main_layer");
    this->addChild(main_layer, 20);
    
    UIMenu* main_menu = UIMenu::create();
    main_menu->setPosition(Point::ZERO);
    main_layer->addChild(main_menu, 100);
    
    // 添加主背景
    Sprite* bg = Sprite::create("ccbi-res/map-bg-main-scene.png");
    bg->setScaleX(win_size.width / bg->getContentSize().width);
    bg->setScaleY(win_size.height / bg->getContentSize().height);
    bg->setAnchorPoint(Point::ZERO);
    bg->setPosition(Point::ZERO);
    bg->setName("main_scene_bg");
    addChild(bg, -10);
    
    Sprite* spr_bottom_bg = Sprite::createWithSpriteFrameName("main-scene/spr-bottom-bg.png");
    spr_bottom_bg->setScale(win_size.width / spr_bottom_bg->getContentSize().width);
    //    spr_bottom_bg->setScaleY(reverse_scale);
    spr_bottom_bg->setAnchorPoint(Point(0.5, 0));
    spr_bottom_bg->setPosition(win_size.width / 2, 0);
    addChild(spr_bottom_bg, 10);
    
    // 添加角色上方的角色信息控件
    Sprite* spr_up_bg = Sprite::createWithSpriteFrameName("main-scene/spr-up-bg.png");
    spr_up_bg->setScale(win_size.width / spr_up_bg->getContentSize().width);
    spr_up_bg->setPosition(win_size.width / 2, win_size.height - notch_height);
    main_layer->addChild(spr_up_bg, 10);
    
    float top_scale = spr_up_bg->getScale();
    Player *player = Player::instance();
    
    // 角色能量显示
    float res_scale = 0.8;
    float res_offset_x = -98;
    float add_offset_x = 120;
    Sprite* spr_attack_bg = Sprite::createWithSpriteFrameName("main-scene/spr-res-bg.png");
    spr_attack_bg->setScale(reverse_scale * top_scale * res_scale);
    spr_attack_bg->setPosition(win_size.width * 0.445,
                               win_size.height - 30 - notch_height);
    main_layer->addChild(spr_attack_bg, 20);
    
    Sprite* icon_attack = Sprite::createWithSpriteFrameName("res-icon/attack-1.png");
    icon_attack->setScale(top_scale * res_scale);
    icon_attack->setPosition(spr_attack_bg->getPositionX() + res_offset_x * spr_attack_bg->getScale(),
                             spr_attack_bg->getPositionY());
    main_layer->addChild(icon_attack, 30);
    
    lbl_attack = Label::createWithTTF("0", FONT_DEFAULT_NAME, 25);
    lbl_attack->enableOutline(Color4B(0, 0, 0, 255), 2);
    lbl_attack->setScale(top_scale * res_scale);
    lbl_attack->setPosition(spr_attack_bg->getPosition() + Vec2(5, -1));
    main_layer->addChild(lbl_attack, 30);
    
    // 角色金币显示
    Sprite* spr_gold_bg = Sprite::createWithSpriteFrameName("main-scene/spr-res-bg.png");
    spr_gold_bg->setScale(reverse_scale * top_scale * res_scale);
    spr_gold_bg->setPosition(win_size.width * 0.629,
                             spr_attack_bg->getPositionY());
    main_layer->addChild(spr_gold_bg, 20);
    
    Sprite* icon_gold = Sprite::createWithSpriteFrameName("backpack/900001.png");
    icon_gold->setScale(top_scale * res_scale * 0.4);
    icon_gold->setPosition(spr_gold_bg->getPositionX() + res_offset_x * spr_gold_bg->getScale(),
                           spr_gold_bg->getPositionY());
    main_layer->addChild(icon_gold, 30);
    
    lbl_gold =  Label::createWithTTF(StringUtil::convertScientific(player->gold), FONT_DEFAULT_NAME, 25);
    lbl_gold->enableOutline(Color4B(0, 0, 0, 255), 2);
    lbl_gold->setScale(top_scale * res_scale);
    lbl_gold->setPosition(spr_gold_bg->getPosition() + Vec2(5, -1));
    main_layer->addChild(lbl_gold, 30);
    
    UIMenuItemImage* btn_add_gold = UIMenuItemImage::createWithSpriteFrameName("button/btn-add-4.png",
                                                                               "button/btn-add-5.png",
                                                                               NULL,
                                                                               CC_CALLBACK_1(MainSceneCtr::onBuyGoldLua,
                                                                                             main_ctr)
                                                                               );
    btn_add_gold->setName("btn_add_gold");
    btn_add_gold->setScale(reverse_scale * top_scale * res_scale);
    btn_add_gold->setPosition(spr_gold_bg->getPositionX() + add_offset_x * spr_gold_bg->getScale(),
                              spr_gold_bg->getPositionY());
    main_menu->addChild(btn_add_gold);
    
    // 角色宝石显示
    Sprite* spr_gem_bg = Sprite::createWithSpriteFrameName("main-scene/spr-res-bg.png");
    spr_gem_bg->setScale(reverse_scale * top_scale * res_scale);
    spr_gem_bg->setPosition(win_size.width * 0.83,
                            spr_attack_bg->getPositionY());
    main_layer->addChild(spr_gem_bg, 20);
    
    Sprite* icon_gem = Sprite::createWithSpriteFrameName("backpack/900002.png");
    icon_gem->setScale(top_scale * res_scale * 0.4);
    icon_gem->setPosition(spr_gem_bg->getPositionX() + res_offset_x * spr_gem_bg->getScale(),
                          spr_gem_bg->getPositionY());
    main_layer->addChild(icon_gem, 30);
    
    lbl_gem = Label::createWithTTF(StringUtil::convertIntScientific(player->gem), FONT_DEFAULT_NAME, 25);
    lbl_gem->enableOutline(Color4B(0, 0, 0, 255), 2);
    lbl_gem->setScale(top_scale * res_scale);
    lbl_gem->setPosition(spr_gem_bg->getPosition() + Vec2(5, -1));
    main_layer->addChild(lbl_gem, 30);
    
    UIMenuItemImage* btn_add_gem = UIMenuItemImage::createWithSpriteFrameName("button/btn-add-4.png",
                                                                              "button/btn-add-5.png",
                                                                              NULL,
                                                                              CC_CALLBACK_1(MainSceneCtr::onBuyGemLua,
                                                                                            main_ctr)
                                                                              );
    btn_add_gem->setName("btn_add_gem");
    btn_add_gem->setScale(reverse_scale * top_scale * res_scale);
    btn_add_gem->setPosition(spr_gem_bg->getPositionX() + add_offset_x * spr_gem_bg->getScale(),
                             spr_gem_bg->getPositionY());
    main_menu->addChild(btn_add_gem);
    
    // 添加角色等级
    Sprite* spr_head_frame = Sprite::createWithSpriteFrameName("main-scene/spr-head-frame-1.png");
    spr_head_frame->setScale(top_scale);
    spr_head_frame->setAnchorPoint(Vec2(0.452, 0.5));
    spr_head_frame->setPosition(win_size.width * 0.078, win_size.height - 80 + (49 - notch_height));
    main_layer->addChild(spr_head_frame, 20);
    
    spr_head = Sprite::createWithSpriteFrameName("head-icon/0.png");
    spr_head->setScale(top_scale * 0.8);
    spr_head->setName("spr_head");
    spr_head->setPosition(spr_head_frame->getPosition());
    main_layer->addChild(spr_head, 20);
    
    auto spr_nick_bg = Sprite::createWithSpriteFrameName("main-scene/spr-name-bg-1.png");
    spr_nick_bg->setAnchorPoint(Vec2(0, 0.5));
    spr_nick_bg->setScale(top_scale * res_scale);
    spr_nick_bg->setPosition(spr_head_frame->getPositionX() + 50 * spr_head_frame->getScale(),
                             spr_attack_bg->getPositionY());
    main_layer->addChild(spr_nick_bg, 10);
    
    // 添加角色昵称
    lbl_role_nick = Label::createWithTTF("", FONT_DEFAULT_NAME_BOLD, 23);
    lbl_role_nick->enableShadow(Color4B::BLACK, Size(1, -2));
    lbl_role_nick->setAnchorPoint(Point(0, 0.5));
    lbl_role_nick->setPosition(spr_nick_bg->getPosition() + Vec2(3 * spr_nick_bg->getScale(), 0));
    lbl_role_nick->setScale(top_scale * res_scale);
    main_layer->addChild(lbl_role_nick, 20);
    
    auto spr_level_bg = Sprite::createWithSpriteFrameName("main-scene/spr-level-bg.png");
    spr_level_bg->setPosition(spr_head_frame->getPosition() - Vec2(0, 40 * spr_head_frame->getScale()));
    main_layer->addChild(spr_level_bg, 20);
    
    lbl_level = Label::createWithBMFont("font/40.fnt", StringUtils::format("%d", player->level));
    lbl_level->setPosition(spr_level_bg->getPosition());
    main_layer->addChild(lbl_level, 20);
    
    UIMenuItemImage* btn_role_info = UIMenuItemImage::create();
    btn_role_info->setContentSize(spr_head_frame->getContentSize());
    btn_role_info->setAnchorPoint(spr_head_frame->getAnchorPoint());
    btn_role_info->setPosition(spr_head_frame->getPosition());
    btn_role_info->setCallback(CC_CALLBACK_1(MainSceneCtr::onRoleLua, main_ctr));
    main_menu->addChild(btn_role_info);
    
    //    // 添加角色经验
    //    Sprite* lbl_exp_left = Sprite::createWithSpriteFrameName("main-scene/lbl-exp.png");
    //    lbl_exp_left->setAnchorPoint(Point(1, 0.5));
    //    lbl_exp_left->setScale(reverse_scale);
    //    lbl_exp_left->setPosition(win_size.width / 2 + 120, lbl_role_nick->getPositionY());
    //    main_layer->addChild(lbl_exp_left, 30);
    
    Sprite* spr_progress_exp_bg = Sprite::createWithSpriteFrameName("main-scene/progress-role-exp-bg.png");
    spr_progress_exp_bg->setScale(top_scale);
    spr_progress_exp_bg->setPosition(win_size.width * 0.5, lbl_gem->getPositionY() + 25);
    spr_progress_exp_bg->setName("spr_progress_exp_bg");
    main_layer->addChild(spr_progress_exp_bg, 19);
    
    int32_t max_level = MainLevelTable::instance()->getMaxLevel();
    int32_t max_exp = MainLevelTable::instance()->getConfig(MIN(player->level, max_level - 1))->exp;
    
    progress_exp = ProgressTimer::create(Sprite::createWithSpriteFrameName("main-scene/progress-role-exp.png"));
    progress_exp->setType(ProgressTimer::Type::BAR);
    progress_exp->setBarChangeRate(Point(1, 0));
    progress_exp->setMidpoint(Point(0, 0));
    progress_exp->setScale(spr_progress_exp_bg->getScale());
    progress_exp->setPosition(spr_progress_exp_bg->getPosition() + Vec2(0, 1));
    progress_exp->setName("progress_exp");
    progress_exp->setPercentage(1.0 * player->exp / max_exp * 100);
    main_layer->addChild(progress_exp, 19);
    
    // 添加界面下方的主界面layer切换menu
    menu_scale = UIMenu::create();
    menu_scale->setPosition(Point::ZERO);
    menu_scale->setTag(10);
    menu_scale->setName("menu_scale");
    main_layer->addChild(menu_scale, 20);
    
    btn_main_city = UIMenuItemScale::create("main-scene/scale-bar-1.png",
                                            "main-scene/scale-bar-2.png",
                                            reverse_scale,
                                            CC_CALLBACK_1(MainSceneCtr::onPub, main_ctr)
                                            );
    btn_main_city->setTag(11);
    // btn_pub->start();
    menu_scale->addChild(btn_main_city);
    
    // 如果按钮长度超出屏幕上限，则缩小按钮初始缩放
    float icon_scale = 0.6;
    float text_scale = 1;
    float o_scale = spr_bottom_bg->getScale() * 1.5;
    Size size_item = Size(btn_main_city->getContentSize().width * o_scale - 20,
                          btn_main_city->getContentSize().height * o_scale);
    
    float begin_x = win_size.width * 0.5 - (7 - 0.5) * size_item.width * 0.5;
    
    btn_main_city->setOScale(o_scale);
    btn_main_city->setName("btn_main_city");
    btn_main_city->setInitPos(Point(begin_x + size_item.width * 0, -4));
    
    auto spr_city = Sprite::createWithSpriteFrameName("main-scene/spr-city.png");
    spr_city->setName("spr_city");
    spr_city->setPosition(Vec2(btn_main_city->getContentSize().width * 0.5, btn_main_city->getContentSize().width * 0.6));
    spr_city->setScale(icon_scale);
    btn_main_city->addChild(spr_city, 15);
    
    auto spr_city_text = Sprite::createWithSpriteFrameName("main-scene/lbl-city.png");
    spr_city_text->setPosition(Vec2(btn_main_city->getContentSize().width * 0.5, btn_main_city->getContentSize().height * 0.2));
    spr_city_text->setScale(text_scale);
    btn_main_city->addChild(spr_city_text, 20);
    
    
    btn_hero = UIMenuItemScale::create("main-scene/scale-bar-1.png",
                                       "main-scene/scale-bar-2.png",
                                       reverse_scale,
                                       CC_CALLBACK_1(MainSceneCtr::onRole, main_ctr)
                                       );
    btn_hero->setOScale(o_scale);
    btn_hero->setInitPos(Point(begin_x + size_item.width * 1, -4));
    btn_hero->setTag(22);
    menu_scale->addChild(btn_hero);
    
    
    auto spr_hero = Sprite::createWithSpriteFrameName("main-scene/spr-hero.png");
    spr_hero->setPosition(Vec2(btn_main_city->getContentSize().width * 0.5, btn_main_city->getContentSize().width * 0.6));
    spr_hero->setScale(icon_scale);
    btn_hero->addChild(spr_hero, 15);
    
    auto spr_hero_text = Sprite::createWithSpriteFrameName("main-scene/lbl-hero.png");
    spr_hero_text->setPosition(Vec2(btn_main_city->getContentSize().width * 0.5, btn_main_city->getContentSize().height * 0.2));
    spr_hero_text->setScale(text_scale);
    btn_hero->addChild(spr_hero_text, 20);
    
    
    btn_backpack = UIMenuItemScale::create("main-scene/scale-bar-1.png",
                                           "main-scene/scale-bar-2.png",
                                           reverse_scale,
                                           CC_CALLBACK_1(MainSceneCtr::onMainPage, main_ctr)
                                           );
    btn_backpack->setOScale(o_scale);
    btn_backpack->setInitPos(Point(begin_x + size_item.width * 2, -4));
    btn_backpack->setTag(33);
    menu_scale->addChild(btn_backpack);
    
    auto spr_backpack = Sprite::createWithSpriteFrameName("main-scene/spr-backpack.png");
    spr_backpack->setPosition(Vec2(btn_main_city->getContentSize().width * 0.5, btn_main_city->getContentSize().width * 0.6));
    spr_backpack->setScale(icon_scale);
    btn_backpack->addChild(spr_backpack, 15);
    
    auto spr_backpack_text = Sprite::createWithSpriteFrameName("main-scene/lbl-backpack.png");
    spr_backpack_text->setPosition(Vec2(btn_main_city->getContentSize().width * 0.5, btn_main_city->getContentSize().height * 0.2));
    spr_backpack_text->setScale(text_scale);
    btn_backpack->addChild(spr_backpack_text, 20);
    
    
    btn_battle = UIMenuItemScale::create("main-scene/scale-bar-1.png",
                                         "main-scene/scale-bar-2.png",
                                         reverse_scale,
                                         CC_CALLBACK_1(MainSceneCtr::onBattle, main_ctr)
                                         );
    btn_battle->setOScale(o_scale);
    btn_battle->setInitPos(Point(begin_x + size_item.width * 3, -4));
    btn_battle->setTag(44);
    menu_scale->addChild(btn_battle);
    
    auto spr_battle = Sprite::createWithSpriteFrameName("main-scene/spr-battle.png");
    spr_battle->setPosition(Vec2(btn_main_city->getContentSize().width * 0.5, btn_main_city->getContentSize().width * 0.6));
    spr_battle->setScale(icon_scale);
    btn_battle->addChild(spr_battle, 15);
    
    auto spr_battle_text = Sprite::createWithSpriteFrameName("main-scene/lbl-battle.png");
    spr_battle_text->setPosition(Vec2(btn_main_city->getContentSize().width * 0.5, btn_main_city->getContentSize().height * 0.2));
    spr_battle_text->setScale(text_scale);
    btn_battle->addChild(spr_battle_text, 20);
    
    
    btn_clan = UIMenuItemScale::create("main-scene/scale-bar-1.png",
                                       "main-scene/scale-bar-2.png",
                                       reverse_scale,
                                       CC_CALLBACK_1(MainSceneCtr::onClan, main_ctr)
                                       );
    btn_clan->setOScale(o_scale);
    btn_clan->setInitPos(Point(begin_x + size_item.width * 4, -4));
    btn_clan->setTag(55);
    menu_scale->addChild(btn_clan);
    
    auto spr_clan = Sprite::createWithSpriteFrameName("main-scene/spr-clan.png");
    spr_clan->setPosition(Vec2(btn_main_city->getContentSize().width * 0.5, btn_main_city->getContentSize().width * 0.6));
    spr_clan->setScale(icon_scale);
    btn_clan->addChild(spr_clan, 15);
    
    auto spr_clan_text = Sprite::createWithSpriteFrameName("main-scene/lbl-clan.png");
    spr_clan_text->setPosition(Vec2(btn_main_city->getContentSize().width * 0.5, btn_main_city->getContentSize().height * 0.2));
    spr_clan_text->setScale(text_scale);
    btn_clan->addChild(spr_clan_text, 20);
    
    
    btn_dragon = UIMenuItemScale::create("main-scene/scale-bar-1.png",
                                         "main-scene/scale-bar-2.png",
                                         reverse_scale,
                                         CC_CALLBACK_1(MainSceneCtr::onOther, main_ctr)
                                         );
    btn_dragon->setOScale(o_scale);
    btn_dragon->setInitPos(Point(begin_x + size_item.width * 5, -4));
    btn_dragon->setTag(66);
    menu_scale->addChild(btn_dragon);
    
    auto spr_dragon = Sprite::createWithSpriteFrameName("main-scene/spr-dragon.png");
    spr_dragon->setPosition(Vec2(btn_main_city->getContentSize().width * 0.5, btn_main_city->getContentSize().width * 0.6));
    spr_dragon->setScale(icon_scale);
    btn_dragon->addChild(spr_dragon, 15);
    
    auto spr_dragon_text = Sprite::createWithSpriteFrameName("main-scene/lbl-dragon.png");
    spr_dragon_text->setPosition(Vec2(btn_main_city->getContentSize().width * 0.5, btn_main_city->getContentSize().height * 0.2));
    spr_dragon_text->setScale(text_scale);
    btn_dragon->addChild(spr_dragon_text, 20);
    
    
    btn_skin = UIMenuItemScale::create("main-scene/scale-bar-1.png",
                                       "main-scene/scale-bar-2.png",
                                       reverse_scale,
                                       CC_CALLBACK_1(MainSceneCtr::onSkin, main_ctr)
                                       );
    btn_skin->setOScale(o_scale);
    btn_skin->setInitPos(Point(begin_x + size_item.width * 6, -4));
    btn_skin->setTag(77);
    menu_scale->addChild(btn_skin);
    
    auto spr_skin = Sprite::createWithSpriteFrameName("main-scene/spr-skin.png");
    spr_skin->setPosition(Vec2(btn_main_city->getContentSize().width * 0.5, btn_main_city->getContentSize().width * 0.6));
    spr_skin->setScale(icon_scale);
    btn_skin->addChild(spr_skin, 15);
    
    auto spr_skin_text = Sprite::createWithSpriteFrameName("main-scene/lbl-skin.png");
    spr_skin_text->setPosition(Vec2(btn_main_city->getContentSize().width * 0.5, btn_main_city->getContentSize().height * 0.2));
    spr_skin_text->setScale(text_scale);
    btn_skin->addChild(spr_skin_text, 20);
    
    update(0);
    this->schedule(CC_SCHEDULE_SELECTOR(MainScene::update), 1.0);
    
//    auto reddot_manager = RedDotManager::instance();
//    reddot_manager->setStickNode(RDT_MS_MAIN_CITY, btn_main_city);
//    reddot_manager->setStickNode(RDT_MS_HERO, btn_hero);
//    reddot_manager->setStickNode(RDT_MS_BACKPACK, btn_backpack);
//    reddot_manager->setStickNode(RDT_MS_BATTLE, btn_battle);
//    reddot_manager->setStickNode(RDT_MS_CLAN, btn_clan);
//    reddot_manager->setStickNode(RDT_MS_DRAGON, btn_dragon);
//    reddot_manager->setStickNode(RDT_MS_SKIN, btn_skin);
}

void MainScene::onExit() {
//    auto reddot_manager = RedDotManager::instance();
//    reddot_manager->setStickNode(RDT_MS_MAIN_CITY, NULL);
//    reddot_manager->setStickNode(RDT_MS_HERO, NULL);
//    reddot_manager->setStickNode(RDT_MS_BACKPACK, NULL);
//    reddot_manager->setStickNode(RDT_MS_BATTLE, NULL);
//    reddot_manager->setStickNode(RDT_MS_CLAN, NULL);
//    reddot_manager->setStickNode(RDT_MS_DRAGON, NULL);
//    reddot_manager->setStickNode(RDT_MS_SKIN, NULL);
    MainSceneCtr::instance()->clearKeepLayer();
    TownScene::onExit();
}

void MainScene::update(float dt) {
    interval++;
    
    auto role_data = RoleData::instance();
    auto language_table = LanguageTable::instance();
    
    // 登录时间
    auto inline_time = Game::instance()->getServerTime() - role_data->login_time;
    if (inline_time > 3600 && role_data->inline_time_tip == 0) {
        role_data->inline_time_tip = 1;
        MessageView::instance()->add(StringUtils::format(language_table->getLanguage(1020), inline_time / 3600));
    }
    
    // 检查过时道具
    if ( interval % 10 == 0 )
    {
        // 时间差.每天凌晨6点删除
        int32_t time_offset = 6 * 3600;
        
        // 登录日期
        time_t lt = role_data->login_time - time_offset;
        int32_t login_day = localtime(&lt)->tm_yday;
        
        // 现在日期
        lt = Game::instance()->getServerTime() - time_offset;
        int32_t now_day = localtime(&lt)->tm_yday;
        
        if ( login_day != now_day )
        {
            role_data->login_time = Game::instance()->getServerTime();
            
            // 刷新道具列表
            ReqBackpackList req_backpack_list;
            NetManager::instance()->send(&req_backpack_list, sizeof(req_backpack_list));
        }
    }
}

#pragma mark ------------MainSceneCtr---------------

MainSceneCtr::MainSceneCtr() {
    cur_layer_type = MLT_INVALID;
    last_layer_type = MLT_INVALID;
    
    player_id = 0;
    buy_item_type = 0;
    battle_match_start_time = 0;
    is_changing = false;
}

MainSceneCtr::~MainSceneCtr() {
    
}

void MainSceneCtr::enter() {
    cur_layer_type = MLT_INVALID;
    is_changing = false;
    // 打开主城界面窗口
    TownSceneCtr::enter();
    changeLayer(MLT_BATTLE);
//    LuaManager::instance()->handleEvent(this, "onExit", [&](LuaStack * ls) {
//        ls->pushObject((Ref*)this, "LuaLayer");
//        return 1;
//    });
}

void MainSceneCtr::didEnter() {
    // is_didenter = true;
    SceneCtr::didEnter();
    
    log("main scene did enter");
    AssetManager::instance()->destroy();
    // 初始主界面为战斗主层
    
//    ChatCtr::instance()->open();
//    GuideCtr::restart();
}

SceneCtrType MainSceneCtr::getSceneCtrType() {
    return SCT_MAIN_SCENE;
}

void MainSceneCtr::loadScene() {
    layer = MainScene::create();
    layer->retain();
    layer->controller = this;
    scene = Scene::create();
    scene->addChild(layer);
    
//    auto layer_effect = MainTouchEffectLayer::create();
//    scene->addChild(layer_effect, 99999);
}

MainScene* MainSceneCtr::getMainScene() {
    return (MainScene*)layer;
}

MainLayerType MainSceneCtr::getCurLayerType() {
    return getMainScene() ? cur_layer_type : MLT_INVALID;
}

Node* MainSceneCtr::getCurLayer()
{
    auto main_scene = getMainScene();
    if (!main_scene) {
        return NULL;
    }
    
    return main_scene->cur_main_layer;
}


void MainSceneCtr::onExit()
{
    vec_keep_layer.clear();
    map_keep_buffer.clear();
    TownSceneCtr::onExit();
}

float MainSceneCtr::getMenuScaleHeight() {
    MainScene* main_scene = getMainScene();
    if (!main_scene) {
        return 0;
    }
    
    float scale_y = 1;
    float d_wth = (float)Game::instance()->d_wth;
    if (d_wth < 150) {
        scale_y = d_wth / 150;
    }
    
    Vector<Node *> vec_item = main_scene->menu_scale->getChildren();
    if ( vec_item.size() > 0 ) {
        UIMenuItemScale* item = (UIMenuItemScale*)vec_item.at(0);
        float height = item->getContentSize().height * item->getOScale() * 1.5;
        float win_height = Director::getInstance()->getWinSize().height;
        // CCLOG("getMenuScaleHeight: %f", (height - (win_height * 0.5 - (win_height * 0.5) * scale_y)) / scale_y);
        return (height - (win_height * 0.5 - (win_height * 0.5) * scale_y)) / scale_y;
    }
    return 0;
}

float MainSceneCtr::getBottomHeight()
{
    MainScene* main_scene = getMainScene();
    if (!main_scene) {
        return 0;
    }
    Vector<Node *> vec_item = main_scene->menu_scale->getChildren();
    if ( vec_item.size() > 0 ) {
        UIMenuItemScale* item = (UIMenuItemScale*)vec_item.at(0);
        float height = item->getContentSize().height * item->getOScale() * 1.5;
        // CCLOG("getBottomHeight: %f", height);
        return height;
    }
    return 0;
}


void MainSceneCtr::visibleMenuScale(bool b)
{
    MainScene* main_scene = getMainScene();
    if (!main_scene) {
        return;
    }
    main_scene->menu_scale->setVisible(b);
}

void MainSceneCtr::relogin() {
//        BattleSceneCtr::instance()->relogin();
}

void MainSceneCtr::changeLayer(MainLayerType layer_type) {
    if (is_changing) {
        resetScaleBtn();
        return;
    }
    is_changing = true;
    
    float delay = 0.14f;
    Scheduler* scheduler = Director::getInstance()->getScheduler();
    scheduler->schedule(schedule_selector(MainSceneCtr::resetChangeAct), this, delay + 0.03, 0, 0, false);
    
    CSJson::Value json;
    json["layer_type"] = layer_type;
    auto is_change = LuaManager::instance()->executeGlobalBoolFunctionReturn("didchangeMainSceneLayer", json);
    
    if (!is_change) {
        resetScaleBtn();
        return;
    }
    
    MainScene* main_scene = getMainScene();
    if (!main_scene) {
        return;
    }

    
    MainLayerType tmp_type = cur_layer_type;
    cur_layer_type = layer_type;
    
    resetScaleBtn();
    
//    main_scene->cur_main_layer = main_scene->getChildByTag(-10000);
    
    Size win_size = Director::getInstance()->getWinSize();
    int action_dir = cur_layer_type > tmp_type ? -1 : 1;    // 层切换方向，-1向左
    auto is_fast_change = main_scene->cur_main_layer == NULL;
    
    // 切换层
    // 先执行当前层移动到界面以外并释放
    Node* tmp_main_layer = main_scene->cur_main_layer;
    if (main_scene->cur_main_layer) {
        main_scene->cur_main_layer = NULL;
        
        tmp_main_layer->stopActionByTag(100);
        auto act_remove = Sequence::createWithTwoActions(MoveTo::create(delay,
                                                                        Point(win_size.width * action_dir + win_size.width / 2,
                                                                              win_size.height / 2)),
                                                         CallFuncN::create(CC_CALLBACK_1(MainSceneCtr::removeActionEnd, this)));
        act_remove->setTag(100);
        tmp_main_layer->runAction(act_remove);
        main_scene->cur_main_layer = NULL;
    }
//    (schedule_selector(GuideCtr::stopWaitTouchTarget), this, delay, false);
    
    main_scene->cur_main_layer = (MSLayerBase*)getKeepBuffer(layer_type);
    
    if (!main_scene->cur_main_layer) {
        CSJson::Value json;
        json["layer_type"] = cur_layer_type;
        main_scene->cur_main_layer = (MSLayerBase*)LuaManager::instance()->executeGlobalNodeFunctionReturn("changeMainSceneLayer", json);
    }
    
    if (!main_scene->cur_main_layer) {
        // 创建目标层向左移动到界面中央
        switch (cur_layer_type) {
            case MLT_BATTLE:
//                main_scene->cur_main_layer = MSLBattle::create();
                break;
            default:
                break;
        }
    }
    
    if (!main_scene->cur_main_layer) {
        return;
    }

    // log("%lld", Maths::getDays(1524745978));
    if (isKeepLayer(cur_layer_type) && !getKeepBuffer(cur_layer_type)) {
        addKeepBuffer(cur_layer_type, main_scene->cur_main_layer);
    }
    
    //    float d_wth = (float)Game::instance()->d_wth;
    //    if (d_wth < 150) {
    ////        main_scene->cur_main_layer->setScale(d_wth / 150);
    //
    //        main_scene->cur_main_layer->setScaleX(win_size.width / main_scene->cur_main_layer->getContentSize().width);
    //        main_scene->cur_main_layer->setScaleY(d_wth / 150);
    //    }
    if (!main_scene->cur_main_layer->getParent())
    {
        main_scene->addChild(main_scene->cur_main_layer);
        main_scene->cur_main_layer->setIgnoreAnchorPointForPosition(false);
        main_scene->cur_main_layer->setAnchorPoint(Vec2(0.5, 0.5));
    }
    
    if (is_fast_change) {
        main_scene->cur_main_layer->setPosition(Point(win_size.width / 2,
                                                      win_size.height / 2 + 20));
    } else {
        main_scene->cur_main_layer->setPosition(Point(-win_size.width * action_dir + win_size.width / 2,
                                                      win_size.height / 2 + 20));
        main_scene->cur_main_layer->stopActionByTag(100);
        main_scene->cur_main_layer->stopActionByTag(101);
        auto act_in = Sequence::create(Show::create(),
                                       MoveTo::create(delay, Point(win_size.width / 2,
                                                                   win_size.height / 2 + 20)),
                                       NULL);
        act_in->setTag(101);
        main_scene->cur_main_layer->runAction(act_in);
    }

    
    main_scene->tmp_main_layer = tmp_main_layer;
    tmp_layer_type = tmp_type;
    
    json["layer_type"] = cur_layer_type;
    LuaManager::instance()->executeGlobalBoolFunctionReturn("changeMainSceneLayerEnd", json);
}

void MainSceneCtr::resetChangeAct(float dt)
{
    is_changing = false;
}

bool MainSceneCtr::isChaning() {
    return is_changing;
}

#pragma mark ----- 界面切换逻辑  -----
// 界面切换逻辑
void MainSceneCtr::addKeepLayer(MainLayerType type)
{
    auto layer_type = std::find(vec_keep_layer.begin(), vec_keep_layer.end(), type);
    if (layer_type == vec_keep_layer.end()) {
        vec_keep_layer.push_back(type);
    }
    
    auto main_scene = getMainScene();
    if (!main_scene || cur_layer_type != type || !main_scene->cur_main_layer) {
        return;
    }
    
    addKeepBuffer(type, main_scene->cur_main_layer);
}

void MainSceneCtr::removeKeepLayer(MainLayerType type)
{
    auto iter_type = std::find(vec_keep_layer.begin(), vec_keep_layer.end(), type);
    if (iter_type != vec_keep_layer.end()) {
        vec_keep_layer.erase(iter_type);
    }
    
    auto iter_node = map_keep_buffer.find(type);
    if (iter_node != map_keep_buffer.end()) {
        auto layer = iter_node->second;
        map_keep_buffer.erase(iter_node);
        
        auto main_scene = getMainScene();
        if (!main_scene || cur_layer_type == type || !layer) {
            return;
        }
        layer->removeFromParent();
    }
}

bool MainSceneCtr::isKeepLayer(MainLayerType type) {
    return std::find(vec_keep_layer.begin(), vec_keep_layer.end(), type) != vec_keep_layer.end();
}

void MainSceneCtr::clearKeepLayer()
{
    vec_keep_layer.clear();
}

void MainSceneCtr::addKeepBuffer(MainLayerType type, Node* node)
{
    auto iter_node = map_keep_buffer.find(type);
    if (iter_node == map_keep_buffer.end()) {
        map_keep_buffer[type] = node;
    }
}

Node* MainSceneCtr::getKeepBuffer(MainLayerType type)
{
    auto iter_node = map_keep_buffer.find(type);
    if (iter_node == map_keep_buffer.end()) {
        return NULL;
    }
    return iter_node->second;
}

MainLayerType MainSceneCtr::getKeepNodeType(Node* node)
{
    for (auto iter = map_keep_buffer.begin(); iter != map_keep_buffer.end(); ++iter)
    {
        if (iter->second == node) {
            return iter->first;
        }
    }
    return MLT_INVALID;
}


void MainSceneCtr::removeActionEnd(Node* node)
{
//    auto main_scene = getMainScene();
//    if (main_scene && main_scene->cur_main_layer == node) {
//        main_scene->cur_main_layer = NULL;
//    }
    
    auto type = getKeepNodeType(node);
    if (type == MLT_INVALID) {
        node->removeFromParent();
        return;
    }
    node->setVisible(false);
}

#pragma mark ----- 主界面设置体力 金币 钻石 经验-----
void MainSceneCtr::setBattle(int32_t from, int32_t to) {
    MainScene* main_scene = getMainScene();
    
    //    int d = (int)abs(to - from) / 2;
    //    float duration = 0.033 * d;
    //
    //    if (duration < 0.2) {
    //        duration = 0.2;
    //    } else if (duration > 1) {
    //        duration = 1.4;
    //    }
    //    main_scene->lbl_energy->runActionFromTo(from, to, duration);
    if (!main_scene) {
        return;
    }
    main_scene->lbl_attack->setString(StringUtils::format("%d", to));
}

void MainSceneCtr::setGold(int64_t from, int64_t to) {
    MainScene* main_scene = getMainScene();
    if (!main_scene) {
        return;
    }
    main_scene->lbl_gold->setString(StringUtil::convertScientific(to));
}

void MainSceneCtr::setGem(int32_t from, int32_t to) {
    MainScene* main_scene = getMainScene();
    if (!main_scene) {
        return;
    }
    main_scene->lbl_gem->setString(StringUtil::convertIntScientific(to));
}

void MainSceneCtr::setLevel(int32_t level) {
    Player::instance()->level = level;
    
    MainScene* main_scene = getMainScene();
    if (!main_scene) {
        return;
    }
    main_scene->lbl_level->setString(StringUtils::format("%d", level));
//
//    RoleData::instance()->achievement_data.updateProgress(AID_ROLE_LEVEL, level);
}


void MainSceneCtr::setExp(int32_t level, int32_t exp) {
    //MainScene* main_scene = getMainScene();
    MainScene* main_scene = getMainScene();
    if (main_scene) {
//        Player* player = Player::instance();
        int32_t max_level = MainLevelTable::instance()->getMaxLevel();
        int32_t max_exp = MainLevelTable::instance()->getConfig(MIN(level, max_level - 1))->exp;
        
        main_scene->progress_exp->setPercentage(1.0 * exp / max_exp * 100);
        //        main_scene->lbl_exp->setString(StringUtils::format("%d/%d", exp, max_exp));
        main_scene->lbl_level->setString(StringUtils::format("%d", level));
        Player::instance()->level = level;
    }
}

void MainSceneCtr::setNick(string nick) {
    MainScene* main_scene = getMainScene();
    if (main_scene) {
        main_scene->lbl_role_nick->setString(nick);
    }
}

#pragma mark ----- 主界面按钮响应 -----
void MainSceneCtr::addEnergy(cocos2d::Ref *pSender) {
//    EnergyRestoreCtr::instance()->open();
}

void MainSceneCtr::addGold(cocos2d::Ref *pSender) {
    CCLOG("add gold");
}

void MainSceneCtr::addGem(cocos2d::Ref *pSender) {
    if (getCurLayerType() == MLT_BATTLE_BEFALL_ROOM_LIST || getCurLayerType() == MLT_BATTLE_BEFALL_ROOM_INFO) {
        //MessageView::instance()->add("副本房间无法进行此操作");
        return;
    }
    changeLayer(MLT_SHOP_GEM);
}

void MainSceneCtr::onRoleInfo(cocos2d::Ref *pSender) {
    ReqPlayerInfo req_player_info;
    req_player_info.player_id = Player::instance()->role_id;
    NetManager::instance()->send(&req_player_info, sizeof(req_player_info));
}

void MainSceneCtr::onPub(cocos2d::Ref *pSender) {
    changeLayer(MLT_MAIN_CITY);
}

void MainSceneCtr::onRole(cocos2d::Ref *pSender) {
    changeLayer(MLT_ROLE);
}

void MainSceneCtr::onMainPage(cocos2d::Ref *pSender) {
    changeLayer(MLT_MAIN_PAGE);
}

void MainSceneCtr::onBattle(cocos2d::Ref *pSender) {
    changeLayer(MLT_BATTLE);
}

void MainSceneCtr::onClan(cocos2d::Ref *pSender) {
    changeLayer(MLT_CLAN_SYNTHESIS);
//    changeClanLayer(CSLT_INVALID, true);
//
//    MSLClanSynthesis* synthesis_layer = (MSLClanSynthesis*)getMainScene()->cur_main_layer;
//    if ( synthesis_layer->cur_layer_type == CSLT_CLAN ) {
//        MSLClan* clan_layer = (MSLClan*)synthesis_layer->cur_layer;
//        clan_layer->clan_data = Player::instance()->clan;
//        clan_layer->updateLayer();
//    }
}

void MainSceneCtr::onOther(cocos2d::Ref *pSender) {
//    auto item = (UIMenuItemScale*)pSender;
//    item->setChecked(false);
    changeLayer(MLT_DRAGON);
}

void MainSceneCtr::onSkin(Ref* pSender) {
    
    changeLayer(MLT_SKIN);
}

#pragma mark ----- 主界面战斗模块按钮响应 -----

void MainSceneCtr::onBattleMission(Ref* pSender)
{
//    if ( ! getMainScene() || getCurLayerType() != MLT_BATTLE) {
//        return;
//    }
//    MSLBattle* battle_layer = (MSLBattle*)getMainScene()->cur_main_layer;
//
//    if (battle_layer->battle_type == MSLBT_MAIN_MISSION_BATTLE) {
//        MessageView::instance()->add("正在战斗中。");
//        return;
//    }
//
//    UIMenuItemMission* item = (UIMenuItemMission*)pSender;
//    auto role_data = RoleData::instance();
//    int32_t status = role_data->chapter_data.getMissionStatus(item->idx);
//    if (status < 0)
//    {
//        MessageView::instance()->add("需要通关上一关卡");
//        return;
//    }
    
    // 选择挂机区域
//    auto menu_mission = (UIMenuBackpack*)item->getParent();
//    menu_mission->unselectAll();
//    item->setSelected(true);
    
    //    auto role_data = RoleData::instance();
    //    role_data->chapter_data.setNowChapterID(item->chapter_id);
    //    role_data->chapter_data.setNowMissionID(item->mission_id);
//    role_data->chapter_data.changeNowMission(item->idx);
}

void MainSceneCtr::onBattleMissionDone(vector<int64_t> vec_hero)
{
//    if ( ! getMainScene() || getCurLayerType() != MLT_BATTLE || vec_hero.size() <= 0) {
//        return;
//    }
//    MSLBattle* battle_layer = (MSLBattle*)getMainScene()->cur_main_layer;
//    auto role_data = RoleData::instance();
//    role_data->chapter_data.setBattleTeam(vec_hero);
    
//    LuaManager::instance()->handleEvent(this, "setBattleTeam", [&](LuaStack* ls) {
//        CSJson::Value json_list;
//        auto vec_battle_role = getBattleRoleByTeam(team);
//        if (vec_battle_role) {
//            for (auto iter = vec_battle_role->begin(); iter != vec_battle_role->end(); ++iter)
//            {
//                json_list.append(StringUtils::format("%lld", (*iter)->role_id));
//            }
//        }
//        CSJson::FastWriter writer;
//        string str_ability = writer.write(json_list);;
//        return str_ability;
//        return 1;
//    });
    
//    auto iter_hero = std::find_if(vec_hero.begin(), vec_hero.end(), [](const int64_t& hero_id){
//        return hero_id != 0;
//    });
//
//    if (iter_hero == vec_hero.end()) {
//        MessageView::instance()->add("战斗队伍不能为空");
//        return;
//    }
//
//    // 停止挂机逻辑更新
//    battle_layer->stopActionByTag(999);
//    battle_layer->battle_type = MSLBT_MAIN_MISSION_BATTLE;
//    battle_layer->updateMissionBattle();
//    battle_layer->updateLayer();
}


void MainSceneCtr::onMissionBattle(Ref* pSender)
{
//    if ( ! getMainScene() || getCurLayerType() != MLT_BATTLE ) {
//        return;
//    }
//
//    MSLBattle* battle_layer = (MSLBattle*)getMainScene()->cur_main_layer;
//    if (battle_layer->battle_type == MSLBT_MAIN_BATTLE) {
//        auto role_data = RoleData::instance();
//        int32_t status = role_data->chapter_data.getBattleStatus(role_data->chapter_data.getNowIdx(), Player::instance()->level);
//
//        if (status == -1) {
//            MessageView::instance()->add("错误的关卡信息");
//            return;
//        } else if (status == -2) {
//            MessageView::instance()->add("战斗力不足");
//            return;
//        } else if (status == -3) {
//            MessageView::instance()->add("等级不足");
//            return;
//        }
//
//        LuaManager::instance()->handleEvent(battle_layer, "onSelectBattleHero", [&](LuaStack* ls) {
//            return 0;
//        });
////            auto role_data = RoleData::instance();
////            auto& heros = Player::instance()->heros;
////
////            vector<int64_t> vec_selected = role_data->chapter_data.getBattleTeam();
////            if (vec_selected.size() < 6) {
////                for (int i = (int32_t)vec_selected.size(); i < 6; i++) {
////                    vec_selected.push_back(0);
////                }
////            }
////
////
////            vector<int64_t> vec_heros = heros.getAllHeros();
////            HeroSelectCtr::instance()->open("英雄出战",
////                                            "出战",
////                                            vec_selected,
////                                            vec_heros,
////                                            NULL,
////                                            CC_CALLBACK_1(MainSceneCtr::onBattleMissionDone, this));
//
//    } else if (battle_layer->battle_type == MSLBT_MAIN_MISSION_BATTLE) {
//        MessageView::instance()->add("正在战斗中。");
//    }
}

// 点击队伍按钮
void MainSceneCtr::onIdleTeam(Ref* pSender)
{
//    if ( ! getMainScene() || getCurLayerType() != MLT_BATTLE) {
//        return;
//    }
//
//    MSLBattle* battle_layer = (MSLBattle*)getMainScene()->cur_main_layer;
//    LuaManager::instance()->handleEvent(battle_layer, "onSelectIdleHero", [&](LuaStack* ls) {
//        return 0;
//    });
    
//    auto role_data = RoleData::instance();
//    auto& heros = Player::instance()->heros;
//    vector<int64_t> vec_selected = role_data->chapter_data.getIdleTeam();
//
//    if (vec_selected.size() < 20) {
//        for (int i = vec_selected.size(); i < 20; i++) {
//            vec_selected.push_back(0);
//        }
//    }
//
//    vector<int64_t> vec_heros = heros.getAllHeros();
//    HeroSelectCtr::instance()->open("挂机阵容",
//                                    "保存阵容",
//                                    vec_selected,
//                                    vec_heros,
//                                    NULL,
//                                    CC_CALLBACK_1(MainSceneCtr::onIdleTeamSave, this));
}

void MainSceneCtr::onIdleTeamSave(vector<int64_t> vec_hero)
{
//    if ( ! getMainScene() || getCurLayerType() != MLT_BATTLE || vec_hero.size() <= 0) {
//        return;
//    }
//    //    MSLBattle* battle_layer = (MSLBattle*)getMainScene()->cur_main_layer;
//    auto role_data = RoleData::instance();
//    role_data->chapter_data.setIdleTeam(vec_hero);
}


void MainSceneCtr::onIldeItemReward(Ref* pSender)
{
//    auto& chapter_data = RoleData::instance()->chapter_data;
//    auto now_time = Game::instance()->getServerTime();
//    if (now_time - chapter_data.getResRewardTime() < 5) {
//        return;
//    }
//    chapter_data.setResRewardTime(now_time);
//
//    chapter_data.setExp(0);
//    chapter_data.setGoldNum(0);
//    chapter_data.setHeroExp(0);
//
//    ReqChapterItemReward req_item_reward;
//    NetManager::instance()->send(&req_item_reward, sizeof(req_item_reward));
//
//    if ( ! getMainScene() || getCurLayerType() != MLT_BATTLE) {
//        return;
//    }
//    MSLBattle* battle_layer = (MSLBattle*)getMainScene()->cur_main_layer;
//    battle_layer->updateReward();
}


void MainSceneCtr::onChapterWorld(Ref* pSender)
{
//    if ( ! getMainScene() || getCurLayerType() != MLT_BATTLE) {
//        return;
//    }
//    MSLBattle* battle_layer = (MSLBattle*)getMainScene()->cur_main_layer;
//
//    if (battle_layer->battle_type == MSLBT_MAIN_MISSION_BATTLE) {
//        MessageView::instance()->add("正在战斗中。");
//        return;
//    }
//
//    LuaManager::instance()->handleEvent(battle_layer, "onChapterWorld", [&](LuaStack* ls) {
//        return 0;
//    });
}

#pragma mark ----- 综合模块-----
void MainSceneCtr::onChangeLayer(MainLayerType layer_type) {
    changeLayer(layer_type);
}

void MainSceneCtr::onChat(Ref *pSender) {
//    ChatCtr::instance()->open();
//    ChatCtr::instance()->onVisible(true);
}

void MainSceneCtr::onFriend(Ref *pSender) {
//    FriendCtr::instance()->open();
}

void MainSceneCtr::setFriendShip(int32_t num) {
//    RoleData::instance()->friends_data.friend_ship_num = num;
//    FriendCtr::instance()->updateFriendNum();
}


void MainSceneCtr::onBuyGemLua(Ref* pSender) {
    LuaManager::instance()->executeGlobalAutoFunction("onBuyGem", [&](LuaStack * ls) {
        return 0;
    });
}

void MainSceneCtr::onBuyGoldLua(Ref* pSender) {
    LuaManager::instance()->executeGlobalAutoFunction("onBuyGold", [&](LuaStack * ls) {
        return 0;
    });
}

void MainSceneCtr::onRoleLua(Ref* pSender) {
    LuaManager::instance()->executeGlobalAutoFunction("onRole", [&](LuaStack * ls) {
        return 0;
    });
}


void MainSceneCtr::createTouch(Vec2 tp) {
    auto point = Director::getInstance()->convertToUI(tp);
    Touch touch_begin;
    touch_begin.setTouchInfo(0, point.x, point.y);
    vector<Touch*> vec_begin;
    vec_begin.push_back(&touch_begin);
    
    EventTouch event_touch_begin;
    event_touch_begin.setEventCode(EventTouch::EventCode::BEGAN);
    event_touch_begin.setTouches(vec_begin);
    
    Director::getInstance()->getEventDispatcher()->dispatchEvent(&event_touch_begin);
    event_touch_begin.setEventCode(EventTouch::EventCode::ENDED);
    event_touch_begin.setTouches(vec_begin);
    Director::getInstance()->getEventDispatcher()->dispatchEvent(&event_touch_begin);
}

void MainSceneCtr::onFriendChat(int64_t player_id)
{
//    ChatCtr::instance()->open();
//    ChatCtr::instance()->friendChat(player_id);
}

void MainSceneCtr::resetScaleBtn() {
    MainScene* main_scene = getMainScene();
    if (!main_scene) {
        return;
    }
    MainLayerType tmp_type = cur_layer_type;
    if (cur_layer_type / 100000 != tmp_type % 100000) {
        auto num = cur_layer_type / 100000;
        auto btn_target = main_scene->menu_scale->getChildByTag(num * 10 + num);
        Vector<Node*>& vec_children = main_scene->menu_scale->getChildren();
        for (auto child : vec_children) {
            UIMenuItemScale* item = dynamic_cast<UIMenuItemScale*>(child);
            if (!child) {
                continue;
            }
            item->setChecked(item == btn_target);
        }
    }
}


void MainSceneCtr::reloadConfig()
{
    for (int i = 0; i < 20; i++)
    {
        reloadConfigOne(i);
    }
}

// 这个函数以后会废弃掉。所以添加一个变量控制加载那一个表
void MainSceneCtr::reloadConfigOne(int32_t type)
{
//    LanguageTable::instance()->reload();
////
//    SystemTable::instance()->reload();
//    HeroSkillTable::instance()->reload();
//    HeroElemMulTable::instance()->reload();
//    ArtTable::instance()->reload();
//    HeroSkillTable::instance()->reload();
//    HeroTypeTable::instance()->reload();
//    BuffTable::instance()->reload();
//    if (type == 1) {
//        HeroElemMulTable::instance()->reload();
//    }
//
    if (type == 2) {
        SystemTable::instance()->reload();
    }
    
//    if (type == 3) {
//        HeroSkillTable::instance()->reload();
//    }
//
//    if (type == 4) {
//        BuffTable::instance()->reload();
//    }
    
//    if (type == 5) {
//        ArtTable::instance()->reload();
//    }
    
//    FileUtils::getInstance()->writeStringToFile(<#const std::string &dataStr#>, <#const std::string &fullPath#>)
//    if (type == 7) {
//        HeroTypeTable::instance()->reload();
//    }
//
    if (type == 8) {
        LanguageTable::instance()->reload();
    }
    
    
//    // 检查技能表是否正确
//    for (auto iter_skill = HeroSkillTable::instance()->table.begin(); iter_skill != HeroSkillTable::instance()->table.end(); ++iter_skill)
//    {
//        for (auto iter_art = iter_skill->second.art_list.begin(); iter_art != iter_skill->second.art_list.end(); ++iter_art)
//        {
//            auto iter_art_id =  ArtTable::instance()->table.find(*iter_art);
//            if (iter_art_id == ArtTable::instance()->table.end()) {
//                log("iter_art = %d", *iter_art);
//                continue;
//            }
//        }
//    }
//
//    for (auto iter_art = ArtTable::instance()->table.begin(); iter_art != ArtTable::instance()->table.end(); ++iter_art)
//    {
//        for (auto iter_buff = iter_art->second.vec_buff.begin(); iter_buff != iter_art->second.vec_buff.end(); ++iter_buff)
//        {
//            auto iter_buff_id =  BuffTable::instance()->table.find(*iter_buff);
//            if (iter_buff_id == BuffTable::instance()->table.end()) {
//                log("iter_buff_id = %d", *iter_buff);
//                continue;
//            }
//        }
//    }

//    BuffLevelTable::instance()->reload();
//    MainMissionRewardTable::instance()->reload();
}


void MainSceneCtr::renameDone()
{
    RoleData::instance()->is_role_rename = true;
}
