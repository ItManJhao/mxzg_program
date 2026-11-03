
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

IS_ANDROID=false

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

-- for module display
-- CC_DESIGN_RESOLUTION = {
--     width = 828,
--     height = 1280,
--     autoscale = "FIXED_HEIGHT",
--     callback = function(framesize)
--         local ratio = framesize.width / framesize.height
--         if ratio <= 1.34 then
--             -- iPad 768*1024(1536*2048) is 4:3 screen
--             return {width = 768, height = 1024, autoscale = "FIXED_WIDTH"}
--         end
--     end
-- }

-- lua filename path
USER_CLASS_PATH = {
    "src.ex",
    "src.factory",
    "src.layer",
    "src.data",
    "src.common",
    "src.native",
    "src.comp",
    "src.comp.menu",
    "src.config",
    "src.context",
    "src.controller",
    "src.effect",
    "src.entity",
    "src.entity.battle",
    "src.global",
    "src.model",
    "src.net",
    "src.person",
    "src.platform",
    "src.autorun",
    "src.scene",
    "src.anim"
}