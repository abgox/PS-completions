[![license](https://img.shields.io/github/license/abgox/PS-completions)](https://github.com/ivaquero/scoopet/blob/master/LICENSE)
[![code size](https://img.shields.io/github/languages/code-size/abgox/PS-completions.svg)](https://img.shields.io/github/languages/code-size/abgox/PS-completions.svg)
[![repo size](https://img.shields.io/github/repo-size/abgox/PS-completions.svg)](https://img.shields.io/github/repo-size/abgox/PS-completions.svg)

<p align="left">
<a href="README.md">English</a> |
<a href="README-CN.md">简体中文</a>
</p>

# PowerShell 中的一些命令补全

## 为什么要使用它

### 以 scoop.ps1 举例

-   更完善的命令补全
    -   基于本地文件进行补全
-   更好的交互
-   更便捷的帮助提示
-   帮助提示多语言选择(如果有不同语言的补全脚本)
    -   英文(scoop.ps1)
    -   中文(scoop-cn.ps1)
    -   中英结合(scoop-cn-en.ps1)
    -   ...

![scoop demo1](./scoop/demo.gif)
![scoop demo2](./scoop/demo2.gif)

## 如何使用它

### 还是以 Take scoop.ps1 为例

#### 1. 通过 Scoop 安装 (推荐)
1. `scoop bucket add abgo_bucket https://github.com/abgox/abgo_bucket`
2. `scoop install scoop-tab`
    - 在 Scoop bucket 中 以此规律命名
    - `scoop.ps1`  >>> `scoop-tab`
    - `scoop-cn.ps1` >>> `scoop-tab-cn`
    - ...
3. 重启 PowerShell 就可以使用了

##### 没有使用过 Scoop :

-   [什么是 Scoop](https://github.com/ScoopInstaller/Scoop)
-   [安装 Scoop](https://github.com/ScoopInstaller/Install)
-   [Scoop 文档](https://github.com/ScoopInstaller/Scoop/wiki)


#### 2. 手动安装

1. 下载 `scoop.ps1`
2. 保存到电脑本地合适的位置
    - 因为这个 `scoop.ps1` 必须一直存在除非你不再使用此补全
3. 复制文件路径
4. `notepad $PROFILE`
5. 在打开的文件中添加以下内容

```powershell
# 添加这一行以启用补全菜单
Set-PSReadLineKeyHandler -Key 'Tab' -Function MenuComplete
# 添加这一行以使用 scoop completions
cat <将复制的路径放到这里> | Out-String | Invoke-Expression
```
