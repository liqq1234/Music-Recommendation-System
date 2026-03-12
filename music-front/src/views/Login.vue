<template>
  <div class="login-page">
    <div class="login-card">
      <h2 class="login-title"><i class="el-icon-headset"></i> 音乐推荐系统</h2>
      <el-form :model="form" :rules="rules" ref="loginForm" label-width="0">
        <el-form-item prop="username">
          <el-input v-model="form.username" prefix-icon="el-icon-user" placeholder="请输入用户名"></el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="form.password" prefix-icon="el-icon-lock" placeholder="请输入密码"
                    type="password" show-password @keyup.enter.native="handleLogin"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="loading" style="width:100%" @click="handleLogin">登 录</el-button>
        </el-form-item>
      </el-form>
      <div class="login-footer">
        还没有账号？<el-link type="primary" @click="$router.push('/register')">立即注册</el-link>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Login',
  data() {
    return {
      loading: false,
      form: { username: '', password: '' },
      rules: {
        username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
        password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
      }
    }
  },
  methods: {
    handleLogin() {
      this.$refs.loginForm.validate(async valid => {
        if (!valid) return
        this.loading = true
        try {
          const res = await this.$http.post('/api/user/login', this.form)
          this.$store.dispatch('login', res.data)
          this.$message.success('登录成功')
          const role = res.data.user.role
          if (role === 2) {
            this.$router.push('/admin')
          } else if (role === 1) {
            this.$router.push('/singer')
          } else {
            this.$router.push('/home')
          }
        } catch (e) {
          // handled by interceptor
        } finally {
          this.loading = false
        }
      })
    }
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh; display: flex; align-items: center; justify-content: center;
  background: #F5F5F5;
}
.login-card {
  width: 420px; padding: 48px 40px; background: rgba(255,255,255,0.95);
  backdrop-filter: blur(20px); border-radius: 20px;
  box-shadow: 0 25px 60px rgba(0,0,0,0.2); position: relative; z-index: 1;
  animation: slideUp 0.5s ease-out;
}
@keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
.login-title {
  text-align: center; margin-bottom: 36px; color: var(--text-primary); font-size: 26px;
  font-weight: 700; letter-spacing: -0.5px;
}
.login-title i { color: var(--primary); margin-right: 8px; }
.login-footer { text-align: center; color: var(--text-secondary); font-size: 14px; margin-top: 8px; }
</style>
