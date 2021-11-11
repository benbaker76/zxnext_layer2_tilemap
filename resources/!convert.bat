@ECHO OFF
IF NOT DEFINED GFX2NEXT_HOME SET GFX2NEXT_HOME=..\..\..\..\NextTools\Gfx2Next\bin
%GFX2NEXT_HOME%\gfx2next.exe -tile-norotate -map-16bit -bank-16k -z80asm -bank-sections=rodata_user,BANK_17,BANK_32,BANK_33,rodata_user tiles.png
REM %GFX2NEXT_HOME%\gfx2next.exe -tile-norotate -map-16bit -map-y -bank-16k -z80asm -bank-sections=rodata_user,BANK_17,BANK_32,BANK_33,rodata_user tiles.png
move *.nxt ..\binary >nul
move *.nxm ..\binary >nul
move *.nxp ..\binary >nul
move *.asm ..\src >nul
move *.h ..\src >nul
