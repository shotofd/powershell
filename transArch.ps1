param
(

[Parameter(Mandatory=$true)][string] $oldFile,
[Parameter(Mandatory=$true)][string] $newFile,
[Parameter(Mandatory=$true)][string] $archive,
[Parameter(Mandatory=$false)][Switch] $cleanUp

)

function testOut
{

    Split-Path $newFile | ls
    Split-Path $oldFile | ls 
    ls $archive

    for($i; $i -le 60; $i++)
    {
        $break=$break + "*"
    }
    
    Write-Host("`r`n`n$break`n")

}

$file = Split-Path $oldFile -Leaf 
$dir = Split-Path $oldFile -Parent       
$newDir = Split-Path $newFile -Parent
$nf = Split-Path $newFile -Leaf

If((Test-Path $oldFile) -and (Test-Path $archive))
{

    Move-Item $oldFile $archive
    Write-Host "$oldFile moved to $archive"    

    if($cleanUp){testOut}
    
    if((Test-Path $newFile) -and (Test-Path "$archive\$file") -and -not (Test-Path $oldFile))
    {
        Move-Item $newFile $dir\$nf
        Write-Host "$newFile moved to $dir"
    }    

    If($cleanUp)
    {
        testOut
        Move-Item $dir\$nf $newDir\$nf
        Move-Item $archive\$file $dir\$file
        Write-Host "Changes Reverted"
        testOut
    }
}
else
{
    "Bad path please try again"
}

