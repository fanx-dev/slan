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
class Post : Record
{
  @Id{autoGenerate=true} 
  Int? id
  Str? author
  DateTime? dt
  Str? text
  Int? point
  
  @Transient override Context ct:=MyContext.c
}
