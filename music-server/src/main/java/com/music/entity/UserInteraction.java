package com.music.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 用户行为交互表（整合收藏、评分、播放记录）
 */
@Data
@TableName("user_interaction")
public class UserInteraction implements Serializable {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private Long musicId;

    /** 评分：1-5 */
    private Integer rating;

    /** 是否收藏：0-否 1-是 */
    private Integer isFavorite;

    /** 播放次数 */
    private Integer playCount;

    /** 最后一次播放时间 */
    private LocalDateTime lastPlayTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    // 非数据库字段，用于关联查询返回给前端
    @TableField(exist = false)
    private Music music;
}
