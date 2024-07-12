# Immich Album Generator

Yet another special use case for Immich Album creation. 

In this scenario, I already had folders created on disk for 'local albums' of similar events. But the structure was mixed. This process will allow you to specify exactly which image files should go into an album. 

## Installation
Requires Powershell YAML

In an Administrator Powershell Prompt:
```ps
Install-Module powershell-yaml
```

Or for just your user: 
```ps
Install-Module -Scope CurrentUser powershell-yaml
```

## Full automatic execution
If you already know that you want all images within a directory to be loaded to an album, use this automatic method. 

```ps 
$ENV:ImmichHost = 'http://x.x.x.x:yyyy/api'
$ENV:ImmichApKey = 'yourSecretApiKey'

./generateYaml.ps1 "path to folder with images" "album name"
```

This will create a YAML containing all image files in the specified folder, create a new album on Immich (if necessary -- will use existing), and assign the photos (assets) to that album. 

You can repeat the command providing different paths and the same album name to append the album. 

## Semi-Automatic
Should you want to filter an auto-generated YAML before loading it, you can do that too. 

```ps
$ENV:ImmichHost = 'http://x.x.x.x:yyyy/api'
$ENV:ImmichApKey = 'yourSecretApiKey'

./generateYaml.ps1 "path to folder with images" "album name" $false

# Make any changes to the new YAML

./albums.ps1 "album name.yaml"


```


## Manual -- Full Control
In the case where you may want to pick and choose your assets to load into albums, you can create your own YAML in the following syntax and push it to Immich as shown

```yaml
Album Name: 
  - path/to/photo1.jpg
  - path/to/photo2.jpg
  - path/to/photo3.jpg
Album 2: 
    - path/to/photo1.jpg
    - path/to/photo1.jpg
    - path/to/photo1.jpg
```
Then load using
```ps
$ENV:ImmichHost = 'http://x.x.x.x:yyyy/api'
$ENV:ImmichApKey = 'yourSecretApiKey'

./albums.ps1 yourYaml.yaml
```

