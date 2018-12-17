//
// Copyright (c) 2018, Andy Frank
// Licensed under the MIT License
//
// History:
//   13 Dec 2018  Andy Frank  Creation
//

using dom

**
** ListDiff finds the minimal amount of moves required to make two lists match.
**
** Based on [list-diff]`https://github.com/livoras/list-diff` implementation.
**
@NoDoc @Js class ListDiff
{
  **
  ** Return minimum amount of moves required to mutate 'oldList'
  ** so that it matches 'newList, where items are considered
  ** equal if 'attr' values match.
  **
  static ListDiffInfo diff(Obj[] oldList, Obj[] newList, Str attr)
  {
    oldFree  := [,]
    newFree  := [,]
    oldIndex := toKeyIndex(oldList, attr, oldFree)
    newIndex := toKeyIndex(newList, attr, newFree)
    moves    := [,]

    // a simulate list to manipulate
    children  := Obj?[,]
    freeIndex := 0

    // first pass to check item in old list: if it's removed or not
    oldList.each |elem|
    {
      key := attrVal(elem, attr)
      if (key != null)
      {
        ix := newIndex[key]
        if (ix == null) children.add(null)
        else children.add(newList[ix])
      }
      else
      {
        freeElem := newFree.getSafe(freeIndex++)
        children.add(freeElem)
      }
    }

    simList := children.dup

    // remove items no longer exist
    i := 0
    while (i < simList.size)
    {
      if (simList[i] == null)
      {
        moves.add(ListMove.remove(i))
        simList.removeAt(i)
      }
      else { i++ }
    }

    // i is cursor pointing to a item in newList
    // j is cursor pointing to a item in simList
    j := 0
    i = 0
    while (i < newList.size)
    {
      elem    := newList[i]
      key     := attrVal(elem, attr)
      simElem := simList.getSafe(j)
      simKey  := attrVal(simElem, attr)

      if (simElem != null)
      {
        if (key == simKey) j++
        else
        {
          // new item, just inesrt it
          oldElem := oldIndex[key]
          if (oldElem == null)
          {
            moves.add(ListMove.insert(i, elem))
          }
          else
          {
            // if remove current simElem make item in right place
            // then just remove it
            nextKey := attrVal(simList[j+1], attr)
            if (nextKey == key)
            {
              moves.add(ListMove.remove(i))
              simList.removeAt(j)
              j++ // after removing, current j is right, just jump to next one
            }
            else
            {
              // else insert item
              moves.add(ListMove.insert(i, elem))
            }
          }
        }
      }
      else
      {
        moves.add(ListMove.insert(i, elem))
      }

      i++
    }

    //if j is not remove to the end, remove all the rest item
    k := simList.size - j
    while (j++ < simList.size)
    {
      k--
      moves.add(ListMove.remove(k + i))
    }

    return ListDiffInfo
    {
      it.moves = moves
      it.children = children
    }
  }

  **
  ** Convert a list of elements (Elem or VElem) into map keying 'attr'
  ** values to list index position.  If a list item does not contain
  ** a value for 'attr', then that item is added to the 'free' list.
  **
  private static Str:Int toKeyIndex(Obj[] list, Str attr, Obj[] free)
  {
    index := Str:Int[:]
    list.each |elem,i|
    {
      key := attrVal(elem, attr)
      if (key == null) free.add(elem)
      else index[key] = i
    }
    return index
  }

  ** Get the 'attr' value for 'elem', or 'null' if attr not found.
  private static Obj? attrVal(Obj? elem, Str attr)
  {
    if (elem == null) return null
    return elem is Elem
      ? ((Elem)elem).attr(attr)
      : ((VElem)elem).attrs[attr]
  }
}

*************************************************************************
** ListDiffInfo
*************************************************************************

@NoDoc @Js class ListDiffInfo
{
  ** Internal ctor.
  internal new make(|This| f) { f(this) }

  ** List of moves to match lists.
  ListMove[] moves

  ** Resulting child element list.
  VElem?[] children
}

*************************************************************************
** ListMove
*************************************************************************

@NoDoc @Js class ListMove
{
  ** Make an insert move.
  static new insert(Int index, Obj elem) { make(1, index, elem) }

  ** Make a remove move.
  static new remove(Int index) { make(0, index, null) }

  ** Private ctor.
  private new make(Int a, Int i, Obj? e)
  {
    this.action = a
    this.index  = i
    this.elem   = e
  }

  ** Action: 0=remove; 1=add
  const Int action

  ** Index of move action.
  const Int index

  ** List element to move.
  Obj? elem { private set }

  override Str toStr()
  {
    (action==0 ? "rem" : "add") + " $index $elem"
  }
}