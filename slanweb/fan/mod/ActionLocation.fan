//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-28 - Initial Contribution
//
using web

**
** find Ctrller#action and fill params
**
class ActionLocation : Weblet
{
  private Str? podName//current pod name
  private Uri dir//action directory
  
  private Str[]? path
  private Str[]? restPath
  
  Type? type
  Method? method
  
  Obj?[]? constructorParams
  Obj?[]? methodParams
  
  
  new make(Str? podName,Uri dir){
    this.podName=podName
    this.dir=dir
  }
  
  This execute(Str[] path){
    this.path=path
    
    findType
    findConstructor
    findMethod
    
    return this
  }
  
  **
  ** find type ,swith on tow mode
  ** 
  private Void findType(){
    if(podName==null){//find in file
      file:=Uri(dir+path[0]+".fan").toFile
      type = Env.cur.compileScript(file)
    }
    else{//find in pod
      typeName:=path[0]
      type =Pod.find(podName).type(typeName)
    }
  }

  **
  ** find constructor and set restPath
  ** 
  private Void findConstructor(){
    //constructor parameter
    cparams:=type.method("make").params
    constructorParams=SlanUtil.getParams(path,cparams,1)
    
    //rest path
    hasRestParams:=path.size>(1+cparams.size)
    restPath=hasRestParams? path[(1+cparams.size)..-1] : Str[,]
  }
  
  ** 
  ** find method and get methodParams using restPath
  ** 
  private Void findMethod(){
    //find method
    Str? methodName
    if(restPath.size>0){
      methodName=restPath[0]
      if(restPath.size>1){
        //put id on req.stash["id"]
        req.stash["id"]=restPath[1]
      }
    }else{
      //get method by http request method name
      methodName=req.method.lower
    }
    
    method=type.method(methodName)
    
    //check the facet
    if(!checkWebMethod(method)){
      res.sendErr(405)
      return
    }

    //getParams
    methodParams=SlanUtil.getParamsByName(req.uri.query,method.params,req.form)
  }
  
  //check for WebMethod facet
  private Bool checkWebMethod(Method m){
    if (!m.isPublic) return false
    if (m.facets.size==0) return true
    if (req.method=="GET") return m.hasFacet(WebGet#)
    if (req.method=="POST") return m.hasFacet(WebPost#)
    return true
  }
}
