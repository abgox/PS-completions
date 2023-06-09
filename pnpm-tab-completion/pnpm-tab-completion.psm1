<#
# @Author      : abgox
# @Github      : https://github.com/abgox/PS-completions
# @description : pnpm tab completion script
#>
using namespace System.Management.Automation
using namespace System.Management.Automation.Language
Register-ArgumentCompleter -CommandName 'pnpm' -ScriptBlock {
    param($wordToComplete, $commandAst)
    $completions = [System.Collections.Specialized.OrderedDictionary]::new()
    $tab_cmd = @('pnpm', 'add', 'install', 'remove', 'list', 'update', 'outdated', 'import', 'install-test', 'link', 'prune', 'rebuild', 'unlink', 'exec', 'run', 'start', 'test', 'help')
    foreach ($_ in $tab_cmd) {
        $completions[$_] = [System.Collections.Specialized.OrderedDictionary]::new()
    }
    function addTab($cmd, $subcmd, $Tip) {
        $completions[$cmd] += @{$subcmd = [CompletionResult]::new($subcmd, $subcmd, 'ParameterValue', $Tip) }
    }

    addTab 'pnpm' 'add' "Installs a package and any packages that it depends on.`nBy default, any new package is installed as a prod dependency"
    addTab 'pnpm' 'install' "Alias: i`nInstall all dependencies for a project"
    addTab 'pnpm' 'remove' "Alias: rm`nRemoves packages from node_modules and from the project's package.json"
    addTab 'pnpm' 'list' "Alias: ls`nPrint all the versions of packages that are installed, as well as their dependencies, in a tree-structure"
    addTab 'pnpm' 'update' "Alias: up`nUpdates packages to their latest version based on the specified range"
    addTab 'pnpm' 'outdated' "Check for outdated packages"
    addTab 'pnpm' 'import' "Generates a pnpm-lock.yaml from an npm package-lock.json (or npm-shrinkwrap.json) file"
    addTab 'pnpm' 'install-test' "Alias: it`nRuns a pnpm install followed immediately by a pnpm test"
    addTab 'pnpm' 'link' "Alias: ln`nConnect the local project to another one"
    addTab 'pnpm' 'prune' "Removes extraneous packages"
    addTab 'pnpm' 'rebuild' "Alias: rb`nRebuild a package"
    addTab 'pnpm' 'unlink' "Unlinks a package. Like yarn unlink but pnpm re-installs the dependency after removing the external link"

    addTab 'pnpm' 'exec' "Executes a shell command in scope of a project"
    addTab 'pnpm' 'run' "Runs a defined package script"
    addTab 'pnpm' 'start' "Runs an arbitrary command specified in the package's `"start`" property of its `"scripts`" object"
    addTab 'pnpm' 'test' "Alias: t`nRuns a package's `"test`" script, if one was provided"

    addTab 'pnpm' '-v' "--version`nPrint the current version of pnpm"
    addTab 'pnpm' 'help' "Show official help"
    foreach ($_ in $tab_cmd) {
        if ($_ -ne 'help') {
            if ($_ -ne 'pnpm') {
                addTab 'help' $_ "Show official help about the command -- pnpm $_"
            }
            addTab $_ '-h' "--help`nShow official help"
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
