
## Slan Web Framework

### Features
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

### Overview
- slanWeb is core web service
- slanDemo is a web app template and demo
- slanRecord is very simple ORM tool
- slanUtil is some web utilitys

### Run Demo
```
  cd slanDemo
  fan slanWeb::Main -podName slanDemo -resPath public/
```
You should be able to hit http://localhost:8080/ with your browser!

### Res Type
- .fan script file
- .fwt fantom JS file
- .fsp standalone template page

### File Resolution
- resPath .fan file
- resPath file
- pod file
- pod Class

