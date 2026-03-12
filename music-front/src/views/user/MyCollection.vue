<template>
  <div class="my-collection">
    <h2>我的收藏</h2>
    <el-table :data="musicList" stripe style="width: 100%; margin-top: 16px;">
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
      <el-table-column label="专辑" width="150">
        <template slot-scope="{ row }">{{ row.music && row.music.album }}</template>
      </el-table-column>
      <el-table-column label="操作" width="160">
        <template slot-scope="{ row }">
          <el-button type="text" icon="el-icon-video-play" @click="playMusic(row)">播放</el-button>
          <el-button type="text" icon="el-icon-delete" style="color:#f56c6c" @click="cancelCollect(row)">取消收藏</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination background layout="prev, pager, next, total"
                   :total="total" :page-size="pageSize" :current-page.sync="pageNum"
                   @current-change="loadList" style="margin-top: 16px; text-align: center;"></el-pagination>
  </div>
</template>

<script>
export default {
  name: 'MyCollection',
  data() {
    return {
      musicList: [], pageNum: 1, pageSize: 15, total: 0,
      defaultCover: 'https://via.placeholder.com/40x40?text=%E2%99%AA'
    }
  },
  created() { this.loadList() },
  methods: {
    async loadList() {
      try {
        const res = await this.$http.get('/api/interaction/page', {
          params: { pageNum: this.pageNum, pageSize: this.pageSize, type: 'favorite' }
        })
        this.musicList = res.data.records || []
        this.total = res.data.total || 0
      } catch (e) { /* ignore */ }
    },
    playMusic(row) {
      if (row.music) {
        this.$store.dispatch('playMusic', { ...row.music, id: row.musicId })
        this.$http.post('/api/music/play/' + row.musicId).catch(() => {})
      }
    },
    async cancelCollect(row) {
      try {
        await this.$http.post('/api/interaction/favorite/' + row.musicId)
        this.$message.success('已取消收藏')
        this.loadList()
      } catch (e) { /* ignore */ }
    }
  }
}
</script>

<style scoped>
.my-collection h2 { margin-bottom: 20px; color: var(--text-primary); font-size: 24px; font-weight: 700; }
</style>
