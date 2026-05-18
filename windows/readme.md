# Windows dotfiles

## Automatically switch to external monitor when Big Picture is enabled

MonitorSteamBPM.ps1

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
> -WindowStyle Hidden -File "D:\dev\dotfiles\windows\MonitorSteamBPM.ps1"
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
