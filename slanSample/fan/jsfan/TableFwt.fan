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

@Js
class TableFwt : Window
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
        top = InsetPane(0, 0, 12, 0) {
          GridPane {
            Button {
              text = "loadData"
              onAction.add { loadData }
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

  Void loadData()
  {
    namet := Text { prefCols = 40 }
    value := Text { prefCols = 40 }
    dlg   := Dialog(window)
    {
      it.title = "load data from server"
      it.body = "Are you sure?"
      it.commands = Dialog.okCancel
    }
    dlg.onClose.add |e|
    {
      if (e.data == Dialog.ok)
      {
        try
        {
          HttpReq { uri = `/action/Ajax/data`; headers["foo"] = "bar!" }.get |res|
          {
            c := res.content.in.readObj
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

  ** field
  Table table
}
@Js
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

