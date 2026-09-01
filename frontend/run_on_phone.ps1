# Stable run for flaky USB (Oppo/ColorOS)
# Usage: .\run_on_phone.ps1

$ErrorActionPreference = "Stop"
$env:Path = "$env:LOCALAPPDATA\Android\Sdk\platform-tools;" + $env:Path
$apk = Join-Path $PSScriptRoot "build\app\outputs\flutter-apk\app-debug.apk"
$package = "com.nirogisathi.nirogisathi"
$activity = "$package/.MainActivity"

function Wait-ForDevice {
  Write-Host "Waiting for phone (must show 'device', not offline)..."
  for ($i = 0; $i -lt 60; $i++) {
    $line = adb devices | Select-String "`tdevice$"
    if ($line) {
      $id = ($line.ToString() -split "\s+")[0]
      Write-Host "Phone online: $id"
      return $id
    }
    Start-Sleep -Seconds 2
  }
  throw "Phone not online. Replug USB, accept debugging prompt, keep screen ON."
}

Set-Location $PSScriptRoot

Write-Host "==== 1) Build APK ===="
flutter build apk --debug
if (-not (Test-Path $apk)) { throw "APK not found: $apk" }

$deviceId = Wait-ForDevice

Write-Host "==== 2) Keep awake + force-stop ===="
adb -s $deviceId shell svc power stayon true 2>$null
adb -s $deviceId shell am force-stop $package 2>$null

Write-Host "==== 3) Push APK ===="
adb -s $deviceId push $apk /data/local/tmp/nirogi-debug.apk
if ($LASTEXITCODE -ne 0) { throw "adb push failed (USB dropped). Retry." }

Write-Host "==== 4) Install from device storage ===="
adb -s $deviceId shell pm install -r -t /data/local/tmp/nirogi-debug.apk
if ($LASTEXITCODE -ne 0) { throw "pm install failed. Enable Install via USB on phone." }

Write-Host "==== 5) Launch + attach ===="
adb -s $deviceId shell am start -n $activity
flutter attach -d $deviceId
