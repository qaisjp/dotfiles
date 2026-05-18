# Referenced by LaunchMonitorSteamBPM.vbs on start up (win-r, `shell:startup`)

# Define a native C# class to handle process scanning without leaking memory
$CSharpSource = @'
using System;
using System.Diagnostics;

public class SteamMonitorCore {
    public static bool IsBigPictureActive() {
        Process[] processes = Process.GetProcessesByName("steamwebhelper");
        bool isActive = false;
        
        foreach (Process p in processes) {
            try {
                if (p.MainWindowTitle == "Steam Big Picture Mode") {
                    isActive = true;
                }
            }
            catch {
                // Safely ignore instances that are protected or terminating
            }
            finally {
                // Instantly free the process handles back to the OS kernel
                p.Dispose();
            }
        }
        return isActive;
    }
}
'@

# Compile the C# class into the pwsh session (only runs once on startup)
if (-not ("SteamMonitorCore" -as [Type])) {
    Add-Type -TypeDefinition $CSharpSource | Out-Null
}

function Test-SteamBigPictureActive {
    <#
    .SYNOPSIS
        Calls our native C# class to check Steam's state.
        100% reliable detection, flat baseline memory, near-0% CPU.
    #>
    return [SteamMonitorCore]::IsBigPictureActive()
}

# --- Main Automation Loop ---

# Dynamically instantiate the initial state on startup
$InBPM = Test-SteamBigPictureActive
$LoopIndex = 0
Write-Host "Starting Steam BPM Monitor. Initial state: $($InBPM ? 'In BPM' : 'Not in BPM')." -ForegroundColor Cyan

while ($true) {
    # Query the helper function for the current state (blazing fast native lookup)
    $IsActiveNow = Test-SteamBigPictureActive

    if ($IsActiveNow -and -not $InBPM) {
        # State changed: Opened BPM
        $InBPM = $true
        Write-Host "BPM Detected: Switching to external display mode." -ForegroundColor Green
        DisplaySwitch.exe /external
    }
    elseif (-not $IsActiveNow -and $InBPM) {
        # State changed: Closed BPM
        $InBPM = $false
        Write-Host "BPM Closed: Switching to internal display mode." -ForegroundColor Yellow
        DisplaySwitch.exe /internal
    }

    # Rest for 2 seconds to minimize CPU cycles
    Start-Sleep -Seconds 2

    
    # Force .NET to immediately reclaim any lingering string allocations from the loop iteration
    # Every 10 loops only
    if ($LoopIndex -eq 10) {
        # Write-Host "Performing garbage collection to free memory." -ForegroundColor Cyan
        [System.GC]::Collect()
        $LoopIndex = 0
    }

    $LoopIndex++
}
