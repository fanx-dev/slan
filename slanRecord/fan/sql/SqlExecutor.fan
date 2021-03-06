//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql
using concurrent

**
** important class for execute sql.
**
internal const class SqlExecutor
{
  const InsertMaker inserMaker := InsertMaker()
  const TableMaker tableMaker := TableMaker()
  const UpdateByIdMaker updateByIdMaker := UpdateByIdMaker()
  const UpdateMaker updateMaker := UpdateMaker()
  const WhereMaker whereMaker := WhereMaker()
  const IdWhereMaker idWhereMaker := IdWhereMaker()
  const SelectMaker selectMaker := SelectMaker()

  const Log log := Pod.of(this).log

  SqlDialect sqlDialect() {
    Actor.locals.getOrAdd("slan.sqlDialect") { SqlDialect() }
  }

  Void insert(TableDef table, SqlConn db, Obj obj)
  {
    sql := inserMaker.getSql(table)
    params := inserMaker.getParam(table, obj)
    SqlUtil.convertParams(params)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(params.toStr)
    }
    stmt := db.sql(sql)
    params.each |p, i|{ stmt.set(i, p) }
    stmt.execute
    if (table.autoGenerateId == true)
    {
      set := stmt.getGeneratedKeys
      if (set.next)
      {
        table.id.set(obj, set.get(0))
      }
      set.close
    }
    stmt.close
  }

  Void updateById(TableDef table, SqlConn db, Obj obj)
  {
    sql := updateByIdMaker.getSql(table, obj)
    params := updateByIdMaker.getParam(table, obj)
    SqlUtil.convertParams(params)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(params.toStr)
    }
    stmt := db.sql(sql)
    params.each |p, i|{ stmt.set(i, p) }
    stmt.execute
    stmt.close
  }

  Void updateByCondition(TableDef table, SqlConn db, Obj obj, Str condition)
  {
    sql := updateMaker.getSql(table, obj) + " where " + condition
    params := updateMaker.getParam(table, obj)
    SqlUtil.convertParams(params)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(params.toStr)
    }
    stmt := db.sql(sql)
    params.each |p, i|{ stmt.set(i, p) }
    stmt.execute
    stmt.close
  }

  Void updateByExample(TableDef table, SqlConn db, Obj obj, Obj where)
  {
    sql := updateMaker.getSql(table, obj) +" "+ whereMaker.getSql(table, where)
    params := updateMaker.getParam(table, obj)
    params2 := whereMaker.getParam(table, where)
    SqlUtil.convertParams(params)
    SqlUtil.convertParams(params2)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(params.toStr + " where " + params2.toStr)
    }
    stmt := db.sql(sql)

    Int pos := params.size
    params.each |p, i|{ stmt.set(i, p) }
    params2.each |p, i|{ stmt.set(i+pos, p) }

    stmt.execute
    stmt.close
  }

