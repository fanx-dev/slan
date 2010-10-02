//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-2 - Initial Contribution
//

using slanBlog
using slanweb
**
**
**
class UserSource : SlanWeblet
{
  override Void onGet(){
    
    req.stash["userList"]=UserService().userList(0)
    
    writeContentType
    render(`view/userList.html`)
  }
}
