Write-Output "PowerShell Timer trigger function executed at:$(get-date)";

$people=@("@bob","@sue","@sally","@jane","@pete","@jen","@stevo","@example@example.com")

if ($people.Count % 2 -eq 1){
    $people.Add("no match this week")
}
$shuffled = $people | Sort-Object {Get-Random}

$sectionTemplate =@"
            {
            
                "facts": [
                    {
                        "name": "Participant 1:",
                        "value": "{{participant1}}"
                    },
                    {
                        "name": "Participant 2:",
                        "value": "{{participant2}}"
                    }
                ],
                "text": "Time for your ice breaker session"
            }
"@

$bodyTemplate = @"
    {
        "@type": "MessageCard",
        "@context": "https://schema.org/extensions",
        "summary": "ADUserLockOut-Notification",
        "themeColor": "D778D7",
        "title": "Ice breaker match",
         "sections": [
            {{sections}}
        ]
    }
"@

$sections = "";

#loop through and make cards for the matches
For ($i=0; $i -le $shuffled.Count-1; $i = $i +2) {
    $section = $sectionTemplate.Replace("{{participant1}}", $shuffled[$i]).Replace("{{participant2}}", $shuffled[$i+1])
    $sections += ", " + $section
}

$body = $bodyTemplate.Replace("{{sections}}", $sections)

Write-Output $body 

$uri = "https://outlook.office.com/webhook/abc"

Invoke-RestMethod -uri $uri -Method Post -body $body -ContentType 'application/json'
