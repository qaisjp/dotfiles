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

Auto-start on boot


> ## Step 2: Create the Elevated Task
> 
> 1. Press `Win + R`, type **`taskschd.msc`**, and hit Enter to open the **Task Scheduler**.
> 2. On the far-right *Actions* panel, click **Create Task...** (do not choose "Create Basic Task").
> 
> ### 1. General Tab
> 
> * **Name:** `Monitor Steam TV Display`
> * **Security Options:**
> * Select **Run only when user is logged on**. *(Crucial: If you choose "whether logged on or not", Windows forces it into a hidden background session where `DisplaySwitch.exe` won't be able to see your monitors).*
> * Check the box for **Run with highest privileges**. *(This is the magic checkbox that grants admin rights while completely bypassing the UAC pop-up).*
> 
> 
> * **Configure for:** Drop down and select **Windows 10** (or Windows 11).
> 
> ### 2. Triggers Tab
> 
> 1. Click **New...** at the bottom.
> 2. Set *Begin the task* to **At log on**.
> 3. Under *Settings*, choose **Specific user** (it should default to your account).
> 4. Click **OK**.
> 
> ### 3. Actions Tab
> 
> 1. Click **New...** at the bottom.
> 2. Set *Action* to **Start a program**.
> 3. In the **Program/script** box, type: `pwsh.exe`
> 4. In the **Add arguments (optional)** box, paste the following parameters exactly:
> ```text
> -WindowStyle Hidden -File "D:\dev\scripts\MonitorSteamBPM.ps1"
> ```
> 
> 
> 5. Click **OK**.
> 
> ### 4. Conditions Tab
> 
> * **Power settings:** Uncheck the box that says **"Start the task only if the computer is on AC power"**. (This ensures it still runs if you ever use this setup on a laptop unplugged from the wall).
> 
> ### 5. Settings Tab
> 
> * Uncheck the box that says **"Stop the task if it runs longer than: 3 days"**. Since your script is an intentional infinite loop, you want Windows to let it run indefinitely.
> * Click **OK** to save the task.
> 
