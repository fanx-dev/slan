//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-1 - Initial Contribution
//
using slanweb
**
**
**
class TableView : SlanWeblet
{
  override Void onGet()
  {
    writeContentType
    renderFwt(`fwt/TableFwt.fan`)
  }
  
  @WebMethod
  Void welcome(){
    writeContentType
    
    s:="""
          [
            ["key","value"],
            ["1","yjd"],
            ["2","yqq"]
          ]
          """
    res.out.w(s)
  }
}
