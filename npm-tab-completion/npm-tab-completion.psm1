<#
# @Author      : abgox
# @Github      : https://github.com/abgox/PS-completions
# @description : npm tab completion script
#>
using namespace System.Management.Automation
using namespace System.Management.Automation.Language
Register-ArgumentCompleter -CommandName 'npm' -ScriptBlock {
    param($wordToComplete, $commandAst)
    $completions = [System.Collections.Specialized.OrderedDictionary]::new()
    $tab_cmd = @('npm', 'install', 'uninstall','update','search', 'init','list','test','cache','config','run','root','view','outdated','help')
    foreach ($_ in $tab_cmd) {
        $completions[$_] = [System.Collections.Specialized.OrderedDictionary]::new()
    }
    function addTab($cmd, $subcmd, $Tip) {
        $completions[$cmd] += @{$subcmd = [CompletionResult]::new($subcmd, $subcmd, 'ParameterValue', $Tip) }
    }
    addTab 'npm' 'install' "alias:i`nInstall a package(Not write to package.json)`neg: npm install axios`n    npm i axios"
    addTab 'install' '-g' "Install a package globally`neg: npm i typescript -g"
    addTab 'install' '-S' "--save`n(Default)Install a package(write to the dependencies of package.json)`neg: npm i axios [-S]"
    addTab 'install' '-D' "--save`nInstall a package(write to the devDependencies of package.json)`neg: npm i sass -D"

    addTab 'npm' 'uninstall' "Uninstall a package`neg: npm Uninstall axios"
    addTab 'uninstall' '-g' "Uninstall a package globally`neg: npm uninstall typescript -g"

    addTab 'npm' 'update' "Update a package`neg: npm Update typescript"

    addTab 'npm' 'search' "Search for packages`neg: npm search [search terms ...]"

    addTab 'npm' 'init' "Initialize a package.json file`neg: npm init"
    addTab 'init' '-y' "--yes`nInitialize a package.json file(without confirm)`neg: npm init -y"
    addTab 'init' '-f' "--force`nForce initialize a package.json file"

    addTab 'npm' 'list' "alias: ls`nList installed packages"
    addTab 'list' '-g' "List installed packages globally"

    addTab 'npm' 'test' "run this project's tests"

    addTab 'npm' 'cache' "Manipulates packages cache"
    addTab 'cache' 'add' "Add packages cache`neg: npm cache add <package-spec>"
    addTab 'cache' 'clean' "Clean packages cache`neg: npm cache clean [<key>]"
    addTab 'cache' 'ls' "List packages cache`neg: npm cache ls [<name>@<version>]"
    addTab 'cache' 'Verify' "Verify packages cache`neg: npm cache verify"

    addTab 'npm' 'config' "alias:c`nManage the npm configuration files"
    addTab 'config' 'set' "Set the npm configuration`neg: npm config set <key>=<value> [<key>=<value> ...]"
    addTab 'config' 'get' "Get the npm configuration`neg: npm config get [<key> [<key> ...]]"
    addTab 'config' 'delete' "Delete the npm configuration`neg: npm config delete <key> [<key> ...]"
    addTab 'config' 'list' "List the npm configuration`neg: npm config list [--json]"
    addTab 'config' 'edit' "Edit the npm configuration`neg: npm config edit"
    addTab 'config' 'fix' "Fix the npm configuration`neg: npm config fix"

    addTab 'npm' 'run' "run the script named <foo>`neg: npm run <foo>"

    addTab 'npm' 'root' "Display npm root"

    addTab 'npm' 'view' "View registry info"

    addTab 'npm' 'outdated' "Check for outdated packages"

    addTab 'npm' '-l' "display usage info for all commands"
    addTab 'npm' '-v' "--version`nPrint the current version of Volta"
    addTab 'npm' 'help' "Show official help"
    foreach ($_ in $tab_cmd) {
        if ($_ -ne 'help') {
            if ($_ -ne 'npm') {
                addTab 'help' $_ "Show official help about the command -- npm $_"
            }
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
