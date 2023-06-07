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
    addTab 'scoop' 'bucket' "Manage Scoop buckets"
    addTab 'bucket' 'list' "Lists the buckets that have been added"
    addTab 'bucket' 'add' "Add Scoop bucket`neg : scoop bucket add <bucket_name> <bucekt_url>"
    addTab 'bucket' 'rm' "Remove Scoop bucket`neg : scoop bucket rm <bucket_name>"
    addTab 'bucket' 'known' "list all known buckets"

    addTab 'scoop' 'search' "Search available apps`neg : scoop search <app>"
    addTab 'scoop' 'install' "Install apps`neg : scoop install [option] <[bucket/]app>"
    addTab 'install' '-g' "--global`nInstall the app globally"
    addTab 'install' '-i' "--independent`nDon't install dependencies automatically"
    addTab 'install' '-k' "--no-cache`nDon't use the download cache"
    addTab 'install' '-u' "--no-update-scoop`nDon't update Scoop before installing if it's outdated"
    addTab 'install' '-s' "--skip`nSkip hash validation (use with caution!)"
    addTab 'install' '-a' "--arch <32bit|64bit|arm64>`nUse the specified architecture <32bit|64bit|arm64>, if the app supports it"

    addTab 'scoop' 'uninstall' "Uninstall apps`neg : scoop uninstall [option] <app>"
    addTab 'uninstall' '-g' "--global`nUninstall the app globally"
    addTab 'uninstall' '-p' "--purge`nRemove all persistent data"

    addTab 'scoop' 'update' "Update apps, or Scoop itself`neg : scoop update [option] <app>"
    addTab 'update' '-f' "--force`nForce update even when there isn't a newer version"
    addTab 'update' '-g' "--global`nUpdate a globally installed app"
    addTab 'update' '-i' "--independent`nDon't install dependencies automatically"
    addTab 'update' '-k' "--no-cache`nDon't use the download cache"
    addTab 'update' '-s' "--skip`nSkip hash validation (use with caution!)"
    addTab 'update' '-q' "--quiet`nHide extraneous messages"
    addTab 'update' '-a' "--all`nUpdate all apps (alternative to '*')"

    addTab 'scoop' 'list' "List installed apps`nscoop list [pattern]`neg : scoop list 7  List all installed apps with names of 7"

    addTab 'scoop' 'info' "Display information about an app`neg : scoop info 7zip"
    addTab 'info' '--verbose' "Display More detailed information"

    addTab 'scoop' 'cache' "Show or clear the download cache`neg : scoop cache <show/rm> <app>"
    addTab 'cache' 'show' "See what's in the cache`neg : scoop cache show *`n     scoop cache show 7zip"
    addTab 'cache' 'rm' "Remove the cache of app`neg : scoop cache rm *`n     scoop cache rm 7zip"

    addTab 'scoop' 'reset' "Reset an app to resolve conflicts`neg : scoop reset python`n     scoop reset python27"
    addTab 'reset' '*' "Reset All apps"

    addTab 'scoop' 'cleanup' "Cleanup apps by removing old versions`neg : scoop cleanup [option] <app/*>"
    addTab 'cleanup' '-a' "--all`nCleanup all apps (alternative to '*')"
    addTab 'cleanup' '-g' "--global`nCleanup a globally installed app"
    addTab 'cleanup' '-k' "--cache`nRemove outdated download cache"

    addTab 'scoop' 'prefix' "Returns the path to the specified app`neg : scoop perfix <app>`n     scoop perfix 7zip"

    addTab 'scoop' 'cat' "Show content of specified manifest`neg : scoop cat <app>`n     scoop cat 7zip"

    addTab 'scoop' 'checkup' "Check for potential problems with Scoop"

    addTab 'scoop' 'alias' "Manage scoop aliases`neg : scoop alias add <name> <command> <description>`n     scoop alias rm <name> <command>`n     scoop alias list"
    addTab 'alias' 'add' "Add an Alias`neg : scoop alias add <name> <command> <description>`n     scoop alias add upgrade 'scoop update *' 'Updates all apps'`nType 'scoop upgrade' to run 'scoop update *'"
    addTab 'alias' 'rm' "Remove an Alias`neg : scoop alias rm <name> <command> <description>`n     scoop alias rm upgrade 'scoop update *' 'Updates all apps'`n"
    addTab 'alias' 'list' "List all alias"

    addTab 'scoop' 'shim' "Manipulate Scoop shims`neg : scoop shim [-g] <add/rm/list/info/alter> <shim_name>..."
    addTab 'shim' 'add' "Add a custom shim`neg : scoop shim add <shim_name> <command_path> [<args>...]"
    addTab 'shim' 'rm' "Remove shims(This could remove shims added by an app manifest)`neg : scoop shim rm <shim_name> [<shim_name>...]"
    addTab 'shim' 'list' "List all shims or matching shims`neg : scoop shim list [<shim_name>/<pattern>...]"
    addTab 'shim' 'info' "Show a shim's information`neg : scoop shim info <shim_name>"
    addTab 'shim' 'alter' "Alternate a shim's target source`neg : scoop shim alter <shim_name>"
    addTab 'shim' '-g' "--global`nManipulate global shim(s)"

    addTab 'scoop' 'config' "Get or set configuration values`neg : scoop config <key> <value> -- set`n     scoop config <key> -- get"
    $jsonData = Get-Content -Raw -Path "~\.config\scoop\config.json" | ConvertFrom-Json
    foreach ($_ in $jsonData.PSObject.Properties) {
        $name = "`"" + $_.name + "`""
        $value = "`"" + $_.Value + "`""
        $completion = @{ $name = [CompletionResult]::new($name, $name, 'ParameterValue', $value) }
        $completions['config'] += $completion
    }
    addTab 'scoop' 'which' "Locate a shim/executable (similar to 'which' on Linux)`neg : scoop which sudo"

    addTab 'scoop' 'hold' "Hold an app to disable updates`neg : scoop hold [option] <app>"
    addTab 'hold' '-g' "Hold a global app to disable updates`neg : scoop hold -g sudo"

    addTab 'scoop' 'unhold' "Unhold an app to enable updates`neg : scoop unhold [option] <app>"
    addTab 'unhold' '-g' "Unhold a global app to disable updates`neg : scoop unhold -g sudo"

    addTab 'scoop' 'export' "Exports installed apps, buckets (and optionally configs) in JSON format`neg : scoop export -c > ~\Desktop\scoopfile.json`n     and you can see it in your Desktop"
    addTab 'export' '-c' "--config`nExport the Scoop configuration file too"

    addTab 'scoop' 'import' "Imports apps, buckets and configs from a Scoopfile in JSON format`neg : scoop import  ~\Desktop\scoopfile.json`n     scoop import <url to scoopfile.json>"

    addTab 'scoop' 'depends' "List dependencies for an app, in the order they'll be installed`neg : scoop depends <app>`n     scoop depends python"

    addTab 'scoop' 'status' "Show status and check for new app versions`neg : scoop status -l"
    addTab 'status' '-l' "--local`nChecks the status for only the locally installed apps,and disables remote fetching/checking for Scoop and buckets"

    addTab 'scoop' 'create' "Create a custom app manifest`neg : scoop create <app_url>"

    addTab 'scoop' 'download' "Download apps in the cache folder and verify hashes`neg : `nThe usual way to download an app, without installing it:`n     scoop download git`nTo download a different version of the app:`n     scoop download gh@2.7.0`nTo download an app from a manifest at a URL:`n     scoop download https://raw.githubusercontent.com/ScoopInstaller/Main/master/bucket/sudo.json`nTo download an app from a manifest on your computer:`n     scoop download path\to\app.json"

    addTab 'download' '-f' "--force`nForce download (overwrite cache)"
    addTab 'download' '--no-hash-check' "Skip hash verification (use with caution!)"
    addTab 'download' '-u' "--no-update-scoop`nDon't update Scoop before downloading if it's outdated"
    addTab 'download' '-a' "--arch <32bit|64bit|arm64>`nUse the specified architecture, if the app supports it"

    addTab 'scoop' 'virustotal' "Look for app's hash or url on virustotal.com`neg : scoop virustotal [* | app1 app2 ...] [options]"
    addTab 'virustotal' '-a' "--all`nCheck for all installed apps"
    addTab 'virustotal' '-s' "--scan`nFor packages where VirusTotal has no information, send download URL for analysis (and future retrieval). This requires you to configure your virustotal_api_key."
    addTab 'virustotal' '-n' "--no-depends`nBy default, all dependencies are checked too. This flag avoids it."
    addTab 'virustotal' '-u' "--no-update-scoop`nDon't update Scoop before checking if it's outdated"
    addTab 'virustotal' '-p' "--passthru`nReturn reports as objects"

    addTab 'scoop' 'home' "Opens the app homepage`neg : scoop home <app>`n     scoop home sudo"

    addTab 'scoop' 'help' "Show official help"
    foreach ($_ in $tab_cmd) {
        if ($_ -ne 'help') {
            addTab $_ '-h' "Show official help"
            if ($_ -ne 'scoop') {
                addTab 'help' $_ "Show official help about the command -- scoop $_"
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
