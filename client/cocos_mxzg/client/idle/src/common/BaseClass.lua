--Create an class.
--
function BaseClass(classname, super)
    local superType = type(super)
    local cls
 
    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end
 
    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}
    
        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do
             print("v = ", v)
             cls[k] = v
            end


            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end
 
        cls.ctor    = function() end
        cls.__cname = classname
        cls.__ctype = 1
 
        function cls.new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end
 
    else
        -- inherited from Lua Object
        if super then
            cls = clone(super)
            cls.super = super
        else
            cls = {ctor = function() end}
        end
 
        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls
 
        function cls.new(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    end
 
    return cls
end



--[[
 usage =
 基础类
    base = BaseClass()
 继承类
    inheri = BaseClass(base)

 function base:__init()
 end
]]--
--[[ 这个类是浅复制父类的方法，单向继承，
     使用这个类是因为luajit的检索深度过深会崩溃 ]]--
--[[
local function _visit_constructor(obj, t)
  if obj then
    t[#t+1] = obj
  end

  if obj._base then
    _visit_constructor(obj._base,t)
  else
    return
  end
end

function BaseClass(base)
   local c = {}    -- a new class instance
   local _baseList = nil
   if type(base) == 'table' then
      -- our new class is a shallow copy of the base class!
      for i,v in pairs(base) do
         c[i] = v
      end
      -- record base
      c._base = base
      -- get base list, 获取父类列表
      _baseList = {}
      _visit_constructor(base,_baseList)
      c._baseList = _baseList
   end
   -- the class will be the metatable for all its objects,
   -- and they will look up their methods in it.
   c.__index = c

   -- expose a constructor which can be called by <classname>(<args>)
   local mt = {}
   mt.__call = function(class_tbl, ...)
     local obj = {}
     setmetatable(obj,c)
     -- inheri constructor
     if _baseList then
        local _size = #_baseList --依次调用 __init call
        for i=_size, 1 , -1 do
          _baseList[i].__init(obj,...)
        end
     end
     obj:__init(...)
     return obj
   end

   c.is_a = function(self, klass)
      local m = getmetatable(self)
      while m do
         if m == klass then return true end
         m = m._base
      end
      return false
   end
   setmetatable(c, mt)
   return c
end
]]