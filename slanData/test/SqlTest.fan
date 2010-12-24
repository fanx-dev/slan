//
// Copyright (c) 2008, John Sublett
// Licensed under the Academic Free License version 3.0
//
// History:
//   12 Jan 07  John Sublett  Creation
//   2010-12-24 Jed Young
//

using isql

**
** SqlServiceTest: this is not actually a Test.  It defines
** all common database tests and is used by the database
** specific tests.
**
class SqlTest : Test
{

//////////////////////////////////////////////////////////////////////////
// Setup
//////////////////////////////////////////////////////////////////////////

  once SqlService db()
  {
    pod := Pod.find("isql")
    return SqlService(
      pod.config("test.connection"),
      pod.config("test.username"),
      pod.config("test.password"),
      pod.config("test.driver"))
  }

//////////////////////////////////////////////////////////////////////////
// Top
//////////////////////////////////////////////////////////////////////////

  Void test()
  {
    try
    {
      db.open
      dropTables
      createTable
      insertTable
      query
    }
    catch (Err e)
    {
      throw e
    }
    finally
    {
      db.close
      db.closePool
      verify(db.isClosed)
    }
  }

  Void query()
  {
    buf := Buf()
    DataService(db).sql("select * from farmers order by farmer_id",buf.out)
    buf.flip
    echo(buf.readAllStr)
  }

//////////////////////////////////////////////////////////////////////////
// Drop Tables
//////////////////////////////////////////////////////////////////////////

  **
  ** Drop all tables in the database
  **
  Void dropTables()
  {
    try
      db.sql("drop table farmers").execute
    catch{}
  }

//////////////////////////////////////////////////////////////////////////
// Create Table
//////////////////////////////////////////////////////////////////////////

  Void createTable()
  {
    db.sql(
     "create table farmers(
      farmer_id int auto_increment not null,
      name      varchar(255) not null,
      married   bit,
      pet       varchar(255),
      ss        char(4),
      age       tinyint,
      pigs      smallint,
      cows      int,
      ducks     bigint,
      height    float,
      weight    double,
      dt        datetime,
      d         date,
      t         time,
      primary key (farmer_id))
      ").execute
  }

//////////////////////////////////////////////////////////////////////////
// Insert Table
//////////////////////////////////////////////////////////////////////////

  Void insertTable()
  {
    // insert a couple rows
    dt := DateTime(2009, Month.dec, 15, 23, 19, 21)
    date := Date("1972-09-10")
    time := Time("14:31:55")
    data := [
      [1, "Alice",   false, "Pooh",     "abcd", 21,   1,   80,  null, 5.3f,  120f, dt, date, time],
      [2, "Brian",   true,  "Haley",    "1234", 35,   2,   99,   5,   5.7f,  140f, dt, date, time],
      [3, "Charlie", null,  "Addi",     null,   null, 3,   44,   7,   null, 6.1f,  dt, date, time],
      [4, "Donny",   true,  null,       "wxyz", 40,  null, null, 8,   null, null,  dt, date, time],
      [5, "John",    true,  "Berkeley", "5678", 35,  null, null, 8,   null, null,  dt, date, time],
    ]
    data.each |Obj[] row| { insertFarmer(row[1..-1]) }

  }

  private Void insertFarmer(Obj[] row)
  {
    s := "insert farmers (name, married, pet, ss, age, pigs, cows, ducks, height, weight, dt, d, t) values ("
    s += row.join(", ") |Obj? o->Str|
    {
      if (o == null)     return "null"
      if (o is Str)      return "'$o'"
      if (o is DateTime) return "'" + o->toLocale("YYYY-MM-DD hh:mm:ss") + "'"
      if (o is Date)     return "'" + o->toLocale("YYYY-MM-DD") + "'"
      if (o is Time)     return "'" + o->toLocale("hh:mm:ss") + "'"
      return o.toStr
    }
    s += ")"

    // verify we got key back
    Int[] keys := db.sql(s).execute
    verifyEq(keys.size, 1)
    verifyEq(keys.typeof, Int[]#)

    // read with key and verify it is what we just wrote
    farmer := db.sql("select * from farmers where farmer_id = $keys.first").query.first
    verifyEq(farmer->name, row[0])
  }

}