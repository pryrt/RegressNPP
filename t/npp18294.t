# https://github.com/notepad-plus-plus/notepad-plus-plus/issues/18294
# ⇒ https://github.com/notepad-plus-plus/notepad-plus-plus/pull/18295
use 5.014; # //, strict, say, s///r
use warnings;
use autodie;

use Test::More;
use Cwd qw/cwd/;

use FindBin;
our $testDir;
our $settingsDir;
our $expectText;

BEGIN { select STDERR; $|=1; select STDOUT; $|=1; }
BEGIN { $testDir = $FindBin::Bin; my $f = $testDir . '/nppPath.inc'; require $f if -f $f; }
use lib $testDir;
BEGIN {
    $expectText = "This is dummy text";
    $settingsDir = "${FindBin::Bin}/files/npp18294.settingsDir";
    $settingsDir =~ s{/}{\\}g;
    if(!-d $settingsDir) { mkdir $settingsDir; }
    my $sessionFilename = "$settingsDir/session.xml";
    $sessionFilename =~ s{/}{\\}g;
    my $backupFilename = "$settingsDir/backup/new 1\@2026-08-27_144300";
    $backupFilename =~ s{/}{\\}g;

    note "settingsDir: $settingsDir";
    note "sessionFilename: $sessionFilename";
    note "backupFilename: $backupFilename";

    if (!-f $backupFilename) {
        open my $fh, '>', $backupFilename;
        print $fh $expectText;
        close $fh;
    }
    if(!-f $backupFilename) { die "FAILED to verify $backupFilename!"; }

    open my $fh, '>', $sessionFilename;
    print {$fh} <<"EOT";
<?xml version="1.0" encoding="UTF-8"?>
<NotepadPlus>
    <Session activeView="1">
        <mainView activeIndex="0" />
        <subView activeIndex="0">
            <File firstVisibleLine="0" xOffset="0" scrollWidth="23" startPos="3" endPos="3" selMode="0" offset="0" wrapCount="1" lang="None (Normal Text)" encoding="-1" userReadOnly="no" filename="new 1" backupFilePath="$backupFilename" originalFileLastModifTimestamp="0" originalFileLastModifTimestampHigh="0" tabColourId="-1" RTL="no" tabPinned="no" mapFirstVisibleDisplayLine="-1" mapFirstVisibleDocLine="-1" mapLastVisibleDocLine="-1" mapNbLine="-1" mapHigherPos="-1" mapWidth="-1" mapHeight="-1" mapKByteInDoc="512" mapWrapIndentMode="-1" mapIsWrap="no" />
        </subView>
    </Session>
</NotepadPlus>
EOT
    close($fh);

=begin

=cut

    if(!-f $sessionFilename) { die "FAILED to create + populate $sessionFilename!"; }

    system(1, qq(notepad++.exe -multiInst -settingsDir="$settingsDir"));
    sleep(2);
}

use Win32::Mechanize::NotepadPlusPlus qw(:main :vars);

# verify backup-file's text

is my $got = editor->getText(), $expectText, 'Verify content of "new 1" loaded';
note "\t- text   => ", $got;
note "\t- expect => ", $expectText;

# exit Notepad++ (and give some time for it to exit)
notepad->menuCommand($NPPIDM{IDM_FILE_EXIT});
sleep(2);

# remove the temporary config
unlink (
    "$settingsDir/config.xml",
    "$settingsDir/contextMenu.xml",
    "$settingsDir/langs.xml",
    "$settingsDir/session.xml.inCaseOfCorruption.bak",
    "$settingsDir/shortcuts.xml",
    "$settingsDir/stylers.xml"
);
rmdir "$settingsDir/themes";

# done
done_testing();

__END__

<?xml version="1.0" encoding="UTF-8"?>
<NotepadPlus>
    <Session activeView="0">
        <mainView activeIndex="0">
            <File firstVisibleLine="0" xOffset="0" scrollWidth="23" startPos="3" endPos="3" selMode="0" offset="0" wrapCount="1" lang="None (Normal Text)" encoding="-1" userReadOnly="no" filename="new 1" backupFilePath="C:\usr\local\share\github\RegressNpp\t\files\npp18294.settingsDir\backup\new 1@2026-08-27_144300" originalFileLastModifTimestamp="0" originalFileLastModifTimestampHigh="0" tabColourId="-1" RTL="no" tabPinned="no" mapFirstVisibleDisplayLine="-1" mapFirstVisibleDocLine="-1" mapLastVisibleDocLine="-1" mapNbLine="-1" mapHigherPos="-1" mapWidth="-1" mapHeight="-1" mapKByteInDoc="512" mapWrapIndentMode="-1" mapIsWrap="no" />
        </mainView>
        <subView activeIndex="0" />
    </Session>
</NotepadPlus>
