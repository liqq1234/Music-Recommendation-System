<template>
  <div class="user-layout">
    <el-header class="header">
      <div class="header-left">
        <h1 class="logo" @click="$router.push('/home')">
          <i class="el-icon-headset"></i> 音乐推荐系统
        </h1>
        <el-menu :default-active="activeMenu" mode="horizontal" router
                 background-color="transparent" text-color="#333" active-text-color="#31C27C">
          <el-menu-item index="/home">首页</el-menu-item>
          <el-menu-item index="/music">音乐库</el-menu-item>
          <el-menu-item index="/playlist">歌单广场</el-menu-item>
          <el-menu-item index="/recommend" v-if="isLoggedIn">个性推荐</el-menu-item>
        </el-menu>
      </div>
      <div class="header-right">
        <el-input v-model="searchKeyword" placeholder="搜索音乐/歌手" prefix-icon="el-icon-search"
                  size="small" style="width: 200px; margin-right: 16px;"
                  @keyup.enter.native="handleSearch" clearable></el-input>
        <template v-if="isLoggedIn">
          <el-dropdown @command="handleCommand">
            <span class="el-dropdown-link">
              <el-avatar :size="32" :src="user.avatar || undefined" icon="el-icon-user-solid"></el-avatar>
              {{ user.nickname }} <i class="el-icon-arrow-down el-icon--right"></i>
            </span>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="profile"><i class="el-icon-user"></i>个人信息</el-dropdown-item>
              <el-dropdown-item command="collection"><i class="el-icon-star-off"></i>我的收藏</el-dropdown-item>
              <el-dropdown-item command="myplaylist"><i class="el-icon-notebook-2"></i>我的歌单</el-dropdown-item>
              <el-dropdown-item command="history"><i class="el-icon-time"></i>播放历史</el-dropdown-item>
              <el-dropdown-item divided v-if="user.role === 1" command="singer"><i class="el-icon-microphone"></i>歌手工作台</el-dropdown-item>
              <el-dropdown-item divided v-if="user.role === 2" command="admin"><i class="el-icon-setting"></i>管理后台</el-dropdown-item>
              <el-dropdown-item divided command="logout"><i class="el-icon-switch-button"></i>退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
        <template v-else>
          <el-button type="text" @click="$router.push('/login')">登录</el-button>
          <el-button type="text" style="color:var(--primary)" @click="$router.push('/register')">注册</el-button>
        </template>
      </div>
    </el-header>
    <el-main class="main-content" style="padding-bottom: 80px;">
      <router-view />
    </el-main>
  </div>
</template>

<script>
export default {
  name: 'UserLayout',
  data() {
    return { searchKeyword: '' }
  },
  computed: {
    activeMenu() { return this.$route.path },
    isLoggedIn() { return this.$store.getters.isLoggedIn },
    user() { return this.$store.state.user || {} }
  },
  methods: {
    handleSearch() {
      if (this.searchKeyword.trim()) {
        this.$router.push({ path: '/music', query: { keyword: this.searchKeyword } })
      }
    },
    handleCommand(cmd) {
      const map = {
        profile: '/profile', collection: '/my/collection',
        myplaylist: '/my/playlist', history: '/my/history',
        singer: '/singer', admin: '/admin'
      }
      if (cmd === 'logout') {
        this.$store.dispatch('logout')
        this.$router.push('/login')
      } else if (map[cmd]) {
        this.$router.push(map[cmd])
      }
    }
  }
}
</script>

<style scoped>
.user-layout { min-height: 100vh; }
.header {
  background: #fff;
  display: flex; align-items: center; justify-content: space-between;
  padding: 0 32px; height: 64px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.08);
  position: sticky; top: 0; z-index: 100;
  border-bottom: 1px solid #eee;
}
.header-left { display: flex; align-items: center; }
.logo {
  color: var(--primary); font-size: 22px; cursor: pointer; margin-right: 40px;
  white-space: nowrap; font-family: 'Righteous', sans-serif;
  letter-spacing: 0.5px; transition: var(--transition);
}
.logo:hover { opacity: 0.85; }
.logo i { font-size: 24px; margin-right: 6px; color: var(--primary); }
.header-right { display: flex; align-items: center; gap: 8px; }
.el-dropdown-link {
  display: flex; align-items: center; gap: 8px; cursor: pointer;
  color: var(--text-primary); font-weight: 500; font-size: 14px;
  padding: 4px 12px; border-radius: 20px; transition: var(--transition);
}
.el-dropdown-link:hover { background: rgba(49,194,124,0.08); }
.el-dropdown-link .el-avatar {
  background: linear-gradient(135deg, #31C27C, #4CD964) !important;
  color: #fff !important; font-size: 14px !important;
}
.main-content { max-width: 1200px; margin: 0 auto; padding: 32px 24px; }
.el-menu--horizontal { border-bottom: none !important; }
.el-menu--horizontal > .el-menu-item {
  height: 64px; line-height: 64px; font-size: 15px; font-weight: 500;
  color: #333 !important; transition: var(--transition);
  border-bottom: 3px solid transparent !important;
  margin: 0 4px; border-radius: 0;
}
.el-menu--horizontal > .el-menu-item:hover { color: var(--primary) !important; background: transparent !important; }
.el-menu--horizontal > .el-menu-item.is-active {
  color: var(--primary) !important;
  border-bottom-color: var(--primary) !important;
  background: transparent !important;
}
</style>
