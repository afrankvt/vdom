//
// Copyright (c) 2018, Andy Frank
// Licensed under the MIT License
//
// History:
//   6 Dec 2018  Andy Frank  Creation
//

using dom

**
** Virtual DOM.
**
@Js class VDom
{

//////////////////////////////////////////////////////////////////////////
// Public
//////////////////////////////////////////////////////////////////////////

  ** Render a VElem to a Elem instance.
  static Elem render(VElem v)
  {
    e := Elem(v.tag)
    v.attrs.each |val, name| { e.setAttr(name, val) }
    v.events.each |func, name|
    {
      capture := name[0] == '+'
      e.onEvent(name, capture, func)
    }
    if (v.text != null) e.text = v.text
    else v.children.each |k| { e.add(VDom.render(k)) }
    return e
  }

  ** Patch Elem to match given VElem instance.
  static Void patch(Elem e, VElem v)
  {
    diffs := VDom.diff(e, v)
    VDom.apply(diffs)
  }

//////////////////////////////////////////////////////////////////////////
// Diff
//////////////////////////////////////////////////////////////////////////

  ** Return a list of diffs between an Elem and VElem instance.
  @NoDoc static VDiff[] diff(Elem e, VElem v)
  {
    if (e.tagName == v.tag && e.attr("key") == v.attrs["key"])
    {
      // nodes match; diff attrs and kids
      diffs := VDiff[,]
      VDom.diffAttrs(e, v, diffs)
      VDom.diffChildren(e, v, diffs)
      return diffs
    }
    else
    {
      // nodes are not the same; replace
      return [diffReplace(e, v)]
    }
  }

  private static Void diffAttrs(Elem e, VElem v, VDiff[] diffs)
  {
    eattrs := e.attrs
    vattrs := v.attrs

    // remove or update old props
    eattrs.each |ev,n|
    {
      vv := vattrs[n]
      if (vv == null)    diffs.add(diffRemAttr(e, n))
      else if (ev != vv) diffs.add(diffSetAttr(e, n, vv))
    }

    // add new props
    vattrs.each |vv,n|
    {
      ev := eattrs[n]
      if (ev == null) diffs.add(diffAddAttr(e, n, vv))
    }
  }

  private static Void diffChildren(Elem e, VElem v, VDiff[] diffs)
  {
    // first check if text node
    if (v.text != null)
    {
      if (e.text != v.text) diffs.add(diffText(e, v))
      return diffs
    }

    info := ListDiff.diff(e.children, v.children, "key")

    // reorder nodes
    info.moves.each |m|
    {
      if (m.action == 1) diffs.add(diffAdd(e, m.elem, m.index))
      else diffs.add(diffRemove(e, m.index))
    }

    // diff matching children
    e.children.each |ekid,i|
    {
      vkid := info.children.getSafe(i)
      if (vkid == null) return
      diffs.addAll(VDom.diff(ekid, vkid))
    }
  }

  private static VDiff diffAdd(Elem e, VElem v, Int ix)
  {
    VDiff(e) { it.op=Vop.add; it.v=v; it.index=ix }
  }

  private static VDiff diffRemove(Elem e, Int ix)
  {
    VDiff(e) { it.op=Vop.remove; it.index=ix }
  }

  private static VDiff diffReplace(Elem e, VElem v)
  {
    VDiff(e) { it.op=Vop.replace; it.v=v }
  }

  private static VDiff diffText(Elem e, VElem v)
  {
    VDiff(e) { it.op=Vop.text; it.v=v; it.text=v.text }
  }

  private static VDiff diffAddAttr(Elem e, Str name, Str val)
  {
    VDiff(e) {
      it.op   = Vop.addAttr
      it.name = name
      it.val  = val
    }
  }

  private static VDiff diffSetAttr(Elem e, Str name, Str val)
  {
    VDiff(e) {
      it.op   = Vop.setAttr
      it.name = name
      it.val  = val
    }
  }

  private static VDiff diffRemAttr(Elem e, Str name)
  {
    VDiff(e) {
      it.op   = Vop.remAttr
      it.name = name
    }
  }

//////////////////////////////////////////////////////////////////////////
// Patch
//////////////////////////////////////////////////////////////////////////

  ** Apply diffs to given Elem instance.
  @NoDoc static Void apply(VDiff[] diffs)
  {
    diffs.each |d|
    {
      switch (d.op)
      {
        case Vop.add:
          ref := d.e.children.getSafe(d.index)
          kid := VDom.render(d.v)
          if (ref == null) d.e.add(kid)
          else d.e.insertBefore(kid, ref)

        case Vop.remove:  d.e.remove(d.e.children[d.index])
        //case Vop.replace:
        case Vop.text:    d.e.text = d.text
        case Vop.addAttr: // fall
        case Vop.setAttr: d.e.setAttr(d.name, d.val)
        case Vop.remAttr: d.e.removeAttr(d.name)
      }
    }
  }

}