//
// Copyright (c) 2018, Andy Frank
// Licensed under the MIT License
//
// History:
//   6 Dec 2018  Andy Frank  Creation
//

using dom

**
** VDiff models a change between an Elem and VElem instance.
**
@NoDoc @Js class VDiff
{
  ** It-block ctor.
  new make(Elem e, |This| f)
  {
    this.e = e
    f(this)
  }

  ** The source element.
  Elem e { private set }

  ** Type of op
  const Vop op

  ** New node if type is 'replace'.
  VElem? v := null

  ** Index if a child mutate op.
  const Int? index := null

  ** Attribute name for attr updates.
  const Str? name := null

  ** Attribute value for attr updates.
  const Str? val := null

  ** Text to update.
  const Str? text := null

  override Str toStr()
  {
    "e=$e op=$op v=$v ix=$index name=$name val=$val text=$text"
  }
}

*************************************************************************
** Vop
*************************************************************************

@NoDoc @Js enum class Vop
{
  add,
  remove,
  replace,
  addAttr,
  setAttr,
  remAttr,
  text
}