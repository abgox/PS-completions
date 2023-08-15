# 👉[PSCompletions —— 一个更好的管理补全的方式](https://github.com/abgox/PSCompletions 'PSCompletions')👈

[![license](https://img.shields.io/github/license/abgox/PS-completions)](https://github.com/abgox/PS-completions/blob/main/LICENSE)
[![code size](https://img.shields.io/github/languages/code-size/abgox/PS-completions.svg)](https://img.shields.io/github/languages/code-size/abgox/PS-completions.svg)
[![repo size](https://img.shields.io/github/repo-size/abgox/PS-completions.svg)](https://img.shields.io/github/repo-size/abgox/PS-completions.svg)

<p align="left">
<a href="README.md">English</a> |
<a href="README-CN.md">简体中文</a> |
<a href="https://github.com/abgox/PS-completions">Github</a> |
<a href="https://gitee.com/abgox/PS-completions">Gitee</a>
</p>

# PowerShell 中的一些命令补全

## 如何使用它们(以 `scoop-tab-completion` 为例)

### 如何去安装

1. 以管理员身份运行`PowerShell`

2. 运行以下代码:

    ```pwsh
    Install-Module scoop-tab-completion
    ```

3. 重启`Powershell`后运行:

    ```pwsh
    Import-Module scoop-tab-completion
    ```

    或者添加到配置文件中:

    ```pwsh
    echo "Import-Module scoop-tab-completion" >> $PROFILE
    ```

    这样就不用每次打开 `Powershell` 引入这个模块

### 如何卸载

1. 以管理员身份运行`PowerShell`.
2. 运行以下代码:

    ```pwsh
    Uninstall-Module scoop-tab-completion
    ```

## Tip

-   `WindowsPowerShell` 也可以使用
-   在`$PROFILE`中设置 `Tab` 补全菜单后，补全体验更好
    -   `echo "Set-PSReadLineKeyHandler -Key 'Tab' -Function MenuComplete" >> $PROFILE`
-   补全提示语言默认为系统语言，除非设置变量
    -   `$tab_completion_language="en-US"`
    -   可用语言范围: `en-US`，`zh-CN`
        -   如果变量值不在此范围内，则使用系统语言
        -   如果系统语言不在此范围内，则使用 `en-US`

### 示例

![scoop demo](./scoop-tab-completion-demo.gif)
