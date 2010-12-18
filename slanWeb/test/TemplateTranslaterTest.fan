//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

internal class TemplateTranslaterTest : Test
{

  Void testReplaceSimple()
  {
    s1 := "hi @message%ok"
    e1 := "hi m->message%ok"

    verifyReplace(s1, e1)
  }

  Void testReplace()
  {
    s1 := Str<| hi$@message%ok "|>
    e1 := Str<| hi${m->message}%ok "|>

    verifyReplace(s1, e1)
  }

  Void testReplaceMutil()
  {
    s1 := Str<| hi$@message%ok$@n "|>
    e1 := Str<| hi${m->message}%ok${m->n} "|>
    verifyReplace(s1, e1)
  }

  Void testReplaceNoSpace()
  {
    s1 := Str<| hi$@message%ok@n "|>
    e1 := Str<| hi${m->message}%ok@n "|>
    verifyReplace(s1, e1)
  }

  Void testReplaceHasSpace()
  {
    s1 := Str<| hi$@message%ok @n "|>
    e1 := Str<| hi${m->message}%ok m->n "|>
    verifyReplace(s1, e1)
  }

  Void testReplaceStart()
  {
    s1 := Str<| $@message%ok$@n "|>
    e1 := Str<| ${m->message}%ok${m->n} "|>

    verifyReplace(s1, e1)
  }

  Void testReplaceEnd()
  {
    s1 := Str<| ok$@|>
    e1 := Str<| ok$@|>

    verifyReplace(s1, e1)
  }

  Void testReplaceEndSpace()
  {
    s1 := Str<| ok$@ a|>
    e1 := Str<| ok$@ a|>

    verifyReplace(s1, e1)
  }

  Void testReplaceEscapeAt()
  {
    s1 := Str<| $@message%ok@@n "|>
    e1 := Str<| ${m->message}%ok@n "|>

    verifyReplace(s1, e1)
  }

  Void testReplaceEscapeDO()
  {
    s1 := Str<| hi\$@message%ok "|>
    e1 := Str<| hi\${m->message}%ok "|>

    verifyReplace(s1, e1)
  }

  Void testReplaceLongInvok()
  {
    s1 := Str<| hi${@message->value}ok "|>
    e1 := Str<| hi${m->message->value}ok "|>

    verifyReplace(s1, e1)
  }

  Void testReplaceLocale()
  {
    s1 := Str<| hi$<@message>ok|>
    e1 := Str<| hi$<slanSample::message>ok|>

    verifyReplace(s1, e1)
  }

  private Void verifyReplace(Str str, Str expected)
  {
    Pod.of(this).log.level = LogLevel.debug
    SlanApp slanApp := SlanApp.makeProduct("slanSample")

    tt := TemplateTranslater(slanApp)
    r1 := tt->replace(str, "@", 0)

    verifyEq(r1, expected)
  }
}