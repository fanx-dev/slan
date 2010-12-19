//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using compiler

**
** err show
**
const class SlanCompilerErr : Err
{
  const CompilerErr err
  const Str source
  const Str file

  new make(CompilerErr err, Str source, Str file) : super(err.msg, err)
  {
    this.err = err
    this.source = source
    this.file = file
  }

  Str dump()
  {
    colorSource := dumpSource(source, err.line, err.col)

    s:="""<html>
            <head>
              <title>Compiler Error</title>
              <style type="text/css">
                $style
              </style>
            </head>
            <body>
              <p id="msg"><a href="#error">Compiler Error: $err.msg</a></p>
              <p id="path"><a href="$file.toStr">$file.toStr ($err.line,$err.col)</a></p>
              <div id="code">$colorSource</div>
              <p id="author">by slanweb</p>
            </body>
          </html>"""
    return s
  }

  //dump error source
  private Str dumpSource(Str source, Int line, Int col)
  {
    line -= 1//to base 0
    lines := source.splitLines

    errorLine := """<span id="errorLine">${lines[line].toXml}</span>"""
    errorCursor := """<span id="errorCursor">${Str.spaces(col)}^ $err.msg</span>"""
    above := lines[0..<line].join("\n").toXml
    below := lines[line+1..-1].join("\n").toXml

    code := """<pre>
                 <code>
               $above
               <a id="error">$errorLine</a>
               $errorCursor
               $below
                 </code>
               </pre>"""
    return code
  }

  private Str style()
  {
    """body { background-color:#7F89BF}
       #errorLine { background-color:red; font-weight:bold; }
       #code { background-color:#ccc; }
       #errorCursor { color:blue; }
       #msg { font:150% "Trebuchet MS",Helvetica,Verdana,sans-serif; color:#FF6A00;}
       #msg a { color:#FF6A00; }
       #author { text-align:right; font-family:Arial; }
       """
  }
}