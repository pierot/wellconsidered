@echo off

echo Compiling Application

set START = %TIME%

"C:\Program Files\Adobe\Flex Builder 3 Beta 2\sdks\3.0.0\bin\asdoc" -doc-sources= be\ -source-path . -output docs\ -footer "wellconsidered" -main-title "wellconsidered classes" -window-title "wellconsidered classes documentation"

set END = %TIME%
set /a DIF = END - START

echo It took %DIF% to compile

@pause