//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-4 - Initial Contribution
//


**
**
**
const class UserService : MyContext
{
  static const UserService cur:=UserService()
  
  User[] list(Int page){
    c.ret{
    User.list(page)
    }
  }
}
