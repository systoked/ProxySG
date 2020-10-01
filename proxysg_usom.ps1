
If (Test-Path -Path c:\proxysg\proxysgdb.txt ) {
Remove-Item c:\proxysg\proxysgdb.txt
}
Invoke-WebRequest https://www.usom.gov.tr/url-list.txt -OutFile c:\proxysg\usomlist.txt
$list =  Get-ChildItem -Path c:\proxysg\usomlist.txt
$lines += $list | sort | Get-Unique

$regex = ‘\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b’
$ipout = @()
$urlout =@()
$ips = $($lines | Select-String -Pattern $regex -AllMatches) |  % { $_.Matches } | % { $_.Value }
$urls = $($lines | Select-String -Pattern $regex -NotMatch ) | select -ExpandProperty line




foreach($ip in $ips)
    {

       $ipout+=  $ip

    }



foreach($url in $urls)
    {
    $split = ($url.Split('=')[0])
      if ($split -match '$?')
      {
        $urlout+= ($split.Split('$?')[0])

      }

    }


#uniqe IP
$iplines = @()
$iplines += $ipout| sort | Get-Unique


#uniqe URL
$urllines = @()
$urllines += $urlout| sort | Get-Unique


Add-Content -Path C:\proxysg\proxysgdb.txt -Value  ('define category "USOM_IP"')
Add-Content -Path C:\proxysg\proxysgdb.txt  -value $iplines
Add-Content -Path  C:\proxysg\proxysgdb.txt  -Value 'end'
Add-Content -Path C:\proxysg\proxysgdb.txt -Value('define category "USOM_URL"')
Add-Content -Path C:\proxysg\proxysgdb.txt  -Value $urllines
Add-Content -Path  C:\proxysg\proxysgdb.txt  -Value 'end'
Remove-Item c:\proxysg\usomlist.txtx
