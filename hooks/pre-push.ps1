param (
	$CommitMessage
)
cls
echo "##### pushing rerere cache ####"
$ScriptDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
. $ScriptDirectory\"hooks-rerere-framework.ps1"

StartGit "add $SolutionDirectoryName" $SharedRerereDirectoryBase
$out = StartGit "commit -m `"$CommitMessage`"" $SharedRerereDirectoryBase
if($out -notcontains "no changes added to commit"){
	StartGit "push origin master" $SharedRerereDirectoryBase
}
else {
	echo "nothing to push to rerere repository"
}
echo "##### finish pushing rerere cache ####"
echo ""
echo ""