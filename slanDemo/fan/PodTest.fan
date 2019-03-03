

using web
using slanWeb

const class PodTest : Controller
{
  Void index() {
    stash("name", "abc")
    render(`/res/podTest.html`)
  }
}