# Windows dotfiles

## Automatically switch to external monitor when Big Picture is enabled

MonitorSteamBPM.ps1

```powershell
# Referenced by LaunchMonitorSteamBPM.vbs on start up (win-r, `shell:startup`)
function Test-SteamBigPictureActive {
    <#
    .SYNOPSIS
        Checks if Steam Big Picture Mode is currently active by scanning 
        for its specific web helper window title.
    .OUTPUTS
        [bool] True if the UI is open, False if it is closed.
    #>
    $BpmWindow = Get-Process -Name "steamwebhelper" -ErrorAction SilentlyContinue | 
                 Where-Object { $_.MainWindowTitle -eq "Steam Big Picture Mode" }
    
    return [bool]$BpmWindow
}

# --- Main Automation Loop ---

# Dynamically instantiate the initial state on startup
$InBPM = Test-SteamBigPictureActive

# Print current state
Write-Host "Initial State: Steam Big Picture Mode is $($InBPM ? 'Active' : 'Inactive')."

while ($true) {
    # Query the helper function for the current state
    $IsActiveNow = Test-SteamBigPictureActive

    if ($IsActiveNow -and -not $InBPM) {
        # State changed: Opened BPM
        $InBPM = $true
        Write-Host "State Change Detected: Steam Big Picture Mode is now Active."
        DisplaySwitch.exe /external
    }
    elseif (-not $IsActiveNow -and $InBPM) {
        # State changed: Closed BPM
        $InBPM = $false
        Write-Host "State Change Detected: Steam Big Picture Mode is now Inactive."
        DisplaySwitch.exe /internal
    }

    # Rest for 2 seconds to minimize CPU cycles
    Start-Sleep -Seconds 2
}
```

Auto-boot - Win+R type `shell:startup` and create a `LaunchMonitorSteamBPM.vbs`

```vbs
CreateObject("Wscript.Shell").Run "powershell.exe -ExecutionPolicy Bypass -File ""D:\dev\scripts\MonitorSteamBPM.ps1""", 0, False
```
