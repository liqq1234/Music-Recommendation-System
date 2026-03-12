<template>
  <div id="app">
    <router-view />
    <!-- 全局音乐播放器 -->
    <div class="global-player" v-if="currentMusic">
      <div class="player-info">
        <img :src="currentMusic.coverUrl || defaultCover" class="player-cover" />
        <div class="player-text">
          <span class="player-title">{{ currentMusic.title }}</span>
          <span class="player-singer">{{ currentMusic.singerName }}</span>
        </div>
      </div>
      <div class="player-controls">
        <audio ref="audio" :src="currentMusic.fileUrl" @ended="onEnded"
               @timeupdate="onTimeUpdate" @loadedmetadata="onLoaded" @error="onAudioError"></audio>
        <el-button icon="el-icon-video-play" circle size="small" v-if="!isPlaying" @click="play"></el-button>
        <el-button icon="el-icon-video-pause" circle size="small" v-else @click="pause"></el-button>
        <el-slider v-model="progress" :show-tooltip="false" @change="seek" class="player-progress"></el-slider>
        <span class="player-time">{{ formatTime(currentTime) }} / {{ formatTime(duration) }}</span>
        <el-slider v-model="volume" :show-tooltip="false" @input="changeVolume" class="player-volume"></el-slider>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'App',
  data() {
    return {
      defaultCover: 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIGZpbGw9IiNlMGUwZTAiLz48dGV4dCB4PSI1MCUiIHk9IjUwJSIgZG9taW5hbnQtYmFzZWxpbmU9Im1pZGRsZSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZmlsbD0iIzk5OSIgZm9udC1zaXplPSIxNiI+8J+OtTwvdGV4dD48L3N2Zz4=',
      progress: 0,
      currentTime: 0,
      duration: 0,
      volume: 80
    }
  },
  computed: {
    currentMusic() {
      return this.$store.state.currentMusic
    },
    isPlaying() {
      return this.$store.state.isPlaying
    }
  },
  watch: {
    currentMusic(val) {
      if (val) {
        this.$nextTick(() => {
          if (this.$refs.audio) {
            this.$refs.audio.volume = this.volume / 100
            this.$refs.audio.play().catch(() => {})
            this.$store.commit('SET_PLAYING', true)
          }
        })
      }
    }
  },
  methods: {
    play() {
      if (this.$refs.audio) {
        this.$refs.audio.play().catch(() => {})
        this.$store.commit('SET_PLAYING', true)
      }
    },
    pause() {
      if (this.$refs.audio) {
        this.$refs.audio.pause()
        this.$store.commit('SET_PLAYING', false)
      }
    },
    onEnded() {
      this.$store.commit('SET_PLAYING', false)
      this.progress = 0
    },
    onTimeUpdate() {
      if (this.$refs.audio) {
        this.currentTime = this.$refs.audio.currentTime
        if (this.duration > 0) {
          this.progress = (this.currentTime / this.duration) * 100
        }
      }
    },
    onLoaded() {
      if (this.$refs.audio) {
        this.duration = this.$refs.audio.duration
      }
    },
    onAudioError() {
      // 音频文件不存在时静默处理，使用音乐自带的duration
      if (this.currentMusic && this.currentMusic.duration) {
        this.duration = this.currentMusic.duration
      }
    },
    seek(val) {
      if (this.$refs.audio && this.duration > 0) {
        this.$refs.audio.currentTime = (val / 100) * this.duration
      }
    },
    changeVolume(val) {
      if (this.$refs.audio) {
        this.$refs.audio.volume = val / 100
      }
    },
    formatTime(s) {
      if (!s || isNaN(s)) return '00:00'
      const m = Math.floor(s / 60)
      const sec = Math.floor(s % 60)
      return `${m.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`
    }
  }
}
</script>

<style>
:root {
  --primary: #31C27C;
  --primary-light: #4CD964;
  --primary-dark: #28A745;
  --accent: #31C27C;
  --bg: #F5F5F5;
  --bg-card: #ffffff;
  --bg-glass: rgba(255, 255, 255, 0.88);
  --text-primary: #1e293b;
  --text-secondary: #64748b;
  --text-muted: #94a3b8;
  --border: #e2e8f0;
  --shadow-sm: 0 1px 3px rgba(0,0,0,0.06), 0 1px 2px rgba(0,0,0,0.04);
  --shadow-md: 0 4px 12px rgba(0,0,0,0.08);
  --shadow-lg: 0 10px 30px rgba(0,0,0,0.1);
  --radius: 12px;
  --radius-sm: 8px;
  --transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: 'Poppins', 'PingFang SC', 'Microsoft YaHei', sans-serif; background: var(--bg); color: var(--text-primary); -webkit-font-smoothing: antialiased; }
