#!/usr/bin/env bun
/**
 * MyBrain 智能标签建议工具
 * 用法: bun run ~/Obsidian/MyBrain/scripts/auto-tag.ts [--dry-run] [--apply]
 */

const DRY_RUN = process.argv.includes("--dry-run") || !process.argv.includes("--apply");
const VAULT = `${process.env.HOME}/Obsidian/MyBrain`;

async function exec(cmd: string[]): Promise<string> {
  const proc = Bun.spawnSync(cmd, { stdout: "pipe", stderr: "pipe" });
  return new TextDecoder().decode(proc.stdout).trim();
}

async function getUntaggedNotes(): Promise<Array<{ slug: string; type: string }>> {
  // 用 gbrain list 获取所有页面
  const raw = await exec(["gbrain", "list", "--json"]);
  try {
    const pages = JSON.parse(raw);
    // 过滤模板和每日笔记
    return (Array.isArray(pages) ? pages : [])
      .filter((p: any) => {
        const slug = p.slug || "";
        return !slug.startsWith("Templates/") && !slug.startsWith("Daily/");
      })
      .filter((p: any) => !p.tags || p.tags.length < 2);
  } catch {
    console.log("无法解析 gbrain list 输出，请确保已导入笔记库");
    return [];
  }
}

async function main() {
  console.log("🔍 MyBrain 智能标签分析");
  console.log(`模式: ${DRY_RUN ? "预览 (--dry-run)" : "应用 (--apply)"}`);
  console.log("");

  const untagged = await getUntaggedNotes();

  if (untagged.length === 0) {
    console.log("✅ 所有笔记都有足够的标签！");
    return;
  }

  console.log(`发现 ${untagged.length} 条标签不足的笔记:\n`);

  for (const page of untagged.slice(0, 20)) {
    const slug = page.slug;
    const fileName = slug.split("/").pop() || slug;

    // 基于路径和类型给出启发式标签建议
    const suggestions: string[] = [];
    if (slug.startsWith("Projects/")) suggestions.push("项目");
    if (slug.startsWith("Areas/")) suggestions.push("领域");
    if (slug.startsWith("Resources/")) suggestions.push("资源");
    if (slug.startsWith("Archives/")) suggestions.push("归档");
    if (slug.startsWith("Inbox/")) suggestions.push("快抓", "待整理");
    if (fileName.includes("机器视觉") || fileName.includes("VLA") || fileName.includes("VLM")) {
      suggestions.push("机器视觉");
    }
    if (fileName.includes("心理")) suggestions.push("心理学");

    console.log(`  📄 ${fileName}`);
    console.log(`     路径: ${slug}`);
    console.log(`     建议标签: ${suggestions.join(", ") || "(无建议—请手动标记)"}`);
    console.log("");
  }

  if (!DRY_RUN) {
    console.log("⚠️  自动标签功能需要通过 Claude Code 调用 LLM 进行语义分析。");
    console.log("   在当前版本的 auto-tag.ts 中，仅提供路径启发性建议。");
    console.log("   完整版 LLM 标签功能: 在 Claude Code 中说 '帮我分析未标签的笔记'");
  }
}

main();
