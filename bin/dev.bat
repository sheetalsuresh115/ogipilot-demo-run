@echo off

REM foreman does not realy support Windows but it will still work
REM if the 'web' process is stared on its own. 'css' and 'worker'
REM can be started together, e.g., `.\bin\dev.bat css=1,worker=1`

FOR /F "tokens=*" %%g IN ('gem list --no-installed --exact foreman') DO (SET NO_FOREMAN=%%g)

IF %NO_FOREMAN%==true (
  echo "Installing foreman..."
  gem install foreman
)

REM Default to port 3000 if not specified
IF "%PORT%"=="" SET PORT=3000

foreman start -f Procfile.dev.win %*
