package com.music.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.entity.UserInteraction;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserInteractionMapper extends BaseMapper<UserInteraction> {
    
    /**
     * 分页查询用户的交互记录及音乐详情
     */
    IPage<UserInteraction> selectInteractionWithMusic(Page<UserInteraction> page, @Param("userId") Long userId, @Param("type") String type);
}
