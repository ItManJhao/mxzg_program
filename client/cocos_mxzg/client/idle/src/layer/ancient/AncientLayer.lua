local AncientLayer = class("AncientLayer", require("src.comp.EventLayer"))

function AncientLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-ancient-1.png", remove_type=1},
    }
    return vec_image
end

function AncientLayer:onCreate()

    self.spr_bg:setScaleX(ex.s.global_scale)
    
    self.scroll_view:setItemType(1)
    self.scroll_view:setItemSize(cc.size(500 * ex.s.global_scale, 250 * ex.s.global_scale))
    self.scroll_view.nodeTouched = handler(self, self.onJump)
    local notch_height = ex.p.height - 100 * ex.s.global_scale - require("src.model.Game"):instance():getNotchHeight()
    self.node_top:setPositionY(notch_height)

    self:updateLayer()
end

function AncientLayer:updateLayer()
    local vec_data = cfg.gamerewardshow.getConfigListByType(3)
    self.scroll_view.createItemFunction = function(data, scale)
        local cell = require("src.layer.ancient.AncientCell"):createWithCCBIFile("ccbi/AncientCell.ccbi")
        cell:setScale(ex.s.global_scale)
        cell:reset(data)
        if data.reddot ~= "" then
            self:addRedDotNode(data.reddot, cell)
        end

        return cell
    end
    self.scroll_view:reloadData(vec_data)
end

function AncientLayer:onBack(tag , pSender)
    if not ex.MainSceneCtr:backLastLayer() then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    end
end

function AncientLayer:onJump(tag, pSender)
    ex.JumpManager:jumpByAtom(pSender.data.atom)
end

return AncientLayer