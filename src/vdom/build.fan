#! /usr/bin/env fan

using build

class Build : build::BuildPod
{
  new make()
  {
    podName = "vdom"
    summary = "Virtual DOM API for Fantom"
    version = Version("0.1")
    meta = [
      "proj.name":    "Vdom",
      "proj.uri":     "https://github.com/afrankvt/vdom",
      "license.name": "MIT",
      "vcs.name":     "Git",
      "vcs.uri":      "https://github.com/afrankvt/vdom",
      "repo.public":  "true",
      "repo.tags":    "web",
    ]
    depends = ["sys 1.0", "web 1.0", "dom 1.0"]
    srcDirs = [`fan/`]
  }
}
