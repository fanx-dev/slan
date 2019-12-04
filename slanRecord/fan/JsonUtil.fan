

class JsonUtil {
  OutStream out
  Bool encode := true

  private new make(OutStream out) {
    this.out = out
  }

  static Str toJson(Obj? val) {
    sb := StrBuf()
    JsonUtil(sb.out).writeJson(val)
    return sb.toStr
  }

  private Void writeJson(Obj? val) {
    if (val == null)  out.print("null")
    else if (val is Str) writeJsonStr(val)
    else if (val is Map) writeJsonMap(val)
    else if (val is List) writeJsonList(val)
    else if (val is Num) out.print(val)
    else if (val is Bool) out.print(val)
    else if (val is Record) writeRecord(val)
    else if (val is Buf) writeJsonStr(((Buf)val).toBase64)
    else writeObj(val)
  }

  private Void writeJsonPair(Str key, Obj? val)
  {
    writeJsonStr(key)
    out.writeChar(':')
    writeJson(val)
  }

  private Void writeRecord(Record r) {
    out.writeChar('{')
    notFirst := false
    r.schema.each |f, i| {
      if (notFirst) out.writeChar(',')
      writeJsonPair(f.name, r.get(i))
      notFirst = true
    }

    r.typeof.fields.each |f| {
      if (f.isStatic) return
      if (f.hasFacet(Transient#)) return
      if (f.name == "values") return
      if (notFirst) out.writeChar(',')
      writeJsonPair(f.name, f.get(r))
      notFirst = true
    }
    out.writeChar('}')
  }

  private Void writeObj(Obj obj) {
    out.writeChar('{')
    notFirst := false
    obj.typeof.fields.each |f| {
      if (f.isStatic) return
      if (f.hasFacet(Transient#)) return
      if (notFirst) out.writeChar(',')
      val := f.get(obj)
      if (val === obj) return
      echo("$obj.typeof, $f, $val")
      writeJsonPair(f.name, val)
      notFirst = true
    }
    out.writeChar('}')
  }

  private Void writeJsonMap([Str:Obj?] map)
  {
    out.writeChar('{')
    notFirst := false
    map.each |val, key|
    {
      if (key isnot Str) key = key.toStr
      if (notFirst) out.writeChar(',')
      writeJsonPair(key, val)
      notFirst = true
    }
    out.writeChar('}')
  }

  private Void writeJsonList(Obj?[] array)
  {
    out.writeChar('[')
    notFirst := false
    array.each |item|
    {
      if (notFirst) out.writeChar(',')
      writeJson(item)
      notFirst = true
    }
    out.writeChar(']')
  }

  private Void writeJsonStr(Str str)
  {
    out.writeChar('"')
    str.each |char|
    {
      if (char <= 0x7f)
      {
        switch (char)
        {
          case '\b': out.writeChar('\\').writeChar('b')
          case '\f': out.writeChar('\\').writeChar('f')
          case '\n': out.writeChar('\\').writeChar('n')
          case '\r': out.writeChar('\\').writeChar('r')
          case '\t': out.writeChar('\\').writeChar('t')
          case '\\': out.writeChar('\\').writeChar('\\')
          case '"':  out.writeChar('\\').writeChar('"')
          default: out.writeChar(char)
        }
      }
      else
      {
        if (encode)
           out.writeChar('\\').writeChar('u').print(char.toHex(4))
        else
           out.writeChar(char)
      }
    }
    out.writeChar('"')
  }
}