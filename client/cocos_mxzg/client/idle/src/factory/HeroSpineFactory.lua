HeroSpineFactory = {}

HeroSpineFactory._baseDir = 'spine/'

--[[
    通过名字创建骨骼动画对象。
    
    name  : 资源文件夹'spine/'下的文件名(不包括后缀名)
    scale : 骨骼动画对象的缩放值
]]
HeroSpineFactory.create = function(name, scale)
    if type(scale) ~= "number" then
        scale = 1.0
    end

    local jsonPath = HeroSpineFactory._baseDir .. name .. '.json'
    local atlasPath = HeroSpineFactory._baseDir .. name .. '.atlas'

    return sp.SkeletonAnimation:create(jsonPath, atlasPath, scale)
end
