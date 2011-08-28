//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-25  Jed Young  Creation
//

**
** experiment features
**
class a : InlineTag
{
  Uri? href
  Str? rel
  Str? type
}

class abbr : InlineTag {}

class acronym : InlineTag{}

class address : InlineTag{}

class area : InlineTag
{
  Str alt
  Uri href
}

class b : InlineTag{}
class base : InlineTag {}

class bdo : InlineTag
{
  Str dir
}

class big : InlineTag {}
class blockquote : InlineTag
{
  Uri? site
}
class body : BlockTag {}
class br : InlineTag {}
class button : InlineTag {}
class caption : InlineTag {}
class cite : InlineTag {}
class code : InlineTag {}
class col : InlineTag {}
class colgroup : InlineTag {}
class dd : InlineTag {}
class del : InlineTag
{
  Str? cite
  DateTime? datetime
}
class div : BlockTag {}
class dfn : InlineTag {}
class dl : BlockTag {}
class dt : InlineTag {}
class em : InlineTag {}
class fieldset : BlockTag {}
class form : BlockTag
{
  Str? action
  Str? accept
  Str? accept-charset
  Str? enctype
  Str? method
}

class h1 : InlineTag {}
class h2 : InlineTag {}
class h3 : InlineTag {}
class h4 : InlineTag {}
class h5 : InlineTag {}
class h6 : InlineTag {}

class head : BlockTag {}
class hr : BlockTag {}
class html : BlockTag {}
class i : InlineTag {}
class img : InlineTag {}
class imput : InlineTag
{
  Str? accept
  Str? alt
  Bool? checked
  Bool? disabled
  Bool? ismap
  Int? maxlength
  Str? name
  Bool? readOnly
  Int? size
  Str? src
  InputType? type
  Str? usemap
  Str? value
}
class ins : InlineTag
{
  Str? cite
  DateTime? datetime
}

class kbd : InlineTag {}
class label : InlineTag {}
class legend : InlineTag {}
class li : InlineTag {}
class link : InlineTag
{

}
class map : InlineTag {
}
class meta : InlineTag
{

}
class noscript : InlineTag {}
class object : BlockTag
{


}
class ol : BlockTag {}
class optgroup : InlineTag {}
class option : InlineTag {}
class p : BlockTag {}
class param : InlineTag {}
class pre : BlockTag {}
class q : BlockTag {}
class samp : InlineTag {}
class script : InlineTag {}
class select : InlineTag {}
class small : InlineTag {}
class span : InlineTag {}
class strong : InlineTag {}
class style : InlineTag {}
class sub : InlineTag {}
class sup : InlineTag {}
class table : BlockTag {}
class tbody : BlockTag {}
class td : InlineTag {}
class textarea : InlineTag {}
class tfoot : InlineTag{}
class th : InlineTag {}
class thead : InlineTag {}
class title : InlineTag {}
class tr : InlineTag {}
class ul : BlockTag {}
class var : InlineTag {}