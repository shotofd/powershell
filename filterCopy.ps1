﻿param
(
    [Parameter(Mandatory=$true)][string] $filePath,
    [Parameter(Mandatory=$true)][string] $pattern,
    [Parameter(Mandatory=$false)][switch] $nomatch = $false,
    [Parameter(Mandatory=$false)][switch] $copy = $false,
    [Parameter(Mandatory=$false)][string] $copyPath 
 )

function copyFiles
{
 param
 (
    [Parameter(Mandatory=$true)][object] $f,
    [Parameter(Mandatory=$true)][string] $p
 )
    if(Test-Path $p)
    {
        $f.CopyTo($p+$f.Name)
        Write-Host $f.Name "Copied"
    }
    else
    {
        Write-Host "Path does not exist"
    }

}

function writeCounter
{
 param
 (
    [Parameter(Mandatory=$true)][int] $counter,
    [Parameter(Mandatory=$true)][object] $f
 )

    $counter++
    Write-Host $counter $f
    return $counter

}

$fc = 0
$mc = 0

if($nomatch){Write-Host "--Excludes "$pattern"--"} else { Write-Host "--Includes "$pattern"--" }

if($copy -and ($copyPath.Length -gt 0) -and !( $copyPath.EndsWith("\"))){ $copyPath=$copyPath+"\" }
write-host $copyPath

$files = Get-ChildItem $filePath -Recurse -File

foreach($file in $files)
{ 
    $fc=writeCounter $fc $file
}

ForEach($file in $files)
{
    if($nomatch)
    {
        if($file -notmatch $pattern)
        {
            $mc=writeCounter $mc $file
            if($copy){copyFiles $file $copyPath}
        }
    }
    else
    {
        if($file -match $pattern)
        {
            $mc=writeCounter $mc $file
            if($copy){copyFiles $file $copyPath}
        }
    }
}