h1, h2, h3, h4, .section-header h3 { font-family: 'Righteous', 'PingFang SC', sans-serif; }
#app { min-height: 100vh; padding-bottom: 80px; }

/* ===== Element UI overrides ===== */
.el-button--primary { background: var(--primary) !important; border-color: var(--primary) !important; border-radius: var(--radius-sm) !important; transition: var(--transition) !important; }
.el-button--primary:hover { background: var(--primary-light) !important; border-color: var(--primary-light) !important; transform: translateY(-1px); box-shadow: 0 4px 12px rgba(49,194,124,0.35) !important; }
.el-button { border-radius: var(--radius-sm) !important; transition: var(--transition) !important; }
.el-card { border-radius: var(--radius) !important; border: 1px solid var(--border) !important; background: var(--bg-card) !important; box-shadow: var(--shadow-sm) !important; transition: var(--transition) !important; }
.el-card:hover { box-shadow: var(--shadow-md) !important; }
.el-input__inner { border-radius: var(--radius-sm) !important; border-color: var(--border) !important; transition: var(--transition) !important; }
.el-input__inner:focus { border-color: var(--primary) !important; box-shadow: 0 0 0 3px rgba(49,194,124,0.12) !important; }
.el-table { border-radius: var(--radius) !important; overflow: hidden; }
.el-table th { background: #f1f5f9 !important; color: var(--text-secondary) !important; font-weight: 600 !important; }
.el-pagination .el-pager li.active { background: var(--primary) !important; border-radius: var(--radius-sm) !important; }
.el-rate__icon { font-size: 20px !important; }
.el-slider__bar { background: linear-gradient(90deg, var(--primary), var(--primary-light)) !important; }
.el-slider__button { border-color: var(--primary) !important; }
.el-tag { border-radius: 20px !important; }
.el-message-box { border-radius: var(--radius) !important; }
.el-dialog { border-radius: var(--radius) !important; }

/* ===== Dropdown Menu ===== */
.el-dropdown-menu {
  border-radius: 12px !important; border: none !important; padding: 8px 0 !important;
  box-shadow: 0 8px 30px rgba(0,0,0,0.12), 0 2px 8px rgba(0,0,0,0.06) !important;
  background: rgba(255,255,255,0.92) !important;
  backdrop-filter: blur(20px) saturate(1.6) !important;
  -webkit-backdrop-filter: blur(20px) saturate(1.6) !important;
  overflow: hidden !important; min-width: 160px !important;
}
.el-dropdown-menu__item {
  padding: 10px 24px !important; font-size: 14px !important;
  color: #333 !important; transition: all 0.2s ease !important;
  line-height: 1.6 !important;
}
.el-dropdown-menu__item:hover {
  background: rgba(49,194,124,0.08) !important; color: #31C27C !important;
}
.el-dropdown-menu__item--divided {
  border-top: 1px solid #f0f0f0 !important; margin-top: 4px !important; padding-top: 12px !important;
}
.el-dropdown-menu__item i {
  margin-right: 8px; font-size: 15px;
}
.el-popper[x-placement^="bottom"] .popper__arrow { display: none !important; }

/* ===== Global Player ===== */
.global-player {
  position: fixed; bottom: 0; left: 0; right: 0; height: 72px;
  background: var(--bg-glass); backdrop-filter: blur(20px) saturate(1.8);
  -webkit-backdrop-filter: blur(20px) saturate(1.8);
  border-top: 1px solid rgba(255,255,255,0.5);
  box-shadow: 0 -4px 20px rgba(0,0,0,0.06);
  display: flex; align-items: center; padding: 0 32px; z-index: 999;
}
.player-info { display: flex; align-items: center; min-width: 220px; }
.player-cover {
  width: 48px; height: 48px; border-radius: 10px; object-fit: cover; margin-right: 14px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.12); transition: var(--transition);
}
.player-cover:hover { transform: scale(1.05); }
.player-text { display: flex; flex-direction: column; gap: 2px; }
.player-title { font-size: 14px; color: var(--text-primary); font-weight: 600; }
.player-singer { font-size: 12px; color: var(--text-muted); }
.player-controls { flex: 1; display: flex; align-items: center; gap: 14px; margin-left: 24px; }
.player-controls .el-button { color: var(--primary) !important; border-color: var(--primary) !important; }
.player-controls .el-button:hover { background: rgba(49,194,124,0.08) !important; }
.player-progress { flex: 1; }
.player-time { font-size: 12px; color: var(--text-muted); white-space: nowrap; font-variant-numeric: tabular-nums; }
.player-volume { width: 100px; }

/* ===== Scrollbar ===== */
::-webkit-scrollbar { width: 6px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 3px; }
::-webkit-scrollbar-thumb:hover { background: #94a3b8; }
</style>
