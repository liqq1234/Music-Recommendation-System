<template>
  <div class="recommend">
    <h2>个性推荐</h2>
    <p class="sub-title">基于协同过滤算法，根据您的评分、收藏和播放记录为您推荐</p>

    <el-tabs v-model="activeTab" @tab-click="handleTabChange">
      <el-tab-pane label="为你推荐" name="personal">
        <div v-loading="loading">
          <div class="music-grid" v-if="personalList.length">
            <div class="music-card" v-for="item in personalList" :key="item.id"
                 @click="$router.push('/music/' + item.id)">
              <div class="card-cover">
                <img :src="item.coverUrl || defaultCover" />
                <div class="play-overlay" @click.stop="playMusic(item)">
                  <i class="el-icon-video-play"></i>
                </div>
              </div>
              <div class="card-info">
                <span class="card-title">{{ item.title }}</span>
                <span class="card-singer">{{ item.singerName }}</span>
              </div>
            </div>
          </div>
          <el-empty v-else description="暂无推荐，去听听音乐和评分吧"></el-empty>
        </div>
      </el-tab-pane>
      <el-tab-pane label="热门 TOP 100" name="top100">
        <el-table :data="top100List" stripe>
          <el-table-column type="index" label="排名" width="70"></el-table-column>
          <el-table-column label="封面" width="60">
            <template slot-scope="{ row }">
              <img :src="row.coverUrl || defaultCover" style="width:40px;height:40px;border-radius:4px;object-fit:cover;" />
            </template>
          </el-table-column>
          <el-table-column prop="title" label="歌曲" min-width="200">
            <template slot-scope="{ row }">
              <el-link @click="$router.push('/music/' + row.id)">{{ row.title }}</el-link>
            </template>
          </el-table-column>
          <el-table-column prop="singerName" label="歌手" width="150"></el-table-column>
          <el-table-column prop="playCount" label="播放量" width="100"></el-table-column>
          <el-table-column label="评分" width="100">
            <template slot-scope="{ row }">{{ row.avgScore ? row.avgScore.toFixed(1) : '--' }}</template>
          </el-table-column>
          <el-table-column label="操作" width="80">
            <template slot-scope="{ row }">
              <el-button type="text" icon="el-icon-video-play" @click="playMusic(row)">播放</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
export default {
  name: 'Recommend',
  data() {
    return {
      activeTab: 'personal', personalList: [], top100List: [], loading: false,
      defaultCover: 'https://via.placeholder.com/200x200?text=Music'
    }
  },
  created() { this.loadPersonal() },
  methods: {
    handleTabChange(tab) {
      if (tab.name === 'personal' && this.personalList.length === 0) this.loadPersonal()
      if (tab.name === 'top100' && this.top100List.length === 0) this.loadTop100()
    },
    async loadPersonal() {
      this.loading = true
      try {
        const res = await this.$http.get('/api/recommend/personal', { params: { limit: 20 } })
        this.personalList = res.data || []
      } catch (e) { /* ignore */ }
      this.loading = false
    },
    async loadTop100() {
      try {
        const res = await this.$http.get('/api/recommend/top100')
        this.top100List = res.data || []
      } catch (e) { /* ignore */ }
    },
    playMusic(music) {
      this.$store.dispatch('playMusic', music)
      this.$http.post('/api/music/play/' + music.id).catch(() => {})
    }
  }
}
</script>

<style scoped>
.recommend h2 { margin-bottom: 6px; color: var(--text-primary); font-size: 24px; font-weight: 700; }
.sub-title { color: var(--text-muted); font-size: 14px; margin-bottom: 24px; }
.music-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 20px; }
.music-card {
  background: #fff; border-radius: 12px; overflow: hidden; cursor: pointer;
  transition: var(--transition); border: 1px solid var(--border);
}
.music-card:hover {
  transform: translateY(-4px); box-shadow: 0 8px 24px rgba(0,0,0,0.1);
  border-color: var(--primary-light);
}
.card-cover { position: relative; padding-top: 100%; overflow: hidden; }
.card-cover img {
  position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover;
  transition: transform 0.4s ease;
}
.music-card:hover .card-cover img { transform: scale(1.08); }
.play-overlay {
  position: absolute; top: 0; left: 0; right: 0; bottom: 0;
  display: flex; align-items: center; justify-content: center;
  background: rgba(0,0,0,0.35); opacity: 0; transition: opacity 0.25s;
}
.card-cover:hover .play-overlay { opacity: 1; }
.play-overlay i { font-size: 44px; color: #fff; filter: drop-shadow(0 2px 8px rgba(0,0,0,0.3)); }
.card-info { padding: 14px; }
.card-title { display: block; font-size: 14px; color: var(--text-primary); font-weight: 600; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.card-singer { display: block; font-size: 12px; color: var(--text-muted); margin-top: 4px; }
</style>
