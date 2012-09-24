#!/usr/bin/perl
# 1st parameter: unique string of old wiki's url
#   Will convert links to that wiki into local wiki links
# Additional parameters: names of complete phrases that should be turned into local links when not already.

my $filename = 'raw.txt';

my $oldwikiname = $ARGV[0];

open(my $INFILE, $filename) or die $!;
open(my $OUTFILE, '>', 'out.txt');
for $line (<$INFILE>)
{
	$line =~ s/\<\/*span.*?\>//g;                   # remove <span> tags
    $line =~ s/\<\/*p.*?\>//g;                      # remove <p> tags
	$line =~ s/\[\[.*?edit\]\]//g;                  # remove EDIT links
                                                    # convert internal links
	$line =~ s/(\[htt\S*$oldwikiname\S* )([^\]]+\])/\[\[$2\]/g;
	$line =~ s/(\[htt\S* \])//g;                    # remove external links with no title
	#$line =~ s/[^\n\*]\*([^\*])/\n\*$1/g;           # list items on new lines
    
    $line =~ s/^\'\'([^\'])/<i>$1/g;                # blockquote formatting
    $line =~ s/([^\'])\'\'$/$1<\/i>/g;
    $line =~ s/<\/i>$/<\/i><br \/>/;
    $line =~ s/^<i>/<blockquote><i>/;
    $line =~ s/^(--.*[^\>])\n/$1<\/blockquote>\n/;
    
    for (my $links = 1;$links <= $#ARGV;$links++)  # Misc link adding
    {
        my $linkname = $ARGV[$links];
        print $linkname."\n";
        $line =~ s/(\s)$linkname(\s)/$1\[\[$linkname\]\]$2/g;
    }
    
	print $OUTFILE $line;
}
close($INFILE);
close($OUTFILE);