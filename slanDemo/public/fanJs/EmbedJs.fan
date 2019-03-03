//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web
using slanWeb

const class EmbedJs : SlanWeblet
{
  Void js()
  {
    stash("compileJs", compileJs(`Hello.fwt`))
    render(`fwtPage.html`)
  }
}