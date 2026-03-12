<template>
  <div class="user-manage">
    <h2>用户管理</h2>
    <div class="filter-bar" style="margin: 16px 0;">
      <el-input v-model="keyword" placeholder="搜索用户名/昵称" prefix-icon="el-icon-search"
                clearable style="width:220px;" @keyup.enter.native="loadList" @clear="loadList"></el-input>
      <el-select v-model="roleFilter" placeholder="全部角色" clearable @change="loadList" style="width:130px;margin-left:12px;">
        <el-option label="普通用户" :value="0"></el-option>
        <el-option label="歌手" :value="1"></el-option>
        <el-option label="管理员" :value="2"></el-option>
      </el-select>
    </div>
    <el-table :data="userList" stripe>
      <el-table-column prop="id" label="ID" width="70"></el-table-column>
      <el-table-column prop="username" label="用户名" width="130"></el-table-column>
      <el-table-column prop="nickname" label="昵称" width="130"></el-table-column>
      <el-table-column label="角色" width="100">
        <template slot-scope="{ row }">
          <el-tag :type="row.role === 2 ? 'danger' : row.role === 1 ? 'warning' : 'info'" size="small">
            {{ row.role === 2 ? '管理员' : row.role === 1 ? '歌手' : '普通用户' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态" width="80">
        <template slot-scope="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small">
            {{ row.status === 1 ? '正常' : '禁用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="email" label="邮箱" width="180"></el-table-column>
      <el-table-column prop="phone" label="手机号" width="130"></el-table-column>
      <el-table-column prop="createTime" label="注册时间" width="170"></el-table-column>
      <el-table-column label="操作" width="140" fixed="right">
        <template slot-scope="{ row }">
          <el-button type="text" v-if="row.status === 1" style="color:#f56c6c" @click="toggleStatus(row, 0)">禁用</el-button>
          <el-button type="text" v-else style="color:#67c23a" @click="toggleStatus(row, 1)">启用</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination background layout="prev, pager, next, total"
                   :total="total" :page-size="pageSize" :current-page.sync="pageNum"
                   @current-change="loadList" style="margin-top:16px;text-align:center;"></el-pagination>
  </div>
</template>

<script>
export default {
  name: 'UserManage',
  data() {
    return { userList: [], pageNum: 1, pageSize: 15, total: 0, keyword: '', roleFilter: null }
  },
  created() { this.loadList() },
  methods: {
    async loadList() {
      try {
        const res = await this.$http.get('/api/user/page', {
          params: { pageNum: this.pageNum, pageSize: this.pageSize, keyword: this.keyword || undefined, role: this.roleFilter }
        })
        this.userList = res.data.records || []
        this.total = res.data.total || 0
      } catch (e) { /* ignore */ }
    },
    async toggleStatus(row, status) {
      const action = status === 0 ? '禁用' : '启用'
      try {
        await this.$confirm(`确认${action}用户 "${row.username}" ？`, '提示', { type: 'warning' })
        await this.$http.put('/api/user/status/' + row.id, null, { params: { status } })
        this.$message.success(`${action}成功`)
        this.loadList()
      } catch (e) { /* ignore */ }
    }
  }
}
</script>

<style scoped>
.user-manage h2 { color: var(--text-primary); font-size: 24px; font-weight: 700; }
.filter-bar {
  display: flex; align-items: center; gap: 12px;
  padding: 16px 20px; background: var(--bg-card); border-radius: var(--radius);
  border: 1px solid var(--border); box-shadow: var(--shadow-sm);
}
</style>
