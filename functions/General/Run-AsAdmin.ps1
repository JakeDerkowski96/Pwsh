function Run-AsAdmin {
    param (
        [Parameter(Mandatory)]
        [string]$Command
    )
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c $Command" -Verb runAs
}

# Example usage
Run-AsAdmin -Command "ipconfig /flushdns"
