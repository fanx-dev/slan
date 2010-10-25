//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-25 - Initial Contribution
//


**
** wrap for req.stash
**
const class ReqStash:SlanWeblet
{
  ** call req.stash[name]
  override Obj? trap(Str name, Obj?[]? args)
  {
    if (args.size == 0) { return req.stash.get(name) }
    if (args.size == 1) { req.stash.set(name, args.first); return null }
    return super.trap(name, args)
  }
}
