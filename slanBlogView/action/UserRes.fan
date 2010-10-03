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
class UserRes : SlanWeblet
{
  Str id
  new make(Str id){
    this.id=id
  }
  
  override Void onGet(){
    req.stash["curUser"]=id
    req.stash["postList"]=User.get(id).postList
    
    writeContentType
    render(`view/home.html`)
  }
  
  @WebMethod
  Void allUsers(Int page){
    req.stash["userList"]=User.list(page)
    
    writeContentType
    render(`view/userList.html`)
  }
}
