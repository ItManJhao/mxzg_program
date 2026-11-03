#include "scripting/lua-bindings/manual/lua_module_register.h"

#include "scripting/lua-bindings/manual/cocosdenshion/lua_cocos2dx_cocosdenshion_manual.h"
#include "scripting/lua-bindings/manual/network/lua_cocos2dx_network_manual.h"
#include "scripting/lua-bindings/manual/cocosbuilder/lua_cocos2dx_cocosbuilder_manual.h"
#include "scripting/lua-bindings/manual/cocostudio/lua_cocos2dx_coco_studio_manual.hpp"
#include "scripting/lua-bindings/manual/extension/lua_cocos2dx_extension_manual.h"
#include "scripting/lua-bindings/manual/ui/lua_cocos2dx_ui_manual.hpp"
#include "scripting/lua-bindings/manual/spine/lua_cocos2dx_spine_manual.hpp"
#include "scripting/lua-bindings/manual/3d/lua_cocos2dx_3d_manual.h"
#include "scripting/lua-bindings/manual/audioengine/lua_cocos2dx_audioengine_manual.h"
#include "scripting/lua-bindings/manual/physics3d/lua_cocos2dx_physics3d_manual.h"
#include "scripting/lua-bindings/manual/navmesh/lua_cocos2dx_navmesh_manual.h"


#include "../auto/lua_cpp_autorun_netmanager_auto.hpp"
#include "../auto/lua_cpp_model_bytearray_auto.hpp"
#include "../auto/lua_cpp_ctrl_layer_lualayerctr_auto.hpp"
#include "../auto/lua_cpp_net_response_responsemanager_auto.hpp"
#include "../auto/lua_cpp_common_ccbloader_auto.hpp"
#include "../auto/lua_cpp_comp_menu_uimenu_auto.hpp"
#include "../auto/lua_cpp_comp_menu_uimenuitem_auto.hpp"
#include "../auto/lua_cpp_ctrl_luanodectr_auto.hpp"
#include "../auto/lua_cpp_comp_uilabel_auto.hpp"
#include "../auto/lua_cpp_comp_uirichtextex_auto.hpp"
#include "../auto/lua_cpp_comp_messageview_auto.hpp"
#include "../auto/lua_cpp_model_game_auto.hpp"
#include "../auto/lua_cpp_animation_actionfactory_auto.hpp"
#include "../auto/lua_cpp_animation_shaderfactory_auto.hpp"
#include "../auto/lua_cpp_platform_socialplatform_auto.hpp"
#include "../auto/lua_cpp_ctrl_scene_mainscenectr_auto.hpp"
#include "../auto/lua_cpp_person_hero_auto.hpp"
#include "../auto/lua_cpp_data_roledata_auto.hpp"
#include "../auto/lua_cpp_comp_uiscrollviewzoom_auto.hpp"
#include "../auto/lua_cpp_comp_menu_uimenuround_auto.hpp"
#include "../auto/lua_cpp_comp_uitableviewex_auto.hpp"
#include "../auto/lua_cpp_comp_menu_uimenugeneral_auto.hpp"
#include "../auto/lua_cpp_net_platformapi_auto.hpp"
#include "../auto/lua_cpp_model_utils_auto.hpp"
#include "../auto/lua_cpp_comp_menu_uimenuitemscale_auto.hpp"
#include "../auto/lua_cpp_comp_protectednodeex_auto.hpp"
#include "../auto/lua_cpp_model_assetmanager_auto.hpp"
#include "../auto/lua_cpp_model_assetdownload_auto.hpp"
#include "../auto/lua_cpp_model_resmanager_auto.hpp"


int lua_module_register(lua_State* L)
{
    // Don't change the module register order unless you know what your are doing
    register_cocosdenshion_module(L);
    register_network_module(L);
    register_cocosbuilder_module(L);
    register_cocostudio_module(L);
    register_ui_module(L);
    register_extension_module(L);
    register_spine_module(L);
    register_cocos3d_module(L);
    register_audioengine_module(L);



    register_all_cpp_autorun_netmanager(L);
    register_all_cpp_model_bytearray(L);
    register_all_cpp_ctrl_layer_lualayerctr(L);
    register_all_cpp_net_response_responsemanager(L);
    register_all_cpp_common_ccbloader(L);
    register_all_cpp_comp_menu_uimenu(L);
    register_all_cpp_comp_menu_uimenuitem(L);
    register_all_cpp_ctrl_luanodectr(L);
    register_all_cpp_comp_uilabel(L);
    register_all_cpp_comp_uirichtextex(L);
    register_all_cpp_comp_messageview(L);
    register_all_cpp_model_game(L);
    register_all_cpp_animation_actionfactory(L);
    register_all_cpp_animation_shaderfactory(L);
    register_all_cpp_platform_socialplatform(L);
    register_all_cpp_ctrl_scene_mainscenectr(L);
    register_all_cpp_person_hero(L);
    register_all_cpp_data_roledata(L);
    register_all_cpp_comp_uiscrollviewzoom(L);
    register_all_cpp_comp_menu_uimenuround(L);
    register_all_cpp_comp_uitableviewex(L);
    register_all_cpp_comp_menu_uimenugeneral(L);
    register_all_cpp_net_platformapi(L);
    register_all_cpp_model_utils(L);
    register_all_cpp_comp_menu_uimenuitemscale(L);
    register_all_cpp_comp_protectednodeex(L);
    register_all_cpp_model_assetmanager(L);
    register_all_cpp_model_assetdownload(L);
    register_all_cpp_model_resmanager(L);
    
#if CC_USE_3D_PHYSICS && CC_ENABLE_BULLET_INTEGRATION
    register_physics3d_module(L);
#endif
#if CC_USE_NAVMESH
    register_navmesh_module(L);
#endif
    return 1;
}

