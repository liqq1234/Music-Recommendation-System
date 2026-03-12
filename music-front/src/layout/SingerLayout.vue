<template>
  <el-container class="singer-layout">
    <el-aside width="220px" class="aside">
      <div class="aside-logo">
        <i class="el-icon-microphone"></i>
        <span>歌手工作台</span>
      </div>
      <el-menu :default-active="activeMenu" router background-color="#1A3C2A"
               text-color="#A8D5BA" active-text-color="#4CD964" unique-opened>
        <el-menu-item index="/singer/music">
          <i class="el-icon-headset"></i><span>我的音乐</span>
        </el-menu-item>
        <el-menu-item index="/singer/upload">
          <i class="el-icon-upload2"></i><span>上传音乐</span>
        </el-menu-item>
        <el-menu-item index="/singer/profile">
          <i class="el-icon-user"></i><span>个人信息</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header class="singer-header">
        <span></span>
        <el-dropdown @command="handleCommand">
          <span class="el-dropdown-link">
            {{ user.nickname }} <i class="el-icon-arrow-down el-icon--right"></i>
          </span>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item command="home">返回前台</el-dropdown-item>
            <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </el-header>
      <el-main style="background: #f5f7fa; min-height: calc(100vh - 60px);">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script>
export default {
  name: 'SingerLayout',
  computed: {
    activeMenu() { return this.$route.path },
    user() { return this.$store.state.user || {} }
  },
  methods: {
    handleCommand(cmd) {
      if (cmd === 'logout') {
        this.$store.dispatch('logout')
        this.$router.push('/login')
      } else if (cmd === 'home') {
        this.$router.push('/home')
      }
    }
  }
}
</script>

<style scoped>
.singer-layout { height: 100vh; }
.aside { background: linear-gradient(180deg, #1A3C2A 0%, #224D36 100%); overflow: hidden; }
.aside-logo {
  height: 64px; display: flex; align-items: center; justify-content: center;
  color: #4CD964; font-size: 20px; font-weight: 700; gap: 10px;
  font-family: 'Righteous', sans-serif;
  border-bottom: 1px solid rgba(255,255,255,0.08);
  letter-spacing: 0.5px;
}
.aside-logo i { font-size: 22px; }
.singer-header {
  background: var(--bg-card); box-shadow: var(--shadow-sm);
  display: flex; align-items: center; justify-content: space-between; padding: 0 28px;
  height: 64px; border-bottom: 1px solid var(--border);
}
.el-dropdown-link { cursor: pointer; color: var(--text-primary); font-weight: 500; }
</style>
