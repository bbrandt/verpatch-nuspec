# Publishing to Internal ProGet Server
1. Download latest verpatch release from https://github.com/pavel-a/ddverpatch
2. Extract [verpatch.exe, verpatch-ReadMe.txt] to src/content folder
3. Run .\build Publish

# Publishing to NuGet.org
## [If You]
1. [Contact me](https://www.nuget.org/packages/verpatch/ContactOwners) to let me know the packge is outdated or request access.  If requesting access, please give a detailed reason. 

## [If Me]
1. Set your [API key](https://docs.microsoft.com/en-us/nuget/create-packages/publish-a-package).
1. nuget.exe push .\artifacts\nuget\Release\verpatch.1.0.14.nupkg -Source https://www.nuget.org/api/v2/package
