//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-20  Jed Young  Creation
//

internal class TokenizerTest : Test
{

  Void test1()
  {
    r := Tokenizer.convert("<html>asdf</html>", "slanSample")
    verifyEq(r, Str<|<html>asdf</html>|>)
  }

  Void test2()
  {
    r := Tokenizer.convert("<html>@asdf</html>", "slanSample")
    verifyEq(r, Str<|<html>${m->asdf.toStr.toXml}</html>|>)
  }

  Void test3()
  {
    r := Tokenizer.convert("<html>@asdf->name</html>", "slanSample")
    verifyEq(r, Str<|<html>${m->asdf->name.toStr.toXml}</html>|>)
  }

  Void test4()
  {
    r := Tokenizer.convert(Str<|<html>$<asdf>->name</html>|>, "slanSample")
    verifyEq(r, Str<|<html>$<slanSample::asdf>->name</html>|>)
  }

  Void test5()
  {
    r := Tokenizer.convert("<html>@{asdf->name</h}tml>", "slanSample")
    verifyEq(r, Str<|<html>${m->asdf->name</h.toStr.toXml}tml>|>)
  }

  Void test6()
  {
    r := Tokenizer.convert("<html>@@asdf->name</html>", "slanSample")
    verifyEq(r, """<html>@asdf->name</html>""")
  }

  Void test7()
  {
    r := Tokenizer.convert(Str<|<html>$$<asdf>->name</html>|>, "slanSample")
    verifyEq(r, Str<|<html>$<asdf>->name</html>|>)
  }

  Void test8()
  {
    r := Tokenizer.convert(Str<|<html><asdf>->name</html>@|>, "slanSample")
    verifyEq(r, Str<|<html><asdf>->name</html>@|>)
  }

  Void test9()
  {
    r := Tokenizer.convert(Str<|<html><asdf>->name</html>$|>, "slanSample")
    verifyEq(r, Str<|<html><asdf>->name</html>$|>)
  }

  Void test10()
  {
    r := Tokenizer.convert(Str<|<html>$<pod::asdf></html>|>, "slanSample")
    verifyEq(r, Str<|<html>$<pod::asdf></html>|>)
  }

  Void test11()
  {
    r := Tokenizer.convert(Str<|$<asdf>|>, "slanSample")
    verifyEq(r, Str<|$<slanSample::asdf>|>)
  }

  Void test12()
  {
    r := Tokenizer.convert(Str<|@{asdf}|>, "slanSample")
    verifyEq(r, Str<|${m->asdf.toStr.toXml}|>)
  }
}