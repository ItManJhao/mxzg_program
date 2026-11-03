//
//  Hero.cpp
//  AVT
//
//  Created by Conix on 16-3-2.
//
//

#include "Hero.h"
#include "../Ctrl/Scene/MainSceneCtr.h"

#include "../Data/RoleData.h"

#include "../Comp/MessageView.h"
#include "../Config/LanguageTable.h"
#include "../Config/SystemTable.h"
#include "../Animation/CCActionExt.h"

//#include "SkeletonAnimation.h"


using namespace spine;

#pragma mark ------Hero------

Hero::Hero()
: spine_hero(NULL)
, spr_shadow(NULL)
, spr_elem(NULL)
, hp_progress(NULL)
, hp_bg_sprite(NULL)
, menu_buff_icon(NULL)
{
    x = -1;
    y = -1;
    
    lbl_level = NULL;
    hp_progress = NULL;
    hp_bg_sprite = NULL;
    
    anger_progress = NULL;
    anger_bg_sprite = NULL;
    
    damage_time = 0;
    tip_time = 0;

    is_show_direction = false;
    is_show_damaged = false;
    is_flipped_x = false;
    is_show_damage = true;
    is_run_action = true;
    
    skin = 0;
}

Hero::Hero(int64_t hero_id, int64_t role_id, int32_t type, int32_t level, int32_t star, int32_t skin)
: spr_shadow(NULL)
, spr_elem(NULL)
, hp_progress(NULL)
, hp_bg_sprite(NULL)
, menu_buff_icon(NULL)
{
    this->item_id = hero_id;
    this->role_id = role_id;
    
    this->type = type;
    this->level = level;
    this->star = star;
    this->skin = skin;
    x = -1;
    y = -1;
    
    lbl_level = NULL;
    spine_hero = NULL;
    hp_progress = NULL;
    hp_bg_sprite = NULL;
    
    anger_progress = NULL;
    anger_bg_sprite = NULL;
    
    node_attack_name = nullptr;
    damage_time = 0;
    tip_time = 0;

    is_show_direction = false;
    is_flipped_x = false;
    is_run_action = true;
    is_show_damaged = false;
//    CCASSERT(type_config != NULL, StringUtils::format("no hero type config with hero type %d", type).c_str());
//    CCASSERT(level_config.type > 0, StringUtils::format("no hero level config with hero type %d and level %d, star %d", type, level, star).c_str());
    
    setEnabled(true);
}

Hero* Hero::create(int64_t hero_id, int64_t role_id, int32_t hero_type, int32_t level, int32_t star, int32_t skin) {
    Hero* ret = new(std::nothrow)Hero(hero_id, role_id, hero_type, level, star, skin);
    
    if (ret && ret->init()) {
        ret->autorelease();
        ret->initHero();
    } else {
        delete ret;
        ret = NULL;
    }
    return ret;
}

void Hero::setSelected(bool b) {
    Unit::setSelected(b);
}

void Hero::initHero() {
    SpriteFrameCache* sfc = SpriteFrameCache::getInstance();
    sfc->addSpriteFramesWithFile("hero/hero.plist");
    
    
    setHeroAnimationByType(this->skin != 0 ? this->skin : type);
    
    // 计算这个item 的锚点
//    float offset = getContentSize().height * 0.5 - 0 * 0.5;
//    float anchPonint_y = static_cast<float>((getContentSize().height * 0.5 - offset)) / getContentSize().height;
//    setAnchorPoint(Vec2(0.5, anchPonint_y));
    
    // 添加阴影  先注释掉
    setShadowVisible(true);
    
    //  释放技能时  显示技能名字
    node_attack_name = Node::create();
    node_attack_name->setPosition(Vec2(getContentSize().width * 0.5f, getContentSize().height));
    addChild(node_attack_name, 1);
    
    
    menu_buff_icon = UIMenu::create();
    menu_buff_icon->setPosition(Vec2::ZERO);
    addChild(menu_buff_icon, 1);
    
    // stand();
}

void Hero::update(float delay) {
    CCLOG("英雄更新");
}

void Hero::setShadowVisible(bool v) {
    if (spr_shadow) {
        spr_shadow->removeFromParentAndCleanup(true);
        spr_shadow = NULL;
    }
    if (v) {
        spr_shadow = Sprite::createWithSpriteFrameName("hero/hero-shadow.png");
        spr_shadow->setPosition(getContentSize().width / 2, 0);
        spr_shadow->setScale(0.7);
        addChild(spr_shadow, -10);
    }
}

