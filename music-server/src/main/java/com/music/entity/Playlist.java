package com.music.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 歌单表
 */
@Data
@TableName("playlist")
@JsonIgnoreProperties(ignoreUnknown = true)
public class Playlist implements Serializable {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String name;

    private String description;

    private String coverUrl;

    private Long userId;

    /** 是否公开：0-私有 1-公开 */
    private Integer isPublic;

    private Long playCount;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    /** 非数据库字段：创建者昵称 */
    @TableField(exist = false)
    private String creatorName;

    /** 非数据库字段：歌单内音乐数量 */
    @TableField(exist = false)
    private Integer musicCount;

    /** 非数据库字段：歌单内音乐列表 */
    @TableField(exist = false)
    private List<Music> musicList;
}
