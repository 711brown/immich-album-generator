param(
  [string]$filename
)
Import-Module powershell-yaml

$immichHost = $ENV:ImmichHost
$apiKey = $ENV:ImmichApKey

$headers = @{
    'x-api-key'=$apiKey
}


$inputContent = get-content $filename | ConvertFrom-yaml


$albums = invoke-restmethod -uri "$immichHost/albums" -headers $headers 


foreach ($album in $inputContent.GetEnumerator()) {
    Write-Host "$($album.Name): $($h.Value)"
    # Make album based on Name, get the ID
    $existingAlbum = $albums | where-object {$_.albumName -eq $album.Name}
    if ($existingAlbum) {
        $albumId = $existingAlbum.id
        write-host "Found album: $($existingAlbum.id)"
    } else {
        write-host "Creating new Album!"
        $body = @{
            'albumName' = $($album.Name)
            'albumUsers' = @(
            )
        } | convertto-json
        $newAlbum = invoke-restmethod -method POST -uri "$immichHost/albums" -headers $headers -body $body -contenttype 'application/json'
        $albumId = $newAlbum.id
    }

    foreach ($file in $album.Value){ 
      write-host $file
      $body = @{
        'originalPath'= "/usr/src/app/external/$file"
      } | convertto-json
      $asset = invoke-restmethod -method POST -uri "$immichHost/search/metadata" -headers $headers -body $body -contenttype 'application/json'
      $assetId = $asset.assets.items[0].id
      # write-host $assetId

      $addAssetsBody = @{
        'ids' = @($assetId)
      } | convertto-json
      invoke-restmethod -method PUT -uri "$immichHost/albums/$albumId/assets" -headers $headers -body $addAssetsBody -contenttype 'application/json'
      write-host "Added $assetId to album $albumId"
    }
}
