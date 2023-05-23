<#
.DESCRIPTION
Sets the default browser to Chrome

#>

begin {
  function Set-ChromeAsDefaultBrowserUsingForms {
    Add-Type -AssemblyName 'System.Windows.Forms'
    Start-Process $env:windir\system32\control.exe -ArgumentList '/name Microsoft.DefaultPrograms /page pageDefaultProgram\pageAdvancedSettings?pszAppName=google%20chrome'
    Start-Sleep -Milliseconds 3500
    [System.Windows.Forms.SendKeys]::SendWait("{TAB}{TAB}{TAB}{TAB}{TAB} {TAB}{TAB} ")
    Start-Sleep -Seconds 2
    Stop-Process -Id (Get-Process -ProcessName SystemSettings).Id
  }

  function Set-ChromeAsDefaultBrowserUsingRegistryKeys {
    $regKeyHttp = "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\{0}\UserChoice"
    Write-Output http, https | ForEach-Object { Set-ItemProperty -path $($regKeyHttp -f $_) -Value "ChromeHTML" -Name ProgId }

    # Run as admin
    Set-ItemProperty -Path "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Value "00000001" -Name "NoNewAppAlert" -Type DWord
    Get-Process explorer | Stop-Process
    Start-Process explorer
  }

  function Get-RDCManVersion {
    Start-Process "https://learn.microsoft.com/en-us/sysinternals/downloads/rdcman"
  }
}

process {
  Set-ChromeAsDefaultBrowserUsingForms
  Start-Sleep -Seconds 1
  Get-RDCManVersion
}