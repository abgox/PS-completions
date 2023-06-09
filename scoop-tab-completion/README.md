# scoop-tab-completion

-   The source code for this project is on [PS-completions](https://github.com/abgox/PS-completions "Some tab completion in powershell")

-   It will help you complete the scoop command by the `Tab` key

## How to install

1. Run PowerShell as Administrator.

2. Execute the following command:

    ```pwsh
    Install-Module scoop-tab-completion
    ```

3. Restart PowerShell and run:

    ```pwsh
    Import-Module scoop-tab-completion
    ```

    or simply:

    ```pwsh
    echo "Import-Module scoop-tab-completion" >> $profile
    ```

    so you don't have to import the module every time you open PowerShell.

## How to uninstall

1. Run PowerShell as Administrator.
2. Execute the following command:

    ```pwsh
    Uninstall-Module scoop-tab-completion
    ```
