<#
# @Author      : abgox
# @Github      : https://github.com/abgox/PS-completions
#>

using namespace System.Globalization
using namespace System.Management.Automation
using namespace System.Management.Automation.Language
Register-ArgumentCompleter -CommandName 'scoop' -ScriptBlock {
    param($wordToComplete, $commandAst)

    $completions = [System.Collections.Specialized.OrderedDictionary]::new()

    # language
    $language_list = Get-ChildItem -Path "$PSScriptRoot\json" | ForEach-Object { $_.BaseName }
    # If $tab_completion_language is set, use it.
    if ($tab_completion_language -in $language_list) {
        $language = $tab_completion_language
    }
    else {
        $system_language = (Get-WinSystemLocale).name
        if ($system_language -in $language_list) {
            $language = $system_language
        }
        else {
            $language = 'en-US'
        }
    }

    if ($language -eq 'zh-CN') {
        $scoop_config_help1 = '当前值 --  '
        $scoop_config_help2 = '值未设置'
    }
    else {
        $scoop_config_help1 = 'Current value --  '
        $scoop_config_help2 = 'It has not been set'
    }

    #region : Parse json data
    $json_file_name = $PSScriptRoot + '\json\' + $language + '.json'
    $jsonContent = (Get-Content -Raw -Path  $json_file_name -Encoding UTF8 | ConvertFrom-Json).PSObject.Properties
    #endregion

    #region : Store all tab-completion
    foreach ($_ in $jsonContent) {
        $subCmd = $_.Name.substring($_.Name.lastIndexOf(' ') + 1)
        $completions['scoop ' + $_.Name] = [CompletionResult]::new($subcmd, $subcmd, 'ParameterValue', $_.Value)
    }
    #endregion


    #region Special point
    $jsonData = Get-Content -Raw -Path "$env:userProfile\.config\scoop\config.json" | ConvertFrom-Json
    foreach ($_ in $jsonData.PSObject.Properties) {
        $name = "'" + $_.name + "'"
        $value = "'" + $_.Value + "'"
        $completions['scoop config ' + $name] = [CompletionResult]::new($name, $name, 'ParameterValue', $scoop_config_help1 + $value)
    }
    @("'use_external_7zip'", "'use_lessmsi'", "'no_junction'", "'scoop_repo'", "'scoop_branch'", "
	'proxy'", "'autostash_on_conflict'", "'default_architecture'", "'debug'", "
	'force_update'", "'show_update_log'", "'show_manifest'", "'shim'", "'root_path'", "
    'global_path'", "'cache_path'", "'gh_token'", "'virustotal_api_key'", "'cat_style'", "'ignore_running_processes'", "
	'private_hosts'", "'hold_update_until'", "'aria2-enabled'", "'aria2-warning-enabled'", "'aria2-retry-wait'", "'aria2-split'", "'aria2-max-connection-per-server'", "'aria2-min-split-size'", "'aria2-options'") | Where-Object {
        if (!$completions['scoop config ' + $_]) {
            $completions['scoop config ' + $_] = [CompletionResult]::new($_, $_, 'ParameterValue', $scoop_config_help2)
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
