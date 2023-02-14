Import-Module AWSPowerShell

$Now = Get-Date
#----- define amount of days ----#

$Days = "7"
#----- define folder where files are located ----#

$copyfrom = "C:\Backup\*"
$to ="c:\here"

#----- define extension ----#

$LastWrite = $Now.AddDays(-$Days)

$Files = Get-Childitem $copyfrom  -Recurse |Where-Object { $_.LastWriteTime -le "$LastWrite"}
 
foreach ($File in $Files)
    {
    if ($File -ne $NULL)
        {
        Write-Output $File >> c:\whatcopied.txt
       Copy-Item $copyfrom $to 
        }
    else
        {
        Write-Host "No more files found " -foregroundcolor "Green"
        }
    }