//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
using sql
**
** model for database table
** 
const class Table
{
  const Type type
  const Column[] columns
  const Str? name
  const Int idIndex
  const Bool autoGenerateId
  
  new make(|This| f){
    f(this)
    if(name==null){
      name=type.name
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
  //fetch data
  ////////////////////////////////////////////////////////////////////////
  
  Obj getInstance(Row r){
    obj:=type.make
    columns.each|Column c,Int i|{
      cl:=r.cols[i]
      value:=r[cl]
      c.setValue(obj,value)
    }
    return obj
  }
  
  ////////////////////////////////////////////////////////////////////////
  //getMetaData
  ////////////////////////////////////////////////////////////////////////
  
  static Table createFromType(Type type,SlanDialect dialect){
    Int? id
    cs:=Column[,]
    Bool generateId:=false
    
    type.fields.each|Field f|{
      if(!f.hasFacet(Transient#) && !f.isStatic){
        if(f.hasFacet(Colu#)){
          Colu c:=f.facet(Colu#)
          cs.add(dialect.createColumn(f,c.name,c.m,c.d))
        }else{
          cs.add(dialect.createColumn(f))
        }
        if(f.hasFacet(Id#)){
          id=cs.size-1
          Id idFacet:=f.facet(Id#)
          generateId=idFacet.auto
        }
      }
    }
    if(id==null){
      throw NullErr("Record must have Id, add @Id facet for field")
    }
    table:=Table{
      it.type=type
      columns=cs
      it.idIndex=id
      if(generateId){
        autoGenerateId=true
      }
    }
    
    return table
  }
}
