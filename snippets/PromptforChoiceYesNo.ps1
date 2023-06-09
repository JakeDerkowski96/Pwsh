#-----------------------------------------------------------------------------------------------------------------------
Function PromptForChoice-YesNo { #--------------------------------------------------------------------------------------
	
	Param (
		#Script parameters go here
		[Parameter(Mandatory=$true,Position=0,
		ValueFromPipeline = $true)]
		[string]$TitleName,
		
		[Parameter(Mandatory=$false)]
		[string]$InfoDescription,
		
		[Parameter(Mandatory=$false)]
		[string]$HintPhrase
	)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#-----------------------------------------------------------------------------------------------------------------------
	# Build Choice Prompt
	#-----------------------------------------------------------------------------------------------------------------------
	$Title = "$TitleName?"
	$Info = "$InfoDescription"
	$ChoiceYes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "[Y]es, $HintPhrase."
	$ChoiceNo = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "[N]o, do not $HintPhrase."
	$Options = [System.Management.Automation.Host.ChoiceDescription[]]($ChoiceYes, $ChoiceNo)
	# default choice: 0 = first Option, 1 = second option, etc.
	[int]$defaultchoice = 0
	#-----------------------------------------------------------------------------------------------------------------------
	# Execute Choice Prompt
	#-----------------------------------------------------------------------------------------------------------------------
	# PromptForChoice() output will always be integer: https://powershell.org/forums/topic/question-regarding-result-host-ui-promptforchoice/
	If ($InfoDescription) {
		$answer = $host.UI.PromptForChoice($Title, $Info, $Options, $defaultchoice)
	} else {
		$answer = $host.UI.PromptForChoice($Title, "", $Options, $defaultchoice)
	}
	#-----------------------------------------------------------------------------------------------------------------------
	# Interpret answer
	#-----------------------------------------------------------------------------------------------------------------------
	#help about_switch
	#https://powershellexplained.com/2018-01-12-Powershell-switch-statement/#switch-statement
	#Write-Verbose "Answer = $answer"
	switch ($answer) {
		0 { # Y - Yes
			Write-Verbose "Yes ('$answer') option selected."
			$ChoiceResultVar = 'Y'
		}
		1 { # N - No
			Write-Verbose "No ('$answer') option selected."
			$ChoiceResultVar = 'N'
		}
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Return $ChoiceResultVar

} # End PromptForChoice-YesNo function ---------------------------------------------------------------------------------