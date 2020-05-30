Write-Output "PowerShell Timer trigger function executed at:$(get-date)";

$people=@("bob","sue","sally","jane","pete","jen","stevo","stuart.eggerton@hotmail.com")

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
             <span itemscope="" itemtype="http://schema.skype.com/Mention" data-itemprops="{&quot;mri&quot;:&quot;19:527737788ec04e3ea4f15c316cb4af87@thread.skype&quot;,&quot;mentionType&quot;:&quot;channel&quot;}" person-card="" class="at-mentions-focus person-card-hover" tabindex="0" role="link" aria-haspopup="true" aria-label="@ice-breaker-cheap" acc-role-dom="clickable">ice-breaker-cheap</span>
            {{sections}}
        ]
    }
"@

$sections = ""

#loop through and make cards for the matches
For ($i=0; $i -le $shuffled.Count-1; $i = $i +2) {
    $section = $sectionTemplate.Replace("{{participant1}}", $shuffled[$i]).Replace("{{participant2}}", $shuffled[$i+1])
    
    if ($i -eq 0){
        $sections += $section}
    else{
        $sections += ", " + $section
    }
}

$body = $bodyTemplate.Replace("{{sections}}", $sections)


$uri = "https://outlook.office.com/webhook/abc"

$body
$uri

Invoke-RestMethod -uri $uri -Method Post -body $body -ContentType 'application/json'
