//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
using sql
**
** mapping model for database table.
** must has a prime key.
** 
const class Table
{
  const Type type
  const Column[] columns
  const Str name
  const Int idIndex
  const Bool autoGenerateId
  
  private const Log log:=Pod.of(this).log
  
  new make(|This| f){
    f(this)
    if(!type.hasFacet(Serializable#)){
        throw MappingErr("class $type.name must be Serializable.
                          please using @Ignore for Ignore")
    }
  }
  
  Column id(){
    return columns[idIndex]
  }
  
  ////////////////////////////////////////////////////////////////////////
  //each
  ////////////////////////////////////////////////////////////////////////
  
  Void nonIdColumn(|Column| f){
    columns.each{
      if(it!=id){
        f(it)
      }
    }
  }
  
  Void nonAutoGenerate(|Column| f){
    if(autoGenerateId==true){
      nonIdColumn(f)
    }else{
      columns.each(f)
    }
  }
  
  ////////////////////////////////////////////////////////////////////////
  // method
  ////////////////////////////////////////////////////////////////////////
  **
  ** fetch data
  ** 
  Obj getInstance(Row r){
    obj:=type.make
    columns.each|Column c,Int i|{
      cl:=r.cols[i]
      value:=r[cl]
      c.setValue(obj,value)
    }
    return obj
  }
  
  ** 
  ** make string from object for cache key
  ** 
  Str makeKey(Obj obj){
    condition:=StrBuf()
    columns.each |Column c|{
      value:=c.getValue(obj)
      if(value!=null){
        condition.add("$c.name=$value&")
      }
    }
    
    return condition.toStr
  }
  
  **
  ** check model is match the database
  ** 
  Bool checkMatchDb(Col[] tcols){
    if(columns.size>tcols.size){
      log.warn("model have $columns.size field,but database $tcols.size")
      return false
    }
    
    errCount:=0
    columns.each|Column c,Int i|{
      pass:=c.checkMatchDb(tcols[i])
      if(!pass){
        log.warn("table $name field ${columns[i].name} miss the database")
        errCount++
      }
    }
    if(errCount>0){
      return false
    }
    return true
  }
  
  ////////////////////////////////////////////////////////////////////////
  // tools
  ////////////////////////////////////////////////////////////////////////
  
  **
  ** auto mapping form type.
  ** table name default is podName+typeName.
  ** 
  static Table mappingFromType(Type type,SlanDialect dialect){
    Int? id
    cs:=Column[,]
    Bool generateId:=false
    
    type.fields.each|Field f|{
      //once method hide field that end with '$Store'
      if(!f.hasFacet(Transient#) && !f.isStatic && !f.name.endsWith("\$Store")){
        if(f.hasFacet(Colu#)){
          Colu c:=f.facet(Colu#)
          cs.add(dialect.createColumn(f,c.name,c.m,c.d))
        }else if(f.hasFacet(Text#)){
          cs.add(dialect.createColumn(f,null,1024))
        }else{
          cs.add(dialect.createColumn(f))
        }
        if(f.hasFacet(Id#)){
          id=cs.size-1
          Id idFacet:=f.facet(Id#)
          
          //get autoGenerate strategy
          if(idFacet.generate!=null){
            generateId=idFacet.generate
          }else{
            if(f.type.toNonNullable==Int#){
              generateId=true
            }
          }
        }
      }
    }
    if(id==null){
      throw MappingErr("Record must have Id, add @Id facet for field")
    }
    table:=Table{
      it.type=type
      name=type.pod.name+type.name
      columns=cs
      it.idIndex=id
      if(generateId){
        autoGenerateId=true
      }
    }
    
    return table
  }
}
