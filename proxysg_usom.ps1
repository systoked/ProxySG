
Remove-Item c:\proxysg\proxysgdb.txt
Invoke-WebRequest https://www.usom.gov.tr/url-list.txt -OutFile c:\proxysg\usomlist.txt
$lines = @()
$list =  Get-ChildItem -Path c:\proxysg\usomlist.txt
$lines += gc $list| sort | Get-Unique
New-Item c:\proxysg\usomuniqe.txt -type File
Add-Content -Path c:\proxysg\usomuniqe.txt -Value $lines
$uniqelist =  Get-ChildItem -Path c:\proxysg\usomuniqe.txt

$regex = ‘\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b’
New-Item c:\proxysg\all.txt -type File
New-Item c:\proxysg\ipout.txt -type File
New-Item c:\proxysg\urlout.txt -type File
$ipout = Get-ChildItem -Path C:\proxysg\ipout.txt
$urlout = Get-ChildItem -Path C:\proxysg\urlout.txt
$ips = (Select-String -path $uniqelist  -Pattern $regex -AllMatches) |  % { $_.Matches } | % { $_.Value }
$urls =  (Select-String -path $uniqelist  -Pattern $regex -NotMatch ) | select -ExpandProperty line




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

    }

#uniqe IP
$iplines = @()
$iplist =  Get-ChildItem -Path c:\proxysg\ipout.txt
$iplines += gc $iplist| sort | Get-Unique
New-Item c:\proxysg\ipuniqe.txt -type File
Add-Content -Path c:\proxysg\ipuniqe.txt -Value $iplines

#uniqe URL
$urllines = @()
$urllist =  Get-ChildItem -Path c:\proxysg\urlout.txt
$urllines += gc $urllist| sort | Get-Unique
New-Item c:\proxysg\urluniqe.txt -type File
Add-Content -Path c:\proxysg\urluniqe.txt -Value $urllines

Add-Content -Path C:\proxysg\proxysgdb.txt -Value  ('define category "USOM_IP"')
Get-content -Path c:\proxysg\ipuniqe.txt | Add-Content -Path C:\proxysg\proxysgdb.txt  
Add-Content -Path  C:\proxysg\proxysgdb.txt  -Value 'end'
Add-Content -Path C:\proxysg\proxysgdb.txt -Value('define category "USOM_URL"')
Get-content -Path c:\proxysg\urluniqe.txt | Add-Content -Path C:\proxysg\proxysgdb.txt  
Add-Content -Path  C:\proxysg\proxysgdb.txt  -Value 'end'

Remove-Item c:\proxysg\usomuniqe.txt
Remove-Item c:\proxysg\all.txt
Remove-Item c:\proxysg\usomlist.txt
Remove-Item c:\proxysg\ipout.txt
Remove-Item c:\proxysg\urlout.txt
Remove-Item c:\proxysg\ipuniqe.txt
Remove-Item c:\proxysg\urluniqe.txt
