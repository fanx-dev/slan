//
// Copyright (c) 2009, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   17 Oct 09  Andy Frank  Creation
//

using dom
using gfx
using fwt
using web

class Cookies : Window
{
  new make() : super(null, null)
  {
    table = Table {
      model = ListModel([[,]])
    }
    content = InsetPane(24)
    {
      EdgePane
      {
        top = InsetPane(0,0,12,0) {
          GridPane {
            Button {
              text = "Refrush"
              onAction.add { addCookie }
            },
          },
        }
        center = table
      },
    }
  }

  Void main()
  {
    open
  }

  Void addCookie()
  {
    namet  := Text { prefCols=40 }
    value := Text { prefCols=40 }
    dlg   := Dialog(window)
    {
      it.title = "Add Cookie"
      it.body = GridPane
      {
        numCols = 2
        Label { text="Name"  }, namet,
        Label { text="Value" }, value,
      }
      it.commands = Dialog.okCancel
    }
    dlg.onClose.add |e|
    {
     if (e.data == Dialog.ok)
     {
       try
       {
         HttpReq { uri=`/action/tableView/data`; headers["foo"]="bar!" }.get |res| 
         {
           c:=res.content.in.readObj
           //Win.cur.alert(c)
           
           table.model=ListModel(c)
           table.refreshAll
         }
       }
       catch (Err err)
       {
         Dialog.openErr(window, "Could not add cookie", err)
       }
     }
    }
    dlg.open
  }

  Table table
}

class ListModel : TableModel
{
  List[] list
  
  new make(List[] list)
  {
    this.list=list
  }
  override Int numRows() { return list.size-1 }
  override Int numCols() { return list[0].size }
  override Str header(Int col) { return list[0][col] }
  override Str text(Int col, Int row)
  {
    return list[row+1][col]
  }
}

