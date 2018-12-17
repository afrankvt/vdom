//
// Copyright (c) 2018, Andy Frank
// Licensed under the MIT License
//
// History:
//   7 Dec 2018  Andy Frank  Creation
//

using dom
using vdom

class DiffTest : Test
{

//////////////////////////////////////////////////////////////////////////
// Attribute
//////////////////////////////////////////////////////////////////////////

  Void testAttr()
  {
    // test add attr
    v1 := VElem("p")
    e1 := VDom.render(v1)
    d1 := VDom.diff(e1, VElem("p") { it.attrs=["foo":"bar"] })
    verifyEq(d1.size, 1)
    verifyAttrDiff(d1.first, e1, Vop.addAttr, "foo", "bar")

    // test rem attr
    v2 := VElem("p") { it.attrs=["foo":"bar"] }
    e2 := VDom.render(v2)
    d2 := VDom.diff(e2, VElem("p"))
    verifyEq(d2.size, 1)
    verifyAttrDiff(d2.first, e2, Vop.remAttr, "foo", null)

    // test set attr
    v3 := VElem("p") { it.attrs=["foo":"bar"] }
    e3 := VDom.render(v3)
    d3 := VDom.diff(e3, VElem("p") { it.attrs=["foo":"zar"] })
    verifyEq(d3.size, 1)
    verifyAttrDiff(d3.first, e3, Vop.setAttr, "foo", "zar")
  }

  Void testKidsAttr()
  {
    // test add attr
    v1 := VElem("ul") { it.children=[VElem("li"), VElem("li"), VElem("li")] }
    e1 := VDom.render(v1)
    d1 := VDom.diff(e1, VElem("ul") {
      it.attrs = ["x":"1"]
      it.children = [
        VElem("li") { it.attrs["y"]="1" },
        VElem("li") { it.attrs["y"]="2" },
        VElem("li") { it.attrs["y"]="3" },
    ]})
    verifyEq(d1.size, 4)
    verifyAttrDiff(d1[0], e1,             Vop.addAttr, "x", "1")
    verifyAttrDiff(d1[1], e1.children[0], Vop.addAttr, "y", "1")
    verifyAttrDiff(d1[2], e1.children[1], Vop.addAttr, "y", "2")
    verifyAttrDiff(d1[3], e1.children[2], Vop.addAttr, "y", "3")
  }

//////////////////////////////////////////////////////////////////////////
// Add
//////////////////////////////////////////////////////////////////////////

  Void testKidsAdd()
  {
    // test add child
    k1 := VElem("ul")
    v1 := VElem("ul") { it.children=[VElem("li"), VElem("li")] }
    e1 := VDom.render(v1)
    d1 := VDom.diff(e1, VElem("ul") {
      it.children = [
        VElem("li"),
        VElem("li"),
        k1,
    ]})
    verifyEq(d1.size, 1)
    verifyElemDiff(d1[0], e1, Vop.add, k1, 2)

    // test add child
    k2 := VElem("li") { it.attrs=["key":"3"] }
    v2 := VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"2"] }
    ]}
    e2 := VDom.render(v2)
    d2 := VDom.diff(e2, VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"2"] },
        k2,
    ]})
    verifyEq(d2.size, 1)
    verifyElemDiff(d2[0], e2, Vop.add, k2, 2)

    // test insert child
    k3 := VElem("li") { it.attrs=["key":"3"] }
    v3 := VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"2"] }
    ]}
    e3 := VDom.render(v3)
    d3 := VDom.diff(e3, VElem("ul") {
      it.children = [
        k3,
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"2"] },
    ]})
    verifyEq(d3.size, 1)
    verifyElemDiff(d3[0], e3, Vop.add, k3, 0)

    // test insert child
    k4 := VElem("li") { it.attrs=["key":"3"] }
    v4 := VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"2"] }
    ]}
    e4 := VDom.render(v4)
    d4 := VDom.diff(e4, VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        k4,
        VElem("li") { it.attrs=["key":"2"] },
    ]})
    verifyEq(d4.size, 1)
    verifyElemDiff(d4[0], e4, Vop.add, k4, 1)
  }

//////////////////////////////////////////////////////////////////////////
// Remove
//////////////////////////////////////////////////////////////////////////

  Void testKidsRemove()
  {
    // remove child no key
    v1 := VElem("ul") { it.children=[VElem("li"), VElem("li")] }
    e1 := VDom.render(v1)
    d1 := VDom.diff(e1, VElem("ul") { it.children=[VElem("li")] })
    verifyEq(d1.size, 1)
    verifyElemDiff(d1[0], e1, Vop.remove, null, 1)

    // remove last child key
    v2 := VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"2"] },
        VElem("li") { it.attrs=["key":"3"] }
    ]}
    e2 := VDom.render(v2)
    d2 := VDom.diff(e2, VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"2"] }
    ]})
    verifyEq(d2.size, 1)
    verifyElemDiff(d2[0], e2, Vop.remove, null, 2)

    // remove internal child key
    v3 := VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"2"] },
        VElem("li") { it.attrs=["key":"3"] }
    ]}
    e3 := VDom.render(v3)
    d3 := VDom.diff(e3, VElem("ul") {
      it.children = [
        VElem("li") { it.attrs=["key":"1"] },
        VElem("li") { it.attrs=["key":"3"] }
    ]})
    verifyEq(d3.size, 1)
    verifyElemDiff(d3[0], e3, Vop.remove, null, 1)
  }

//////////////////////////////////////////////////////////////////////////
// Text
//////////////////////////////////////////////////////////////////////////

  Void testText()
  {
    // no change
    v1 := VElem("p") { it.text="foo" }
    e1 := VDom.render(v1)
    d1 := VDom.diff(e1, VElem("p") { it.text="foo" })
    verifyEq(d1.size, 0)

    // change
    v2 := VElem("p") { it.text="foo" }
    e2 := VDom.render(v2)
    d2 := VDom.diff(e2, VElem("p") { it.text="bar" })
    verifyEq(d2.size, 1)
    verifyTextDiff(d2.first, e2, Vop.text, "bar")
  }

//////////////////////////////////////////////////////////////////////////
// Verify helpers
//////////////////////////////////////////////////////////////////////////

  private Void verifyElemDiff(VDiff d, Elem e, Vop op, VElem? v, Int? ix)
  {
// echo("# elem_diff = $d")
    verifyEq(d.op, op)
    verifySame(d.e, e)
    verifySame(d.v, v)
    verifyEq(d.index, ix)
  }

   private Void verifyAttrDiff(VDiff d, Elem e, Vop op, Str? name, Str? val)
  {
// echo("# attr_diff = $d")
    verifyEq(d.op,   op)
    verifySame(d.e,  e)
    verifyEq(d.name, name)
    verifyEq(d.val,  val)
  }

  private Void verifyTextDiff(VDiff d, Elem e, Vop op, Str text)
  {
// echo("# text_diff = $d")
    verifyEq(d.op, op)
    verifySame(d.e, e)
    verifyEq(d.text, text)
  }
}