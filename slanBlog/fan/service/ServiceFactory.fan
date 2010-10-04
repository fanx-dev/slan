//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-4 - Initial Contribution
//


**
**
**
const class ServiceFactory
{
  static const ServiceFactory cur:=ServiceFactory()
  private new make(){}
  
  const PostService postService:=PostService()
  const LogService logService:=LogService()
  const UserService userService:=UserService()
  const CommentService commentService:=CommentService()
}
