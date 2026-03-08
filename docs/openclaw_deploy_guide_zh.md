# OpenClaw 是什么？

OpenClaw 是经典游戏 **Captain Claw（《猫爪船长》）** 的一个开源复刻实现项目，目标是在现代系统上可编译、可运行并可继续维护。

> 注意：OpenClaw 本身通常只提供“游戏引擎/运行时”，并不总是包含原版游戏资源文件（如关卡、音频、贴图等）。
> 你通常需要合法获取原始资源并按项目说明放置。

---

## 一、部署思路（推荐）

本仓库提供了一个一键脚本：

- `scripts/setup_openclaw.sh`

它会完成以下事情：

1. 检查系统（当前针对 Ubuntu/Debian）
2. 安装构建依赖（cmake、g++、SDL2、OpenGL/X11 相关开发包等）
3. 克隆 OpenClaw 源码（默认仓库可通过参数覆盖）
4. 使用 CMake 构建
5. 生成启动说明

---

## 二、快速开始

### 1) 赋予脚本执行权限

```bash
chmod +x scripts/setup_openclaw.sh
```

### 2) 执行安装与构建

```bash
./scripts/setup_openclaw.sh
```

你也可以指定仓库地址、分支、安装目录：

```bash
./scripts/setup_openclaw.sh \
  --repo https://github.com/pjasicek/OpenClaw.git \
  --branch master \
  --dir "$HOME/openclaw"
```

### 3) 运行

构建完成后，进入脚本输出的 `build` 目录运行可执行文件（可执行名会因上游版本略有不同）。

---

## 三、资源文件（非常关键）

OpenClaw 一般需要原版游戏资源。常见处理方式：

1. 合法获取 Captain Claw 原始资源；
2. 参照 OpenClaw 仓库 README 的资源放置说明，将数据文件复制到指定目录（通常是可执行同级目录或指定 data 目录）；
3. 启动程序验证是否能正常进入主菜单。

---

## 四、常见问题

### 1) `apt` 安装失败

- 检查网络；
- 更换镜像源；
- 确保当前用户有 sudo 权限。

### 2) SDL2/OpenGL 相关编译报错

- 再次确认依赖是否安装完整；
- `sudo apt install libsdl2-dev libgl1-mesa-dev libglu1-mesa-dev`。

### 3) 启动后黑屏/缺资源

- 绝大多数是资源路径不对；
- 对照 OpenClaw 上游文档检查资源目录结构。

---

## 五、如果你要“服务器化部署”

OpenClaw 本质是桌面游戏程序，通常不是 Web 服务。
如果你想在云主机上“远程玩”：

- 可考虑图形转发（X11/VNC/Sunshine + Moonlight）；
- 或将其封装到支持 GPU 的桌面容器/云桌面环境。

