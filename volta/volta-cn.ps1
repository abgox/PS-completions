<#
# @Author      : abgox
# @Github      : https://github.com/abgox/PS-completions
# @description : Scoop tab completion script
# @version     : v1.0.0
#>
using namespace System.Management.Automation
using namespace System.Management.Automation.Language
Register-ArgumentCompleter -CommandName 'volta' -ScriptBlock {
    param($wordToComplete, $commandAst)
    $completions = [System.Collections.Specialized.OrderedDictionary]::new()
    $tab_cmd = @('volta', 'pin', 'list', 'install', 'fetch', 'uninstall', 'which', 'run', 'setup', 'completions', 'help')
    foreach ($_ in $tab_cmd) {
        $completions[$_] = [System.Collections.Specialized.OrderedDictionary]::new()
    }
    function addTab($cmd, $subcmd, $Tip) {
        $completions[$cmd] += @{$subcmd = [CompletionResult]::new($subcmd, $subcmd, 'ParameterValue', $Tip) }
    }
    addTab 'volta' 'pin' "固定项目的运行时或包管理器`neg: volta pin node@lts"

    addTab 'volta' 'list' "显示当前工具链"
    addTab 'list' '-c' "--current`n显示当前活动的工具"
    addTab 'list' '-d' "--default`n显示默认工具"
    addTab 'list' '--format' "指定输出格式,可选值(human,plain)`neg: volta list --format human`n    volta list --format plain"

    addTab 'volta' 'install' "安装工具`neg: volta install yarn@1"
    addTab 'install' 'node' "安装 Node `neg: volta install node@lts`n    volta install node@16"
    addTab 'install' 'npm' "安装 Npm `neg: volta install npm@8"
    addTab 'install' 'yarn' "安装 Yarn`neg: volta install yarn@1"

    addTab 'volta' 'fetch' "获取一个工具到本地`neg: volta fetch yarn@1"
    addTab 'fetch' 'node' "获取 Node `neg: volta fetch node@lts`n    volta fetch node@16"
    addTab 'fetch' 'npm' "获取 Npm`neg: volta fetch npm@8"
    addTab 'fetch' 'yarn' "获取 Yarn`neg: volta fetch yarn@1"

    addTab 'volta' 'uninstall' "卸载工具`neg: volta uninstall yarn@1"
    addTab 'uninstall' 'node' "卸载 Node `neg: volta uninstall node@lts`n    volta uninstall node@16"
    addTab 'uninstall' 'npm' "卸载 Npm`neg: volta uninstall npm@8"
    addTab 'uninstall' 'yarn' "卸载 Yarn`neg: volta uninstall yarn@1"

    addTab 'volta' 'which' "定位 Volta 将要调用二进制文件"
    addTab 'which' 'node' "定位 Node 的二进制文件"
    addTab 'which' 'npm' "定位 Npm 的二进制文件"
    addTab 'which' 'yarn' "定位 Yarn 的二进制文件"

    addTab 'volta' 'run' "运行带有自定义 Node/Npm/Yarn 版本的命令"
    addTab 'run' '--node' "运行带有自定义Node、npm、pnpm和/或Yarn版本的命令`neg: volta run --node <version> <command>"
    addTab 'run' '--npm' "设置自定义的 Npm 版本`neg: volta run --npm <version> <command>"
    addTab 'run' '--yarn' "设置自定义的 Yarn 版本`neg: volta run --yarn <version> <command>"
    addTab 'run' '--env' "设置一个环境变量(可以多次使用)`neg: volta run --env <NAME=value>"
    addTab 'run' '--no-yarn' "禁用 Yarn"
    addTab 'run' '--bundled-npm' "强制 Npm 为 Node 绑定的版本"

    addTab 'volta' 'setup' "为当前用户/Shell启用 Volta"

    addTab 'volta' 'completions' "生成 Volta 补全`n你已经有补全，并不需要它"

    addTab 'volta' '-v' "--cersion`n打印 Volta 版本"
    addTab 'volta' 'help' "显示帮助"
    foreach ($_ in $tab_cmd) {
        if ($_ -ne 'help') {
            if ($_ -ne 'volta') {
                addTab 'help' $_ "显示关于 volta $_ 的帮助"
            }
            addTab $_ '-h' "--help`n显示帮助"
            addTab $_ '--verbose' "启用详细诊断"
            addTab $_ '--c' "防止不必要的输出"

        }
    }
    # ---------------------------------
    $commandElements = $commandAst.CommandElements
    $lastCommandElement = $commandElements[$commandElements.Count - 1].Value
    foreach ($cmd in $completions.keys) {
        if ($commandElements[$commandElements.Count - 2].Value -eq $cmd) {
            $completions[$cmd].keys | Where-Object { $_ -like "$lastCommandElement*" } | ForEach-Object {
                if ($lastCommandElement -ne $_ ) { $completions[$cmd][$_] }
            }
        }
    }
    $completions[$lastCommandElement].keys | Where-Object {
        $_ -like "$wordToComplete*"
    } | ForEach-Object { $completions[$lastCommandElement][$_] }
}
