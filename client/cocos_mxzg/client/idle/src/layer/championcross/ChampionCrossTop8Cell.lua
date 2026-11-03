local ChampionTop8Cell = class("ChampionCrossTop8Cell", require("src.comp.EventLayer"))

function ChampionTop8Cell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)
end

function ChampionTop8Cell:reset(data, stage, round)
    local setLineVisible = function(name, visible)
        local line = self[name]
        if not line then
            return
        end
        line:setVisible(visible)
    end

    local setBtnGray = function(name, gray)
        local btn = self[name]
        if not btn then
            return
        end
        ex.Tools:setGrayAuto(btn:getNormalImage(), gray)
    end

    local setEffect = function(name, is_effect)
        local spr = self[name]
        if not spr then
            return
        end

        spr:setVisible(is_effect)
        if is_effect then
            ex.EffectCtr:playNormalEff(24, 0, 0, nil, spr, 0)
        else
            spr:removeAllChildren()
        end
    end

    -- 置灰按钮
    ex.Tools:ergodicAllNode(self.menu_player, function(node)
        if node.getNormalImage then
            node:setLabelText("?")
            ex.Tools:setGrayAuto(node:getNormalImage(), true)
        end
    end)

    if data then
        for k,v in pairs(data) do
            local next_data = data[k / 2]
            for i,vp in ipairs(v) do
                local btn_player1 = self[string.format("btn_player_%d_%d_1", k, i)]
                local btn_player2 = self[string.format("btn_player_%d_%d_2", k, i)]

                if btn_player1 then
                    btn_player1.rid = vp.atk_rid
                    btn_player1:setLabelText(vp.atk_name)
                end

                if btn_player2 then
                    btn_player2.rid = vp.def_rid
                    btn_player2:setLabelText(vp.def_name)
                end

                -- -- 点亮攻方路线
                -- local light1 = TableEx.findValueFunction(next_data,function(value)
                --     return vp.atk_name == value.atk_name or vp.atk_name == value.def_name
                -- end)

                -- -- 点亮守方路线
                -- local light2 = TableEx.findValueFunction(next_data,function(value)
                --     return vp.def_name == value.atk_name or vp.def_name == value.def_name
                -- end)
                
                -- 具体点亮的线路下标。简化逻辑
                -- local light_index = light1 ~= nil and (1) or (light2 ~= nil and 2 or 0)

                -- 具体点亮的线路下标。简化逻辑
                -- local light_index = vp.which_win

                local light_index = 0 -- stage == 3 and 0 or vp.which_win
                if next_data and table.nums(next_data) > 0 then
                    light_index = vp.which_win
                else
                    print(stage, round)
                    light_index = (stage == 3 and round > 4) and 0 or vp.which_win
                end


                -- local line_key = 
                -- 位置。线类型。下标。无类型
                -- line_（32强）_（位置）_（防守方）

                -- 点亮
                -- 攻方连线
                setLineVisible(string.format("line_light_%d_%d_1", k, i), light_index == 1)
                -- 守方连线
                setLineVisible(string.format("line_light_%d_%d_2", k, i), light_index == 2)
                -- 中线
                setLineVisible(string.format("line_light_%d_%d_z", k, i), light_index ~= 0)

                -- 变灰
                -- 攻方连线
                setLineVisible(string.format("line_gray_%d_%d_1_1", k, i), light_index ~= 1)
                setLineVisible(string.format("line_gray_%d_%d_1_2", k, i), light_index ~= 1)

                -- 守方连线
                setLineVisible(string.format("line_gray_%d_%d_2_1", k, i), light_index ~= 2)
                setLineVisible(string.format("line_gray_%d_%d_2_2", k, i), light_index ~= 2)

                -- 中线
                setLineVisible(string.format("line_gray_%d_%d_1_z", k, i), light_index == 0)
                
                -- 点亮按钮
                setBtnGray(string.format("btn_player_%d_%d_1", k, i), (light_index == 1) == false)
                setBtnGray(string.format("btn_player_%d_%d_2", k, i), (light_index == 2) == false)

                -- 展示战报按钮
                local btn_report = self[string.format("btn_report_%d_%d",k, i)]
                if btn_report then
                    btn_report.data = vp
                    btn_report:setVisible(light_index ~= 0)
                end

                -- 没有下一阶段的数据。并且阶段是战斗阶段。并且胜负还没出
                local is_effect = (next_data == nil or table.nums(next_data) <= 0) and stage == 3 and vp.which_win ~= 0 and round > 4
                setEffect(string.format("spr_effect_%d_%d",k, i), is_effect)
            end
        end
    else
        self.node_gray:setVisible(true)
        self.node_light:setVisible(false)
        self.menu_replay:setVisible(false)
    end
end


function ChampionTop8Cell:onRole(tag, pSender)
    if pSender.rid == nil or pSender.rid == 0 then
        return
    end
    ex.Tools:showPlayerInfo(pSender.rid)
end

function ChampionTop8Cell:onReport(tag, pSender)
    local data = pSender.data
    if not data or data.which_win == 0 then
        return
    end

    -- 查询战斗。如果有。就开始战斗
    local req_bid = ChampionCross_pb.GReqGetChampionCrossBattle()
    req_bid.bid = data.bid
    NetManager:sendMessage(ProtocolID.GReqGetChampionCrossBattle, req_bid)
end

return ChampionTop8Cell