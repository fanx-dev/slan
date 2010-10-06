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
mixin MyRecord:Record
{
  override Context ct(){DbConnection.cur.c}
}
