
## Slan Web Framework

### Overview
#### Features
- HTTP-to-code url mapping
- Bind an HTTP parameter to a code method parameter
- Hot reload(fix the bug and hit reload)
- Show error source code directly
- Simple stateless MVC
- Familiar templating engine
- Javascript FWT suppert
- Zero configuration
- Build-in localization
- Full-stack(ORM/Validate/Patchca...)

#### Pods
- slanWeb is core web service
- slanDemo is a web app template and demo
- slanRecord is very simple ORM tool
- slanUtil is some web utilitys

### Quick Start

#### Hello Word Html
make file `./public/Hello.fan` like this:
```
  using slanWeb
  class Hello : SlanWeblet {
    Str index() {
      setContentType("html")
      return "<html><h2>Hello Word</h2></html>"
    }
  }
```
start server:
```
  fan slanWeb -resPath public/
```
see: http://localhost:8080/Hello


#### Hello Word Js

file `./public/Hello.fwt`:
```
  using dom
  using domkit

  @Js
  class Main : Box
  {
    new make()
    {
      label := Label { it.text="Hi" }
      this {
        label,
        Button { it.text="Press Me"; onAction { label.text = label.text+"!" } },
      }
    }

    Void main() { Win.cur.doc.body.add(Main()) }
  }
```
see: http://localhost:8080/Hello.fwt

#### Using Template
`./public/Temp.fan`:
```
  using slanWeb
  class Temp : SlanWeblet {
    Void hi() {
      stash("name", "Abc")
      render(`temp.html`)
    }
  }
```
`./public/temp.html`:
```
  <html>
    <h2>Hello @name</h2>
  </html>
```
see: http://localhost:8080/Temp/hi

#### Database ORM
```
  using slanRecord

  class Person {
    @Id Str? sid
    Str? name
    Int? age
  }

  //get connection
  pool = ConnPool.make(...)
  c = poo.openContext

  //create table
  c.createTable(Person#)

  //insert data
  c.insert(Person{ sid = "abc"; name = "abc"; age = 20 })

  //query data
  list := c.list(Person{ age = 20 })

  //select and update
  one := c.one(Person{ id = "abc" })
  one.age = 30
  c.updateById(one)

  //release
  c.close

```

#### Run Demo
```
  cd slanDemo
  fan slanWeb -podName slanDemo -resPath public/
```
You should be able to hit http://localhost:8080/ with your browser!


### Appendix
#### Res Type
- .fan script file
- .fwt fantom JS file
- .fsp standalone template page

#### File Resolution
- resPath .fan file
- resPath file
- pod file
- pod Class

