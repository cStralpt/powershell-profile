oh-my-posh init powershell --config "$env:POSH_THEMES_PATH\json.omp.json" | Invoke-Expression
set-alias -name pn -value pnpm
set-alias -name host -value "c:\Windows\System32\Drivers\etc\hosts"
Import-Module -Name Terminal-Icons
#Import-Module -Name GuiCompletion
#Import-Module -Name npm-completion
#Import-Module -Name Crayon
#Import-Module -Name PwshComplete
#Import-Module -Name WSLTabCompletion
# Import-Module PSReadLine
set-alias -name vnn -value "C:\Program Files\Neovim\bin\nvim-qt.exe"
set-alias -name auth1drive -value "D:\My Softwares\RClone OneDrive Authenticate\rclone.exe" 
# set-alias -name vim -value hyper


function getVariableValue{
  param( [string]$Variable)

    if ($Variable.StartsWith('$')) {
        $variableName = $Variable.Substring(1)
        $variableValue = Get-Variable -Name $variableName -ValueOnly

        # Check if the variable exists and is a string
        if ($variableValue -and $variableValue.GetType().Name -eq 'String') {
            return $variableValue
        }
    }

    # Return the original value if it doesn't start with '$'
    return $Variable
  }

function openvsCode {
    param(
        [string]$Project
    )
    $Project=getVariableValue -Variable $Project
    Show-NeovimAnimation -TextIndicator "VS Code"
    code $Project
}

Set-Alias -Name vsc -Value openvsCode
function Invoke-Vn {
    param(
        [switch]$Animate = $false,
        [string]$Command = "",
        [string]$ProjectPath= ""
    )

    if ($Animate) {
        Show-NeovimAnimation -TextIndicator "NeoVim"
    }
    $ProjectPath=getVariableValue -Variable $ProjectPath
    if (![string]::IsNullOrEmpty($Command)) {
        Invoke-Expression "$Command $ProjectPath"
    }

    # hyper
}

function Show-NeovimAnimation {
      param(
        [string]$TextIndicator = ""
    )

    $animationDelay = 0.1
    $loadingText = "Opening $TextIndicator..."
    $progressBarWidth = 20
    $progressBarColor = "Green"  # Set the desired color for the progress bar
    
    cfonts "Happy Coding! | my boss" --colors candy
    Write-Host "`r$loadingText" -ForegroundColor Red -NoNewline
    $loadingTextLength = $loadingText.Length
    $progressBarPosition = $Host.UI.RawUI.CursorPosition
    
    # Move the cursor to the bottom of the text
    $progressBarPosition.Y += 1
    $progressBarPosition.X = 0
    $Host.UI.RawUI.CursorPosition = $progressBarPosition
    
    for ($i = 0; $i -lt $progressBarWidth; $i++) {
        $progressBarPosition.X = $Host.UI.RawUI.CursorPosition.X - $progressBarWidth
        $Host.UI.RawUI.CursorPosition = $progressBarPosition
        
        $progress = [string]::Empty.PadLeft($i, '█')  # Use █ character to represent the progress bar
        Write-Host $progress -NoNewline -ForegroundColor $progressBarColor
        Start-Sleep -Seconds $animationDelay
    }
    
    # Move the cursor to the next line after the progress bar
    $progressBarPosition.Y += 1
    $progressBarPosition.X = 0
    $Host.UI.RawUI.CursorPosition = $progressBarPosition
    
    Start-Sleep -Seconds 3
    # hyper
}


function Show-NeovimDialog {
  param(
    [string]$Directory
  )
    $caption = "Neovim Options"
    $message = "Choose an option:"
    $options = @("&Open in Current Window", "&Open in New Window", "&Cancel")
    $defaultOption = 2
    
    Write-Host $caption -ForegroundColor Yellow
    Write-Host $message

    for ($i = 0; $i -lt $options.Count; $i++) {
        Write-Host ("{0}. {1}" -f ($i + 1), $options[$i])
    }

    $choice = Read-Host -Prompt "Enter your choice (1-$($options.Count))"

    if ([string]::IsNullOrEmpty($choice)) {
        $choice = $defaultOption.ToString()
    }

    switch ($choice) {
        1 {
            Invoke-Vn -Animate:$true -Command nvim -ProjectPath $Directory
            break
        }
        2 {
            # Invoke-Vn -Animate:$true hyper
            Invoke-Vn -Animate:$true -Command hyper -ProjectPath $Directory
            break
        }
        default { Write-Host "Neovim execution canceled." }
    }
}

# function Show-NeovimDialog {
#     $caption = "Neovim Options"
#     $message = "Choose an option:"
#     $options = @("&Open in Current Window", "&Open in New Window", "&Cancel")
#     $defaultOption = 2
#     $selectedIndex = 0
#
#     Write-Host $caption -ForegroundColor Yellow
#     Write-Host $message
#
#     for ($i = 0; $i -lt $options.Count; $i++) {
#         if ($i -eq $selectedIndex) {
#             Write-Host ("{0}. {1}" -f ($i + 1), $options[$i]) -ForegroundColor Cyan
#         } else {
#             Write-Host ("{0}. {1}" -f ($i + 1), $options[$i])
#         }
#     }
#
#     $keyHandler = {
#         param([Management.Automation.KeyInfo]$key)
#
#         switch ($key.VirtualKeyCode) {
#             38 {  # Up arrow
#                 $selectedIndex = ($selectedIndex - 1) % $options.Count
#             }
#             40 {  # Down arrow
#                 $selectedIndex = ($selectedIndex + 1) % $options.Count
#             }
#             13 {  # Enter
#                 $choice = ($selectedIndex + 1).ToString()
#                 $null = Remove-PSReadLineKeyHandler -ScriptBlock $keyHandler
#             }
#         }
#
#         Write-Host "`r" -NoNewline
#         for ($i = 0; $i -lt $options.Count; $i++) {
#             if ($i -eq $selectedIndex) {
#                 Write-Host ("{0}. {1}" -f ($i + 1), $options[$i]) -ForegroundColor Cyan
#             } else {
#                 Write-Host ("{0}. {1}" -f ($i + 1), $options[$i])
#             }
#         }
#     }
#
#     $null = Add-PSReadLineKeyHandler -Key UpArrow -ScriptBlock $keyHandler
#     $null = Add-PSReadLineKeyHandler -Key DownArrow -ScriptBlock $keyHandler
#     $null = Add-PSReadLineKeyHandler -Key Enter -ScriptBlock $keyHandler
#
#     while ($true) {
#         Start-Sleep -Milliseconds 100
#         if (![string]::IsNullOrEmpty($choice)) {
#             break
#         }
#     }
#
#     if ([string]::IsNullOrEmpty($choice)) {
#         $choice = $defaultOption.ToString()
#     }
#
#     switch ($choice) {
#         '1' {
#             Invoke-Vn -Animate -Command "nvim"
#         }
#         '2' {
#             Invoke-Vn -Animate -Command "hyper"
#         }
#         default {
#             Write-Host "Neovim execution canceled."
#         }
#     }
#
#     $null = Remove-PSReadLineKeyHandler -ScriptBlock $keyHandler
# }

Set-Alias -Name vn -Value Show-NeovimDialog
