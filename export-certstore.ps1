$certs = (Get-ChildItem -Path Cert:\LocalMachine\AuthRoot -Recurse)
Add-Type -AssemblyName System.Windows.Forms
$application = New-Object -ComObject Shell.Application
$path = ($application.BrowseForFolder(0, 'Select a folder', 0)).Self.Path

if ($path -ne $NULL)
{
    New-Item -ItemType Directory -Path "$path\cert_export"

    $outfolder = "$path\cert_export"

    foreach ($cert in $certs)
    {
        Try
        {
            $subject = ($cert.SubjectName.Name).Split(',')
            $subject = (([String]$subject[0]).Split('='))[1]
            $thumb = ($cert.Thumbprint).Substring(0, 9)
            $file = $subject + "." + $thumb + ".cer"
            Export-Certificate -Type CERT -Cert $cert -NoClobber -FilePath $outfolder\$file -Verbose
        }

        catch
        {
            "$file cannot be exported"
        }
    }
}
