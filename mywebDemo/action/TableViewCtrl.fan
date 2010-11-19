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
class TableViewCtrl : SlanWeblet
{
  Void get()
  {
    writeContentType
    renderFwt(`TableFwt.fan`)
  }
  
  Void data(){
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