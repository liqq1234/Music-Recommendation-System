const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  lintOnSave: false,
  devServer: {
    port: 8080,
    proxy: {
      '/api': {
        target: 'http://localhost:8089',
        changeOrigin: true
      },
      '/uploads': {
        target: 'http://localhost:8089',
        changeOrigin: true
      }
    }
  }
})
