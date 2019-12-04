//
// Copyright (c) 2008, John Sublett
// Licensed under the Academic Free License version 3.0
//
// History:
//   12 Jan 07  John Sublett  Creation
//

using [java]java.lang::Class

**
** SqlServiceTest (maybe rename from old test)
**
class SqlServiceTest1 : Test
{
  SqlConn? db

  //const static Str uri := "jdbc:sqlite:test.sqlite.db"
  const static Str uri := "jdbc:h2:test"

  static
  {
    //Class.forName("org.sqlite.JDBC")
    Class.forName("org.h2.Driver")
  }

//////////////////////////////////////////////////////////////////////////
// Open
//////////////////////////////////////////////////////////////////////////

  Void test()
  {
    db = SqlConn.open(uri, null, null)
    verifyEq(db.isClosed, false)

    dropTables
    createTable
    insertTable
    query
    prepare

    db.close
    verifyEq(db.isClosed, true)
  }

  **
  ** Drop all tables in the database
  **
  Void dropTables()
  {
    db.sql("drop table if exists farmers").execute
  }

  Void createTable()
  {
    db.sql(
     "create table farmers(
      farmer_id int auto_increment,
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
      bigdec    decimal(2,1),
      dt        datetime,
      d         date,
      t         time,
      primary key (farmer_id))
      ").execute

    meta := db.meta.tableMeta("farmers")
    verifyEq(meta.size, 15)
  }

//////////////////////////////////////////////////////////////////////////
// Insert
//////////////////////////////////////////////////////////////////////////

  Void insertTable()
  {
    // insert a couple rows
    dt := DateTime(2009, Month.dec, 15, 23, 19, 21)
    date := Date("1972-09-10")
    time := TimeOfDay("14:31:55")
    data := [
      [1, "Alice",   false, "Pooh",     "abcd", 21,   1,   80,  null, 5.3f,  120f, 3.2d, dt, date, time],
      [2, "Brian",   true,  "Haley",    "1234", 35,   2,   99,   5,   5.7f,  140f, 1.5d, dt, date, time],
      [3, "Charlie", null,  "Addi",     null,   null, 3,   44,   7,   null, 6.1f,  2.0d, dt, date, time],
      [4, "Donny",   true,  null,       "wxyz", 40,  null, null, 8,   null, null,  5.0d, dt, date, time],
      [5, "John",    true,  "Berkeley", "5678", 35,  null, null, 8,   null, null,  5.7d, dt, date, time],
    ]
    data.each |Obj?[] row| { insertFarmer(row[1..-1]) }
  }

  private Void insertFarmer(Obj?[] row)
  {
    s := "insert into farmers (name, married, pet, ss, age, pigs, cows, ducks, height, weight, bigdec, dt, d, t) values ("
    s += row.join(", ") |Obj? o->Str|
    {
      if (o == null)     return "null"
      if (o is Str)      return "'$o'"
      if (o is DateTime) return "'" + o->toLocale("YYYY-MM-DD hh:mm:ss") + "'"
      if (o is Date)     return "'" + o->toLocale("YYYY-MM-DD") + "'"
      if (o is TimeOfDay)     return "'" + o->toLocale("hh:mm:ss") + "'"
      if (o is Bool)     return (Bool)o ? "1" : "0"
      return o.toStr
    }
    s += ")"

    db.sql(s).execute
  }

//////////////////////////////////////////////////////////////////////////
// Query
//////////////////////////////////////////////////////////////////////////

  private Void query()
  {
    set := db.sql("select * from farmers order by farmer_id").query

    while(set.next)
    {
      set.cols.each |c|
      {
        val := set.get(c.index)
        t := val==null?"":val.typeof
        echo("$c.name: $val, ${t}")
      }
      echo("=======================")
    }
    set.close
  }

  private Void prepare()
  {
    set := db.sql("select * from farmers where name=?").set(0, "Alice").query

    while(set.next)
    {
      set.cols.each |c|
      {
        val := set.get(c.index)
        t := val==null?"":val.typeof
        echo("$c.name: $val, ${t}")
      }
    }
    set.close
  }
}