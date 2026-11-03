
--------------------------------
-- @module Hero
-- @extend Unit
-- @parent_module cpp

--------------------------------
-- 
-- @function [parent=#Hero] showAnger 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] setSelected 
-- @param self
-- @param #bool v
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] setFlippedX 
-- @param self
-- @param #bool flippedX
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] updateZOrder 
-- @param self
-- @param #float dt
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] setAnimationNode 
-- @param self
-- @param #sp.SkeletonAnimation node
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] reborn 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] setShowDamage 
-- @param self
-- @param #bool b
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] getAnimationNode 
-- @param self
-- @return SkeletonAnimation#SkeletonAnimation ret (return value: sp.SkeletonAnimation)
        
--------------------------------
-- 
-- @function [parent=#Hero] beattack 
-- @param self
-- @param #long long attacker
-- @param #int buff_type
-- @param #int damage
-- @param #int damage_type
-- @param #int hp_new
-- @param #int elem_type
-- @param #bool is_critical
-- @param #float delay
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] showHP 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] setAnimation 
-- @param self
-- @param #int trackIndex
-- @param #string name
-- @param #bool loop
-- @return spTrackEntry#spTrackEntry ret (return value: spTrackEntry)
        
--------------------------------
-- 
-- @function [parent=#Hero] hideElem 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] setShadowVisible 
-- @param self
-- @param #bool v
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] updateBuffIcon 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] hideLevel 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] hideHP 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] attack 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] setHeroAnimationByType 
-- @param self
-- @param #int type
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] isShowDamage 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#Hero] startUpdateZOrder 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] setShader 
-- @param self
-- @param #int shader_type
-- @param #bool loop
-- @param #string name
-- @param #bool time_scale
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] mergeDamage 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] isRunAction 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#Hero] setRunAction 
-- @param self
-- @param #bool b
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] update 
-- @param self
-- @param #float delay
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] initHero 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] showLevel 
-- @param self
-- @param #int level
-- @return Label#Label ret (return value: cc.Label)
        
--------------------------------
-- 
-- @function [parent=#Hero] hideAnger 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] showAbilityTip 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] stopUpdateZOrder 
-- @param self
-- @param #int z
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] addAbilityTip 
-- @param self
-- @param #int type
-- @param #int value
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] addAnimation 
-- @param self
-- @param #int trackIndex
-- @param #string name
-- @param #bool loop
-- @param #float delay
-- @return spTrackEntry#spTrackEntry ret (return value: spTrackEntry)
        
--------------------------------
-- 
-- @function [parent=#Hero] addAbilityTextTip 
-- @param self
-- @param #string text
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] die 
-- @param self
-- @param #Unit killer
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] resetTimeScale 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] showElem 
-- @param self
-- @param #int elem
-- @return Sprite#Sprite ret (return value: cc.Sprite)
        
--------------------------------
-- 
-- @function [parent=#Hero] isFlippedX 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#Hero] stand 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] showDamage 
-- @param self
-- @return Hero#Hero self (return value: Hero)
        
--------------------------------
-- 
-- @function [parent=#Hero] create 
-- @param self
-- @param #long long hero_id
-- @param #long long role_id
-- @param #int hero_type
-- @param #int level
-- @param #int star
-- @param #int skin
-- @return Hero#Hero ret (return value: Hero)
        
--------------------------------
-- @overload self, long long, long long, int, int, int, int         
-- @overload self         
-- @function [parent=#Hero] Hero
-- @param self
-- @param #long long hero_id
-- @param #long long role_id
-- @param #int type
-- @param #int level
-- @param #int star
-- @param #int skin
-- @return Hero#Hero self (return value: Hero)

return nil
