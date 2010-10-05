//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
using sql
**
** important class for execute sql.
** 
internal const class Executor
{
  const static InsertMaker inserMaker:=InsertMaker()
  const static TableMaker tableMaker:=TableMaker()
  const static UpdateMaker updateMaker:=UpdateMaker()
  const static WhereMaker whereMaker:=WhereMaker()
  const static IdWhereMaker idWhereMaker:=IdWhereMaker()
  const Log log:=Pod.of(this).log
  
  Void insert(Table table,SqlService db,Obj obj){
    sql:=inserMaker.getSql(table)
    param:=inserMaker.getParam(table,obj)
    if(log.isDebug){
      log.debug(sql)
      log.debug(param.toStr)
    }
    r:=db.sql(sql).prepare.execute(param)
    if(table.autoGenerateId==true){
      table.id.field.set(obj,r->get(0))
    }
  }
  
  Void update(Table table,SqlService db,Obj obj){
    sql:=updateMaker.getSql(table,obj)
    param:=updateMaker.getParam(table,obj)
    if(log.isDebug){
      log.debug(sql)
      log.debug(param.toStr)
    }
    db.sql(sql).prepare.execute(param)
  }
  
  ////////////////////////////////////////////////////////////////////////
  //do where
  ////////////////////////////////////////////////////////////////////////
  
  Obj[] select(Table table,SqlService db,Obj obj,Str orderby){
    sql:="select * "+whereMaker.getSql(table,obj)
    if(orderby!="")sql+=" "+orderby
    param:=whereMaker.getParam(table,obj)
    if(log.isDebug){
      log.debug(sql)
      log.debug(param.toStr)
    }
    Obj[] list:=[,]
    db.sql(sql).prepare.queryEach(param)|Row r|{
      list.add(table.getInstance(r))
    }
    return list
  }
  
  Obj[] selectId(Table table,SqlService db,Obj obj,Str orderby,Int start,Int num){
    sql:="select $table.id.name "+whereMaker.getSql(table,obj)
    if(orderby!="")sql+=" "+orderby
    param:=whereMaker.getParam(table,obj)
    if(log.isDebug){
      log.debug(sql)
      log.debug(param.toStr)
    }
    Obj[] list:=[,]
    i:=0
    s:=db.sql(sql)
    s.limit=start+num
    s.prepare.queryEach(param)|Row r|{
      if(i<start){
        i++
        return
      }
      list.add(r[r.cols[0]])
    }
    return list
  }
  
  Obj[] selectWhere(Table table,SqlService db,Str where,Int start,Int num){
    sql:="select $table.id.name from $table.name where $where"
    if(log.isDebug){
      log.debug(sql)
    }
    Obj[] list:=[,]
    i:=0
    s:=db.sql(sql)
    s.limit=start+num
    s.queryEach(null)|Row r|{
      if(i<start){
        i++
        return
      }
      list.add(r[r.cols[0]])
    }
    return list
  }
  
  Void delete(Table table,SqlService db,Obj obj){
    sql:="delete "+whereMaker.getSql(table,obj)
    param:=whereMaker.getParam(table,obj)
    if(log.isDebug){
      log.debug(sql)
      log.debug(param.toStr)
    }
    db.sql(sql).prepare.execute(param)
  }
  
  Int count(Table table,SqlService db,Obj obj){
    rows:=queryWhere(table,db,obj,"select count(*)","")
    r:=rows[0]
    n:=r[r.cols[0]]
    return n
  }
  Row[] queryWhere(Table table,SqlService db,Obj obj,Str before,Str after){
    sql:=before+" "+whereMaker.getSql(table,obj);
    if(after!="")sql+=" "+after
    param:=whereMaker.getParam(table,obj)
    if(log.isDebug){
      log.debug(sql)
      log.debug(param.toStr)
    }
    return db.sql(sql).prepare.query(param)
  }
  
  ////////////////////////////////////////////////////////////////////////
  //by ID
  ////////////////////////////////////////////////////////////////////////
  
  Void removeById(Table table,SqlService db,Obj id){
    sql:="delete "+idWhereMaker.getSql(table)
    param:=idWhereMaker.getParam(table,id)
    if(log.isDebug){
      log.debug(sql)
      log.debug(param.toStr)
    }
    db.sql(sql).prepare.execute(param)
  }
  
  Obj? findById(Table table,SqlService db,Obj id){
    rows:=queryById(table,db,id,"select *")
    if(rows.size==0)return null
    return table.getInstance(rows.first)
  }
  
  Bool existById(Table table,SqlService db,Obj id){
    rows:=queryById(table,db,id,"select count(*)")
    r:=rows[0]
    n:=r[r.cols[0]]
    return n>0
  }
  
  private Row[] queryById(Table table,SqlService db,Obj id,Str before){
    sql:=before+" "+idWhereMaker.getSql(table)
    param:=idWhereMaker.getParam(table,id)
    if(log.isDebug){
      log.debug(sql)
      log.debug(param.toStr)
    }
    return db.sql(sql).prepare.query(param)
  }
  
  ////////////////////////////////////////////////////////////////////////
  //table op
  ////////////////////////////////////////////////////////////////////////

  Void createTable(Table table,SqlService db){
    sql:=tableMaker.createTable(table)
    if(log.isDebug){
      log.debug(sql)
    }
    db.sql(sql).execute()
  }
  
  Void dropTable(Table table,SqlService db){
    sql:=tableMaker.dropTable(table)
    if(log.isDebug){
      log.debug(sql)
    }
    db.sql(sql).execute()
  }
  
  Void clearDatabase(SqlService db){
    Str[] tables := db.tables.dup
    while (tables.size != 0)
    {
      Int dropped := 0
      tables.each |Str tableName|
      {
        try
        {
          sql:="drop table $tableName"
          log.debug(sql)
          db.sql(sql).execute
          tables.remove(tableName)
          dropped++
        }
        catch (Err e)
        {
        }
      }

      if (dropped == 0)
        throw SqlErr("All tables could not be dropped.")
    }
  }
}
