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
const class LogService : MyContext
{
  User? login(Str id,Str password){
    c.ret{
      User.login(id,password)
    }
  }
  
  User? logup(Str id,Str password,Str email){
    c.ret{
      User.logup(id,password,email)
    }
  }
}
