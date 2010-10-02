//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-2 - Initial Contribution
//
using slanweb
using slanBlog

**
**
**
class Index : SlanWeblet
{
  override Void onGet(){
    writeContentType
    render(`view/home.html`)
  }
}
