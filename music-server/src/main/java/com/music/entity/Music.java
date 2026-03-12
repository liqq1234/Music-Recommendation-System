package com.music.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 音乐表
 */
@Data
@TableName("music")
@JsonIgnoreProperties(ignoreUnknown = true)
public class Music implements Serializable {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String title;

    private Long singerId;

    private String singerName;

    private String category;

    private String album;

    /** 时长（秒） */
    private Integer duration;

    private String coverUrl;

    private String fileUrl;

    private String lyric;

    private String audioFingerprint;

    private Long playCount;

    /** 状态：0-下架 1-正常 2-审核中 */
    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    /** 非数据库字段：平均评分 */
    @TableField(exist = false)
    private Double avgScore;
}
