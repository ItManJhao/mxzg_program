local Hero = class("Hero", function(hero_id, role_id, hero_type, level, star, skin)
                                return cpp.Hero:create(hero_id, role_id, hero_type, level, star, skin or 0)
                            end)
                            
return Hero