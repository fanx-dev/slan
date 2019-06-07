//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-12-02  Jed Young  Creation
//
using util

**
** test slanData
**
internal class DataTest : Test
{
  Log log := Pod.of(this).log
  LogLevel defaultLevel := log.level

  Context? c
  ConnPool? factory

  override Void setup()
  {
    log.level = LogLevel.debug
    factory = ConnPool.makeConfig(DataTest#.pod, "test")
    c = factory.openContext
  }

  override Void teardown()
  {
    //factory.close(c.conn)
    c.close
    log.level = defaultLevel
  }

  private Void buildTable()
  {
    if (c.tableExists(User#))
    {
      c.dropTable(User#)
    }
    c.createTable(User#)
  }

  private Void insert()
  {
    t1 := User()
    t1.name = "yjd"
    t1.age = 25
    t1.weight = 56.9f
    buf := Buf()
    buf.write('K').flip
    t1.image = buf

    verifyNull(t1.id)
    c.save(t1)
    verifyNotNull(t1.id)
  }

  private Void query()
  {
    example := User { it.name = "yjd" }
    t2 := c.one(example, "order by name") as User

    verifyEq(t2.age, 25)
    verifyEq(t2.weight, 56.9f)
    echo(t2.image)
    verifyEq(t2.image.read, 'K')

    t3 := c.select(User#, "where name='yjd'", 0, 2)
    verifyEq(t3.size, 1)

    verifyEq(c.list(example).size, 1)
    verifyEq(c.count(example), 1)
    verify(c.exist(example))
  }

  private Void update() {
    obj := c.one(User { it.name = "yjd" }) as User

    obj.age = 28
    c.updateById(obj)
    t2 := c.one(User { it.name = "yjd" }) as User
    verifyEq(t2.age, 28)

    obj.age = 29
    c.updateByCondition(obj, "name='yjd'")
    t3 := c.one(User { it.name = "yjd" }) as User
    verifyEq(t3.age, 29)

    obj.age = 30
    c.updateByExample(obj, User { it.name = "yjd" })
    t4 := c.one(User { it.name = "yjd" }) as User
    verifyEq(t4.age, 30)
  }

  private Void transaction() {
    example := User { it.name = "yjd" }
    try {
      c.trans {
        c.deleteByExample(example)
        throw Err()
      }
    } catch (Err e) {}
    verify(c.exist(example))
  }

  private Void queryTrap() {
    res := c.query("select * from User where name=?", ["yjd"])
    verifyEq(res.size, 1)
    verifyEq(res[0]->name, "yjd")
  }

  private Void queryMapper() {
    res := c.query("select * from User where name=?", ["yjd"], User#)
    verifyEq(res.size, 1)
    user := res[0] as User
    verifyEq(user.name, "yjd")
  }

  private Void queryJson() {
    res := c.query("select * from User where name=?", ["yjd"])
    verifyEq(res.size, 1)
    str := JsonUtil.toJson(res)
    jval := JVal.readJson(str)
    verifyEq(jval.getAt(0)["name"].asStr, "yjd")
  }

  Void test()
  {
    buildTable
    insert
    query
    queryJson
    queryTrap
    queryMapper
    update
    transaction
  }
}