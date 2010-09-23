class CacheTest:Test{
  
  Void testGet(){
    cache:=Cache()
    cache["key"]="obj"
    this.verify(cache["key"]=="obj")
  }
  
  Void testRemove(){
    cache:=Cache()
    cache["key"]="obj"
    cache.remove("key")
    this.verify(cache["key"]==null)
  }
}