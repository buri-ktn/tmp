@echo off

@REM setlocal enabledelayedexpansion

rem �o�b�N�A�b�v���s�̃R�}���h(��) �{����sqlcmd
call C:\Users\User\Desktop\�w�K\�o�b�`�쐬\get_backup.bat


:loop

REM ���s����sqlcmd(SELECT��)��g�ݗ��ā@��1���R�[�h��1�̃J����(name)���擾
set sqlcmd=sqlcmd -S DESKTOP-A3NQEUQ\SQLEXPRESS -d test -E -W -Q "SET NOCOUNT ON; select top(1)lifecycle from test order by task_id desc"

@REM echo %sqlcmd%

REM SELECT��(sqlcmd)�����s�����ʂ�ϐ��ulifecycle�v�֊i�[
for /f %%i in ('%sqlcmd%') do set lifecycle=%%i

REM �ϐ��uname�v�̒l���m�F
echo �X�e�[�^�X : %lifecycle%

rem �X�e�[�^�X�F SUCCESS�@�̏ꍇ���̃o�b�`���Ăяo��
if %lifecycle% == SUCCESS (
    echo kakunin
    call C:\Users\User\Desktop\�w�K\�o�b�`�쐬\hoge.bat
    rem �������I��
    goto :EOF
    
) else if %lifecycle% == ERROR ( goto judge_end
) else if %lifecycle% == CANCELLED ( goto judge_end
) else if %lifecycle% == CREATED ( goto judge_loop
) else if %lifecycle% == IN_PROGRESS ( goto judge_loop
) else if %lifecycle% == CANCEL_REQUESTED ( goto judge_loop
) else (
    rem sqlcmd���s�ȂǑz��O�̏ꍇ�A�������I������B
    rem �������I��
    echo �z��O�̒l���ԋp���ꂽ���ߏI��
    exit 1
)

if not %errorlevel% == 0 (
	echo �G���[�̂��ߏ������I��
    goto :EOF
) 

echo ���̕����͕\������Ȃ���

:test1
exit /b 1

:judge_loop
    echo %lifecycle% �̒�
    rem 30���̏ꍇ��3600(�b)�ɐݒ�B
    timeout /t 5 
    rem /nobreak >nul
    goto loop

:judge_end
    echo %lifecycle%�̒�
    rem �������I��
    goto :EOF