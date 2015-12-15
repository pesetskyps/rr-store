$ErrorActionPreference="Stop"
$ScriptDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$i = 0
$WorkDirectory = $ScriptDirectory.Split('\')
$comp = $WorkDirectory.IndexOf(".git") - 1
$GitDirectory = ""

($i..$comp).Foreach{ $GitDirectory += $WorkDirectory[$_]; $GitDirectory += "\"  }
$RerereLink="$GitDirectory.git\rr-cache"

$RerereLinkResolver = fsutil reparsepoint query $RerereLink | Select-String "Print Name:"
$RerereLinkResolver -cmatch "([A-Z]:.*)"
$RerereLinkResolver = $Matches[0]
#git -C $RerereRootDir add .
#git -C $RerereRootDir commit -m "$CommitMessage"
#git -C $RerereRootDir push origin master