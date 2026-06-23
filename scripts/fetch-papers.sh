#!/bin/bash
# arXiv 机器视觉论文自动抓取
# 运行时间: 每日 07:00 (launchd)
# 输出: ~/Obsidian/MyBrain/Inbox/papers-YYYY-MM-DD.md

DATE=$(date +%Y-%m-%d)
INBOX="$HOME/Obsidian/MyBrain/Inbox"
OUTFILE="$INBOX/papers-${DATE}.md"

# arXiv API 查询 cat:cs.CV (计算机视觉) + 关键词
QUERY="cat:cs.CV+AND+%28visual+recognition+OR+object+detection+OR+image+segmentation+OR+vision+language+OR+VLA+OR+embodied+AI%29"
MAX_RESULTS=5
API_URL="http://export.arxiv.org/api/query?search_query=${QUERY}&sortBy=submittedDate&sortOrder=descending&max_results=${MAX_RESULTS}"

echo "---" > "$OUTFILE"
echo "created: $DATE" >> "$OUTFILE"
echo "tags: [论文, 机器视觉, 自动抓取]" >> "$OUTFILE"
echo "source: arXiv API" >> "$OUTFILE"
echo "---" >> "$OUTFILE"
echo "" >> "$OUTFILE"
echo "# 📄 arXiv 机器视觉最新论文 - $DATE" >> "$OUTFILE"
echo "" >> "$OUTFILE"
echo "> 自动抓取时间: $(date '+%H:%M')" >> "$OUTFILE"
echo "> 来源: [arXiv cs.CV](https://arxiv.org/list/cs.CV/recent)" >> "$OUTFILE"
echo "" >> "$OUTFILE"

# 使用 Python 解析 arXiv XML 响应
python3 -c "
import urllib.request, xml.etree.ElementTree as ET, sys

url = '$API_URL'
try:
    resp = urllib.request.urlopen(url, timeout=30)
    xml_data = resp.read().decode('utf-8')
    root = ET.fromstring(xml_data)
    ns = {
        'atom': 'http://www.w3.org/2005/Atom',
        'arxiv': 'http://arxiv.org/schemas/atom'
    }
    entries = root.findall('atom:entry', ns)
    if not entries:
        print('_(暂无新论文)_')
    for i, entry in enumerate(entries[:$MAX_RESULTS], 1):
        title = entry.find('atom:title', ns).text.strip().replace('\n', ' ')
        summary = entry.find('atom:summary', ns).text.strip()[:300].replace('\n', ' ')
        link = entry.find('atom:id', ns).text.strip()
        published = entry.find('atom:published', ns).text.strip()[:10]
        authors = [a.find('atom:name', ns).text for a in entry.findall('atom:author', ns)]
        author_str = ', '.join(authors[:3])
        if len(authors) > 3:
            author_str += ' et al.'

        print(f'## {i}. {title}')
        print(f'')
        print(f'- **作者:** {author_str}')
        print(f'- **日期:** {published}')
        print(f'- **链接:** [{link.split(\"/\")[-1]}]({link})')
        print(f'- **摘要:** {summary}')
        print(f'')
except Exception as e:
    print(f'_(抓取失败: {e})_')
" >> "$OUTFILE"

echo "---" >> "$OUTFILE"
echo "" >> "$OUTFILE"
echo "## 相关笔记" >> "$OUTFILE"
echo "" >> "$OUTFILE"
echo "- [[机器视觉学习路线]]" >> "$OUTFILE"
echo "- [[VLA 模型]]" >> "$OUTFILE"
echo "" >> "$OUTFILE"
echo "> 💡 每周整理时，将感兴趣论文移到 Resources/文献/" >> "$OUTFILE"

# 触发同步
(gbrain sync --repo ~/Obsidian/MyBrain --quiet 2>/dev/null &)

echo "✅ arXiv 论文抓取完成: $OUTFILE"
