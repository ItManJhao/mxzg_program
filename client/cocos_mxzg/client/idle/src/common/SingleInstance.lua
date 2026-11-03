local SingleInstance = {}

function SingleInstance:instance()
    if self._instance == nil then
        self._instance = self:create()
    end
    return self._instance
end

return SingleInstance
 