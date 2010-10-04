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
  static User? fromPo(UserPo? p){
    if(p==null)return null
    return User{id=p.id;role=p.role}
  }
  
  static User? login(Str id,Str password){
    up:= UserPo{it.id=id;it.password=password}.one
    return fromPo(up)
  }
  
  static User? logup(Str id,Str password,Str email){
    UserPo? p
    if(!UserPo{it.id=id}.exist){
      p=UserPo{
        it.id=id
        it.password=password
        it.email=email
        it.role=Role.normal
      }.insert
    }
    return fromPo(p)
  }
  
  static User[] list(Int page){
    UserPo[] ps:= UserPo{}.select
    return ps.map{fromPo(it)}
  }
  
  static User get(Str id){
    p:= c.findById(UserPo#,id)
    return fromPo(p)
  }
}
