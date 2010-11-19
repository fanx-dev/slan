//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using slanWeb

**
**
**
class TableViewCtrl : SlanWeblet
{
  Void index()
  {
    writeContentType
    renderFwt(`TableFwt.fan`)
  }

  Void data()
  {
    writeContentType

    s := """
            [
              ["key","value"],
              ["1","yjd"],
              ["2","yqq"]
            ]
            """
    res.out.w(s)
  }
}