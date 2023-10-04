@echo off

@REM setlocal enabledelayedexpansion

rem バックアップ実行のコマンド(仮) 本来はsqlcmd
call C:\Users\User\Desktop\学習\バッチ作成\get_backup.bat


:loop

REM 実行するsqlcmd(SELECT文)を組み立て　※1レコードの1つのカラム(name)を取得
set sqlcmd=sqlcmd -S DESKTOP-A3NQEUQ\SQLEXPRESS -d test -E -W -Q "SET NOCOUNT ON; select top(1)lifecycle from test order by task_id desc"

@REM echo %sqlcmd%

REM SELECT文(sqlcmd)を実行し結果を変数「lifecycle」へ格納
for /f %%i in ('%sqlcmd%') do set lifecycle=%%i

REM 変数「name」の値を確認
echo ステータス : %lifecycle%

rem ステータス： SUCCESS　の場合次のバッチを呼び出す
if %lifecycle% == SUCCESS (
    echo kakunin
    call C:\Users\User\Desktop\学習\バッチ作成\hoge.bat
    rem 処理を終了
    goto :EOF
    
) else if %lifecycle% == ERROR ( goto judge_end
) else if %lifecycle% == CANCELLED ( goto judge_end
) else if %lifecycle% == CREATED ( goto judge_loop
) else if %lifecycle% == IN_PROGRESS ( goto judge_loop
) else if %lifecycle% == CANCEL_REQUESTED ( goto judge_loop
) else (
    rem sqlcmd失敗など想定外の場合、処理を終了する。
    rem 処理を終了
    echo 想定外の値が返却されたため終了
    exit 1
)

if not %errorlevel% == 0 (
	echo エラーのため処理を終了
    goto :EOF
) 

echo この文字は表示されないんぜ

:test1
exit /b 1

:judge_loop
    echo %lifecycle% の中
    rem 30分の場合は3600(秒)に設定。
    timeout /t 5 
    rem /nobreak >nul
    goto loop

:judge_end
    echo %lifecycle%の中
    rem 処理を終了
    goto :EOF