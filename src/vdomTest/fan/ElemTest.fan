//
// Copyright (c) 2018, Andy Frank
// Licensed under the MIT License
//
// History:
//   6 Dec 2018  Andy Frank  Creation
//

using dom
using vdom

class ElemTest : Test
{
  Void testBasic()
  {
    v := VElem("p")
    verifyElem(v, VDom.render(v))

    v = VElem("p") { it.attrs=["class":"foo"] }
    verifyElem(v, VDom.render(v))

    v = VElem("div") {
      it.attrs = ["class":"bar"]
      it.children = [
        VElem("p") { it.text="alpha" },
        VElem("p") { it.text="alpha" },
        VElem("p") { it.text="alpha" },
      ]
    }
    verifyElem(v, VDom.render(v))
  }

  Void testConveniences()
  {
    f := |e| { echo("cool") }
    v := VElem("p")
    {
      it->foo = "bar"
      it.onEvent("click", false, f)
      VElem("span") { it.text="This is some text" },
    }

    verifyEq(v.tag, "p")
    verifyEq(v.attrs["foo"], "bar")
    verifyEq(v->foo,         "bar")
    verifySame(v.events["click"], f)
    verifyEq(v.children.size, 1)
    verifyEq(v.children.first.tag,  "span")
    verifyEq(v.children.first.text, "This is some text")
  }

  private Void verifyElem(VElem v, Elem e)
  {
    verifyEq(v.tag, e.tagName)

    verifyEq(v.attrs.size, e.attrs.size)
    v.attrs.each |val,n| { verifyEq(val, e.attr(n)) }

    // TODO: test events

    verifyEq(v.children.size, e.children.size)
    v.children.each |kid,i| { verifyElem(kid, e.children[i]) }
  }
}