//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-24  Jed Young  Creation
//

using isql

**
** convert row[] to XML
**
internal class XmlMaker
{
  private Row[] rows

  new make(Row[] rows)
  {
    this.rows = rows
  }

  Void dump(OutStream out)
  {
    out.printLine("<data>")
    if (!rows.isEmpty)
    {
      writeMeta(out, rows.first)
    }

    rows.each
    {
      writeRow(out, it)
    }
    out.printLine("</data>")
  }

  private Void writeMeta(OutStream out, Row row)
  {
    out.printLine("  <meta>")
    row.cols.each
    {
      writeCol(out, it)
    }
    out.printLine("  </meta>")
  }

  private Void writeCol(OutStream out, Col col)
  {
    out.printLine("""    <col name="$col.name" type="$col.type.name"/>""")
  }

  private Void writeRow(OutStream out, Row row)
  {
    out.printLine("  <row>")
    row.cols.each
    {
      writeField(out, it, row)
    }
    out.printLine("  </row>")
  }

  private Void writeField(OutStream out, Col col, Row row)
  {
    value := row.get(col)?.toStr
    out.printLine("""    <$col.name>$value</$col.name>""")
  }
}