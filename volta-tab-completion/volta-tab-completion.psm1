<#
# @Author      : abgox
# @Github      : https://github.com/abgox/PS-completions
# @description : volta tab completion script
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
    addTab 'volta' 'pin' "Pin your project's runtime or package manager`neg: volta pin node@lts"

    addTab 'volta' 'list' "Display the current toolchain"
    addTab 'list' '-c' "--current`nShow the currently-active tool(s)"
    addTab 'list' '-d' "--default`nShow your default tool(s)"
    addTab 'list' '--format' "Specify the output format [possible values: human, plain]`neg: volta list --format human`n    volta list --format plain"

    addTab 'volta' 'install' "Install a tool in your toolchain`neg: volta install yarn@1"
    addTab 'install' 'node' "Install node `neg: volta install node@lts`n    volta install node@16"
    addTab 'install' 'npm' "Install npm`neg: volta install npm@8"
    addTab 'install' 'yarn' "Install yarn`neg: volta install yarn@1"

    addTab 'volta' 'fetch' "Fetch a tool to the local machine`neg: volta fetch yarn@1"
    addTab 'fetch' 'node' "Fetch node `neg: volta fetch node@lts`n    volta fetch node@16"
    addTab 'fetch' 'npm' "Fetch npm`neg: volta fetch npm@8"
    addTab 'fetch' 'yarn' "Fetch yarn`neg: volta fetch yarn@1"

    addTab 'volta' 'uninstall' "Uninstall a tool in your toolchain`neg: volta uninstall yarn@1"
    addTab 'uninstall' 'node' "Uninstall node `neg: volta uninstall node@lts`n    volta uninstall node@16"
    addTab 'uninstall' 'npm' "Uninstall npm`neg: volta uninstall npm@8"
    addTab 'uninstall' 'yarn' "Uninstall yarn`neg: volta uninstall yarn@1"

    addTab 'volta' 'which' "Locate the actual binary that will be called by Volta"
    addTab 'which' 'node' "Locate the binary file for node"
    addTab 'which' 'npm' "Locate the binary file for npm"
    addTab 'which' 'yarn' "Locate the binary file for yarn"

    addTab 'volta' 'run' "Run a command with custom Node, npm, pnpm, and/or Yarn versions"
    addTab 'run' '--node' "Set the custom Node version`neg: volta run --node <version> <command>"
    addTab 'run' '--npm' "Set the custom Npm version`neg: volta run --npm <version> <command>"
    addTab 'run' '--yarn' "Set the custom Yarn version`neg: volta run --yarn <version> <command>"
    addTab 'run' '--env' "Set an environment variable (can be used multiple times)`neg: volta run --env <NAME=value>"
    addTab 'run' '--no-yarn' "Disable Yarn"
    addTab 'run' '--bundled-npm' "Force npm to be the version bundled with Node"

    addTab 'volta' 'setup' "Enable Volta for the current user / shell"

    addTab 'volta' 'completions' "Generate Volta completions`nYou already have completions. You don't need it"

    addTab 'volta' '-v' "--version`nPrint the current version of Volta"
    addTab 'volta' 'help' "Show official help"
    foreach ($_ in $tab_cmd) {
        if ($_ -ne 'help') {
            if ($_ -ne 'volta') {
                addTab 'help' $_ "Show official help about the command -- volta $_"
            }
            addTab $_ '-h' "--help`nShow official help"
            addTab $_ '--verbose' "Enables verbose diagnostics"
            addTab $_ '--c' "Prevents unnecessary output"

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
