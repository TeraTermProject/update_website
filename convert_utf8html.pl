#
# htmlファイルを変換する
#	- エンコーディングを UTF-8 にする
#	- charset を utf-8 に変更する

use strict;
use warnings;
use utf8;
use Encode::Guess;
use Encode 'decode';

binmode STDOUT, ':utf8';

sub ReadContentUTF8 {
	my $file = shift;
	my $fh;
	open($fh, '<:raw', $file) or die("error :$! $file");
	my $content;
	while (my $line = <$fh>) {
		$content .= $line;
	}
	close($fh);
	my $enc;
	my $utf8_content;
	if ($content =~ /charset=utf-8/) {
		# utf-8
		$utf8_content = $content;
		$enc = 'utf-8';
	}
	elsif ($content =~ /charset=iso-8859-1/) {
		# 8859-1
		$utf8_content = decode('iso-8859-1', $content);
		$enc = 'iso-8859-1';
	}
	elsif ($content =~ /charset=Shift_JIS/) {
		$utf8_content = decode('Shift_JIS', $content);
		$enc = 'Shift_jis';
	}
	else {
		# Shift_jis(cp932)? (or utf-8)
		my $decoder = guess_encoding($content,  qw/cp932 utf8/);
		$enc = $decoder->name;
		$utf8_content = $decoder->decode($content);
	}
	$utf8_content =~ s/^\x{FEFF}//;	# remove BOM
	return ($enc, $utf8_content);
}

my $file = shift;
my ($enc, $content) = ReadContentUTF8($file);
print "$file $enc\n";
if ($enc eq "utf-8") {
	# 変換不要
	exit(1);
}

my @lines = split /\n/, $content;

my $fh;
open($fh, ">:encoding(utf8)", $file);
print $fh "\x{feff}" ;  # add BOM
foreach my $line (@lines) {
	$line =~ s/[\r\n]+$//;
	if ($line =~ /charset=/) {
		$line =~ s/charset=[\w\-]+/charset=utf-8/g;
	}
	print $fh $line . "\n";
}
close($fh);
