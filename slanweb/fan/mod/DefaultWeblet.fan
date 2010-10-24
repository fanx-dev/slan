//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-24 - Initial Contribution
//


**
** if not committed:
** - on GET render view at view/typename/method.html.
** - on POST(or others) just back
** 
const class DefaultWeblet:SlanWeblet
{
  const Str viewDir//view directory
  new make(Str viewDir){
    this.viewDir=viewDir
  }
  
  Void onInvoke(Type type,Method method,
                        Obj[] constructorParams,Obj[] methodParams){
    if(req.method=="GET"){
      writeContentType
      this.render("$viewDir/$type.name/${method.name}.html".toUri)
    }else{
      back
    }
  }
}
