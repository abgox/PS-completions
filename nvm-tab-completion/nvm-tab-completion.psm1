<#
# @Author      : abgox
# @Github      : https://github.com/abgox/PS-completions
#>
using namespace System.Management.Automation
using namespace System.Management.Automation.Language
Register-ArgumentCompleter -CommandName ($(Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Leaf) -split '-')[0] -ScriptBlock {
    param($wordToComplete, $commandAst)

    # Generate an ordered array
    $completions = [System.Collections.Specialized.OrderedDictionary]::new()

    #region : Parse json data
    $json_file_name = (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Leaf) + ".json"
    $jsonContent = Get-Content -Raw -Path ($PSScriptRoot + "\" + $json_file_name) -Encoding UTF8 | ConvertFrom-Json
    #endregion

    #region : Store all tab-completion
    foreach ($_ in $jsonContent.PSObject.Properties) {
        $cmds = $_.Name
        $help = $_.Value
        $cmd = $cmds.substring(0, $cmds.lastIndexOf(' '))
        $subCmd = $cmds.substring($cmds.lastIndexOf(' ') + 1)
        $completions[$cmds] = [CompletionResult]::new($subcmd, $subcmd, 'ParameterValue', $help)

    }
    #endregion

    #region Special point
    $known_list = $(scoop bucket known)
    $bucket_list = $(scoop bucket list).Name
    foreach ($_ in $known_list) {
        $completions['scoop bucket add ' + $_] = [CompletionResult]::new($_, $_, 'ParameterValue', "Add Scoop bucket -- $_")
    }
    foreach ($_ in $bucket_list) {
        $completions['scoop bucket rm ' + $_] = [CompletionResult]::new($_, $_, 'ParameterValue', "Remove Scoop bucket -- $_")
    }
    $jsonData = Get-Content -Raw -Path "$env:userProfile\.config\scoop\config.json" | ConvertFrom-Json
    foreach ($_ in $jsonData.PSObject.Properties) {
        $name = "'" + $_.name + "'"
        $value = "'" + $_.Value + "'"
        $completions['scoop config ' + $name] = [CompletionResult]::new($name, $name, 'ParameterValue', "Current value --  " + $value)
    }
    @("'use_external_7zip'", "'use_lessmsi'", "'no_junction'", "'scoop_repo'", "'scoop_branch'", "
	'proxy'", "'autostash_on_conflict'", "'default_architecture'", "'debug'", "
	'force_update'", "'show_update_log'", "'show_manifest'", "'shim'", "'root_path'", "
    'global_path'", "'cache_path'", "'gh_token'", "'virustotal_api_key'", "'cat_style'", "'ignore_running_processes'", "
	'private_hosts'", "'hold_update_until'", "'aria2-enabled'", "'aria2-warning-enabled'", "'aria2-retry-wait'", "'aria2-split'", "'aria2-max-connection-per-server'", "'aria2-min-split-size'", "'aria2-options'") | Where-Object {
        if (!$completions['scoop config ' + $_]) {
            $completions['scoop config ' + $_] = [CompletionResult]::new($_, $_, 'ParameterValue', 'It has not been set')
        }
    }
    #endregion

    #region : Carry out
    $commandElements = $commandAst.CommandElements
    function completion($num) {
        # Space($num=0)/input($num=-1) and then tab
        $completions.Keys | Where-Object { $_ -like "$commandElements*" } | ForEach-Object {
            $input_space_count = ($commandElements -split ' ').Count - 1
            $cmd_space_count = ($_ -split ' ').Count - 1
            if ($input_space_count -eq $cmd_space_count + $num) { $completions[$_] }
        }
    }
    completion $(if ($wordToComplete.length) { 0 }else { -1 })
    #endregion
}