void Hero::setFlippedX(bool flippedX) {
    is_flipped_x = flippedX;
    if (spine_hero) {
        // 英雄的方向跟逻辑方向是反的
        spine_hero->getSkeleton()->flipX = !is_flipped_x;
    }
}

bool Hero::isFlippedX() {
    return is_flipped_x;
}


void Hero::setHeroAnimationByType(int32_t type) {
    // spine动画
    string str_tmp = StringUtils::format("spine/%d", type);
    if ( ! FileUtils::getInstance()->isFileExist(str_tmp + ".json") ) {
        str_tmp = "spine/10104004";
    }
    
    //    createWithFile
    //    spine_hero = SkeletonAnimation::createWithJsonFile(StringUtils::format("%s.json", str_tmp.c_str()),
    //                                                       StringUtils::format("%s.atlas",str_tmp.c_str()),
    //                                                          0.5f);
    //    auto texture = Director::getInstance()->getTextureCache()->addImage(StringUtils::format("%s.png",str_tmp.c_str()));
    //    texture->setAntiAliasTexParameters();
//    this->setRotation()
    
    auto spine_hero = SkeletonAnimation::createWithJsonFile(StringUtils::format("%s.json", str_tmp.c_str()),
                                                            StringUtils::format("%s.atlas",str_tmp.c_str()),
                                                            0.5f);
    spine_hero->setAnimation(0, "stand", true);
    spine_hero->update(0.1 * (rand() % 30));    // 错开呼吸时间.
//    addChild(spine_hero);
    
    spine_hero->setMix("stand", "attack", 0.2f);
    spine_hero->setMix("stand", "hit", 0.2f);
    spine_hero->setMix("attack", "stand", 0.2f);
    spine_hero->setMix("attack", "hit", 0.2f);
    spine_hero->setMix("hit", "stand", 0.2f);
    spine_hero->setMix("hit", "attack", 0.2f);

    setContentSize(Size(140, 120));
    spine_hero->setPosition(getContentSize().width * 0.5, 0);
    setAnimationNode(spine_hero);
}


void Hero::setAnimationNode(SkeletonAnimation* node) {
    if (spine_hero) {
        spine_hero->removeFromParent();
        spine_hero = NULL;
    }
    spine_hero = node;
    if (spine_hero) {
        addChild(spine_hero);
        resetTimeScale();
    }
}

SkeletonAnimation* Hero::getAnimationNode() {
    return spine_hero;
}

void Hero::resetTimeScale() {
    if (spine_hero) {
        spine_hero->setScheduler(getScheduler());
        spine_hero->setActionManager(getActionManager());
    }
}

spTrackEntry* Hero::setAnimation (int trackIndex, const std::string& name, bool loop)
{
    if (spine_hero) {
        return spine_hero->setAnimation(trackIndex, name, loop);
    }
    return NULL;
}

spTrackEntry* Hero::addAnimation (int trackIndex, const std::string& name, bool loop, float delay)
{
    if (spine_hero) {
        return spine_hero->addAnimation(trackIndex, name, loop, delay);
    }
    return NULL;
}

void Hero::setShader(ShaderType shader_type, bool loop, const std::string& name, bool time_scale)
{
    auto gl = ShaderFactory::instance()->getGLProgram(shader_type);
    if (gl && spine_hero) {
        spine_hero->setGLProgram(gl);
        spine_hero->setTimeScale(time_scale);
        if (name != "") {
            setAnimation(0, name, loop);
        }
    }
}

void Hero::updateZOrder(float dt) {
    int32_t z = 10000 - getPositionY();
    this->setLocalZOrder(z);
//    addAbilityTip(201, z);
//    Node *parent = getParent();
//
//    if (parent != nullptr) {
//
//        // localZOrder 下面的单位 > 上边的单位  右边的单位 > 左边的单位
////        t_int32 z = 100000 - y * 1000 + 10 * x;
//        int32_t z = 10000 - getPositionY();
//        parent->reorderChild(this, z);
//    }
}

void Hero::startUpdateZOrder() {
    schedule(CC_SCHEDULE_SELECTOR(Hero::updateZOrder), 0.1f);
}

