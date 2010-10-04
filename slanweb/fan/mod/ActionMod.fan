//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
using web
**
** ActionCompiler
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
    onActionFile(path)
  }

  private Void onActionFile(Str[] path){
    Type? type
    if(podName==null){
      file:=Uri(dir+path[0]+".fan").toFile
      type = Env.cur.compileScript(file)
    }else{
      typeName:=path[0].capitalize
      type =Pod.find(podName).type(typeName)
    }

    fillParamsAndCall(type,path)
  }

  **
  ** route as `type/constructorParams/method?methodParams`
  ** 
  private Void fillParamsAndCall(Type type,Str[] path){
    params:=type.method("make").params
    noMethod:=(params.size==path.size-1)
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

  private Bool checkWebMethod(Method m){
    WebMethod? webM:=m.facet(WebMethod#,false)
    if(webM==null || req.method!=webM.type){
      return false
    }
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
  ** trap for check
  ** 
  protected virtual Bool beforeInvoke(Type type,Method method){
    return true
  }
  
  protected virtual Void onInvoke(Type type,Method method,
                                  Obj[] constructorParams,Obj[] methodParams){
    obj:=type.make(constructorParams)
    method.callOn(obj,methodParams)
  }
  
  protected virtual Void afterInvoke(Type type,Method method){
  }
}

**************************************************************************
** facet
**************************************************************************

facet class WebMethod {
  const Str type:="GET"
}