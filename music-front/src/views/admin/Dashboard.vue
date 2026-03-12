<template>
  <div class="dashboard">
    <h2>数据概览</h2>
    <!-- 统计卡片 -->
    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card" style="border-left: 4px solid #409EFF;">
          <div class="stat-num">{{ userStats.total || 0 }}</div>
          <div class="stat-label">总用户数</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card" style="border-left: 4px solid #67C23A;">
          <div class="stat-num">{{ userStats.totalSingers || 0 }}</div>
          <div class="stat-label">歌手数量</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card" style="border-left: 4px solid #E6A23C;">
          <div class="stat-num">{{ musicStats.total || 0 }}</div>
          <div class="stat-label">总音乐数</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card" style="border-left: 4px solid #F56C6C;">
          <div class="stat-num">{{ musicStats.review || 0 }}</div>
          <div class="stat-label">待审核音乐</div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 详细统计 -->
    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="12">
        <el-card>
          <div slot="header"><b>用户角色分布</b></div>
          <div class="chart-placeholder">
            <div class="bar-chart">
              <div class="bar-item">
                <span class="bar-label">普通用户</span>
                <el-progress :percentage="calcPercent(userStats.totalUsers, userStats.total)" color="#409EFF"></el-progress>
                <span class="bar-val">{{ userStats.totalUsers || 0 }}</span>
              </div>
              <div class="bar-item">
                <span class="bar-label">歌手</span>
                <el-progress :percentage="calcPercent(userStats.totalSingers, userStats.total)" color="#67C23A"></el-progress>
                <span class="bar-val">{{ userStats.totalSingers || 0 }}</span>
              </div>
              <div class="bar-item">
                <span class="bar-label">管理员</span>
                <el-progress :percentage="calcPercent(userStats.totalAdmins, userStats.total)" color="#E6A23C"></el-progress>
                <span class="bar-val">{{ userStats.totalAdmins || 0 }}</span>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card>
          <div slot="header"><b>音乐状态分布</b></div>
          <div class="chart-placeholder">
            <div class="bar-chart">
              <div class="bar-item">
                <span class="bar-label">正常上架</span>
                <el-progress :percentage="calcPercent(musicStats.normal, musicStats.total)" color="#67C23A"></el-progress>
                <span class="bar-val">{{ musicStats.normal || 0 }}</span>
              </div>
              <div class="bar-item">
                <span class="bar-label">已下架</span>
                <el-progress :percentage="calcPercent(musicStats.offline, musicStats.total)" color="#F56C6C"></el-progress>
                <span class="bar-val">{{ musicStats.offline || 0 }}</span>
              </div>
              <div class="bar-item">
                <span class="bar-label">审核中</span>
                <el-progress :percentage="calcPercent(musicStats.review, musicStats.total)" color="#E6A23C"></el-progress>
                <span class="bar-val">{{ musicStats.review || 0 }}</span>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'Dashboard',
  data() {
    return { userStats: {}, musicStats: {} }
  },
  created() { this.loadStats() },
  methods: {
    async loadStats() {
      try {
        const [uRes, mRes] = await Promise.all([
          this.$http.get('/api/user/statistics'),
          this.$http.get('/api/music/statistics')
        ])
        this.userStats = uRes.data || {}
        this.musicStats = mRes.data || {}
      } catch (e) { /* ignore */ }
    },
    calcPercent(part, total) {
      if (!total || !part) return 0
      return Math.round((part / total) * 100)
    }
  }
}
</script>

<style scoped>
.dashboard h2 { color: var(--text-primary); font-size: 24px; font-weight: 700; }
.stat-card {
  text-align: center; padding: 16px 0; border-left-width: 4px !important;
  transition: var(--transition);
}
.stat-card:hover { transform: translateY(-3px); }
.stat-num { font-size: 36px; font-weight: 700; color: var(--text-primary); font-variant-numeric: tabular-nums; }
.stat-label { font-size: 14px; color: var(--text-muted); margin-top: 6px; font-weight: 500; }
.bar-chart { padding: 16px 0; }
.bar-item { display: flex; align-items: center; margin-bottom: 18px; gap: 14px; }
.bar-label { width: 70px; font-size: 14px; color: var(--text-secondary); text-align: right; flex-shrink: 0; font-weight: 500; }
.bar-val { width: 40px; font-size: 14px; color: var(--text-primary); font-weight: 700; text-align: right; }
.el-progress { flex: 1; }
</style>
