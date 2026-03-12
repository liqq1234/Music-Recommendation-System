package com.music.common;

/**
 * 系统常量
 */
public class Constants {

    /** 角色：普通用户 */
    public static final int ROLE_USER = 0;
    /** 角色：歌手 */
    public static final int ROLE_SINGER = 1;
    /** 角色：管理员 */
    public static final int ROLE_ADMIN = 2;

    /** 状态：禁用 */
    public static final int STATUS_DISABLED = 0;
    /** 状态：正常 */
    public static final int STATUS_NORMAL = 1;

    /** 音乐状态：下架 */
    public static final int MUSIC_STATUS_OFF = 0;
    /** 音乐状态：正常 */
    public static final int MUSIC_STATUS_NORMAL = 1;
    /** 音乐状态：审核中 */
    public static final int MUSIC_STATUS_REVIEW = 2;

    /** Redis Key: TOP100 */
    public static final String REDIS_TOP100 = "music:top100";
    /** Redis Key: 推荐前缀 */
    public static final String REDIS_RECOMMEND_PREFIX = "music:recommend:";
    /** Redis缓存过期时间（秒） */
    public static final long REDIS_EXPIRE_SECONDS = 3600;

    /** Token请求头 */
    public static final String TOKEN_HEADER = "Authorization";
}
