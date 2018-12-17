#! /usr/bin/env fan

using build

class Build : build::BuildPod
{
  new make()
  {
    podName = "vdomTest"
    summary = "Vdom Unit Tests"
    meta = [
      "proj.name":    "Vdom",
      "proj.uri":     "https://github.com/afrankvt/vdom",
      "license.name": "MIT",
      "vcs.name":     "Git",
      "vcs.uri":      "https://github.com/afrankvt/vdom"
    ]
    depends = ["sys 1.0", "web 1.0", "dom 1.0", "vdom 0+"]
    srcDirs = [`fan/`]
  }
}
