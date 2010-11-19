//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

**
** wrap for req.stash
**
const class ReqStash : SlanWeblet
{
  ** call req.stash[name]
  override Obj? trap(Str name, Obj?[]? args)
  {
    if (args.size == 0) { return req.stash.get(name) }
    if (args.size == 1) { req.stash.set(name, args.first); return null }
    return super.trap(name, args)
  }
}
