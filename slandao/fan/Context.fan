//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
using sql
**
** session and manager
** 
const class Context
{
  const SqlService db
  const Type:Table tables:=[:]
  const Cache cache:=Cache()
  const Executor executor:=Executor()
  
  new make(SqlService db,|This| f){
    this.db=db
    f(this)
  }
  
  Table getTable(Type t){
    return tables[t]
  }
  
  ////////////////////////////////////////////////////////////////////////
  //tools
  ////////////////////////////////////////////////////////////////////////
  
  static Type:Table autoRegister(Type:Table tables,Pod pod){
    pod.types.each|Type t|{
      if(t.fits(Record#) && t!=Record#){
        table:=Table.createFromType(t)
        tables[t]=table
      }
    }
    return tables
  }
  
  ////////////////////////////////////////////////////////////////////////
  //execute sql
  ////////////////////////////////////////////////////////////////////////

  Void insert(Obj obj){
    table:=getTable(obj.typeof)
    executor.insert(table,db,obj)
    cache[table.name+getId(obj)]=obj
  }
  
  Void update(Obj obj){
    table:=getTable(obj.typeof)
    executor.update(table,db,obj)
    cache[table.name+getId(obj)]=obj
  }
  
  Void delete(Obj obj){
    table:=getTable(obj.typeof)
    executor.delete(table,db,obj)
    cache.remove(table.name+getId(obj))
  }
  
  Obj[] noCacheSelect(Obj obj,Str orderby:=""){
    table:=getTable(obj.typeof)
    return executor.select(table,db,obj,orderby)
  }
  
  ////////////////////////////////////////////////////////////////////////
  //select id
  ////////////////////////////////////////////////////////////////////////
  
  Obj[] list(Obj obj,Str orderby:="",Int start:=0,Int num:=20){
    table:=getTable(obj.typeof)
    ids:= executor.selectId(table,db,obj,orderby,start,num)
    Obj[] list:=[,]
    ids.each{
      instance:=findById(obj.typeof,it)
      list.add(instance)
    }
    return list
  }
  
  Obj? one(Obj obj,Str orderby:="",Int start:=0,Int num:=20){
    table:=getTable(obj.typeof)
    ids:= executor.selectId(table,db,obj,orderby,start,num)
    if(ids.size==0)return null
    return findById(obj.typeof,ids[0])
  }
  
  ////////////////////////////////////////////////////////////////////////
  //by ID
  ////////////////////////////////////////////////////////////////////////
  
  Obj findById(Type type,Obj id){
    table:=getTable(type)
    obj:=cache[table.name+id]
    if(obj==null){
      obj= executor.findById(table,db,id)
    }
    return obj
  }
  
  Obj? getId(Obj obj){
    table:=getTable(obj.typeof)
    return table.id.field.get(obj)
  }

  ////////////////////////////////////////////////////////////////////////
  //extend method
  ////////////////////////////////////////////////////////////////////////
  
  Int count(Obj obj){
    table:=getTable(obj.typeof)
    return executor.count(table,db,obj)
  }
  
  Bool exist(Obj obj){
    return count(obj)>0
  }
  
  Void save(Obj obj){
    if(existById(obj)){
      update(obj)
    }else{
      insert(obj)
    }
  }
  private Bool existById(Obj obj){
    table:=getTable(obj.typeof)
    id:=table.id.field.get(obj)
    return findById(obj.typeof,id)
  }
  
  ////////////////////////////////////////////////////////////////////////
  //table operate
  ////////////////////////////////////////////////////////////////////////
  
  Void createTable(Type type){
    table:=getTable(type)
    executor.createTable(table,db)
  }
  
  Void dropTable(Type type){
    table:=getTable(type)
    executor.dropTable(table,db)
  }
  
  Bool tableExists(Type type){
    table:=getTable(type)
    return db.tableExists(table.name)
  }
  
  ////////////////////////////////////////////////////////////////////////
  //transaction
  ////////////////////////////////////////////////////////////////////////
  
  Void trans(|This| f){
    oauto:=db.autoCommit
    try{
      db.autoCommit=false
      f(this)
      db.commit
    }catch(Err e){
      e.trace
      db.rollback
    }finally{
      db.autoCommit=oauto
    }
  }
}
