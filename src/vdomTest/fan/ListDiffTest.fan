//
// Copyright (c) 2018, Andy Frank
// Licensed under the MIT License
//
// History:
//   13 Dec 2018  Andy Frank  Creation
//

using dom
using vdom

class ListDiffTest : Test
{
  Void testAddNoKey()
  {
    // no key; add elem
    n1 := velem("p")
    a1 := [,]
    b1 := [n1]
    m1 := ListDiff.diff(a1, b1, "key")
    verifyEq(m1.moves.size, 1)
    verifyMove(m1.moves[0], 1, 0, n1)

    // no key; add elem
    n2 := velem("p")
    a2 := [elem("div")]
    b2 := [velem("div"), n2]
    m2 := ListDiff.diff(a2, b2, "key")
    verifyEq(m2.moves.size, 1)
    verifyMove(m2.moves[0], 1, 1, n2)

    // no key; add elem
    n3 := velem("p")
    a3 := [elem("div"), elem("span")]
    b3 := [velem("div"), velem("span"), n3]
    m3 := ListDiff.diff(a3, b3, "key")
    verifyEq(m3.moves.size, 1)
    verifyMove(m3.moves[0], 1, 2, n3)

    // no key; swap elem
    n4 := velem("p")
    a4 := [elem("p")]
    b4 := [n4]
    m4 := ListDiff.diff(a4, b4, "key")
    verifyEq(m4.moves.size, 0)
  }

  Void testAddKey()
  {
    // key; add elem
    n1 := velem("p", 1)
    a1 := [,]
    b1 := [n1]
    m1 := ListDiff.diff(a1, b1, "key")
    verifyEq(m1.moves.size, 1)
    verifyMove(m1.moves[0], 1, 0, n1)

    // key; add elem
    n2 := velem("p", 2)
    a2 := [elem("div", 1)]
    b2 := [velem("div",1), n2]
    m2 := ListDiff.diff(a2, b2, "key")
    verifyEq(m2.moves.size, 1)
    verifyMove(m2.moves[0], 1, 1, n2)

    // key; add elem
    n3 := velem("p", 3)
    a3 := [elem("div",  1), elem("span",  2)]
    b3 := [velem("div", 1), velem("span", 2), n3]
    m3 := ListDiff.diff(a3, b3, "key")
    verifyEq(m3.moves.size, 1)
    verifyMove(m3.moves[0], 1, 2, n3)

    //  key; swap elem
    n4 := velem("p", 1)
    a4 := [elem("p", 2)]
    b4 := [n4]
    m4 := ListDiff.diff(a4, b4, "key")
    verifyEq(m4.moves.size, 2)
    verifyMove(m4.moves[0], 0, 0, null)
    verifyMove(m4.moves[1], 1, 0, n4)
  }

  Void testRemoveNoKey()
  {
    // no key
    a1 := [elem("div"),  elem("span"), elem("p")]
    b1 := [velem("div"), /* remove */  velem("p")]
    m1 := ListDiff.diff(a1, b1, "key")
    verifyEq(m1.moves.size, 1)
    verifyMove(m1.moves[0], 0, 2, null)
  }

  Void testRemoveKey()
  {
    // key
    a2 := [elem("div",  1), elem("span", 2), elem("p",  3)]
    b2 := [velem("div", 1), /* remove */     velem("p", 3)]
    m2 := ListDiff.diff(a2, b2, "key")
    verifyEq(m2.moves.size, 1)
    verifyMove(m2.moves[0], 0, 1, null)
  }

  Void testAddRemoveNoKey()
  {
    // no key
    n1 := velem("p")
    a1 := [elem("div"),  elem("span")]
    b1 := [velem("div"), n1]
    m1 := ListDiff.diff(a1, b1, "key")
    verifyEq(m1.moves.size, 0)
  }

  Void testAddRemoveKey()
  {
    // key
    n1 := velem("p", 3)
    a1 := [elem("div",  1), elem("span", 2)]
    b1 := [velem("div", 1), n1]
    m1 := ListDiff.diff(a1, b1, "key")
    verifyEq(m1.moves.size, 2)
    verifyMove(m1.moves[0], 0, 1, null)
    verifyMove(m1.moves[1], 1, 1, n1)
  }

  private Elem elem(Str tag, Obj? key := null)
  {
    Elem(tag) {
      if (key != null) it.setAttr("key", key.toStr)
    }
  }

  private VElem velem(Str tag, Obj? key := null)
  {
    key == null ? VElem(tag) : VElem(tag) { it.attrs["key"]=key.toStr }
  }

  private Void verifyMove(ListMove m, Int action, Int index, Obj? elem)
  {
// echo("# move = $m")
    verifyEq(m.action, action)
    verifyEq(m.index, index)
    verifyEq(m.elem, elem)
  }
}