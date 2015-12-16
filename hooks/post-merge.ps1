echo ""
echo ""
echo "##### pulling rerere cache ####"
$ScriptDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
. $ScriptDirectory\"hooks-rerere-framework.ps1"
echo "##### start pulling rerere cache from $SharedRerereDirectoryBase####"
StartGit "pull" $SharedRerereDirectoryBase
echo "##### finish pulling rerere cache ####"
echo ""
echo ""