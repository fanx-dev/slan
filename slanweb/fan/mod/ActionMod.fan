//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
using web
**
** ActionCompiler.
** see the uri 'http://localhost:8080/action/welcome/ad/printInfo?i=123&m=bac'
**  it will route to 'action'(dir) and compile 'Welcome.fan'(class),
**  then newInstance 'Welecome' with 'ad'(params).
**  call 'printInfo'(method) with 'i=123,m=bac'(named params)
**  
** if no explicit method,then call 'onService'
** named method expected 'WebMethod' facet, except 'onService'
**  
const class ActionMod : WebMod
{
  const Uri dir;
  const Str? podName;
  
  new make(Uri dir){
    this.dir=dir
    this.podName=Config.instance.podName
  }
  override Void onService()
  {
    path:=convertPath(req.modRel.path)
    if(path.size==0){
      throw Err("path is empty.Maybe some errors on convertPath")
    }
    onActionFile(path)
  }

  private Void onActionFile(Str[] path){
    Type? type
    if(podName==null){//find in file
      
      file:=Uri(dir+path[0]+".fan").toFile
      type = Env.cur.compileScript(file)
    }
    else{//find in pod
      
      typeName:=path[0]
      type =Pod.find(podName).type(typeName)
    }

    fillParamsAndCall(type,path)
  }

  **
  ** route as `type/constructorParams/method?methodParams`
  ** 
  private Void fillParamsAndCall(Type type,Str[] path){
    params:=type.method("make").params
    //find method
    noMethod:=(params.size>=path.size-1)
    methodName:=noMethod?"onService":path[1+params.size]
    method:=type.method(methodName)

    //two check
    if(!beforeInvoke(type,method)){
      if(!res.isCommitted)res.sendErr(401)
      return
    }
    if(!noMethod && !checkWebMethod(method)){
      res.sendErr(405)
      return
    }

    //getParams
    constructorParams:=SlanUtil.getParams(path,params,1)
    methodParams:=SlanUtil.getParamsByName(req.uri.query,method.params,req.form)

    //call
    try{
      onInvoke(type,method,constructorParams,methodParams)
    }catch(Err e){
      throw Err("call method error : name $method.qname,
                  on $constructorParams,with $methodParams",e)
    }finally{
      afterInvoke(type,method)
    }
  }
  
  ** execute
  private Void onInvoke(Type type,Method method,
                                  Obj[] constructorParams,Obj[] methodParams){
    obj:=type.make(constructorParams)
    method.callOn(obj,methodParams)
  }

  //check for WebMethod facet
  private Bool checkWebMethod(Method m){
    if (!m.isPublic) return false
    if (m.facets.size==0) return true
    if (req.method=="GET") return m.hasFacet(WebGet#)
    if (req.method=="POST") return m.hasFacet(WebPost#)
    return true
  }
  
  ////////////////////////////////////////////////////////////////////////
  //virtual method
  ////////////////////////////////////////////////////////////////////////
  **
  ** trap for url rewrite
  ** 
  protected virtual Str[] convertPath(Str[] inPath){
    if(inPath.size==0){
      return ["Index"]
    }
    return inPath
  }
  
  **
  ** return false will cancel
  ** 
  protected virtual Bool beforeInvoke(Type type,Method method){
    return true
  }
  
  ** guaranty invoke after onInvoke
  protected virtual Void afterInvoke(Type type,Method method){
  }
}

**************************************************************************
** facet
**************************************************************************

** http request method 'GET'
facet class WebGet {
}
** http request method 'POST'
facet class WebPost {
}
