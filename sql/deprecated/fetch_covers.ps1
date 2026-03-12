$apiKey = "qrV0nZX2T2UYFuzKYuq"
$baseUrl = "https://api.yaohud.cn/api/qqmusic/v2"

# All songs: id, title, singer
$songs = @(
    @(1, "青花瓷", "周杰伦"),
    @(2, "稻香", "周杰伦"),
    @(3, "七里香", "周杰伦"),
    @(4, "晴天", "周杰伦"),
    @(5, "双截棍", "周杰伦"),
    @(6, "简单爱", "周杰伦"),
    @(7, "夜曲", "周杰伦"),
    @(8, "反方向的钟", "周杰伦"),
    @(9, "十年", "陈奕迅"),
    @(10, "浮夸", "陈奕迅"),
    @(11, "富士山下", "陈奕迅"),
    @(12, "孤勇者", "陈奕迅"),
    @(13, "淘汰", "陈奕迅"),
    @(14, "好久不见", "陈奕迅"),
    @(15, "江南", "林俊杰"),
    @(16, "修炼爱情", "林俊杰"),
    @(17, "她说", "林俊杰"),
    @(18, "可惜没如果", "林俊杰"),
    @(19, "不为谁而作的歌", "林俊杰"),
    @(20, "倔强", "五月天"),
    @(21, "突然好想你", "五月天"),
    @(22, "知足", "五月天"),
    @(23, "温柔", "五月天"),
    @(24, "干杯", "五月天"),
    @(25, "李白", "李荣浩"),
    @(26, "模特", "李荣浩"),
    @(27, "年少有为", "李荣浩"),
    @(28, "戒烟", "李荣浩"),
    @(29, "Love Story", "Taylor Swift"),
    @(30, "Shake It Off", "Taylor Swift"),
    @(31, "Blank Space", "Taylor Swift"),
    @(32, "Anti-Hero", "Taylor Swift"),
    @(33, "成都", "赵雷"),
    @(34, "画", "赵雷"),
    @(35, "南方姑娘", "赵雷"),
    @(36, "鼓楼", "赵雷"),
    @(37, "平凡之路", "朴树"),
    @(38, "白桦林", "朴树"),
    @(39, "那些花儿", "朴树"),
    @(40, "生如夏花", "朴树"),
    @(41, "克罗地亚狂想曲", "马克西姆"),
    @(42, "卡农", "帕赫贝尔"),
    @(43, "River Flows in You", "Yiruma"),
    @(44, "夜的钢琴曲五", "石进"),
    @(45, "Faded", "Alan Walker"),
    @(46, "Alone", "Alan Walker"),
    @(47, "See You Again", "Wiz Khalifa"),
    @(48, "Shape of You", "Ed Sheeran")
)

$sqlLines = @("USE music_recommendation;", "")

foreach ($song in $songs) {
    $id = $song[0]
    $title = $song[1]
    $singer = $song[2]
    $word = [System.Web.HttpUtility]::UrlEncode("$title $singer")
    $url = "$baseUrl`?type=so&word=$word&key=$apiKey&format=json&per_page=1"
    
    try {
        $response = Invoke-RestMethod -Uri $url -Method Get -TimeoutSec 15
        if ($response.code -eq 200 -and $response.data.list.Count -gt 0) {
            $pic = $response.data.list[0].pic
            if ($pic) {
                $escapedPic = $pic.Replace("'", "''")
                $sqlLines += "UPDATE music SET cover_url = '$escapedPic' WHERE id = $id;"
                Write-Host "OK: [$id] $title - $pic"
            } else {
                Write-Host "NO PIC: [$id] $title"
            }
        } else {
            Write-Host "NO RESULT: [$id] $title"
        }
    } catch {
        Write-Host "ERROR: [$id] $title - $_"
    }
    
    Start-Sleep -Milliseconds 1500
}

$sqlContent = $sqlLines -join "`n"
$sqlPath = Join-Path $PSScriptRoot "real_covers.sql"
[System.IO.File]::WriteAllText($sqlPath, $sqlContent, [System.Text.Encoding]::UTF8)
Write-Host "`nSQL file saved to: $sqlPath"
