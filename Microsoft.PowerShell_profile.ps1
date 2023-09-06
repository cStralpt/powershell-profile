oh-my-posh init powershell --config "$env:POSH_THEMES_PATH\1_shell.omp.json" | Invoke-Expression
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
    
    cfonts "Happy Coding!" --colors candy
    Write-Host "`r$loadingText" -ForegroundColor Red -NoNewline
    $loadingTextLength = $loadingText.Length
    $progressBarPosition = $Host.UI.RawUI.CursorPosition
    
    # Move the cursor to the next line after the loading text
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
}

function Show-NeovimDialog {
    param(
        [string]$Directory
    )

    $caption = "Neovim Options"
    $options = @(
        "Open in Current Window",
        "Open in New Window",
        "Open in Visual Studio Code",
        "Cancel"
    )
    $defaultOption = 3

    $selectedIndex = 0

    while ($true) {
        Clear-Host
        Write-Host $caption -ForegroundColor Yellow
        Write-Host "Use arrow keys to navigate and press Enter to select:"
        for ($i = 0; $i -lt $options.Count; $i++) {
            $optionText = $options[$i]
            if ($i -eq $selectedIndex) {
                Write-Host ("✔️ {0}" -f $optionText) -ForegroundColor Green  # Change color to emerald (Green)
            } else {
                Write-Host ("⚡ {0}" -f $optionText) -ForegroundColor White  # Change color to white
            }
        }

        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode

        switch ($key) {
            13 {  # Enter key
                if ($selectedIndex -eq 0) {
                    Invoke-Vn -Animate:$true -Command nvim -ProjectPath $Directory
                }
                elseif ($selectedIndex -eq 1) {
                    Invoke-Vn -Animate:$true -Command hyper -ProjectPath $Directory
                }
                elseif ($selectedIndex -eq 2) {
                    Invoke-Vn -Animate:$true -Command code -ProjectPath $Directory  # Open in Visual Studio Code
                }
                else {
                    Write-Host "Neovim execution canceled."
                }
                return
            }
            38 {  # Up arrow key
                $selectedIndex = [Math]::Max(0, $selectedIndex - 1)
            }
            40 {  # Down arrow key
                $selectedIndex = [Math]::Min($options.Count - 1, $selectedIndex + 1)
            }
        }
    }
}


Set-Alias -Name vn -Value Show-NeovimDialog
