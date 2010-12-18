//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-11-20  Jed Young  Creation
//

using web

const class HttpTool : Weblet
{
  Bool isOldIE()
  {
    Str agent := req.headers["User-Agent"]
    return agent.contains("MSIE 6") || agent.contains("MSIE 7")
  }

  Locale locale()
  {
    localeStr := req.headers["Accept-Language"].split(';').first
    localeStr = localeStr.split(',').first
    list := localeStr.split('-')

    lang := list.first.lower
    country := list.last.upper
    locale := "$lang-$country"

    return Locale(locale)
  }

  Void goback()
  {
    Str uri := req.headers["Referer"]
    res.redirect(uri.toUri)
  }
}