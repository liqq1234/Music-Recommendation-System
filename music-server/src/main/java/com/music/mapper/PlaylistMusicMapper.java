package com.music.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.music.entity.PlaylistMusic;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PlaylistMusicMapper extends BaseMapper<PlaylistMusic> {
}
