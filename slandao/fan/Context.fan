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
  }
  
  Void update(Obj obj){
    table:=getTable(obj.typeof)
    executor.update(table,db,obj)
  }
  
  Void delete(Obj obj){
    table:=getTable(obj.typeof)
    executor.delete(table,db,obj)
  }
  
  Obj[] select(Obj obj,Str orderby:=""){
    table:=getTable(obj.typeof)
    return executor.select(table,db,obj,orderby)
  }
  
  Obj findById(Type type,Obj id){
    table:=getTable(type)
    return executor.findById(table,db,id)
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
  //extend method
  ////////////////////////////////////////////////////////////////////////
  
  Int count(Obj obj){
    table:=getTable(obj.typeof)
    rows:=executor.queryWhere(table,db,obj,"select count(*)","")
    r:=rows[0]
    n:=r[r.cols[0]]
    return n
  }
  
  Bool exist(Obj obj){
    return count(obj)>0
  }
  
  private Bool existById(Obj obj){
    table:=getTable(obj.typeof)
    id:=table.id.field.get(obj)
    rows:=executor.queryById(table,db,id,"select count(*)")
    r:=rows[0]
    n:=r[r.cols[0]]
    return n>0
  }
  
  Obj? getId(Obj obj){
    table:=getTable(obj.typeof)
    return table.id.field.get(obj)
  }
  
  Void save(Obj obj){
    if(existById(obj)){
      update(obj)
    }else{
      insert(obj)
    }
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
