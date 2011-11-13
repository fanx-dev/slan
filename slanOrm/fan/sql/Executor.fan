//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql

**
** important class for execute sql.
**
internal const class Executor
{
  const static InsertMaker inserMaker := InsertMaker()
  const static TableMaker tableMaker := TableMaker()
  const static UpdateMaker updateMaker := UpdateMaker()
  const static WhereMaker whereMaker := WhereMaker()
  const static IdWhereMaker idWhereMaker := IdWhereMaker()
  const static SelectMaker selectMaker := SelectMaker()

  const Log log := Pod.of(this).log

  Void insert(Table table, SqlConn db, Obj obj)
  {
    sql := inserMaker.getSql(table)
    params := inserMaker.getParam(table, obj)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(params.toStr)
    }
    stmt := db.prepare(sql)
    params.each |p, i|{ stmt.set(i, p) }
    stmt.use
    {
      it.execute
      if (table.autoGenerateId == true)
      {
        set := it.getGeneratedKeys
        if (set.next)
        {
          table.id.field.set(obj, set.get(0))
        }
      }
    }
  }

  Void update(Table table, SqlConn db, Obj obj)
  {
    sql := updateMaker.getSql(table, obj)
    params := updateMaker.getParam(table, obj)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(params.toStr)
    }
    stmt := db.prepare(sql)
    params.each |p, i|{ stmt.set(i, p) }
    stmt.use { it.execute }
  }

//////////////////////////////////////////////////////////////////////////
// select
//////////////////////////////////////////////////////////////////////////

  ** select data list
  Obj[] select(Table table, SqlConn db, Obj obj, Str orderby, Int offset, Int limit)
  {
    sql := selectMaker.getSql(table) + whereMaker.getSql(table, obj)
    if (orderby != "") sql += " " + orderby
    params := whereMaker.getParam(table,obj)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(params.toStr)
    }
    Obj[] list := [,]
    stmt := db.prepare(sql)
    stmt.limit = offset + limit
    params.each |p, i|{ stmt.set(i, p) }
    stmt.use |s|
    {
      s.query |set|
      {
        set.moveTo(offset)
        while(set.next)
        {
          list.add(table.getInstance(set))
        }
      }
    }
    return list
  }

  ** select data list
  Obj? selectOne(Table table, SqlConn db, Obj obj, Str orderby, Int offset)
  {
    sql := selectMaker.getSql(table) + whereMaker.getSql(table, obj)
    if (orderby != "") sql += " " + orderby
    params := whereMaker.getParam(table,obj)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(params.toStr)
    }
    Obj? one := null
    stmt := db.prepare(sql)
    stmt.limit = offset + 1
    params.each |p, i|{ stmt.set(i, p) }
    stmt.use |s|
    {
      s.query |set|
      {
        set.moveTo(offset)
        if (set.next)
        {
          one = (table.getInstance(set))
        }
      }
    }
    return one
  }

  ** select by condition
  Obj[] selectWhere(Table table, SqlConn db, Str condition, Int offset, Int limit)
  {
    sql := selectMaker.getSql(table) + " from $table.name"
    if (condition != "") sql += " " + condition

    if (log.isDebug)
    {
      log.debug(sql)
    }
    Obj[] list := [,]
    i := 0
    stmt := db.prepare(sql)
    stmt.limit = offset + limit
    stmt.use |s|
    {
      s.query |set|
      {
        set.moveTo(offset)
        while(set.next)
        {
          list.add(table.getInstance(set))
        }
      }
    }
    return list
  }

  Void delete(Table table, SqlConn db, Obj obj)
  {
    sql := "delete " + whereMaker.getSql(table, obj)
    paramss := whereMaker.getParam(table, obj)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(paramss.toStr)
    }
    stmt := db.prepare(sql)
    paramss.each |p, i|{ stmt.set(i, p) }
    stmt.use { it.execute }
  }

  Int count(Table table, SqlConn db, Obj obj)
  {
    sql := "select count(*)" + whereMaker.getSql(table, obj);
    params := whereMaker.getParam(table, obj)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(params.toStr)
    }
    stmt := db.prepare(sql)
    params.each |p, i|{ stmt.set(i, p) }
    Int i := 0
    stmt.use |s|
    {
      s.query |set|
      {
        set.next
        i = set.get(0)
      }
    }
    return i
  }

//////////////////////////////////////////////////////////////////////////
// by ID
//////////////////////////////////////////////////////////////////////////

  Void removeById(Table table, SqlConn db, Obj id)
  {
    stmt := byIdStmt(table, db, id, "delete ")
    stmt.use { it.execute }
  }

  Obj? findById(Table table, SqlConn db, Obj id)
  {
    stmt := byIdStmt(table, db, id, selectMaker.getSql(table))

    Obj? obj := null
    stmt.use |s|
    {
      s.query |set|
      {
        set.next
        obj = table.getInstance(set)
      }
    }
    return obj
  }

  Bool existById(Table table, SqlConn db, Obj id)
  {
    stmt := byIdStmt(table, db, id, "select count(*)")

    Bool exist := false
    stmt.use |s|
    {
      s.query |DataSet set|
      {
        exist = set.next
      }
    }
    return exist
  }

  private Statement byIdStmt(Table table, SqlConn db, Obj id, Str before)
  {
    sql := before + idWhereMaker.getSql(table)
    params := idWhereMaker.getParam(table, id)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(params.toStr)
    }
    stmt := db.prepare(sql)
    params.each |p, i|{ stmt.set(i, p) }
    return stmt
  }

//////////////////////////////////////////////////////////////////////////
// Table op
//////////////////////////////////////////////////////////////////////////

  Void createTable(Table table, SqlConn db)
  {
    sql := tableMaker.createTable(table)
    if (log.isDebug)
    {
      log.debug(sql)
    }
    db.execute(sql)
  }

  Void dropTable(Table table, SqlConn db)
  {
    sql := tableMaker.dropTable(table)
    if (log.isDebug)
    {
      log.debug(sql)
    }
    db.execute(sql)
  }
}