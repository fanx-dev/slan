//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-2 - Initial Contribution
//

using slandao
**
**
**
class UserService : MyContext
{
  
  User? login(Str id,Str password){
    c.ret{
      User{it.id=id;it.password=password}.one
    }
  }
  
  User? logup(Str id,Str password,Str email){
    User? u
    c.use{
      if(!User{it.id=id}.exist){
        u=User{
          it.id=id
          it.password=password
          it.email=email
          it.role=Role.normal
        }.insert
      }
    }
    return u
  }
  
  User[] userList(Int page){
    c.ret{
      User{}.select
    }
  }
}
