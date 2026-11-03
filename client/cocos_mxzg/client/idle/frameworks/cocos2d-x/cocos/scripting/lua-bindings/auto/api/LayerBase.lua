
--------------------------------
-- @module LayerBase
-- @extend Layer,CCBMemberVariableAssigner,NodeLoaderListener
-- @parent_module cpp

--------------------------------
-- 
-- @function [parent=#LayerBase] onNodeLoaded 
-- @param self
-- @param #cc.Node pNode
-- @param #cc.NodeLoader pNodeLoader
-- @return LayerBase#LayerBase self (return value: LayerBase)
        
--------------------------------
-- 
-- @function [parent=#LayerBase] clearLoadedPlist 
-- @param self
-- @return LayerBase#LayerBase self (return value: LayerBase)
        
--------------------------------
-- 
-- @function [parent=#LayerBase] isTouchInside 
-- @param self
-- @param #cc.Touch touch
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#LayerBase] getLoadedPlist 
-- @param self
-- @return array_table#array_table ret (return value: array_table)
        
--------------------------------
-- 
-- @function [parent=#LayerBase] onTouchBegan 
-- @param self
-- @param #cc.Touch pTouch
-- @param #cc.Event pEvent
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#LayerBase] shake 
-- @param self
-- @param #float range
-- @param #int times
-- @param #float slow_down
-- @return LayerBase#LayerBase self (return value: LayerBase)
        
--------------------------------
-- 
-- @function [parent=#LayerBase] setLoadedPlist 
-- @param self
-- @param #array_table vec_plist
-- @return LayerBase#LayerBase self (return value: LayerBase)
        
--------------------------------
-- 
-- @function [parent=#LayerBase] onAssignCCBMemberVariable 
-- @param self
-- @param #cc.Ref target
-- @param #char memberVariableName
-- @param #cc.Node node
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#LayerBase] create 
-- @param self
-- @return LayerBase#LayerBase ret (return value: LayerBase)
        
--------------------------------
-- 
-- @function [parent=#LayerBase] LayerBase 
-- @param self
-- @return LayerBase#LayerBase self (return value: LayerBase)
        
return nil
