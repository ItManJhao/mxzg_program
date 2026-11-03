local ChapterAllTable = class("ChapterAllTable", require("src.config.CSVLoader"), require("src.common.SingleInstance"))

ChapterAllTable.file_name = "config/chapterall.csv"
ChapterAllTable.main_key = "world"

function ChapterAllTable:ctor()
    self.data = clone({})
    self.keys = clone({})
end

-- local config =  self:getConfig(2)
-- config.chapter

function ChapterAllTable:getChapterByMissionId(mission_id)
	local config = nil
	local pre_mission_id = 0
	local world_list = {}

	local index = 1
	for k,v in pairs(self.data) do
		world_list[index] = k
		index = index + 1
	end

	local function testSort(a,b)
        return tonumber(a) < tonumber(b)
    end
    table.sort(world_list, testSort)

	print("world_list", json.encode(world_list))

	for i,v in ipairs(world_list) do
		local tmp_config = self:getConfig(v)
		if tonumber(tmp_config.chapter) <= tonumber(mission_id) then
			config = self:getConfig(k)
			pre_mission_id = tonumber(config.chapter)
		else
			config = self:getConfig(v)
			break
		end
	end
	
	config.pre_mission_id = pre_mission_id
	return config
end

function ChapterAllTable:reloadDone()
	--print("ChapterAllTable:reloadDone", self.data)

	local function testSort(a,b)
        return tonumber(a.level)> tonumber(b.level)
    end
    table.sort(self.data,testSort)

	--print("ChapterAllTable:reloadDone", json.encode(self.data))
end

return ChapterAllTable
