use 5.014; # //, strict, say, s///r
use warnings;

BEGIN {
    system(1, 'notepad++.exe -multiInst -nosession');
    sleep(5);
}

use Test::More;

use FindBin;
BEGIN { my $f = $FindBin::Bin . '/nppPath.inc'; require $f if -f $f; }
use Win32::Mechanize::NotepadPlusPlus qw(:main :vars);

diag scalar localtime;
#diag "PS => ", qx{powershell -Command "Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 25 -Property Id, ProcessName, CPU"};
diag "task => ", qx{cmd /c tasklist /fi "imagename eq notepad++*"};
notepad->menuCommand($NPPIDM{IDM_FILE_EXIT});
sleep(5);
diag scalar localtime;
#diag "PS => ", qx{powershell -Command "Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 25 -Property Id, ProcessName, CPU"};
diag "task => ", qx{cmd /c tasklist /fi "imagename eq notepad++*"};

ok 1, 'dummy test';
done_testing();
