function ConvertPSObjectToHashtable
{
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )

    process
    {
        if ($null -eq $InputObject) { return $null }

        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string])
        {
            $collection = @(
                foreach ($object in $InputObject) { ConvertPSObjectToHashtable $object }
            )

            Write-Output -NoEnumerate $collection
        }
        elseif ($InputObject -is [psobject])
        {
            $hash = @{}

            foreach ($property in $InputObject.PSObject.Properties)
            {
                $hash[$property.Name] = ConvertPSObjectToHashtable $property.Value
            }

            $hash
        }
        else
        {
            $InputObject
        }
    }
}

$json = @"
{
    "outer": "value1",
    "outerArray": [
        "value2",
        "value3"
    ],
    "outerHash": {
        "inner": "value4",
        "innerArray": [
            "value5",
            "value6"
        ],
        "innerHash": {
            "innermost1": "value7",
            "innermost2": "value8",
            "innermost3": "value9"
        }
    }
}
"@
$j = $json | ConvertFrom-Json
$x = $j | ConvertPSObjectToHashtable