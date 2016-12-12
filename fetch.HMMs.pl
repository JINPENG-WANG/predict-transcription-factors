#!/usr/bin/perl -w
use strict;
use IO::File;

# HMM IDs of DNA binding domains are stored in the DBD.txt file.
my $DB_fh=IO::File->new("DBD.txt",'r');

# Pfam-A.hmm contains HMM models stored in the Pfam database.
my $Pfam_fh=IO::File->new("Pfam-A.hmm",'r');

# Output file.
my $out_fh=IO::File->new(">DBD.Pfam.hmm");

my %pfam;
while(<$DB_fh>){
    chomp;
    my $line=$_;
    if($line=~/PFAM$/){
        my @eles=split /\t/, $line;
        my $name=$eles[1];
        $pfam{$name}=1;
        print "$name\n";
    }
}


my $print_flag=0;
my $head1="HMMER3/f [3.1b2 | February 2015]";
while(<$Pfam_fh>){
    chomp;
    my $line=$_;
    unless($line=~/^HMMER3\/f/){
        if($line=~/^NAME\s+(.+)/){
            my $name=$1;
            if($pfam{$name}){
                $print_flag=1;
                $out_fh->print("$head1\n$line\n");
            }else{
                $print_flag=0;
            }
        }else{
            if($print_flag == 1){
                $out_fh->print("$line\n");
            }
        }
    }
}
