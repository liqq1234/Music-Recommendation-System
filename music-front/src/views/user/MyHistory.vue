<template>
  <div class="my-history">
    <h2>播放历史</h2>
    <el-table :data="historyList" stripe style="width: 100%; margin-top: 16px;">
      <el-table-column type="index" width="50"></el-table-column>
      <el-table-column label="封面" width="60">
        <template slot-scope="{ row }">
          <img :src="(row.music && row.music.coverUrl) || defaultCover"
               style="width:40px;height:40px;border-radius:4px;object-fit:cover;" referrerpolicy="no-referrer" />
        </template>
      </el-table-column>
      <el-table-column label="歌曲" min-width="200">
        <template slot-scope="{ row }">
          <el-link @click="$router.push('/music/' + row.musicId)">{{ row.music && row.music.title }}</el-link>
        </template>
      </el-table-column>
      <el-table-column label="歌手" width="150">
        <template slot-scope="{ row }">{{ row.music && row.music.singerName }}</template>
      </el-table-column>
      <el-table-column label="播放次数" width="100">
        <template slot-scope="{ row }">{{ row.playCount }} 次</template>
      </el-table-column>
      <el-table-column label="最后播放" width="180">
        <template slot-scope="{ row }">{{ row.lastPlayTime || '--' }}</template>
      </el-table-column>
      <el-table-column label="操作" width="80">
        <template slot-scope="{ row }">
          <el-button type="text" icon="el-icon-video-play" @click="playMusic(row)">播放</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination background layout="prev, pager, next, total"
                   :total="total" :page-size="pageSize" :current-page.sync="pageNum"
                   @current-change="loadHistory" style="margin-top: 16px; text-align: center;"></el-pagination>
  </div>
</template>

<script>
export default {
  name: 'MyHistory',
  data() {
    return {
      historyList: [],
      pageNum: 1, pageSize: 20, total: 0,
      defaultCover: 'https://via.placeholder.com/40x40?text=%E2%99%AA'
    }
  },
  created() { this.loadHistory() },
  methods: {
    async loadHistory() {
      try {
        const res = await this.$http.get('/api/interaction/page', {
          params: { pageNum: this.pageNum, pageSize: this.pageSize, type: 'history' }
        })
        this.historyList = res.data.records || []
        this.total = res.data.total || 0
      } catch (e) { /* ignore */ }
    },
    playMusic(row) {
      if (row.music) {
        this.$store.dispatch('playMusic', { ...row.music, id: row.musicId })
        this.$http.post('/api/music/play/' + row.musicId).catch(() => {})
      }
    }
  }
}
</script>

<style scoped>
.my-history h2 { margin-bottom: 20px; color: var(--text-primary); font-size: 24px; font-weight: 700; }
</style>
