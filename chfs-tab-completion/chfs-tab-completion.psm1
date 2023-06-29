<#
# @Author      : abgox
# @Github      : https://github.com/abgox/PS-completions
#>
using namespace System.Management.Automation
using namespace System.Management.Automation.Language
Register-ArgumentCompleter -CommandName ($(Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Leaf) -split '-')[0] -ScriptBlock {
    param($wordToComplete, $commandAst)

    $input_cmds = $commandAst.CommandElements
    foreach ($_ in $input_cmds) {
        $input_cmds_str += " " + $_
    }
    $input_cmds_str = $input_cmds_str.TrimStart()

    $completions = [System.Collections.Specialized.OrderedDictionary]::new()

    #region : Parse json data
    $json_file_name = (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Leaf) + ".json"
    $json_path = "$PSScriptRoot\$json_file_name"
    $jsonContent = $(Get-Content -Raw -Path $json_path -Encoding UTF8 | ConvertFrom-Json).PSObject.Properties
    # endregion

    foreach ($_ in $jsonContent.Value.PSObject.Properties.name) {
        # echo $jsonContent.Value
        $completions[$_] = [CompletionResult]::new($_, $_, 'ParameterValue', $jsonContent.Value.$_)
    }
    if ($wordToComplete) {
        $completions.Keys | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object { $completions[$_] }
    }
    else {
        $completions.Keys | Where-Object { $input_cmds_str -notlike "*$_*" } | ForEach-Object { $completions[$_] }
    }
}
