# 巨人之肩 · 输出模板 (Report Template)

Use this shape for the pre-flight brief. Keep it tight — the whole thing should
fit on one screen unless the landscape is unusually rich. Match the user's
language. Lead with the verdict; don't bury it.

## Template

```markdown
🔭 巨人之肩 · 开工前调研

任务核心问题：<one line — the problem, not the user's chosen solution>
覆盖度：<高 | 中 | 低> · 信源：<web / GitHub / 内置知识>

现状全景（分四桶，每桶最多 3 条，挑最相关的）：
| 名称 | 链接 | 状态 | 关系 | 归类 |
|---|---|---|---|---|
| <name> | <link> | <维护中/活跃/停更 last-commit> | <一句话相关性> | 直接匹配 |
| ... | | | | 相邻方案 |
| ... | | | | 部分方案 |
| ... | | | | 已废弃 |

通用套路（3-6 条，跨方案反复出现的做法）：
- <recurring architecture / library / design choice>
- <...>

差异 / 空白（当前任务和现有方案差在哪 —— 真正的价值所在）：
- <where the task diverges; the real differentiator, honestly stated>
- <...>

裁决：<直接用 X / 基于 Y 改造扩展 / 贡献到上游 Z / 从零做（因为空白 W）/ 先搞清楚为什么前人失败>
下一步：<one concrete action>
```

Then continue with the actual task.

## Worked example

Task: "帮我写个脚本，把飞书多维表格里的重复记录去掉。"

```markdown
🔭 巨人之肩 · 开工前调研

任务核心问题：对结构化表格数据做"按指定字段去重"，数据源是飞书多维表格 (Bitable)。
覆盖度：高 · 信源：web + GitHub

现状全景：
| 名称 | 链接 | 状态 | 关系 | 归类 |
|---|---|---|---|---|
| pandas.drop_duplicates | pandas.pydata.org | 事实标准 | 按列子集判重，本地内存 | 直接匹配 |
| 飞书 Bitable OpenAPI | open.feishu.cn | 官方维护 | 读写/批量删记录的底座 | 直接匹配 |
| dedupe (dedupeio) | github.com/dedupeio/dedupe | 活跃, MIT | 模糊/近似判重 | 相邻方案 |
| csvkit | github.com/wireservice/csvkit | 维护中 | CSV 命令行去重 | 部分方案 |

通用套路：
- 都走"拉数据 → 判重键 → 删/标重复"三步；判重键交给用户指定（整行 vs 某几列）
- drop_duplicates 的 subset 参数就是"按哪些字段判重"
- 脏数据场景普遍用模糊匹配，不用精确等值

差异 / 空白：
- 现成库都吃本地文件；数据在 Bitable，读写要走 OpenAPI，还要处理分页和删除限流
- 用户没定义"什么算重复"——精确等值还是近似，需要先问

裁决：基于现有能力改造——用飞书 OpenAPI 拉/删 + pandas 判重，不造轮子。
下一步：先跟用户确认判重字段，再拉一页样本验证判重逻辑。
```

## Notes

- **2-4 references per bucket** is the sweet spot. Over-searching shows up as a
  landscape table with 15 rows.
- **"未发现直接对标方案"** is legitimate and valuable — say where you looked. It
  tells the user they're in novel territory, which changes how to proceed.
- Always include links so findings are verifiable.
- The **"差异 / 空白"** section and the **verdict** are the point of the whole
  exercise. Everything above them is setup; these two carry the value.
- Don't pad the verdict with "it depends…". Pick one. The user can push back.
