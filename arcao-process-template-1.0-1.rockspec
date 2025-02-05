package = "arcao-process-template"
version = "1.0-1"
source = {
   url = "git://github.com/ArcAOGaming/arcao-process-template",
   tag = "v1.0"
}
description = {
   homepage = "https://github.com/ArcAOGaming/arcao-process-template/",
   license = "MIT"
}
dependencies = {
   "lua >= 5.3",
   "busted >= 2.1.1",  -- Adding Busted dependency
   "ldoc",
   "json4lua"
}
build = {
   type = "builtin",
   modules = {
      ["arcao.main"] = "src/main.lua",
      ["arcao.math_helper"] = "src/math_helper.lua"
   }
}
