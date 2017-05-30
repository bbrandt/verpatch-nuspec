$psake.use_exit_on_error = $true
properties {
   $scriptDir = $psake.build_script_dir 
   $baseDir = Join-Path $psake.build_script_dir ".." | Resolve-Path 
   $artifactDir = Join-Path $baseDir "artifacts"

   $nugetDir = Join-Path $artifactDir "nuget\Release"
   $nugetDebugDir = Join-Path $artifactDir "nuget\Debug"
   $srcDir = Join-Path $baseDir "src"
   $nugetDebugFeed = "http://proget:81/nuget/DevFeed"
   $nugetFeed = "http://proget:81/nuget/ReleaseFeed"
   $nuspecList = @("verpatch.nuspec")

   $toolsDir = Join-Path $scriptDir "Tools\"
   $nugetExe = Join-Path $toolsDir "NuGet\nuget.exe"
  
   $echoargs = "C:\Program Files (x86)\PowerShell Community Extensions\Pscx3\Pscx\Apps\EchoArgs.exe"
}

Task LocalPublish -Description "Publish locally to artifacts folder" -depends Clean, NuGetPack
Task Publish -Description "Publish to ProGet" -depends LocalPublish, NuGetDebugPush, NuGetPush
Task default -depends LocalPublish

Task Clean {
    if (Test-Path "$artifactDir") {
      Remove-Item "$artifactDir" -Recurse -Force
    }

    mkdir "$artifactDir"
   
}

Task NuGetPack {
   mkdir $nugetDir
   mkdir $nugetDebugDir

   ForEach ($nuspec in $nuspecList) {
      $nuspecFile = Join-Path $srcDir $nuspec
      
      Exec { .$nugetExe pack "$nuspecFile" -OutputDirectory "$nugetDir" -IncludeReferencedProjects -Prop Configuration=Release -Verbosity detailed }
      Exec { .$nugetExe pack "$nuspecFile" -OutputDirectory "$nugetDebugDir" -IncludeReferencedProjects -Prop Configuration=Debug -Verbosity detailed }
   }
}

Task NuGetPush {
   Exec { .$nugetExe push "$nugetDir\*.nupkg" -Source "$nugetFeed" -Verbosity detailed }
}

Task NuGetDebugPush {
   Exec { .$nugetExe push "$nugetDebugDir\*.nupkg" -Source "$nugetDebugFeed" -Verbosity detailed }
}