void Hero::stopUpdateZOrder(int32_t z) {
    unschedule(CC_SCHEDULE_SELECTOR(Hero::updateZOrder));
    this->setLocalZOrder(z);
}

void Hero::stand() {
    // spine动画设置为stand状态
    setAnimation(0, "stand", true);
}

void Hero::attack() {
    setAnimation(0, "attack", false);
    addAnimation(0, "stand", true, 0.8);
}

void Hero::die(Unit *killer) {
//    return;
    
//    //  更新地图
//    MapManager& map_manager = RoleData::instance()->map_manager;
//    map_manager.updateMap(GridPoint(x, y), 0);
    
//    setVisible(false);
    
//    spine_hero->setAnimation(0, "die", false);
    auto act_spine_die = Sequence::create(DelayTime::create(0.2),
                                          FadeTo::create(0.8, 0),
                                          NULL);
    act_spine_die->setTag(900);
    spine_hero->runAction(act_spine_die);
    
    
    auto act_hero_die = Sequence::create(DelayTime::create(1),
                                         Hide::create(),
                                         NULL);
    act_hero_die->setTag(900);
    runAction(act_hero_die);
    
    Unit::die(killer);
}

void Hero::beattack(const int64_t& attacker,
                    const int& buff_type,
                    const int& damage,
                    const int32_t& damage_type,
                    const int& hp_new,
                    const int& elem_type,
                    bool is_critical,
                    const float& delay) {
    
    setHp(hp_new);
    
    if (!isRunAction()) {
        showHP();
        if (getHp() <= 0) {
            stopActionByTag(10);
            die(nullptr);
        }
        return;
    }
    
    if (isDie()) {
        return;
    }
    
    float reverse_scale = Game::instance()->getReverseScale();

    if (damage >= 0) {
        auto act_stop = CallFunc::create([=](){
            this->stopActionByTag(10);
            setVisible(true);
            
            auto pos = Vec2(getContentSize().width * 0.5, 0);
            float offset_x = 0;//(battle_hero->getTeam() % 2 == 0) ? 30 : -30;
            auto beattack_action = Sequence::create(MoveTo::create(0.2, Vec2(pos.x + offset_x, pos.y)),
                                                    MoveTo::create(0.1, pos),
                                                    NULL);
            beattack_action->setTag(22);
            spine_hero->stopActionByTag(22);
            spine_hero->runAction(beattack_action);
            
            if (getHp() <= 0) {
                stopActionByTag(10);
                die(nullptr);
            }
        });
        
        runAction(Sequence::create(DelayTime::create(delay), act_stop, NULL));
        
        
        setAnimation(0, "hit", false);
        addAnimation(0, "stand", true, 0.5);
        
        // 受击效果
        auto anim = ActionFactory::createAnimate("hero/hero-beattack.plist",
                                                 StringUtils::format("hero-beattack/%d-%%02d.png", elem_type).c_str(),
                                                 0.04,
                                                 NULL);
        
        Sprite* spr_beattack = Sprite::createWithSpriteFrameName(StringUtils::format("hero-beattack/%d-00.png", elem_type));
        spr_beattack->setScheduler(getScheduler());
        spr_beattack->setActionManager(getActionManager());
        spr_beattack->setPosition(getPosition() - Vec2(0, 11));
        spr_beattack->setScale(reverse_scale);
        spr_beattack->setVisible(false);
        this->getParent()->getParent()->addChild(spr_beattack, this->getLocalZOrder() + 1);
        
        spr_beattack->runAction(Sequence::create(DelayTime::create(delay), Show::create(), anim, RemoveSelf::create(), NULL));
        
        if (Game::isInVisible(this)) {
            Game::playEffect("music/beattack.wav");
        }
    }
    
    // 显示伤害
    if (is_show_damage)
    {
        DamegeData damage_data;
        damage_data.attacker = attacker;
        damage_data.buff_type = buff_type;
        damage_data.damage = damage;
        damage_data.damage_type = damage_type;
        damage_data.is_critical = is_critical;
        
//        log("damage_data.type = %d, damage_data.damage = %d", damage_data.buff_type, damage_data.damage);
        vec_damage.push_back(damage_data);
        auto act_damage = CallFunc::create(CC_CALLBACK_0(Hero::showDamage, this));
        auto act_show_hp = CallFunc::create(CC_CALLBACK_0(Hero::showHP, this));
        this->runAction(Sequence::create(DelayTime::create(delay), act_damage, act_show_hp, NULL));
    }
}

