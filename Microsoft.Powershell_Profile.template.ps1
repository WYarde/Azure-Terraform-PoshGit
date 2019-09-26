Import-Module posh-git

function syncAccount {
	$global:account = az.cmd account show --query name -o tsv
}

function getAccount {
	if (-Not $account) { syncAccount }
	return $account
}

function az {
	$result = az.cmd $args
	Write-Output $result
	
	if (($args[0] -eq 'account') -And ($args[1] -eq 'set')) {
		syncAccount
	}
}

function prompt {
	[Console]::ResetColor();
	
	$prompt = ""
	
	If (Test-Path '.terraform') {
		$workspace = terraform workspace show
		$prompt += Write-Prompt "`n### " -ForegroundColor Yellow
		$prompt += Write-Prompt $workspace -ForegroundColor Magenta
		$prompt += Write-Prompt " ### " -ForegroundColor Yellow
		$prompt += Write-Prompt "[$(getAccount)]`n" -ForegroundColor DarkGray
	}

	$prompt += & $GitPromptScriptBlock
	
	if ($prompt) {$prompt} else {" "}
}
