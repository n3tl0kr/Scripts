<#
    Title: Build-HashBase.ps1
    Author: Goffar, Paul @n3tl0kr
    Scope: Using to build hash tables for known good OS files
    Notes:
            06.28.2019 - Initial Commit
 #>


$a=@()
$bad=@()
$scandir="c:\" #Edit as needed
$outfile="" #Insert Filename Here
$osname=(Get-WmiObject win32_operatingsystem).caption
$osbitness=(Get-WmiObject win32_operatingsystem).OSArchitecture
$osversion=(Get-WmiObject win32_operatingsystem).Version

Write-Host "Building File Table"

$filetable=DIR -Force $scandir -Recurse -ErrorVariable +gcierror -ErrorAction SilentlyContinue | ?{!$_.psiscontainer}

Write-Host "Processing File Table"

foreach ($errorRecord in $gcierror)
{
    $obj = new-object psobject
    $obj | Add-Member -MemberType NoteProperty -Name 'filename' -Value $($errorRecord.TargetObject)
    $obj | Add-Member -MemberType NoteProperty -Name 'file_error' -Value $($errorRecord.Exception)
    $bad+=$obj
}

foreach ($file in $filetable){

$md5 = Get-FileHash -Algorithm MD5 $file.FullName
$sha1 = Get-FileHash -Algorithm SHA1 $file.FullName
$owner = $file.GetAccessControl()

$obj = New-Object psobject
$obj | Add-Member -MemberType NoteProperty -Name 'filename' -Value $file.name
$obj | Add-Member -MemberType NoteProperty -Name 'filepath' -Value $file.FullName
$obj | Add-Member -MemberType NoteProperty -Name 'filesize_kb' -Value (($file.length)/1KB)
$obj | Add-Member -MemberType NoteProperty -Name 'filehash_md5' -Value $($md5.Hash)
$obj | Add-Member -MemberType NoteProperty -Name 'filehash_sha1' -Value $($sha1.hash)
$obj | Add-Member -MemberType NoteProperty -Name 'file_owner' -Value $($owner.owner)
$obj | Add-Member -MemberType NoteProperty -Name 'os_name' -Value $osname
$obj | Add-Member -MemberType NoteProperty -Name 'os_bitness' -Value $osbitness
$obj | Add-Member -MemberType NoteProperty -Name 'os_version' -Value $osversion
$a+=$obj

write-host "$($file.name) with hash $($md5.hash)"

}

$a | Export-Csv -Path $outfile -NoClobber -NoTypeInformation