void Hero::showHP() {
    if (!hp_bg_sprite) {
        SpriteFrameCache::getInstance()->addSpriteFramesWithFile("hero/hero.plist");
        hp_bg_sprite = Sprite::createWithSpriteFrameName("hero/progress-hp-bg.png");
       // hp_bg_sprite->setAnchorPoint(Vec2(0.5, 0));
        hp_bg_sprite->setScale(0.5f);
        hp_bg_sprite->setPosition(Point(getContentSize().width * 0.5, getContentSize().height));
        addChild(hp_bg_sprite, 2);
        
        Sprite* tmp = NULL;
        if (battle_type == UNIT_FRIEND) {
            tmp = Sprite::createWithSpriteFrameName("hero/progress-hp-green.png");
        } else {
            tmp = Sprite::createWithSpriteFrameName("hero/progress-hp-red.png");
        }
        
        hp_progress = ProgressTimer::create(tmp);
        hp_progress->setType(ProgressTimer::Type::BAR);
        hp_progress->setBarChangeRate(Point(1, 0));
        hp_progress->setMidpoint(Point(0, 0));
        hp_progress->setPosition(Point(hp_bg_sprite->getContentSize().width / 2, hp_bg_sprite->getContentSize().height / 2 + 3.25));
        hp_bg_sprite->addChild(hp_progress, 0, 10000);
        
    } else {
        hp_progress->stopAllActions();
        hp_progress->setOpacity(255);
        hp_progress->setVisible(true);
    }
    
    float percentage = 100.0 * getHp() / getHpMax();
    hp_progress->setPercentage(percentage);
}

void Hero::hideHP() {
    if (hp_bg_sprite) {
        hp_bg_sprite->setVisible(false);
    }
}

void Hero::showAnger()
{
    if (!anger_bg_sprite) {
        SpriteFrameCache::getInstance()->addSpriteFramesWithFile("hero/hero.plist");
        anger_bg_sprite = Sprite::createWithSpriteFrameName("hero/progress-hp-bg.png");
        // hp_bg_sprite->setAnchorPoint(Vec2(0.5, 0));
        anger_bg_sprite->setScale(0.5f);
        anger_bg_sprite->setPosition(Point(getContentSize().width * 0.5, getContentSize().height - 10));
        addChild(anger_bg_sprite, 2);
        
        Sprite* tmp = NULL;
        tmp = Sprite::createWithSpriteFrameName("hero/progress-hp-blue.png");
        anger_progress = ProgressTimer::create(tmp);
        anger_progress->setType(ProgressTimer::Type::BAR);
        anger_progress->setBarChangeRate(Point(1, 0));
        anger_progress->setMidpoint(Point(0, 0));
        anger_progress->setPosition(Point(anger_bg_sprite->getContentSize().width / 2, anger_bg_sprite->getContentSize().height / 2 + 3.25));
        anger_bg_sprite->addChild(anger_progress, 0, 10000);
        
    } else {
        anger_progress->stopAllActions();
        anger_progress->setOpacity(255);
        anger_progress->setVisible(true);
    }
    
//    if (battle_hero)
//    {
//        float percentage = 100.0 * battle_hero->getAnger() / (SystemTable::instance()->getConfig("battle_enegry_max")->value * 10);
//        anger_progress->setPercentage(percentage);
//    }
}

void Hero::hideAnger()
{
    if (anger_bg_sprite) {
        anger_bg_sprite->setVisible(false);
    }
}

void Hero::reborn() {
    Unit::reborn();
    
    spine_hero->stopActionByTag(900);
    stopActionByTag(900);
    
    
    auto act_spine_reborn = Sequence::create(FadeTo::create(0.8, 255),
                                             NULL);
    act_spine_reborn->setTag(900);
    spine_hero->runAction(act_spine_reborn);
    
    auto act_hero_reborn = Sequence::create(Show::create(),
                                            NULL);
    act_hero_reborn->setTag(900);
    runAction(act_hero_reborn);
    
    showHP();
}



