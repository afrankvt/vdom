//
// Copyright (c) 2018, Andy Frank
// Licensed under the MIT License
//
// History:
//   7 Dec 2018  Andy Frank  Creation
//

using dom
using vdom

class PatchTest : Test
{

//////////////////////////////////////////////////////////////////////////
// Attributes
//////////////////////////////////////////////////////////////////////////

  Void testAttrBasic()
  {
    e := VDom.render(VElem("p"))

    // add attr
    VDom.patch(e, VElem("p") { it.attrs=["foo":"bar"] })
    verifyEq(e.attr("foo"), "bar")

    // set attr
    VDom.patch(e, VElem("p") { it.attrs=["foo":"zar"] })
    verifyEq(e.attr("foo"), "zar")

    // remove attr
    VDom.patch(e, VElem("p"))
    verifyEq(e.attr("foo"), null)
  }

  Void testAttrClass()
  {
    e := VDom.render(VElem("p"))
    verifyEq(e.style.classes.join(","), "")

    // add class
    VDom.patch(e, VElem("p") { it.attrs=["class":"alpha"] })
    verifyEq(e.style.classes.join(" "), "alpha")

    // add class
    VDom.patch(e, VElem("p") { it.attrs=["class":"alpha beta"] })
    verifyEq(e.style.classes.join(" "), "alpha beta")

    // remove attr
    VDom.patch(e, VElem("p"))
    verifyEq(e.attr("foo"), null)
  }

  Void testKidsAttr()
  {
    // test add attr
    v1 := VElem("ul") { it.children=[VElem("li"), VElem("li"), VElem("li")] }
    e1 := VDom.render(v1)
    VDom.patch(e1, VElem("ul") {
      it.attrs = ["x":"1"]
      it.children = [
        VElem("li") { it.attrs=["y":"1"] },
        VElem("li") { it.attrs=["y":"2"] },
        VElem("li") { it.attrs=["y":"3"] },
      ]
    })
    verifyEq(e1.attr("x"), "1")
    verifyEq(e1.children[0].attr("y"), "1")
    verifyEq(e1.children[1].attr("y"), "2")
    verifyEq(e1.children[2].attr("y"), "3")
  }

//////////////////////////////////////////////////////////////////////////
// Add
//////////////////////////////////////////////////////////////////////////

  Void testKidsAdd()
  {
    // add child no key
    v1 := VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["id":"1"] },
        VElem("li") { it.attrs=["id":"2"] },
    ]}
    e1 := VDom.render(v1)
    VDom.patch(e1, VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["id":"1"] },
        VElem("li") { it.attrs=["id":"2"] },
        VElem("li") { it.attrs=["id":"3"] },
    ]})
    verifyEq(e1.children.size, 3)
    verifyEq(e1.children[0].attr("id"), "1")
    verifyEq(e1.children[1].attr("id"), "2")
    verifyEq(e1.children[2].attr("id"), "3")

    // insert child no key
    v2 := VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["id":"1"] },
        VElem("li") { it.attrs=["id":"2"] },
    ]}
    e2 := VDom.render(v2)
    VDom.patch(e2, VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["id":"3"] },
        VElem("li") { it.attrs=["id":"1"] },
        VElem("li") { it.attrs=["id":"2"] },
    ]})
    verifyEq(e2.children.size, 3)
    verifyEq(e2.children[0].attr("id"), "3")
    verifyEq(e2.children[1].attr("id"), "1")
    verifyEq(e2.children[2].attr("id"), "2")

    // add child key
    v3 := VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"2"] }
    ]}
    e3    := VDom.render(v3)
    e3_k0 := e3.children[0]
    e3_k1 := e3.children[1]
    VDom.patch(e3, VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"2"] },
        VElem("li") { it.attrs=["key":"3"] }
    ]})
    verifyEq(e3.children.size, 3)
    verifyEq(e3.children[0].attr("key"), "1")
    verifyEq(e3.children[1].attr("key"), "2")
    verifyEq(e3.children[2].attr("key"), "3")
    verifySame(e3.children[0], e3_k0)
    verifySame(e3.children[1], e3_k1)

    // insert child key
    v4 := VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"2"] }
    ]}
    e4    := VDom.render(v4)
    e4_k0 := e4.children[0]
    e4_k1 := e4.children[1]
    VDom.patch(e4, VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"3"] },
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"2"] },
    ]})
    verifyEq(e4.children.size, 3)
    verifyEq(e4.children[0].attr("key"), "3")
    verifyEq(e4.children[1].attr("key"), "1")
    verifyEq(e4.children[2].attr("key"), "2")
    verifySame(e4.children[1], e4_k0)
    verifySame(e4.children[2], e4_k1)
  }

//////////////////////////////////////////////////////////////////////////
// Remove
//////////////////////////////////////////////////////////////////////////

  Void testKidsRemove()
  {
    // remove last child no key
    v1 := VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["id":"1"] },
        VElem("li") { it.attrs=["id":"2"] },
        VElem("li") { it.attrs=["id":"3"] },
    ]}
    e1 := VDom.render(v1)
    VDom.patch(e1, VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["id":"1"] },
        VElem("li") { it.attrs=["id":"2"] },
    ]})
    verifyEq(e1.children.size, 2)
    verifyEq(e1.children[0].attr("id"), "1")
    verifyEq(e1.children[1].attr("id"), "2")

    // remove internal child no key
    v2 := VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["id":"1"] },
        VElem("li") { it.attrs=["id":"2"] },
        VElem("li") { it.attrs=["id":"3"] },
    ]}
    e2 := VDom.render(v2)
    VDom.patch(e2, VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["id":"1"] },
        VElem("li") { it.attrs=["id":"3"] },
    ]})
    verifyEq(e2.children.size, 2)
    verifyEq(e2.children[0].attr("id"), "1")
    verifyEq(e2.children[1].attr("id"), "3")

    // remove last child key
    v3 := VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"2"] },
        VElem("li") { it.attrs=["key":"3"] },
    ]}
    e3 := VDom.render(v3)
    VDom.patch(e3, VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"2"] },
    ]})
    verifyEq(e3.children.size, 2)
    verifyEq(e3.children[0].attr("key"), "1")
    verifyEq(e3.children[1].attr("key"), "2")

    // remove internal child key
    v4 := VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"2"] },
        VElem("li") { it.attrs=["key":"3"] },
    ]}
    e4 := VDom.render(v4)
    VDom.patch(e4, VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"3"] },
    ]})
    verifyEq(e4.children.size, 2)
    verifyEq(e4.children[0].attr("key"), "1")
    verifyEq(e4.children[1].attr("key"), "3")
  }

//////////////////////////////////////////////////////////////////////////
// Text
//////////////////////////////////////////////////////////////////////////

  Void testText()
  {
    // no change
    v1 := VElem("p") { it.text="foo" }
    e1 := VDom.render(v1)
    VDom.patch(e1, VElem("p") { it.text="foo" })
    verifyEq(e1.text, "foo")

    // change
    v2 := VElem("p") { it.text="foo" }
    e2 := VDom.render(v2)
    VDom.patch(e2, VElem("p") { it.text="bar" })
    verifyEq(e2.text, "bar")
  }
}