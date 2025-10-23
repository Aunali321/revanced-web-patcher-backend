# ReVanced Web Patcher - Windows GUI Launcher
# Copyright (C) 2024 ReVanced

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$serverPath = "$env:ProgramFiles\ReVanced Web Patcher\ReVanced Web Patcher.exe"
$frontendUrl = "https://rv.aun.rest"
$apiUrl = "http://localhost:3000"

function Test-ServerRunning {
    $process = Get-Process -Name "ReVanced Web Patcher" -ErrorAction SilentlyContinue
    return $null -ne $process
}

function Start-Server {
    if (Test-ServerRunning) {
        [System.Windows.Forms.MessageBox]::Show("Server is already running!", "ReVanced Web Patcher", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        return
    }
    
    Start-Process -FilePath $serverPath -WindowStyle Hidden
    Start-Sleep -Seconds 2
    
    if (Test-ServerRunning) {
        [System.Windows.Forms.MessageBox]::Show("Server started successfully!`n`nAPI: $apiUrl`nFrontend: $frontendUrl", "ReVanced Web Patcher", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        Start-Process $frontendUrl
        Update-Status
    } else {
        [System.Windows.Forms.MessageBox]::Show("Failed to start server. Check if Java is installed.", "ReVanced Web Patcher", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

function Stop-Server {
    if (-not (Test-ServerRunning)) {
        [System.Windows.Forms.MessageBox]::Show("Server is not running", "ReVanced Web Patcher", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        return
    }
    
    Stop-Process -Name "ReVanced Web Patcher" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
    
    if (-not (Test-ServerRunning)) {
        [System.Windows.Forms.MessageBox]::Show("Server stopped", "ReVanced Web Patcher", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        Update-Status
    } else {
        [System.Windows.Forms.MessageBox]::Show("Failed to stop server", "ReVanced Web Patcher", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

function Update-Status {
    if (Test-ServerRunning) {
        $process = Get-Process -Name "ReVanced Web Patcher"
        $statusLabel.Text = "Status: 🟢 Running (PID: $($process.Id))"
        $statusLabel.ForeColor = [System.Drawing.Color]::Green
        $startButton.Enabled = $false
        $stopButton.Enabled = $true
    } else {
        $statusLabel.Text = "Status: 🔴 Stopped"
        $statusLabel.ForeColor = [System.Drawing.Color]::Red
        $startButton.Enabled = $true
        $stopButton.Enabled = $false
    }
}

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "ReVanced Web Patcher"
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Title label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Location = New-Object System.Drawing.Point(10, 10)
$titleLabel.Size = New-Object System.Drawing.Size(360, 30)
$titleLabel.Text = "ReVanced Web Patcher Server"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$titleLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($titleLabel)

# Status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(10, 50)
$statusLabel.Size = New-Object System.Drawing.Size(360, 25)
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$statusLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($statusLabel)

# Start button
$startButton = New-Object System.Windows.Forms.Button
$startButton.Location = New-Object System.Drawing.Point(50, 90)
$startButton.Size = New-Object System.Drawing.Size(130, 40)
$startButton.Text = "Start Server"
$startButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$startButton.Add_Click({ Start-Server })
$form.Controls.Add($startButton)

# Stop button
$stopButton = New-Object System.Windows.Forms.Button
$stopButton.Location = New-Object System.Drawing.Point(210, 90)
$stopButton.Size = New-Object System.Drawing.Size(130, 40)
$stopButton.Text = "Stop Server"
$stopButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$stopButton.Add_Click({ Stop-Server })
$form.Controls.Add($stopButton)

# Open Frontend button
$frontendButton = New-Object System.Windows.Forms.Button
$frontendButton.Location = New-Object System.Drawing.Point(50, 140)
$frontendButton.Size = New-Object System.Drawing.Size(290, 35)
$frontendButton.Text = "Open Frontend"
$frontendButton.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$frontendButton.Add_Click({ Start-Process $frontendUrl })
$form.Controls.Add($frontendButton)

# Info label
$infoLabel = New-Object System.Windows.Forms.Label
$infoLabel.Location = New-Object System.Drawing.Point(10, 185)
$infoLabel.Size = New-Object System.Drawing.Size(360, 40)
$infoLabel.Text = "API: $apiUrl`nFrontend: $frontendUrl"
$infoLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$infoLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($infoLabel)

# Close button
$closeButton = New-Object System.Windows.Forms.Button
$closeButton.Location = New-Object System.Drawing.Point(130, 230)
$closeButton.Size = New-Object System.Drawing.Size(130, 30)
$closeButton.Text = "Exit"
$closeButton.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$closeButton.Add_Click({ $form.Close() })
$form.Controls.Add($closeButton)

# Timer to update status
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 2000  # Update every 2 seconds
$timer.Add_Tick({ Update-Status })
$timer.Start()

# Initial status update
Update-Status

# Show the form
[void]$form.ShowDialog()
$timer.Stop()
