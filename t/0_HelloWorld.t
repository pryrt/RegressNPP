use 5.014; # //, strict, say, s///r
use warnings;
use Win32::Mechanize::NotepadPlusPlus;

use Test::More;

use FindBin;
BEGIN { my $f = $FindBin::Bin . '/nppPath.inc'; require $f if -f $f; }

my @wheres = split /\R/, `where notepad++ 2> NUL`;
my $where_ret;
if ($? == -1) {
    diag "failed to execute: $!\n";
}
elsif ($? & 127) {
    diag sprintf "child died with signal %d, %s coredump\n",
        ($? & 127),  ($? & 128) ? 'with' : 'without';
}
else {
    diag sprintf "child exited with value %d\n", $where_ret = $? >> 8;
}
ok defined scalar @wheres, "number of notepad++ instances found";
ok defined $where_ret, "return value for `where notepad++` is defined";
is $where_ret, 0, "return value for `where notepad++` is 0 (no error)";

diag "\n"x2;
diag "\tPATH ELEMENT: '", $_, "'\n" for grep { /notepad\+\+/i or -f "$_/notepad++.exe" } (split /;/, $ENV{PATH});
diag "\tNPP PATH:     '", $_, "'\n" for @wheres;
diag "\n"x2;

done_testing();
