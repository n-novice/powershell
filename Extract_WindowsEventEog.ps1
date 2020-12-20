#Create objects for export log
$Results = @()

#EVENT 4624 4625 ALL_GET
$ALLEVENT = get-winevent -FilterHashtable @{
    path='sec.evtx';
    logname="Security";
    id = (4624,4625);
    starttime = '2020-12-19T10:00:00.000Z'; endtime = '2020-12-19T14:59:59.999Z'
}  -MaxEvents 100000 | select Id,Version,TimeCreated,LogName,MachineName,LevelDisplayName,OpcodeDisplayName,TaskDisplayName,Message 

ForEach ($Event in $ALLEVENT) {

    #Create new obect
    $Output = New-Object psobject

    $Event.Message = $Event.Message -replace "`r`n", ";"
	$Event.Message = $Event.Message -replace "`t", ""

    #Add object
    $Results += $Event
}

#Export results to csv file
$Results| Export-Csv -Path log.csv -NoTypeInformation -Encoding UTF8
