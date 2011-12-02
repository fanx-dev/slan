//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-12-02  Jed Young  Creation
//

using slanData

**
** test slanData
**
internal class DataTest : Test
{
  Log log := Pod.of(this).log
  LogLevel defaultLevel := log.level

  Context? c
  ConnFactory? factory

  Schema? table

  override Void setup()
  {
    log.level = LogLevel.debug
    table = Teacher.getSchema
    factory = ConnFactory.make(TestConnection#.pod)
    tables := Mapping([table])
    c = Context(tables)
    factory.open
  }

  override Void teardown()
  {
    factory.close
    log.level = defaultLevel
  }

  private Void buildTable()
  {
    if (c.tableExists(table))
    {
      c.dropTable(table)
    }
    c.createTable(table)
  }

  private Void insert()
  {
    r1 := Record(table)
    t1 := Teacher(r1)
    t1.name = "yjd"
    t1.age = 25
    t1.weight = 56.9f
    buf := Buf()
    buf.write('K').flip
    t1.image = buf

    verifyNull(t1.id)
    c.insert(r1)
    verifyNotNull(t1.id)
  }

  private Void query()
  {
    r1 := Record(table)
    t1 := Teacher(r1)
    t1.name = "yjd"
    r2 := c.one(r1)
    t2 := Teacher(r2)

    verifyEq(t2.age, 25)
    verifyEq(t2.weight, 56.9f)
    echo(t2.image)
    verifyEq(t2.image.read, 'K')

    //TODO: why the size is 1024
    //verifyEq(t2.image.size, 1)
  }

  Void test()
  {
    buildTable
    insert
    query
  }
}