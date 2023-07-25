<#
# @Author      : abgox
# @Github      : https://github.com/abgox/PS-completions
#>

using namespace System.Globalization
using namespace System.Management.Automation
using namespace System.Management.Automation.Language
Register-ArgumentCompleter -CommandName 'chfs' -ScriptBlock {
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

    #region : Parse json data
    $json_file_name = $PSScriptRoot + "\json\" + $language + ".json"
    $jsonContent = (Get-Content -Raw -Path $json_file_name -Encoding UTF8 | ConvertFrom-Json).PSObject.Properties
    # endregion

    #region : Carry out
    $commandElements = $commandAst.CommandElements
    foreach ($_ in $commandElements) {
        $commandElements_str += " " + $_
    }
    $commandElements_str = $commandElements_str.TrimStart()

    foreach ($_ in $jsonContent.Value.PSObject.Properties.name) {
        $completions[$_] = [CompletionResult]::new($_, $_, 'ParameterValue', $jsonContent.Value.$_)
    }
    if ($wordToComplete) {
        $completions.Keys | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object { $completions[$_] }
    }
    else {
        $completions.Keys | Where-Object { $commandElements_str -notlike "*$_*" } | ForEach-Object { $completions[$_] }
    }
    #endregion
}
