package com.music.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.entity.Music;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface MusicMapper extends BaseMapper<Music> {

    @Select("SELECT m.*, " +
            "IFNULL((SELECT AVG(ui.rating) FROM user_interaction ui WHERE ui.music_id = m.id), 0) AS avg_score " +
            "FROM music m " +
            "WHERE m.status = 1 ORDER BY m.play_count DESC LIMIT 100")
    List<Music> selectTop100();

    @Select("SELECT * FROM music WHERE id = #{id}")
    Music selectDetailById(@Param("id") Long id);
}
