local AudioManager = class("AudioManager", require("src.common.SingleInstance"))

function AudioManager:ctor()
	-- ccexp.AudioEngine:lazyInit()
	self.music_file = -1
	self.music_id = 0

	self.is_play_music = self:isPlayMusic()
	self.is_play_effect = self:isPlayEffect()
	
	self:preloadEffect("music/button-click.mp3")
	self:preloadEffect("music/main-city.mp3")
end

function AudioManager:clear()
	self.music_file = ""
	self.music_id = 0

	-- ccexp.AudioEngine:stopAll()
	self:stopMusic()
end

function AudioManager:preloadEffect(file)
	-- ccexp.AudioEngine:preload(file)
end

function AudioManager:preloadBackgroundMusic(file)
	-- ccexp.AudioEngine:preload(file)
end


function AudioManager:isPlayMusic()
	return cc.UserDefault:getInstance():getBoolForKey("play_music", true)
end

function AudioManager:setPlayMusic(b)
	if b == false then
		self:stopMusic()
	end

	local play_old = self.is_play_music
	self.is_play_music = b
	cc.UserDefault:getInstance():setBoolForKey("play_music", self.is_play_music)

	if b == true  and self.is_play_music ~= play_old then
		-- 重新播放音乐
		if ex then
			ex.Tools:autoPlaySceneMusic()
		end
	end
end

function AudioManager:isPlayEffect()
	return cc.UserDefault:getInstance():getBoolForKey("play_effect", true)
end


function AudioManager:setPlayEffect(b)
	self.is_play_effect = b
	cc.UserDefault:getInstance():setBoolForKey("play_effect", self.is_play_effect)
end


function AudioManager:playMusic(file, loop)
	if self.is_play_music ~= true then
		return
	end

	if self.music_file == file then
		return
	end

	-- print("self.music_id", self.music_id)
	self:stopMusic()
	
	local is_loop = loop or true

	self.music_file = file
	-- self.music_id = ccexp.AudioEngine:play2d(file, is_loop)
	self.music_id = 0
	cc.SimpleAudioEngine:getInstance():playMusic(file, is_loop)
end

function AudioManager:stopMusic()
	if self.music_id >= 0 then
		-- ccexp.AudioEngine:stop(self.music_id)
		cc.SimpleAudioEngine:getInstance():stopMusic()
		self.music_id = -1
		self.music_file = ""
	end
end


function AudioManager:playEffect(file)
	-- print("AudioManager:playEffect", file)
	if self.is_play_effect ~= true then
		return
	end
	-- print("AudioManager:playEffect", file)
	-- ccexp.AudioEngine:play2d(file, false)
	-- dump(debug.traceback())
	cc.SimpleAudioEngine:getInstance():playEffect(file)
end

function AudioManager:stopEffect()
	cc.SimpleAudioEngine:getInstance():stopAllEffects()
end

return AudioManager