Label* Hero::showLevel(int32_t level) {
    if (!lbl_level) {
        lbl_level = Label::createWithTTF("", FONT_DEFAULT_NAME, 30);
        lbl_level->setAnchorPoint(Vec2::ANCHOR_MIDDLE_RIGHT);
        lbl_level->setPosition(getContentSize().width * 0.5 - anger_bg_sprite->getContentSize().width * 0.5 * anger_bg_sprite->getScale() - 22,
                               (hp_bg_sprite->getPositionY() + anger_bg_sprite->getPositionY()) * 0.5);
        lbl_level->enableOutline(Color4B::BLACK, 2);
        addChild(lbl_level, 2);
    }
    
    if (lbl_level) {
        lbl_level->setString(StringUtils::format("%d", level));
    }
    
    return lbl_level;
}

void Hero::hideLevel() {
    if (lbl_level) {
        lbl_level->removeFromParent();
        lbl_level = NULL;
    }
}

Sprite* Hero::showElem(int32_t elem) {
    if (!spr_elem) {
//        log("elem = %d", elem);
        SpriteFrameCache::getInstance()->addSpriteFramesWithFile("ccbi-res/hero-icon.plist");
        spr_elem = Sprite::createWithSpriteFrameName(StringUtils::format("hero-icon/elem-%d.png", elem));
        spr_elem->setPosition(getContentSize().width * 0.5 - anger_bg_sprite->getContentSize().width * 0.5 * anger_bg_sprite->getScale() - 5,
                             (hp_bg_sprite->getPositionY() + anger_bg_sprite->getPositionY()) * 0.5);
        spr_elem->setScale(30 / spr_elem->getContentSize().width);
        addChild(spr_elem, 2);
    }
    
    if (spr_elem) {
        spr_elem->setSpriteFrame(StringUtils::format("hero-icon/elem-%d.png", elem));
    }
    
    return spr_elem;
}

void Hero::hideElem() {
    if (spr_elem) {
        spr_elem->removeFromParent();
        spr_elem = NULL;
    }
}

void Hero::mergeDamage()
{
//    return;
    // 0:回血  1:伤害  2:额外伤害
    // 如果释放者一样， 伤害类型一样， bufff类型也一样。则合并伤害
    vector<DamegeData> tmp_vec_damage;
    for (auto iter = vec_damage.begin(); iter != vec_damage.end(); ++iter)
    {
        auto iter_damage = std::find_if(tmp_vec_damage.begin(), tmp_vec_damage.end(), [&](const DamegeData& data){
            return iter->attacker == data.attacker && iter->damage_type == data.damage_type && iter->buff_type == data.buff_type;
        });

        if (iter_damage != tmp_vec_damage.end()) {
            iter_damage->damage += iter->damage;
        } else {
            tmp_vec_damage.push_back(*iter);
        }
    }
    
    vec_damage = tmp_vec_damage;
}

