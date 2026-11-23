# 部署到 GitHub Pages · 操作清单

目标：把 `deploy/index.html` 发布为 https://www.zhupeiwen.top/

## 现状（已核过）

- GitHub 用户名：`jasonzhuv`
- 域名解析已就绪：`zhupeiwen.top` 的 A 记录指向 185.199.108–111.153，`www` 是 CNAME 指向 `jasonzhuv.github.io` —— **DNS 不用再改**
- 当前线上页面来自旧仓库 **PalestInk**（docsify 老站），它的 `CNAME` 文件占着 `www.zhupeiwen.top`
- 本机 SSH 22 端口被网络重置，走不通 → 用 **HTTPS + PAT** 推送
- 本地 `deploy/` 已经是 git 仓库，remote 指向 `https://github.com/jasonzhuv/zhupeiwen-site.git`，首次提交已完成

## 一、建仓库（网页操作，1 分钟）

1. 打开 https://github.com/new
2. Repository name 填 `zhupeiwen-site`
3. 选 **Public**，**不要**勾 Add a README / .gitignore / license
4. Create repository

> 不要用 `jasonzhuv.github.io` 这个名字，那是用户主页仓库，会占用根域名规则。

## 二、生成访问令牌（替代密码）

1. 打开 https://github.com/settings/tokens
2. Generate new token → **Generate new token (classic)**
3. Note 随便写（如 `deploy`），Expiration 选 90 天
4. 勾选 scope：**repo**（整项即可）
5. Generate token，复制那串 `ghp_...`（只显示一次）

> GitHub 2021 年起不再接受账号密码做 git 推送，必须用 PAT。

## 三、推送

```bash
cd "/Users/jason/祝佩文/祝佩文一心搞事业/deploy"
git push -u origin main
```

- Username：`jasonzhuv`
- Password：粘贴刚才的 PAT（不要粘账号密码）

成功会看到 `branch 'main' -> new branch 'main'`。

## 四、开启 Pages

1. 进仓库 → **Settings** → 左侧 **Pages**
2. Source 选 **Deploy from a branch**
3. Branch 选 **main**，目录选 **/ (root)** → **Save**
4. 等 1–2 分钟，页面顶部出现 `Your site is live at https://jasonzhuv.github.io/zhupeiwen-site/`

## 五、把域名让过来（关键顺序）

先释放旧仓库，再绑新仓库，否则 GitHub 会报 “domain is already taken”。

1. 打开 https://github.com/jasonzhuv/PalestInk
2. 删除根目录的 `CNAME` 文件（进文件 → 右上垃圾桶 → Commit changes）
3. 回到 `zhupeiwen-site` → Settings → Pages → **Custom domain** 填 `www.zhupeiwen.top` → **Save**
4. 等 DNS check 通过（几分钟），勾选 **Enforce HTTPS**

## 六、验证

- https://www.zhupeiwen.top/ 打开是新页面
- https://zhupeiwen.top/ 自动跳到 www
- 浏览器地址栏有锁（HTTPS）

## 以后更新内容

改 `plan-site/src/data/plan.js` 或 `base.css` 后，一条命令发布：

```bash
bash "/Users/jason/祝佩文/祝佩文一心搞事业/deploy/deploy.sh"
```

脚本做三件事：构建 → 同步产物 → 提交推送。约 1 分钟后线上生效。

## 常见问题

| 现象 | 原因 | 处理 |
|---|---|---|
| `Repository not found` | 仓库没建 / 名字拼错 / 无权限 | 核对 `zhupeiwen-site` 拼写与 Public 设置 |
| `Authentication failed` | PAT 没勾 repo 或已过期 | 重新生成，勾 repo |
| 页面 404 | Pages 未开或分支选错 | Settings → Pages 确认 main + /(root) |
| 域名绑定报占用 | 旧仓库 CNAME 还在 | 先删 PalestInk 的 CNAME，再绑 |
| 开了 HTTPS 仍提示不安全 | 证书签发中 | 等 15–60 分钟，最长 24 小时 |
