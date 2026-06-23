#!/usr/bin/env bun
/**
 * MyBrain 收件箱自动摘要工具
 * 用法: bun run ~/Obsidian/MyBrain/scripts/summarize-inbox.ts
 *
 * 检测 Inbox/ 中24小时内新增的笔记，通过 gbrain + Claude 生成摘要和分类建议
 */

import { readdirSync, readFileSync, statSync } from "fs";
import { join } from "path";

const VAULT = `${process.env.HOME}/Obsidian/MyBrain`;
const INBOX = join(VAULT, "Inbox");
const NOW = Date.now();
const DAY_MS = 24 * 60 * 60 * 1000;

async function main() {
  console.log("📥 MyBrain 收件箱摘要分析");
  console.log("=" .repeat(40));

  // 找出24h内的新笔记
  const files = readdirSync(INBOX).filter(f => f.endsWith(".md") && f !== "📥 收件箱.md");

  const recent: Array<{ name: string; path: string; content: string; ageHours: number }> = [];

  for (const file of files) {
    const filePath = join(INBOX, file);
    const stat = statSync(filePath);
    const ageMs = NOW - stat.mtimeMs;
    if (ageMs < DAY_MS) {
      const content = readFileSync(filePath, "utf-8");
      const ageHours = Math.round(ageMs / (60 * 60 * 1000) * 10) / 10;
      recent.push({ name: file, path: filePath, content, ageHours });
    }
  }

  if (recent.length === 0) {
    console.log("✅ 收件箱为空或没有近期新增的笔记。");
    return;
  }

  console.log(`发现 ${recent.length} 条近期笔记:\n`);

  for (const note of recent) {
    const lines = note.content.split("\n");
    const title = lines.find(l => l.startsWith("# "))?.replace("# ", "") || note.name;
    const bodyText = lines.filter(l => !l.startsWith("#") && !l.startsWith("---") && !l.startsWith("tags:") && !l.startsWith("created:") && l.trim()).slice(0, 5).join("\n");

    // 启发式分类
    const category = guessCategory(note.content, note.name);

    console.log(`### ${title}`);
    console.log(`- 文件: \`${note.name}\``);
    console.log(`- 创建: ${note.ageHours} 小时前`);
    console.log(`- 建议分类: **${category}**`);
    console.log(`- 预览: ${bodyText.slice(0, 100)}${bodyText.length > 100 ? "..." : ""}`);
    console.log("");
  }

  console.log("---");
  console.log("💡 在 Claude Code 中输入以下命令来生成 AI 摘要:");
  console.log('   "帮我分析 Inbox 里的新笔记，为每篇生成3句话摘要和建议标签"');
}

function guessCategory(content: string, filename: string): string {
  const text = content + filename;
  if (/项目|project|roadmap|路线|学习计划|学习路线/.test(text)) return "Projects";
  if (/论文|paper|文献|VLA|VLM|模型|架构|camera|检测/.test(text)) return "Resources/文献";
  if (/心理|认知|情绪|行为|self|personality/.test(text)) return "Areas/心理学";
  if (/代码|python|jupyter|程序|实现|tutorial/.test(text)) return "Resources/机器视觉";
  if (/日记|daily|日记|碎碎念|mood/.test(text)) return "Daily";
  return "Inbox (待定)";
}

main();
