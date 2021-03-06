function startGit ($arguments, $workingDirectory, $ExceptionTextToCheck = $null){

	$GitErrorFilename = "giterror"
	$GitOutputFilename = "gitout"
	$GitErrorFile = join-path $ScriptDirectory "\$GitErrorFilename"
	$GitOutputFile = join-path $ScriptDirectory "\$GitOutputFilename"
	
	$bla = Start-Process -FilePath git.exe -ArgumentList "$arguments" -WorkingDirectory $workingDirectory -Wait -NoNewWindow -RedirectStandardError $GitErrorFile -RedirectStandardOutput $GitOutputFile
	$out = (gc $GitErrorFile) + (gc $GitOutputFile)
	if($ExceptionTextToCheck){
		if($out -like "*$ExceptionTextToCheck*"){
			throw "Error in git occured while executing `"git $arguments`" in $workingDirectory. Exception mask to check was $ExceptionTextToCheck. Git output is: $out"
		}
	}
	return $out
}

function CheckDirectoryIsGitRepository ($dir) {
	echo "detecting whether $dir is a git repo"
	startGit "remote -v" $dir "Not a git repository"
	echo "$dir is git repo. continuing..."
}

$ErrorActionPreference="Stop"
$ScriptDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$DotGirDirectory = Split-Path -Parent $ScriptDirectory
$SolutionDirectory = Split-Path -Parent $DotGirDirectory
$RererefolderName = Join-Path $DotGirDirectory "rr-cache"
if($SolutionDirectory -ne $null){
	CheckDirectoryIsGitRepository $SolutionDirectory
	$SolutionDirectoryName = (Get-item $SolutionDirectory).Name
}

$TargetDirectoryName = $null
if(!(Test-Path $RererefolderName)){
	throw "rerere folder name: $RererefolderName not found"
}
$MatchPattern = "Print Name:"
$RerereLinkResolver = fsutil reparsepoint query $RererefolderName | out-string -stream | Select-String "Print Name:"
if($RerereLinkResolver -ne $null){
	echo "rerere target directory from fsutil is: $RerereLinkResolver"
	$TargetDirectoryName = $RerereLinkResolver.ToString().Substring($RerereLinkResolver.ToString().IndexOf($MatchPattern)+$MatchPattern.Length)
	$TargetDirectoryName = $TargetDirectoryName -replace "\s",""
	$SharedRerereDirectoryBase = Split-Path $TargetDirectoryName -Parent
	
	if(!(Test-Path $SharedRerereDirectoryBase)){
		throw "Rerere cache directory name: $SharedRerereDirectoryBase does not exist."
	}
}
else {
	throw "Verify that $RererefolderName is windows link rerere shared directory"
}