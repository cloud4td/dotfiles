# Dotfiles

macOS 和 devcontainer 的个人配置文件管理仓库。

## 📁 目录结构

```
dotfiles/
├── .devcontainer/          # VS Code devcontainer 配置
│   └── devcontainer.json
├── zsh/                    # Zsh 配置
│   ├── .zshrc             # 主配置文件
│   ├── env.zsh            # 公开环境变量（提交到 git）
│   ├── aliases.zsh        # 别名定义（提交到 git）
│   ├── secrets.zsh        # 敏感信息（不提交，已在 .gitignore）
│   └── secrets.zsh.example # 敏感信息模板
├── scripts/               # 安装和配置脚本
│   └── install.sh         # 主安装脚本
├── .gitignore
└── README.md
```

## 🔐 安全设计

### 敏感信息管理策略

本仓库采用**分离式管理**，将配置分为两类：

**✅ 公开配置**（提交到 git）
- `zsh/env.zsh` - 通用环境变量（Java、Python、Docker 路径等）
- `zsh/aliases.zsh` - 命令别名
- `zsh/.zshrc` - 主配置文件

**🔒 敏感配置**（不提交到 git）
- `zsh/secrets.zsh` - 包含所有 tokens、credentials
- 已在 `.gitignore` 中排除，永远不会提交

### Token 管理的三种方式

#### 方式 1：本地开发（推荐）✨
```bash
# secrets.zsh 已经包含了你当前的 tokens
# 它在 .gitignore 中，不会被提交到 git

# 查看 git 状态确认
cd ~/work/talkdesk/code/dotfiles
git status  # 应该看不到 secrets.zsh
```

#### 方式 2：新机器迁移
```bash
# 在新机器上
git clone https://github.com/cloud4td/dotfiles.git ~/work/talkdesk/code/dotfiles
cd ~/work/talkdesk/code/dotfiles

# 手动创建 secrets.zsh（从模板或手动输入）
cp zsh/secrets.zsh.example zsh/secrets.zsh
vim zsh/secrets.zsh  # 填入真实的 tokens

# 运行安装
./scripts/install.sh
```

#### 方式 3：devcontainer 中使用 🐳

在 VS Code devcontainer 中，敏感信息通过**环境变量**传递：

**选项 A - 本地环境变量**（最简单）
```bash
# 你的 tokens 已经在 ~/.zshrc 中
# devcontainer 会自动从 host 读取这些环境变量
# 不需要额外操作！
```

**选项 B - GitHub Codespaces Secrets**
1. 进入 GitHub repository → Settings
2. Secrets and variables → Codespaces
3. 添加所需的 secrets：
   - `COPILOT_MCP_FIGMA_API_TOKEN`
   - `SNYK_TOKEN`
   - 等等...

## 🚀 快速开始

### 在当前机器应用配置

```bash
# 1. 备份当前配置（已自动完成）
# 2. 运行安装脚本
cd ~/work/talkdesk/code/dotfiles
chmod +x scripts/install.sh
./scripts/install.sh

# 3. 重新加载配置
source ~/.zshrc

# 4. 验证
echo $SNYK_TOKEN  # 应该输出你的 token
```

### 提交到 Git

```bash
cd ~/work/talkdesk/code/dotfiles

# 查看将要提交的文件
git status

# 确认 secrets.zsh 不在列表中！
git add .
git commit -m "Add dotfiles configuration"
git push
```

## 📝 更新配置

```bash
# 修改公开配置
vim ~/dotfiles/zsh/env.zsh

# 提交到 git
cd ~/dotfiles
git add zsh/env.zsh
git commit -m "Update environment config"
git push

# 其他机器拉取更新
git pull
source ~/.zshrc
```

## ⚠️ 安全提醒

- ✅ `secrets.zsh` 已经创建并包含你的真实 tokens
- ✅ `secrets.zsh` 已在 `.gitignore` 中，不会被提交
- ⚠️ 使用 `git status` 确认没有意外提交敏感文件
- 🔄 定期轮换你的 tokens
- 🚨 如果意外提交，使用 `git filter-branch` 或 BFG Repo-Cleaner 清理历史

## 🛠️ 依赖

- zsh
- oh-my-zsh（安装脚本会自动安装）
- git

## 📄 License

MIT