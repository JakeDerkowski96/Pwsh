$Params = @{ 
		"Path" 				= '$($env:Onedrive)\Scripts\MyPwshModules' 
		"Author" 			= 'Fake Author' 
		"CompanyName" 			= 'jderkowski.com' 
		"RootModule" 			= 'MODULENAME.psm1' 
		"CompatiblePSEditions" 		= @('Desktop','Core') 
		"FunctionsToExport" 		= @('') 
		"CmdletsToExport" 		= @() 
		"VariablesToExport" 		= '' 
		"AliasesToExport" 		= @() 
		"Description" = '' 
}

New-ModuleManifest @Params
