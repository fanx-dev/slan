//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-30 - Initial Contribution
//
using compiler

**
**
**
const class TemplateErr:Err
{
  const CompilerErr err
  const Str source
  const File file
  new make(CompilerErr err,Str source,File file):super(err.msg,err){
    this.err=err
    this.source=source
    this.file=file
  }
  
  Str dump(){
    colorSource:=dumpSource(source,err.line)
    //new line
    line:=err.line-4
    col:=err.col-21
    
    s:="""<html>
            <head><title>template error</title></head>
            <body>
              <h1>TemplateErr: $err.msg</h1>
              <h2>$file.toStr ($line,$col)
              </h2>
              <p>$colorSource</p>
            </body>
          </html>"""
    return s
  }
  
  //dump error source
  private Str dumpSource(Str source,Int line){
    line-=1//to base 0
    lines:=source.splitLines
    
    errorLine:="""<span style="background-color:red; font-weight:bold;">${replace(lines[line])}</span>"""
    above:=replace(lines[0..<line].join("\n"))
    below:=replace(lines[line+1..-1].join("\n"))
    code:="""<div style="background-color:#aaa">
             <code><pre>$above
             $errorLine
             $below</pre></code>
             </div>"""
    return code+"<p>by slanweb</p>"
  }
  
  private Str replace(Str s){
    s.replace("<","&lt;").replace(">","&gt;")
  }
}
