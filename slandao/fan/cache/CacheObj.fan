//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-9-27 - Initial Contribution
//

**
**
**
@Serializable
class CacheObj
{
  Duration lastAccess
  Obj? value
  const Str id
  const Duration expire
  const Duration createTime
  
  new make(|This| f){
    f(this)
    lastAccess=Duration.now
    createTime=Duration.now
  }
}
