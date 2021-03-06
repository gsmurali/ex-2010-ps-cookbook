#example 1:

Get-MailboxDatabase -Identity DB1 -Status | fl Name,LastFullBackup

#example 2:

Get-MailboxDatabase -Status | 
  ?{$_.LastFullBackup -le (Get-Date).AddDays(-1)} | 
    Select-object Name,LastFullBackup

#example 3:

Get-MailboxDatabase -Status | ForEach-Object {
  if(!$_.LastFullBackup) {
	  $LastFull = "Never"
	}
	else {
	  $LastFull = $_.LastFullBackup
	}
	New-Object PSObject -Property @{
	    Name = $_.Name
		LastFullBackup = $LastFull
		DaysSinceBackup = if($LastFull -is [datetime]) {
		  (New-TimeSpan $LastFull).Days
		}
		Else {
		  $LastFull
		}
	}
}
