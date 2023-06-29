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
