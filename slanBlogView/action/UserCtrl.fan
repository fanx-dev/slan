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
class UserCtrl : SlanWeblet
{
  UserService userSer:=ServiceFactory.userService
  PostService postSer:=ServiceFactory.postService
  
  Str id
  new make(Str id){
    this.id=id
  }
  
  override Void onGet(){
    req.stash["curUser"]=id
    req.stash["postList"]=postSer.listByUser(id)
    
    writeContentType
    render(`view/home.html`)
  }
  
  @WebMethod
  Void allUsers(Int page){
    req.stash["userList"]=userSer.list(page)
    
    writeContentType
    render(`view/userList.html`)
  }
}
