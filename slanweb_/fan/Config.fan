//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//

**
** Config
**
class Config
{
  ** do not change this once init
  static const Unsafe unsafe:=Unsafe(Config())
  static Config instance(){
    return unsafe.val
  }

  private new make(){}
  Str? podName:=null
  
  **
  ** switch podFile or file
  ** 
  static Uri getUri(Uri ps){
    Str? podName:=Config.instance.podName
    if(podName==null){
      return `file:`+ps
    }else{
      return (`fan://` + podName +`/`+ ps).toUri
    }
  }
}