<#
# @Author      : abgox
# @Github      : https://github.com/abgox/PS-completions
# @description : Scoop tab completion script
# @version     : v1.0.1
#>
using namespace System.Management.Automation
using namespace System.Management.Automation.Language
Register-ArgumentCompleter -CommandName 'scoop' -ScriptBlock {
    param($wordToComplete, $commandAst)
    $completions = [System.Collections.Specialized.OrderedDictionary]::new()
    $tab_cmd = @("scoop", 'bucket', 'search', 'install', 'uninstall', 'update', 'list', 'info', 'cache', 'reset', 'cleanup', 'prefix', 'cat', 'checkup', 'alias', 'shim', 'config', 'which', 'hold', 'unhold', 'export', 'import', 'depends', 'status', 'create', 'download', 'virustotal', 'home', 'help')
    foreach ($_ in $tab_cmd) {
        $completions[$_] = [System.Collections.Specialized.OrderedDictionary]::new()
    }
    function addTab($cmd, $subcmd, $Tip) {
        $completions[$cmd] += @{$subcmd = [CompletionResult]::new($subcmd, $subcmd, 'ParameterValue', $Tip) }
    }
    addTab 'scoop' 'bucket' "管理 Scoop buckets"
    addTab 'bucket' 'list' "列出已添加的 buckets"
    addTab 'bucket' 'add' "添加 bucket`neg : scoop bucket add <bucket_name> <bucekt_url>"
    addTab 'bucket' 'rm' "移除 bucket`neg : scoop bucket rm <bucket_name>"
    addTab 'bucket' 'known' "列出所有已知的 buckets"

    addTab 'scoop' 'search' "搜索应用`neg : scoop search <app>"

    addTab 'scoop' 'install' "安装应用`neg : scoop install [option] <[bucket/]app>"
    addTab 'install' '-g' "--global`n全局安装应用"
    addTab 'install' '-i' "--independent`n不自动安装依赖"
    addTab 'install' '-k' "--no-cache`n不使用下载缓存"
    addTab 'install' '-u' "--no-update-scoop`n如果Scoop有新版本，不在安装之前更新Scoop"
    addTab 'install' '-s' "--skip`n跳过 hash 验证(谨慎使用!)"
    addTab 'install' '-a' "--arch <32bit|64bit|arm64>`n如果应用程序支持，使用指定的架构<32bit|64bit|arm64>"

    addTab 'scoop' 'uninstall' "卸载应用`neg : scoop uninstall [option] <app>"
    addTab 'uninstall' '-g' "--global`n全局卸载应用"
    addTab 'uninstall' '-p' "--purge`n删除持久化数据(persist目录下)"

    addTab 'scoop' 'update' "更新应用程序，或者是Scoop本身`neg : scoop update [option] <app>"
    addTab 'update' '-f' "--force`n强制更新，即使没有新版本"
    addTab 'update' '-g' "--global`n更新全局安装的应用"
    addTab 'update' '-i' "--independent`n不自动安装依赖项"
    addTab 'update' '-k' "--no-cache`n不使用下载缓存"
    addTab 'update' '-s' "--skip`n跳过 hash 验证(谨慎使用!)"
    addTab 'update' '-q' "--quiet`n隐藏无关信息"
    addTab 'update' '-a' "--all`n更新所有应用程序(scoop update *)"

    addTab 'scoop' 'list' "列出已安装的所有应用`nscoop list [pattern]`neg : scoop list 7  列出所有应用名含有7的已安装应用"

    addTab 'scoop' 'info' "显示应用信息`neg : scoop info 7zip"
    addTab 'info' '--verbose' "显示详细应用信息"

    addTab 'scoop' 'cache' "查看或清除下载缓存`neg : scoop cache <show/rm> <app>"
    addTab 'cache' 'show' "查看下载缓存`neg : scoop cache show *`n     scoop cache show 7zip"
    addTab 'cache' 'rm' "移除下载缓存`neg : scoop cache rm *`n     scoop cache rm 7zip"

    addTab 'scoop' 'reset' "重置一个应用来解决冲突(版本切换)`neg : scoop reset python`n     scoop reset python27"
    addTab 'reset' '*' "Reset All apps"

    addTab 'scoop' 'cleanup' "通过删除旧版本来清理应用程序`neg : scoop cleanup [option] <app/*>"
    addTab 'cleanup' '-a' "--all`n清除所有应用程序(替代'*')"
    addTab 'cleanup' '-g' "--global`n清理全局安装的应用"
    addTab 'cleanup' '-k' "--cache`n删除过时的下载缓存"

    addTab 'scoop' 'prefix' "返回指定应用程序的路径`neg : scoop perfix <app>`n     scoop perfix 7zip"

    addTab 'scoop' 'cat' "显示指定应用清单的内容`neg : scoop cat <app>`n     scoop cat 7zip"

    addTab 'scoop' 'checkup' "检查Scoop的潜在运行问题"

    addTab 'scoop' 'alias' "管理 Scoop 别名`neg : scoop alias add <name> <command> <description>`n     scoop alias rm <name> <command>`n     scoop alias list"
    addTab 'alias' 'add' "添加别名`neg : scoop alias add <name> <command> <description>`n     scoop alias add upgrade 'scoop update *' 'Updates all apps'`n输入'scoop upgrade'会运行 'scoop update *'"
    addTab 'alias' 'rm' "移除别名`neg : scoop alias rm <name> <command> <description>`n     scoop alias rm upgrade 'scoop update *' 'Updates all apps'`n"
    addTab 'alias' 'list' "列出所有别名"

    addTab 'scoop' 'shim' "操作 Scoop shims`neg : scoop shim [-g] <add/rm/list/info/alter> <shim_name>..."
    addTab 'shim' 'add' "添加自定义 shim`neg : scoop shim add <shim_name> <command_path> [<args>...]"
    addTab 'shim' 'rm' "移除 shim(这可能删除通过应用程序清单添加的 shim)`neg : scoop shim rm <shim_name> [<shim_name>...]"
    addTab 'shim' 'list' "列出所有匹配的 shims`neg : scoop shim list [<shim_name>/<pattern>...]"
    addTab 'shim' 'info' "显示 shim 的信息`neg : scoop shim info <shim_name>"
    addTab 'shim' 'alter' "更改 shim 的目标源`neg : scoop shim alter <shim_name>"
    addTab 'shim' '-g' "--global`n操作全局的 shim(s)"

    addTab 'scoop' 'config' "获取或设置 Scoop 的配置`neg : scoop config <key> <value> -- set`n     scoop config <key> -- get"
    $jsonData = Get-Content -Raw -Path "~\.config\scoop\config.json" | ConvertFrom-Json
    foreach ($_ in $jsonData.PSObject.Properties) {
        $name = "`"" + $_.name + "`""
        $value = "`"" + $_.Value + "`""
        $completion = @{ $name = [CompletionResult]::new($name, $name, 'ParameterValue', $value) }
        $completions['config'] += $completion
    }
    addTab 'scoop' 'which' "定位shim/可执行文件 (类似于 Linux 的 'which' 命令)`neg : scoop which sudo"

    addTab 'scoop' 'hold' "禁用指定软件更新`neg : scoop hold [option] <app>"
    addTab 'hold' '-g' "禁用指定全局软件更新`neg : scoop hold -g sudo"

    addTab 'scoop' 'unhold' "恢复指定软件更新`neg : scoop unhold [option] <app>"
    addTab 'unhold' '-g' "恢复指定全局软件更新`neg : scoop unhold -g sudo"

    addTab 'scoop' 'export' "以JSON格式导出已安装的应用程序、bucket(以及可选的config)`neg : scoop export -c > ~\Desktop\scoopfile.json`n     导出为Desktop下的 scoopfile.json"
    addTab 'export' '-c' "--config`n导出包括 Scoop 配置文件"

    addTab 'scoop' 'import' "以JSON格式导出已安装的应用程序、bucket(以及config)`neg : scoop import  ~\Desktop\scoopfile.json`n     scoop import <url to scoopfile.json>"

    addTab 'scoop' 'depends' "列出应用的依赖项，按安装顺序排列`neg : scoop depends <app>`n     scoop depends python"

    addTab 'scoop' 'status' "显示状态并检查新应用程序版本`neg : scoop status -l"
    addTab 'status' '-l' "--local`n只检查本地安装的应用程序的状态，并禁用远程抓取/检查 Scoop 和 buckets"

    addTab 'scoop' 'create' "创建一个自定义应用程序清单`neg : scoop create <app_url>"

    addTab 'scoop' 'download' "在缓存文件夹中下载应用程序并验证哈希值`neg : `n下载应用程序而不安装它:`n     scoop download git`n下载不同版本的应用程序:`n     scoop download gh@2.7.0`n通过URL从清单中下载应用程序:`n     scoop download https://raw.githubusercontent.com/ScoopInstaller/Main/master/bucket/sudo.json`n从计算机本地中的清单中下载应用程序:`n     scoop download path\to\app.json"

    addTab 'download' '-f' "--force`n强制下载(覆盖缓存)"
    addTab 'download' '--no-hash-check' "跳过hash验证(谨慎使用!)"
    addTab 'download' '-u' "--no-update-scoop`n如果Scoop有新版本，不在安装之前更新Scoop"
    addTab 'download' '-a' "--arch <32bit|64bit|arm64>`n如果应用程序支持，使用指定的架构<32bit|64bit|arm64>"

    addTab 'scoop' 'virustotal' "在 virustotal.com 上查找应用的 hash 或 url`neg : scoop virustotal [* | app1 app2 ...] [options]"
    addTab 'virustotal' '-a' "--all`n检查所有已安装的应用程序"
    addTab 'virustotal' '-s' "--scan`n对于VirusTotal没有信息的包，请发送下载URL以供分析(和将来检索)。这需要配置virustotal_api_key"
    addTab 'virustotal' '-n' "--no-depends`n默认情况下，也会检查所有依赖项。这个选项会避开它。"
    addTab 'virustotal' '-u' "--no-update-scoop`n如果Scoop有新版本，不在安装之前更新Scoop"
    addTab 'virustotal' '-p' "--passthru`n作为对象返回报告"

    addTab 'scoop' 'home' "打开应用主页`neg : scoop home <app>`n     scoop home sudo"

    addTab 'scoop' 'help' "显示官方帮助"
    foreach ($_ in $scoop_cmd) {
        if ($_ -ne 'help') {
            addTab $_ '-h' "显示官方帮助"
            if ($_ -ne 'scoop') {
                addTab 'help' $_ "显示关于 scoop $_ 这个命令的帮助"
            }
        }
    }
    $scoop_path = Split-Path -Path (Split-Path -Path (where.exe scoop)[0] -Parent) -Parent
    foreach ($_ in Get-ChildItem "$scoop_path\apps") {
        $completion = @{$_.name = [CompletionResult]::new($_.name, $_.name, 'ParameterValue', $_) }
        $completions['uninstall'] += $completion
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
