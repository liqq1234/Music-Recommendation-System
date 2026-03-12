const https = require('https');
const fs = require('fs');
const path = require('path');

const API_KEY = 'qrV0nZX2T2UYFuzKYuq';
const BASE_URL = 'https://api.yaohud.cn/api/qqmusic/v2';

const songs = [
  [49, '青花瓷', '周杰伦'], [50, '稻香', '周杰伦'], [51, '七里香', '周杰伦'],
  [52, '晴天', '周杰伦'], [53, '双截棍', '周杰伦'], [54, '简单爱', '周杰伦'],
  [55, '夜曲', '周杰伦'], [56, '反方向的钟', '周杰伦'],
  [57, '十年', '陈奕迅'], [58, '浮夸', '陈奕迅'], [59, '富士山下', '陈奕迅'],
  [60, '孤勇者', '陈奕迅'], [61, '淘汰', '陈奕迅'], [62, '好久不见', '陈奕迅'],
  [63, '江南', '林俊杰'], [64, '修炼爱情', '林俊杰'], [65, '她说', '林俊杰'],
  [66, '可惜没如果', '林俊杰'], [67, '不为谁而作的歌', '林俊杰'],
  [68, '倔强', '五月天'], [69, '突然好想你', '五月天'], [70, '知足', '五月天'],
  [71, '温柔', '五月天'], [72, '干杯', '五月天'],
  [73, '李白', '李荣浩'], [74, '模特', '李荣浩'], [75, '年少有为', '李荣浩'],
  [76, '戒烟', '李荣浩'],
  [77, 'Love Story', 'Taylor Swift'], [78, 'Shake It Off', 'Taylor Swift'],
  [79, 'Blank Space', 'Taylor Swift'], [80, 'Anti-Hero', 'Taylor Swift'],
  [81, '成都', '赵雷'], [82, '画', '赵雷'], [83, '南方姑娘', '赵雷'],
  [84, '鼓楼', '赵雷'],
  [85, '平凡之路', '朴树'], [86, '白桦林', '朴树'], [87, '那些花儿', '朴树'],
  [88, '生如夏花', '朴树'],
  [89, '克罗地亚狂想曲', '马克西姆'], [90, '卡农', '帕赫贝尔'],
  [91, 'River Flows in You', 'Yiruma'], [92, '夜的钢琴曲五', '石进'],
  [93, 'Faded', 'Alan Walker'], [94, 'Alone', 'Alan Walker'],
  [95, 'See You Again', 'Wiz Khalifa'], [96, 'Shape of You', 'Ed Sheeran']
];

function fetchCover(title, singer) {
  return new Promise((resolve) => {
    const word = encodeURIComponent(title + ' ' + singer);
    const url = `${BASE_URL}?type=so&word=${word}&key=${API_KEY}&format=json&per_page=1`;
    https.get(url, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          if (json.code === 200 && json.data && json.data.list && json.data.list.length > 0) {
            resolve(json.data.list[0].pic || null);
          } else { resolve(null); }
        } catch (e) { resolve(null); }
      });
    }).on('error', () => resolve(null));
  });
}

function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

async function main() {
  const sqlLines = ['USE music_recommendation;', ''];
  let ok = 0, fail = 0;

  for (const [id, title, singer] of songs) {
    const pic = await fetchCover(title, singer);
    if (pic) {
      const escaped = pic.replace(/'/g, "''");
      sqlLines.push(`UPDATE music SET cover_url = '${escaped}' WHERE id = ${id};`);
      console.log(`OK [${id}] ${title} -> ${pic}`);
      ok++;
    } else {
      console.log(`FAIL [${id}] ${title}`);
      fail++;
    }
    await sleep(1500);
  }

  const sqlPath = path.join(__dirname, 'real_covers.sql');
  fs.writeFileSync(sqlPath, sqlLines.join('\n'), 'utf8');
  console.log(`\nDone! ${ok} success, ${fail} failed`);
  console.log(`SQL saved to: ${sqlPath}`);
}

main();
