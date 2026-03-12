package com.music.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 歌单-音乐关联表
 */
@Data
@TableName("playlist_music")
public class PlaylistMusic implements Serializable {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long playlistId;

    private Long musicId;

    private Integer sort;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
