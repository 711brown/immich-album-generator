param(
    [string]$imgPath,
    [string]$albumName
    [bool]$pushToImmich=$true
)

Import-Module powershell-yaml

$wildcards = @(".jpg",".jpeg",".tif",'.tiff','.nef')

$imageFiles = (ls $imgPath | where {$_.extension -in $wildcards}).Name


$imagePathClean = ($imgPath -replace 'W:\\') -replace '\\', '/'



$outObj = @{ 
    $albumName = @( 
        $imageFiles | foreach-object { "$imagePathClean/$_"} 
    )
}


$outObj | convertto-yaml | out-file "$albumName.yaml"

if($pushToImmich){
    ./albums.ps1 "$albumName.yaml"
}