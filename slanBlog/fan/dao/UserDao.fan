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
mixin UserDao : MyContext
{
  static User? login(Str id,Str password){
    User{it.id=id;it.password=password}.one
  }
  
  static User? logup(Str id,Str password,Str email){
    if(!User{it.id=id}.exist){
      p:=User{
        it.id=id
        it.password=password
        it.email=email
        it.role=Role.normal
      }.insert
      return p
    }
    return null
  }
  
  static User[] list(Int page){
    User{}.select
  }
  
  static User get(Str id){
    c.findById(User#,id)
  }
}
