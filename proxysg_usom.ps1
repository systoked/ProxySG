Remove-Item c:\proxysg\proxysgdb.txt
Invoke-WebRequest https://www.usom.gov.tr/url-list.txt -OutFile c:\proxysg\usomlist.txt
$list =  Get-ChildItem -Path c:\proxysg\usomlist.txt
gc $list| sort | get-unique > $lines
$lines =  Get-ChildItem -Path c:\proxysg\usomuniqe.txt

$regex = ‘\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b’
New-Item c:\proxysg\all.txt -type File
New-Item c:\proxysg\ipout.txt -type File
New-Item c:\proxysg\urlout.txt -type File
$ipout = Get-ChildItem -Path C:\proxysg\ipout.txt
$urlout = Get-ChildItem -Path C:\proxysg\urlout.txt
$ips = (Select-String -path $lines  -Pattern $regex -AllMatches) |  % { $_.Matches } | % { $_.Value }
$urls =  (Select-String -path $lines  -Pattern $regex -NotMatch ) | select -ExpandProperty line




foreach($ip in $ips)
    {

        Add-Content -Path $ipout -Value ([string]::Format("'{0}'",$ip))

    }



foreach($url in $urls)
    {
    $split = ($url.Split('=')[0])
      if ($split -match '$?')
      {
        Add-Content -Path $urlout -Value ($split.Split('$?')[0])
      }
      Add-Content -Path  $urlout  -Value 'end'
    }

gc C:\proxysg\ipout.txt| sort | get-unique > C:\proxysg\ipunq.txt
gc C:\proxysg\urlout.txt| sort | get-unique > C:\proxysg\urlunq.txt

Add-Content -Path C:\proxysg\proxysgdb.txt -Value  ('define category "USOM_IP"')
Get-content -Path c:\proxysg\ipunq.txt | Add-Content -Path C:\proxysg\proxysgdb.txt  
Add-Content -Path  C:\proxysg\proxysgdb.txt  -Value 'end'
Add-Content -Path C:\proxysg\proxysgdb.txt -Value('define category "USOM_URL"')
Get-content -Path c:\proxysg\urlunq.txt | Add-Content -Path C:\proxysg\proxysgdb.txt  
Add-Content -Path  C:\proxysg\proxysgdb.txt  -Value 'end'

Remove-Item c:\proxysg\usomuniqe.txt
Remove-Item c:\proxysg\all.txt
Remove-Item c:\proxysg\usomlist.txt
Remove-Item c:\proxysg\ipout.txt
Remove-Item c:\proxysg\urlout.txt
Remove-Item c:\proxysg\ipunq.txt
Remove-Item c:\proxysg\urlunq.txt