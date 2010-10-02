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
@Serializable
class User : Record
{
  @Id Str? id
  Str? password
  Str? name
  Str? email
  Date? birthday
  Role? role
  
  @Transient override Context ct:=MyContext.c
}
