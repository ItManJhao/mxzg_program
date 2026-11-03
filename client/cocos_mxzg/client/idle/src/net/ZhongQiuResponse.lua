local ZhongQiuResponse = class("ZhongQiuResponse")

function ZhongQiuResponse:onInfo(data)
    ex.Player.promotion_data.zhongqiu_data:initData(data)
end

function ZhongQiuResponse:onSummon(data)
    ex.Player.promotion_data.zhongqiu_data:setRemainingCount(data.lottery_best_remaining_count)
    ex.Player.promotion_data.zhongqiu_data:setSummonCount(data.lottery_count)
    ex.Player.promotion_data.zhongqiu_data:RedPointByMainCity()
    ex.EventManager:fire(EVENT.ZHONG_QIU.SUMMON,data)
end 

function ZhongQiuResponse:onBoxReward(data)
    ex.Player.promotion_data.zhongqiu_data:setRewardCord(data.idx)
    ex.Player.promotion_data.zhongqiu_data:RedPointByMainCity()
    ex.EventManager:fire(EVENT.ZHONG_QIU.BOX_REWARD)
end 

function ZhongQiuResponse:onSelect(data)
    ex.Player.promotion_data.zhongqiu_data:setSelectInfo(data.select_info)
end 


function ZhongQiuResponse:onJiaYaoData(data)
    ex.Player.promotion_data.zhongqiu_data:initJiaYaoData(data.buy)
end 

function ZhongQiuResponse:onBuyData(data)
    ex.Player.promotion_data.zhongqiu_data:updateJiaYaoBuyRecord(data.buy)
    ex.EventManager:fire(EVENT.ZHONG_QIU.UPDATE_JIA_YAO_BUY)
end 

return ZhongQiuResponse 
