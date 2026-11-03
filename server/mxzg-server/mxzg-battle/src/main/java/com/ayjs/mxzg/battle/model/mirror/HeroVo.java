package com.ayjs.mxzg.battle.model.mirror;

import com.alibaba.fastjson.annotation.JSONField;
import com.ayjs.mxzg.battle.model.EvolveData;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.HeroStatus;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.*;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 英雄数据
 *
 * @author meiyc
 */
@Getter
@Setter
public class HeroVo implements HeroConfig {

    /**
     * 英雄主键id
     */
    private long id;
    /**
     * 英雄id
     */
    private int heroId;
    /**
     * 英雄名字
     */
    private String name;
    /**
     * 位置
     */
    private int pos;

    /**
     * 等级
     */
    private int level;

    /**
     * 星级
     */
    private int star;

    /**
     * 等阶
     */
    private int stage;

    /**
     * 状态
     */
    private int status;

    /**
     * 皮肤id
     */
    private int fashionId;

    /**
     * 属性信息
     */
    private Map<Integer, Long> attributes;

    /**
     * 技能信息
     */
    private Map<Integer, Integer> skills;

    /**
     * Buff触发次数
     */
    private Map<Integer, Integer> triggerTimes = new HashMap<>();

    /**
     * 保存触发次数
     */
    private boolean saveTriggerTimes;

    /**
     * 进化信息
     */
    private EvolveData evolve = new EvolveData();


    public static HeroVo valueOf(HeroDo heroDo) {
        HeroVo heroVo = new HeroVo();
        heroVo.setId(heroDo.getId());
        heroVo.setHeroId(heroDo.getHeroId());
        heroVo.setName(heroDo.getName());
        heroVo.setLevel(heroDo.getLevel());
        heroVo.setPos(heroDo.getPosition());
        heroVo.setStar(heroDo.getStar());
        heroVo.setStage(heroDo.getStage());
        heroVo.setStatus(heroDo.getStatus().ordinal());
        heroVo.setFashionId(heroDo.getFashionId());
        heroVo.setAttributes(heroDo.getAttributeInfo().getAttributeValues());
        int pos = (int)heroDo.getAttributeInfo().getAttribute(AttributeType.POS);
        if(pos != 0){
            heroVo.setPos(pos);
        }
        Map<Integer, Integer> skills = new HashMap<>();
        heroDo.getSkillInfo().getAllSkills().forEach(skillDo -> {
            skills.put(skillDo.getSkillId(), skillDo.getSkill().getLevel());
        });

        heroVo.setSkills(skills);
        if (heroDo.getBuffInfo() != null) {
            heroVo.setTriggerTimes(heroDo.getBuffInfo().getTriggerTimes());
        }
        if (Objects.nonNull(heroDo.getEvolve())) {
            heroVo.setEvolve(EvolveData.of(heroDo.getEvolve()));
        }
        return heroVo;
    }

    /**
     * 获取血量
     *
     * @return
     */
    public long getHp() {
        return this.attributes.getOrDefault(AttributeType.HP.getValue(), 0L);
    }

    /**
     * 获取最大血量
     *
     * @return
     */
    public long getMaxHp() {
        return this.attributes.getOrDefault(AttributeType.MAX_HP.getValue(), 0L);
    }


    @JSONField(serialize = false)
    @Override
    public List<AttributeKind> getAttr() {
        return this.attributes.entrySet().stream().map(entry -> AttributeKind.valueOf(entry.getKey(), entry.getValue(), KindType.FINAL_VALUE)).collect(Collectors.toList());
    }


    @Override
    public List<EquipInfo> getEquipment() {
        return null;
    }


    @Override
    public List<RunesVo> getRunes() {
        return null;
    }

    /**
     * 恢复血量
     *
     * @param percent
     */
    public void recoverHP(int percent) {
        long hp = getHp();
        if (hp <= 0) {
            return;
        }
        long maxHp = getMaxHp();
        long recoverHp = AttributeUtil.addPercent(maxHp, percent);
        hp += recoverHp;
        hp = Math.min(hp, maxHp);
        this.attributes.put(AttributeType.HP.getValue(), hp);
    }

    @Override
    public int getHero_type() {
        return this.heroId;
    }

    /**
     * 增加指定属性
     *
     * @param type
     * @param value
     */
    public void addAttribute(AttributeType type, long value) {
        long baseValue = this.attributes.getOrDefault(type.getValue(), 0L);
        baseValue += value;
        this.attributes.put(type.getValue(), baseValue);
    }

    @Override
    public int getHero_level() {
        return this.level;
    }

    @Override
    public int getHero_star() {
        return this.star;
    }

    /**
     * 英雄是否死亡
     * @return
     */
    public boolean isDead(){
        return this.status == HeroStatus.DEAD.ordinal();
    }
}
