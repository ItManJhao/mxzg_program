## cocos2dx框架源码修改记录

### 导出骨骼动画的信息到lua层

修改时间 : 2019-10-23
修改文件 : "frameworks/cocos2d-x/cocos/scripting/lua-bindings/auto/lua_cocos2dx_spine_auto.cpp"

增加函数 `lua_cocos2dx_spine_SkeletonAnimation_findAnimationDuration`

说明 : 为了让lua层可以获取到骨骼动画的duration，方便计算打击帧

### cocos2dx调度器绑定功能导出到lua层

修改时间 : 2019-10-25
修改文件 : "frameworks/cocos2d-x/cocos/scripting/lua-bindings/auto/lua_cocos2dx_spine_auto.cpp"

增加函数
- `lua_cocos2dx_Scheduler_bindScheduleUpdate`
- `lua_cocos2dx_Scheduler_bindActionManagerUpdate`

说明 : 让lua层可以绑定自定义的调度器到默认的调度器中，使其可以生效。并且支持将动作管理器也绑定到指定的调度器中，使其可以对动作进行统一管理。
