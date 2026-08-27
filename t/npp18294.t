use 5.014; # //, strict, say, s///r
use warnings;
use autodie;

use FindBin;
our $testDir;

BEGIN { $testDir = $FindBin::Bin; my $f = $testDir . '/nppPath.inc'; require $f if -f $f; }
use lib $testDir;
BEGIN {
    my $sessionFilename = "${FindBin::Bin}/files/npp18294.sess";
    my $testFilename = "${FindBin::Bin}/${FindBin::Script}";
    open my $fh, '>', $sessionFilename;
    print {$fh} <<"EOT";
<?xml version="1.0" encoding="UTF-8"?>
<NotepadPlus>
    <Session activeView="0">
        <mainView activeIndex="0">
            <File firstVisibleLine="0" xOffset="0" scrollWidth="0" startPos="0" endPos="0" selMode="0" offset="0" wrapCount="1" lang="Perl" encoding="-1" userReadOnly="no" filename="$testFilename" backupFilePath="" originalFileLastModifTimestamp="0" originalFileLastModifTimestampHigh="0" tabColourId="-1" RTL="no" tabPinned="no" mapFirstVisibleDisplayLine="-1" mapFirstVisibleDocLine="-1" mapLastVisibleDocLine="-1" mapNbLine="-1" mapHigherPos="-1" mapWidth="-1" mapHeight="-1" mapKByteInDoc="0" mapWrapIndentMode="-1" mapIsWrap="no" />
        </mainView>
        <subView activeIndex="0" />
    </Session>
</NotepadPlus>
EOT
    close($fh);

    system(1, qq(notepad++.exe -multiInst -nosession -openSession "$sessionFilename"));
    sleep(2);
}

use Win32::Mechanize::NotepadPlusPlus qw(:main :vars);

END { notepad->menuCommand($NPPIDM{IDM_FILE_EXIT}); }

use Test::More;
use Cwd qw/cwd/;

diag sprintf "Current Working Directory: %s\n", cwd();

ok 1, 'dummy test';

notepad->newFile();
editor->addText("Hello, World...");
editor->setSavePoint(); # pretend there are no unsaved changes
sleep(3);
notepad->close();
done_testing();