//////////////////////////////////////////////////////////////////////////
// select
//////////////////////////////////////////////////////////////////////////

  ** select data list
  Obj[] select(TableDef table, SqlConn db, Obj obj, Str orderby, Int offset, Int limit)
  {
    sql := selectMaker.getSql(table)  + " from $table.name " + whereMaker.getSql(table, obj)
    if (orderby != "") sql += " " + orderby
    params := whereMaker.getParam(table,obj)
    SqlUtil.convertParams(params)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(params.toStr)
    }
    Obj[] list := [,]
    stmt := db.sql(sql)
    stmt.limit = offset + limit
    params.each |p, i|{ stmt.set(i, p) }

    set := stmt.query
    set.moveTo(offset)
    while(set.next)
    {
      list.add(SqlUtil.getInstance(table, set))
    }
    set.close
    stmt.close
    return list
  }

  ** select data list
  Obj? selectOne(TableDef table, SqlConn db, Obj obj, Str orderby, Int offset)
  {
    sql := selectMaker.getSql(table)  + " from $table.name " + whereMaker.getSql(table, obj)
    if (orderby != "") sql += " " + orderby
    params := whereMaker.getParam(table,obj)
    SqlUtil.convertParams(params)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(params.toStr)
    }
    Obj? one := null
    stmt := db.sql(sql)
    stmt.limit = offset + 1
    params.each |p, i|{ stmt.set(i, p) }
    set := stmt.query
    set.moveTo(offset)
    if (set.next)
    {
      one = (SqlUtil.getInstance(table, set))
    }
    set.close
    stmt.close

    return one
  }

  ** select by condition
  Obj[] selectWhere(TableDef table, SqlConn db, Str condition, Int offset, Int limit)
  {
    sql := selectMaker.getSql(table) + " from $table.name"
    if (condition != "") sql += " " + condition

    if (log.isDebug)
    {
      log.debug(sql)
    }
    Obj[] list := [,]
    //i := 0
    stmt := db.sql(sql)
    stmt.limit = offset + limit
    set := stmt.query
    set.moveTo(offset)
    while(set.next)
    {
      list.add(SqlUtil.getInstance(table, set))
    }
    set.close
    stmt.close

    return list
  }

  Obj[] query(TableDef? table, SqlConn db, Str sql, Obj[]? params, Int offset, Int limit)
  {
    if (log.isDebug)
    {
      log.debug(sql)
    }
    Obj[] list := [,]
    stmt := db.sql(sql)
    stmt.limit = offset + limit
    SqlUtil.convertParams(params)
    params?.each |p, i|{ stmt.set(i, p) }
    set := stmt.query

    if (table == null) {
      table = SqlUtil.colsToSchema("_temp_table_", set.cols)
    }

    set.moveTo(offset)
    while(set.next)
    {
      list.add(SqlUtil.getInstance(table, set))
    }
    set.close
    stmt.close

    return list
  }

  Void delete(TableDef table, SqlConn db, Obj obj)
  {
    sql := "delete from $table.name " + whereMaker.getSql(table, obj)
    paramss := whereMaker.getParam(table, obj)
    SqlUtil.convertParams(paramss)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(paramss.toStr)
    }
    stmt := db.sql(sql)
    paramss.each |p, i|{ stmt.set(i, p) }
    stmt.execute
    stmt.close
  }

  Int count(TableDef table, SqlConn db, Obj obj)
  {
    sql := "select count(*) from $table.name " + whereMaker.getSql(table, obj);
    params := whereMaker.getParam(table, obj)
    SqlUtil.convertParams(params)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(params.toStr)
    }
    stmt := db.sql(sql)
    params.each |p, i|{ stmt.set(i, p) }
    Int i := 0
    set := stmt.query
    set.next
    i = set.get(0)
    set.close
    stmt.close

    return i
  }

//////////////////////////////////////////////////////////////////////////
// by ID
//////////////////////////////////////////////////////////////////////////

  Void removeById(TableDef table, SqlConn db, Obj id)
  {
    stmt := byIdStmt(table, db, id, "delete ")
    stmt.execute
    stmt.close
  }

  Obj? findById(TableDef table, SqlConn db, Obj id)
  {
    stmt := byIdStmt(table, db, id, selectMaker.getSql(table))

    Obj? obj := null
    set := stmt.query
    set.next
    obj = SqlUtil.getInstance(table, set)
    set.close
    stmt.close

    return obj
  }

  Bool existById(TableDef table, SqlConn db, Obj id)
  {
    stmt := byIdStmt(table, db, id, "select count(*)")

    Bool exist := false
    set := stmt.query
    exist = set.next
    set.close
    stmt.close
    return exist
  }

  private Statement byIdStmt(TableDef table, SqlConn db, Obj id, Str before)
  {
    sql := before + " from $table.name " + idWhereMaker.getSql(table)
    params := idWhereMaker.getParam(table, id)
    SqlUtil.convertParams(params)
    if (log.isDebug)
    {
      log.debug(sql)
      log.debug(params.toStr)
    }
    stmt := db.sql(sql)
    params.each |p, i|{ stmt.set(i, p) }
    return stmt
  }

//////////////////////////////////////////////////////////////////////////
// Table op
//////////////////////////////////////////////////////////////////////////

  Void createTable(TableDef table, SqlConn db)
  {
    sql := tableMaker.createTable(table, sqlDialect)
    if (log.isDebug)
    {
      log.debug(sql)
    }
    stmt := db.sql(sql)
    stmt.execute
    stmt.close

    table.each |FieldDef f|
    {
      if (f.indexed)
      {
        sql = tableMaker.createIndex(table.name, f.name)
        if (log.isDebug)
        {
          log.debug(sql)
        }
        stmt = db.sql(sql)
        stmt.execute
        stmt.close
      }
    }
  }

  Void dropTable(TableDef table, SqlConn db)
  {
    sql := tableMaker.dropTable(table)
    if (log.isDebug)
    {
      log.debug(sql)
    }
    stmt := db.sql(sql)
    stmt.execute
    stmt.close
  }
}