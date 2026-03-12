# 定制音乐推荐系统 (Custom Music Recommendation System)

## 项目简介

本项目是一个基于 **Spring Boot + Vue.js** 的前后端分离架构的定制音乐推荐系统。系统集成了音乐播放、收藏、评分、歌单管理等核心功能，并采用 **协同过滤算法**（User-based Collaborative Filtering）实现个性化音乐推荐。

## 核心功能

- **用户系统**: 注册、登录、个人详情修改、头像上传。
- **音乐库**: 音乐搜索、分类筛选、在线播放、播放记录统计。
- **互动体验**: 音乐评分（1-5星）、收藏/取消收藏音乐。
- **歌单管理**: 创建歌单、向歌单添加/删除音乐、公开歌单广场。
- **智能推荐**: 获取个性化推荐歌曲（基于相似用户品味）。
- **后台管理**: 管理员可进行数据统计、用户管理、音乐审核与下架。

## 技术栈

- **后端**: Spring Boot 2.7, MyBatis-Plus, MySQL 8.0, Redis, JWT
- **前端**: Vue 2.x, Element UI, Axios, Vuex
- **算法**: 用户协同过滤算法 (User-CF)

## 部署教程

### 1. 环境准备
- **Java**: JDK 1.8 或更高版本
- **Node.js**: 16.x 或更高版本
- **数据库**: MySQL 8.0, Redis 6.x
- **IDE**: IntelliJ IDEA (推荐), VS Code

### 2. 数据库配置
1. 创建数据库 `music_recommendation`。
2. 依次执行项目根目录下 `sql/` 文件夹中的脚本：
   - `1_schema.sql`: 创建表结构。
   - `2_data.sql`: 导入完整初始测试数据（含48首真实音乐、歌手及交互记录）。

### 3. 后端部署 (music-server)
1. 导入 `music-server` 作为 Maven 项目。
2. 修改 `src/main/resources/application.yml` 中的 **MySQL** 和 **Redis** 连接信息（IP、端口、密码）。
3. 运行 `com.music.MusicApplication` 启动项目。
4. 后端默认端口：`8089`

### 4. 前端部署 (music-front)
1. 进入 `music-front` 目录。
2. 安装依赖包：
   ```bash
   npm install
   ```
3. 运行项目：
   ```bash
   npm run dev
   ```
4. 访问地址：`http://localhost:8080`

## 默认账户信息

| 角色 | 用户名 | 密码 |
|------|--------|------|
| **管理员** | `admin` | `admin123` |
| **歌手** | `jay_chou` | `singer123` |
| **普通用户** | `user01` | `user123` |

## 项目结构说明

```text
├── music-server/          # 后端项目源码
│   ├── src/main/java      # Java 源代码
│   └── src/main/resources # 配置文件及 SQL 脚本库
├── music-front/           # 前端项目源码
│   ├── src/views          # 业务页面 (user, singer, admin)
│   └── src/store          # Vuex 状态管理
├── sql/                   # 根目录 SQL 部署脚本
└── README.md              # 项目说明文档
```

---

## 推荐逻辑简述

系统通过分析用户的历史行为（评分、播放、收藏），计算用户间的余弦相似度。推荐引擎获取与当前用户最相似的 Top-N 用户，并向其推荐那些相似用户喜爱但当前用户尚未听过的歌曲。如果用户行为数据不足，系统会自动推荐热门榜单（Top 100）作为补充。
