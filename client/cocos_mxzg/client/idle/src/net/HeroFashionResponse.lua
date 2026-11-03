local HeroFashionResponse = class("HeroFashionResponse")

function HeroFashionResponse:handleHeroFashion(data)
	ex.Player.hero_data.fashion:setWearList(data.list)
end

function HeroFashionResponse:heroFashionList( data )

    local save_data = {}
    for i,v in ipairs(data.list) do

        local cur_data = {}
        cur_data.hero_type = v.hero_type
        cur_data.fashion_id = v.fashion_id
        cur_data.level = v.level
        cur_data.status = v.status
        cur_data.end_time = v.end_time

        table.insert(save_data, cur_data)
    end

    ex.Player.hero_data.fashion:setFashionList(save_data)

    -- add 熊梦 已经拥有的皮肤服务端发送过来数据后赋值完再调用一次英雄界面红点初始化
    ex.Player.hero_data:initRedPoint()

    ex.EventManager:fire(EVENT.FASHION_SETTING.DATA_DIRTY)
end


function HeroFashionResponse:activeHeroFashion( data )
    --激活成功后,打开皮肤获取界面
    require("src.layer.skinsystem.NewFashionCtrl"):instance():openWindow(data.fashion_id)
    
    -- 放松获取解锁皮肤列表
    NetManager:sendMessage(ProtocolID.GReqHeroFashionList)
end

function HeroFashionResponse:handleHeroFashionChange(data)
    ex.Player.hero_data.fashion:setWearFashion(data.hero_id, data.fashion_id)

    ex.EventManager:fire(EVENT.FASHION_SETTING.WEAR)
end

function HeroFashionResponse:handleHeroFashionUp(data)
    ex.Player.hero_data.fashion:upgradeFashionLevel(data.fashion_id, data.level)

    ex.EventManager:fire(EVENT.FASHION_SETTING.UPGRADE)

    --add 熊梦 刷新一下英雄界面的红点
    ex.EventManager:fire(EVENT.FASHION_SETTING.DATA_DIRTY)
end

return HeroFashionResponse