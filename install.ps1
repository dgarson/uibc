# Ask for ac_install_dir
do {
    if (!($ac_install_dir = Read-Host -Prompt 'Enter AC Install Directory')) { $ac_install_dir='C:\Turbine\Asheron''s Call' }
} until ((Test-Path $ac_install_dir) -and (Test-Path (Join-Path $ac_install_dir 'acclient.exe')))
Write-Output "AC Install Directory: $ac_install_dir"

# Ask for ch_install_dir
do {
    if (!($ch_install_dir = Read-Host -Prompt 'Enter ChaosHelper Directory')) { $ch_install_dir='C:\Games\Decal Plugins\ChaosHelper' }
} until ((Test-Path $ch_install_dir) -and (Test-Path (Join-Path $ch_install_dir 'chaoshelper.dll')))
Write-Output "ChaosHelper Install Directory: $ac_install_dir"

# Ask for party_name
$party_name = Read-Host -Prompt 'Enter Group Name'
if (!($party_password = Read-Host -Prompt 'Enter Group Password (blank to disable)')) { $party_password` = 'CHANGEME' }

# Ask for character names
$char_list = @()
do {
    $char_name = Read-Host -Prompt 'Enter Character Name (leave blank to finish)'
    if ($char_name -ne '') {
        $char_list += $char_name.Trim()
    }
} until ($char_name -eq '')

# Open template file and replace placeholders --> TODO: change to .tpl.af ??
$template = Get-Content -Path 'UltimateIBControl.af' -Raw
$template = $template -replace '\$PARTY_NAME', $party_name
$template = $template -replace '\$PARTY_PASSWORD', $party_password
$template = $template -replace 'InlineCharlist,0', 'InlineCharlist,1'
[regex]$regex = 'CHANGEME'
foreach ($char in $char_list) {
    $template = $regex.replace($template, $char, 1)
}


# Save the interpolated contents
$template | Out-File -FilePath 'UltimateIBControl.templated.af'

# Execute metaf.exe
& .\metaf\metaf.exe 'UltimateIBControl.templated.af' 'UltimateIBControl.templated.met'

# Copy files from 'chaoshelper' to ch_install_dir
# Get-ChildItem -Path '.\chaoshelper' -filter *.ch | ForEach-Object {
#     $destination = Join-Path $ch_install_dir $_.Name
#     Copy-Item -Path $_.FullName -Destination $destination -Confirm
# }

# Copy 'UltimateIBControl_Core.met' to ac_install_dir
Copy-Item -Path '.\UltimateIBControl_Core.met' -Destination $ac_install_dir -Confirm

# Copy 'UltimateIBControl.templated.met' to ac_install_dir as 'UltimateIBControl.met'
Copy-Item -Path '.\UltimateIBControl.templated.met' -Destination (Join-Path $ac_install_dir 'UltimateIBControl_cfg.met') -Confirm