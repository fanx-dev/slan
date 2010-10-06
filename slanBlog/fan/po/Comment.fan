//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-3 - Initial Contribution
//

using slandao
**
**
**
@Persistent
@Serializable
class Comment: MyRecord,CommentDao
{
  @Id{auto=true} 
  Int? id
  Int? owner
  Str? author
  DateTime? dt
  Str? text
}
