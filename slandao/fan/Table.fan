//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
using sql

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
  
  Column? id(){
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
      c.field.set(obj,value)
    }
    return obj
  }
  
  ////////////////////////////////////////////////////////////////////////
  //getMetaData
  ////////////////////////////////////////////////////////////////////////
  
  static Table createFromType(Type type){
    Int? id
    cs:=Column[,]
    Bool generateId:=false
    
    type.fields.each|Field f|{
      if(!f.hasFacet(Transient#) && !f.isStatic){
        if(f.hasFacet(Colu#)){
          Colu c:=f.facet(Colu#)
          cs.add(Column(f,c.name,c.sqlType))
        }else{
          cs.add(Column(f))
        }
        if(f.hasFacet(Id#)){
          id=cs.size-1
          generateId=f.facet(Id#)->autoGenerate
        }
      }
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
