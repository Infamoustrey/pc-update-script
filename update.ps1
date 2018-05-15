$results = "<h1>PC Update Report</h1><hr/><br/>"

$pclist = Get-ADComputer -Filter "Name -like 'your-computer-name-regex' " | select -Property Name

$pclist | %{

    Try
    {

        Invoke-Command -ComputerName $_.Name -ScriptBlock {

            #Make Sure Choclatey is installed or up to date
            Try {
                choco upgrade chocolatey
            }
            Catch {
                SSet-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
                Break
            }
            
            #Stable, Official
            choco install -y # desired package names here
            #Stable, Unofficial
            choco install seamonkey --version 2.48 -y # unofficial packages here


        }

        $results += "<p style='color:green;'>$($_.Name) updated successfully.</p>"

     }
     Catch{
     
        $results += "<p style='color:red;'>$($_.Name) did not update successfully.</p>"
      
     }

}


$recipients = "youremail@yourdomain.com"
$sender = "Update <updates@yourdomain.com>"
$subject = "PC Update Report"

Send-MailMessage -To $recipients -From $sender -Subject $subject -BodyAsHtml $results -smtpserver #yoursmptserver/mailgun/aws/etc...
