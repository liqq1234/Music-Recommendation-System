<template>
  <div class="profile">
    <h2>个人信息</h2>
    <el-card style="max-width: 600px; margin-top: 16px;">
      <el-form :model="form" label-width="80px">
        <el-form-item label="用户名">
          <el-input :value="form.username" disabled></el-input>
        </el-form-item>
        <el-form-item label="昵称">
          <el-input v-model="form.nickname"></el-input>
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="form.email"></el-input>
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="form.phone"></el-input>
        </el-form-item>
        <el-form-item label="简介">
          <el-input v-model="form.introduction" type="textarea" rows="3"></el-input>
        </el-form-item>
        <el-form-item label="头像">
          <el-upload action="/api/file/upload" :data="{ type: 'avatar' }"
                     :headers="uploadHeaders" :show-file-list="false"
                     :on-success="handleAvatarSuccess">
            <el-avatar :size="64" :src="form.avatar || undefined" icon="el-icon-user-solid"></el-avatar>
            <el-button size="small" type="text" style="margin-left: 12px;">更换头像</el-button>
          </el-upload>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="saveProfile">保存修改</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card style="max-width: 600px; margin-top: 16px;">
      <h3 style="margin-bottom: 16px;">修改密码</h3>
      <el-form :model="pwdForm" label-width="80px">
        <el-form-item label="原密码">
          <el-input v-model="pwdForm.oldPassword" type="password" show-password></el-input>
        </el-form-item>
        <el-form-item label="新密码">
          <el-input v-model="pwdForm.newPassword" type="password" show-password></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="warning" @click="changePassword">修改密码</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'Profile',
  data() {
    return {
      form: { username: '', nickname: '', email: '', phone: '', introduction: '', avatar: '' },
      pwdForm: { oldPassword: '', newPassword: '' }
    }
  },
  computed: {
    uploadHeaders() {
      return { Authorization: 'Bearer ' + localStorage.getItem('token') }
    }
  },
  created() { this.loadProfile() },
  methods: {
    async loadProfile() {
      try {
        const res = await this.$http.get('/api/user/info')
        this.form = res.data
      } catch (e) { /* ignore */ }
    },
    handleAvatarSuccess(res) {
      if (res.code === 200) {
        this.form.avatar = res.data.url
      }
    },
    async saveProfile() {
      try {
        await this.$http.put('/api/user/update', this.form)
        this.$message.success('保存成功')
        // 更新vuex中的用户信息
        const res = await this.$http.get('/api/user/info')
        this.$store.commit('SET_USER', res.data)
      } catch (e) { /* ignore */ }
    },
    async changePassword() {
      if (!this.pwdForm.oldPassword || !this.pwdForm.newPassword) {
        this.$message.warning('请填写完整')
        return
      }
      if (this.pwdForm.newPassword.length < 6) {
        this.$message.warning('新密码至少6个字符')
        return
      }
      try {
        await this.$http.put('/api/user/password', this.pwdForm)
        this.$message.success('密码修改成功，请重新登录')
        this.$store.dispatch('logout')
        this.$router.push('/login')
      } catch (e) { /* ignore */ }
    }
  }
}
</script>

<style scoped>
.profile h2 { margin-bottom: 20px; color: var(--text-primary); font-size: 24px; font-weight: 700; }
</style>
