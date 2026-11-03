
--------------------------------
-- @module Game
-- @extend Ref,SingleInstance<Game>
-- @parent_module cpp

--------------------------------
-- 
-- @function [parent=#Game] getDeviceString 
-- @param self
-- @return string#string ret (return value: string)
        
--------------------------------
-- 
-- @function [parent=#Game] getDeviceOrientation 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#Game] reLogin 
-- @param self
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] getBundleId 
-- @param self
-- @return string#string ret (return value: string)
        
--------------------------------
-- 
-- @function [parent=#Game] downloadApp 
-- @param self
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] confirmDevice 
-- @param self
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] setClipboard 
-- @param self
-- @param #string str
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] getDeviceToken 
-- @param self
-- @return string#string ret (return value: string)
        
--------------------------------
-- 
-- @function [parent=#Game] setResLogin 
-- @param self
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] updatePushId 
-- @param self
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] getNetworkState 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#Game] getCurrentLanguageCodeFull 
-- @param self
-- @return string#string ret (return value: string)
        
--------------------------------
-- 
-- @function [parent=#Game] onInconsistentData 
-- @param self
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] getNotchHeight 
-- @param self
-- @return float#float ret (return value: float)
        
--------------------------------
-- 
-- @function [parent=#Game] openURL 
-- @param self
-- @param #char url
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] getEGLViewRect 
-- @param self
-- @return rect_table#rect_table ret (return value: rect_table)
        
--------------------------------
-- 
-- @function [parent=#Game] updateDeviceUUID 
-- @param self
-- @return string#string ret (return value: string)
        
--------------------------------
-- 
-- @function [parent=#Game] setServerTime 
-- @param self
-- @param #long long server_time
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 获取服务端精确时间(毫秒量级)
-- @function [parent=#Game] getServerMillisecond 
-- @param self
-- @return long long#long long ret (return value: long long)
        
--------------------------------
-- 
-- @function [parent=#Game] stopCheckNetwork 
-- @param self
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] getDeviceLanguage 
-- @param self
-- @return string#string ret (return value: string)
        
--------------------------------
-- 
-- @function [parent=#Game] stopTheGame 
-- @param self
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 获取服务端精确时间(秒级)
-- @function [parent=#Game] getServerTime 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#Game] getVersion 
-- @param self
-- @return string#string ret (return value: string)
        
--------------------------------
-- 
-- @function [parent=#Game] updateXingeToken 
-- @param self
-- @param #string token
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] onOffline 
-- @param self
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] deviceUUID 
-- @param self
-- @return string#string ret (return value: string)
        
--------------------------------
-- 
-- @function [parent=#Game] startCheckNetwork 
-- @param self
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] showExitTheGame 
-- @param self
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] exitTheGame 
-- @param self
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] setEffectsVisible 
-- @param self
-- @param #bool visible
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] orientationChange 
-- @param self
-- @param #int orientation
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] getEffectsVolume 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#Game] second 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#Game] exitTheGameNoParam 
-- @param self
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] getReverseScale 
-- @param self
-- @return float#float ret (return value: float)
        
--------------------------------
-- 
-- @function [parent=#Game] millisecond 
-- @param self
-- @return long long#long long ret (return value: long long)
        
--------------------------------
-- 
-- @function [parent=#Game] setBackgroundMusicVolume 
-- @param self
-- @param #int volume
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] shutDownKeyBoard 
-- @param self
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] setBackgroundMusicVisible 
-- @param self
-- @param #bool visible
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] stopBackgroundMusic 
-- @param self
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] getBackgroundMusicVolume 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#Game] instance 
-- @param self
-- @return Game#Game ret (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] makeLuaId 
-- @param self
-- @return string#string ret (return value: string)
        
--------------------------------
-- 
-- @function [parent=#Game] getEffectsVisible 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#Game] preloadBackgroundMusic 
-- @param self
-- @param #char path
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] playBackgroundMusic 
-- @param self
-- @param #char path
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] sendLog 
-- @param self
-- @param #char content
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] isKeyBoardShown 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#Game] playEffect 
-- @param self
-- @param #char path
-- @param #bool frequently
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] preloadEffect 
-- @param self
-- @param #char path
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] getBackgroundMusicVisible 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#Game] isInVisible 
-- @param self
-- @param #cc.Node node
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#Game] setEffectsVolume 
-- @param self
-- @param #int volume
-- @return Game#Game self (return value: Game)
        
--------------------------------
-- 
-- @function [parent=#Game] Game 
-- @param self
-- @return Game#Game self (return value: Game)
        
return nil
