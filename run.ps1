Write-Output "PowerShell Timer trigger function executed at:$(get-date)";

@people=@("bob","sue","sally","jane","pete","jen","stevo","baz","kel")


$a.Count
$body = @"
    {
        "@type": "MessageCard",
        "@context": "https://schema.org/extensions",
        "summary": "ADUserLockOut-Notification",
        "themeColor": "D778D7",
        "title": "Active Directory: Account Locked-Out Event",
         "sections": [
            {
            
                "facts": [
                    {
                        "name": "Username:",
                        "value": "DOMAIN_USERNAME"
                    },
                    {
                        "name": "Time:",
                        "value": "DATETIME"
                    }
                ],
                "text": "An AD account is currently being locked out for 15 minutes"
            }
        ]
    }
"@


$uri = "https://outlook.office.com/webhook/abc"

Invoke-RestMethod -uri $uri -Method Post -body $body -ContentType 'application/json'
