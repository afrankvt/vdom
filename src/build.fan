#! /usr/bin/env fan

using build

class Build : BuildGroup
{
  new make()
  {
    childrenScripts =
    [
      `vdom/build.fan`,
      `vdomTest/build.fan`,
    ]
  }
}
