<template>
  <div class="my-playlist">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
      <h2>我的歌单</h2>
      <el-button type="primary" icon="el-icon-plus" size="small" @click="showCreate = true">创建歌单</el-button>
    </div>
    <el-table :data="playlists" stripe>
      <el-table-column prop="name" label="歌单名称" min-width="200">
        <template slot-scope="{ row }">
          <el-link @click="$router.push('/playlist/' + row.id)">{{ row.name }}</el-link>
        </template>
      </el-table-column>
      <el-table-column prop="musicCount" label="歌曲数" width="100"></el-table-column>
      <el-table-column label="公开" width="80">
        <template slot-scope="{ row }">{{ row.isPublic ? '是' : '否' }}</template>
      </el-table-column>
      <el-table-column prop="playCount" label="播放量" width="100"></el-table-column>
      <el-table-column label="操作" width="160">
        <template slot-scope="{ row }">
          <el-button type="text" @click="editPlaylist(row)">编辑</el-button>
          <el-button type="text" style="color:#f56c6c" @click="deletePlaylist(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination background layout="prev, pager, next, total"
                   :total="total" :page-size="pageSize" :current-page.sync="pageNum"
                   @current-change="loadList" style="margin-top: 16px; text-align: center;"></el-pagination>

    <!-- 创建/编辑对话框 -->
    <el-dialog :title="editForm.id ? '编辑歌单' : '创建歌单'" :visible.sync="showCreate" width="450px">
      <el-form :model="editForm" label-width="80px">
        <el-form-item label="歌单名称">
          <el-input v-model="editForm.name" placeholder="请输入歌单名称"></el-input>
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="editForm.description" type="textarea" rows="3" placeholder="歌单描述（选填）"></el-input>
        </el-form-item>
        <el-form-item label="是否公开">
          <el-switch v-model="editForm.isPublic" :active-value="1" :inactive-value="0"></el-switch>
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button @click="showCreate = false">取消</el-button>
        <el-button type="primary" @click="submitPlaylist">确定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'MyPlaylist',
  data() {
    return {
      playlists: [], pageNum: 1, pageSize: 15, total: 0,
      showCreate: false,
      editForm: { id: null, name: '', description: '', isPublic: 1 }
    }
  },
  created() { this.loadList() },
  methods: {
    async loadList() {
      try {
        const res = await this.$http.get('/api/playlist/my', {
          params: { pageNum: this.pageNum, pageSize: this.pageSize }
        })
        this.playlists = res.data.records || []
        this.total = res.data.total || 0
      } catch (e) { /* ignore */ }
    },
    editPlaylist(row) {
      this.editForm = { id: row.id, name: row.name, description: row.description, isPublic: row.isPublic }
      this.showCreate = true
    },
    async submitPlaylist() {
      if (!this.editForm.name) {
        this.$message.warning('请输入歌单名称')
        return
      }
      try {
        if (this.editForm.id) {
          await this.$http.put('/api/playlist/update', this.editForm)
        } else {
          await this.$http.post('/api/playlist/create', this.editForm)
        }
        this.$message.success('操作成功')
        this.showCreate = false
        this.editForm = { id: null, name: '', description: '', isPublic: 1 }
        this.loadList()
      } catch (e) { /* ignore */ }
    },
    async deletePlaylist(row) {
      try {
        await this.$confirm('确认删除该歌单？', '提示', { type: 'warning' })
        await this.$http.delete('/api/playlist/delete/' + row.id)
        this.$message.success('删除成功')
        this.loadList()
      } catch (e) { /* ignore */ }
    }
  }
}
</script>

<style scoped>
.my-playlist h2 { color: var(--text-primary); font-size: 24px; font-weight: 700; }
</style>
