//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using slanWeb

**
** xml example
**
class Xml : SlanWeblet
{
  Void data()
  {
    echo("Xml.data")
    stash("name", "abc")
    render(`template/Xml/data`)
  }
}