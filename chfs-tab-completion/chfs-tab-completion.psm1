<#
# @Author      : abgox
# @Github      : https://github.com/abgox/PS-completions
# @description : chfs tab completion script
#>
using namespace System.Management.Automation
using namespace System.Management.Automation.Language
Register-ArgumentCompleter -CommandName 'chfs' -ScriptBlock {
    param($wordToComplete, $commandAst)
    $completions = [System.Collections.Specialized.OrderedDictionary]::new()
    $tab_cmd = @('chfs')
    foreach ($_ in $tab_cmd) {
        $completions[$_] = [System.Collections.Specialized.OrderedDictionary]::new()
    }
    function addTab($cmd, $subcmd, $Tip) {
        $completions[$cmd] += @{$subcmd = [CompletionResult]::new($subcmd, $subcmd, 'ParameterValue', $Tip) }
    }
    addTab 'chfs' '--path=' "Directories where store shared files`neg: chfs --path=D:\`n    chfs --path=`"C:\Program Files`""
    addTab 'chfs' '--port=' "HTTP listening port(Default is 80)`neg: chfs --port=8080"

    addTab 'chfs' '--log=' "Log directory. Empty value will disable log"

    addTab 'chfs' '--version' "Show application version"

    addTab 'chfs' '--allow=' "Allowed IPv4 addresses(Allow any address by default)`n White list mode: `"listitem1[,listitem2,...]`"`n More help info by running `"chfs --help`""

    addTab 'chfs' '--rule=' "Access rules(anybody can access any thing by default).`nList defines like:`"USER:PWD:MASK[:DIR:MASK...][|...]`":`n`"192.168.1.2-192.168.1.10,192.169.1.222`" allows this 10 addresses.`nBlack list mode: `"not(listitem1[,listitem2,...])`"`n`"not(192.168.1.2-192.168.1.10,192.169.1.222)`" bans this 10 addresses!"

    addTab 'chfs' '--file=' "A configuration file which overwrites & enhence the
    settings"

    addTab 'chfs' '--help' "Show context-sensitive help (also try --help-long and  --help-man)"
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
