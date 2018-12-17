//
// Copyright (c) 2018, Andy Frank
// Licensed under the MIT License
//
// History:
//   6 Dec 2018  Andy Frank  Creation
//

using dom

**
** VElem models a virtual Elem instance.
**
@Js class VElem
{
  ** Create a new VElem instance.
  new make(Str tag)
  {
    this.tag = tag
  }

  ** Tag name of this element.
  const Str tag

  ** Attributes for this element.
  Str:Str attrs := [:]

  ** Event handlers for this element.
  Str:Func events := [:]

  ** Text content contained in this element.
  Str? text := null

  ** Child nodes for this element.
  VElem[] children := [,]

  ** Convenience for `attrs` get and set.
  override Obj? trap(Str name, Obj?[]? args := null)
  {
    val := args?.first
    if (val == null) return attrs[name]
    attrs[name] = val.toStr
    return null
  }

  ** Convenience for `events`.
  Void onEvent(Str name, Bool useCapture, |Event| func)
  {
    // use a + prefix for capture names
    if (useCapture) name = "+${name}"
    events[name] = func
  }

   ** Add a new element as a child to this element. Return this.
  @Operator This add(VElem child)
  {
    children.add(child)
    return this
  }
}