void Hero::showDamage() {
    if (vec_damage.size() <= 0) {
        return;
    }
    
    if (!isRunAction()) {
        return;
    }
    
    float tmp_delay = 200;
    if (is_show_damaged) {
        this->stopActionByTag(-100000);
        auto seq_delay = Sequence::create(DelayTime::create(0.001 * tmp_delay),
                                          CallFunc::create(CC_CALLBACK_0(Hero::showDamage, this)),
                                          NULL);
        seq_delay->setTag(-100000);
        runAction(seq_delay);
        return;
    }
    is_show_damaged = true;
    
//    int64_t now_time = Game::instance()->getServerMillisecond();
//    int64_t tmp_delay = 0;
//    if ( now_time - damage_time < 80 ) {
//        return;
//    } else {
//        tmp_delay = 100;
//        damage_time = now_time;
//    }
    
    mergeDamage();
    
    auto damage_data = vec_damage[0];
    vec_damage.erase(vec_damage.begin());
//    vec_damage.pop_back();
    
    int flipped_coe =  is_flipped_x ? -1 : 1;
    
//    damage_data.is_critical = true;
    // red-116.fnt
    const char* font_name = damage_data.damage_type < 0 ? "font/green-30.fnt" : "font/red-40.fnt";
    const char* damage_coe = damage_data.is_critical ? "" : (damage_data.damage_type < 0 ? "+" : "-");
    Point pos_begin = this->getPosition() + Point(flipped_coe * -25, getContentSize().height - 50);
    
    float offset_x = 0;
    Node* node_damage = Label::createWithBMFont(font_name, StringUtils::format("%s%d", damage_coe, abs(damage_data.damage)));
    // node_damage->setScale(1);
    // getParent()->getParent()->addChild(lbl_damage, 100);
    int32_t offset_y = 0;
    if (damage_data.is_critical && damage_data.damage > 0)
    {
        // log("offset_y = %f", offset_y);
        auto spr_critical_bg = Sprite::createWithSpriteFrameName("hero-beattack/spr-critical-bg.png");
        spr_critical_bg->setScale(0.7);
        node_damage->setPositionX(spr_critical_bg->getContentSize().width * 0.63 + 20);
        spr_critical_bg->addChild(node_damage);
        
        node_damage->setScale(1.0 / spr_critical_bg->getScale());
        node_damage->setAnchorPoint(Vec2::ANCHOR_MIDDLE_LEFT);
        node_damage->setPositionY(spr_critical_bg->getContentSize().height * 0.5);
        
        offset_x = spr_critical_bg->getContentSize().width * 0.5 * spr_critical_bg->getScale() + node_damage->getContentSize().width * 0.5;
        offset_x = offset_x * flipped_coe;
        node_damage = spr_critical_bg;
    } else if (damage_data.damage < 0) {
        node_damage->setScale(0.8);
        offset_y = -20;
    }
    
    node_damage->setScheduler(getScheduler());
    node_damage->setActionManager(getActionManager());
    node_damage->setPosition(pos_begin + Vec2(0, offset_y));
    getParent()->getParent()->addChild(node_damage, 100);
    
    node_damage->runAction(Sequence::create(JumpBy::create(0.3, Vec2((30) * flipped_coe, 0), 50, 1),
                                            JumpBy::create(0.3, Vec2((20) * flipped_coe, 0), 30, 1),
                                            JumpBy::create(0.3, Vec2((10) * flipped_coe, 0), 10, 1),
                                            MoveBy::create(0.7, Vec2((5 + rand() % 10) * flipped_coe, 0)),
                                            RemoveSelf::create(),
                                            NULL));
    node_damage->runAction(Sequence::create(DelayTime::create(1.4),
                                            FadeOut::create(0.2),
                                            NULL));
    
    
//    ccBezierConfig config = ccBezierConfig();
//    config.endPosition = Point(pos_begin.x + (150) * flipped_coe, pos_begin.y + 50);
//    config.controlPoint_1 = Point(pos_begin);
//    config.controlPoint_2 = Point(pos_begin.x + (60) * flipped_coe, pos_begin.y + 120);
////
//    node_damage->runAction(Sequence::create(BezierTo::create(0.8f, config),
//                                            RemoveSelf::create(),
//                                            NULL));
    
    auto resetTag = [&]() {
        this->is_show_damaged = false;
    };
    
    auto seq_delay = Sequence::create(DelayTime::create(0.001 * tmp_delay),
                                      CallFunc::create(resetTag),
                                      CallFunc::create(CC_CALLBACK_0(Hero::showDamage, this)),
                                      NULL);
    runAction(seq_delay);
}


void Hero::addAbilityTextTip(string text)
{
//    return;
    vec_tip.push_back(text);
    showAbilityTip();
}


void Hero::addAbilityTip(int32_t type, int32_t value)
{
//    return;
//    string str_tip = StringUtils::format("%d", value);
    string str_tip = StringUtils::format(LanguageTable::instance()->getLanguage(120000 + type), value);
    vec_tip.push_back(str_tip);
//    log("addAbilityTip:%s", str_tip.c_str());
    showAbilityTip();
}

