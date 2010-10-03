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
@Serializable
class CommentPo: MyRecord
{
  @Id{autoGenerate=true} 
  Int? id
  Int? owner
  Str? author
  DateTime? dt
  Str? text
}