void Hero::showAbilityTip()
{
    if (vec_tip.size() <= 0) {
        return;
    }
    
    if (!getParent()) {
        return;
    }
    
//    if (!getParent()->getParent()) {
//        return;
//    }
//    int64_t now_time = Game::instance()->getServerMillisecond();
//    int64_t tmp_delay = 0;
//    log("showAbilityTip = %lld", now_time - tip_time);
//
////    if (now_time - tip_time > 156700000) {
////        int aa = 0;
////        aa = 1;
////    }
//
//    if ( now_time - tip_time < 150 ) {
//        return;
//    } else {
//        tmp_delay = 200;
//        tip_time = now_time;
//    }
    if (tip_time > 0) {
        return;
    }
    
    tip_time = 1;
    
    int64_t tmp_delay = 200;
    
    
    auto tip_data = vec_tip[vec_tip.size() - 1];
    vec_tip.pop_back();
    
    Label* node_tip = Label::createWithTTF(StringUtils::format("%s", tip_data.c_str()), FONT_DEFAULT_NAME_BOLD, 30);
    node_tip->setScale(0.8);
//    node_tip->setOpacity(180);
    node_tip->enableShadow();
    node_tip->setPosition(this->getPosition() + Vec2(0, getContentSize().height - 50));
    getParent()->getParent()->addChild(node_tip, 100);
    
    node_tip->runAction(Sequence::create(MoveBy::create(1.5, Vec2(0, getContentSize().height)),
                                         RemoveSelf::create(),
                                         NULL));
    
    auto seq_reset = Sequence::create(DelayTime::create(0.02),
                                      DelayTime::create(0.001 * tmp_delay * 0.5),
                                      CallFunc::create([=](){
        this->tip_time = 0;
    }),
                                      NULL);
    node_tip->runAction(seq_reset);
    
    auto seq_delay = Sequence::create(DelayTime::create(0.02),
                                      DelayTime::create(0.02),
                                      DelayTime::create(0.02),
                                      DelayTime::create(0.02),
                                      DelayTime::create(0.02),
                                      DelayTime::create(0.02),
                                      DelayTime::create(0.02),
                                      DelayTime::create(0.02),
                                      DelayTime::create(0.001 * tmp_delay),
                                      CallFunc::create(CC_CALLBACK_0(Hero::showAbilityTip, this)),
                                      NULL);
    menu_buff_icon->runAction(seq_delay);
}


void Hero::updateBuffIcon()
{
//    if (!isRunAction()) {
//        return;
//    }
//
//    auto frame_size = Size(30, 25);
//    float begin_x = getContentSize().width * 0.5 - 30;
//    float begin_y = hp_bg_sprite->getPositionY() + 20;
//
//    auto vec_buff = battle_hero->getBuffIcon();
//
//    int32_t max_col = floor(hp_bg_sprite->getContentSize().width * 0.9 / (frame_size.width));
//    //    int32_t max_row = ceil(map_buff.size() / max_col);
//    auto& children = menu_buff_icon->getChildren();
//
//    for (int i = 0; i < children.size(); ++i)
//    {
//        auto item_skill = (UIMenuItemBuffIcon*)children.at(i);
//        item_skill->setTag(0);
//    }
//
//    int32_t index = 0;
//    for (auto iter = vec_buff.begin(); iter != vec_buff.end(); ++iter)
//    {
//        UIMenuItemBuffIcon* item_buff = NULL;
//        for (int i = 0; i < children.size(); ++i)
//        {
//            auto item_skill = (UIMenuItemBuffIcon*)children.at(i);
//            if (item_skill->caster == iter->caster && item_skill->skill_type == iter->skill_type && item_skill->icon == iter->icon) {
//                item_buff = item_skill;
//                break;
//            }
//        }
//
//        if (!item_buff) {
//            item_buff = UIMenuItemBuffIcon::create(iter->caster,
//                                                   iter->skill_type,
//                                                   iter->icon,
//                                                   iter->round,
//                                                   NULL);
//            item_buff->setScale(0.3);
//            menu_buff_icon->addChild(item_buff);
//        }
//        item_buff->setTag(1);
//        item_buff->setScale(1 / this->getScaleX(), 1 / this->getScaleY());
//        item_buff->setRound(battle_hero->getBuffStackNum(iter->caster, iter->skill_type, iter->icon));
//        item_buff->setPositionX(begin_x + (index % max_col) * frame_size.width);
//        item_buff->setPositionY(begin_y + floor(index / max_col) * frame_size.height);
//        index++;
////        log("index = %d", index);
//    }
//
//    // 删除过时的buff
//    for (int i = 0; i < children.size(); )
//    {
//        auto item_skill = (UIMenuItemBuffIcon*)children.at(i);
//        if (item_skill->getTag() <= 0) {
//            item_skill->removeFromParent();
//        } else {
//            ++i;
//        }
//    }
}

void Hero::setShowDamage(bool b)
{
    is_show_damage = b;
}

bool Hero::isShowDamage()
{
    return is_show_damage;
}


void Hero::setRunAction(bool b)
{
    is_run_action = b;
}

bool Hero::isRunAction()
{
    return is_run_action;
}

