#!/usr/bin/perl -w
##########################################################################
#  File Name    : FV_get_notmap_dff.pl
#  Description  : 
#               : 
#  Author Name  : Davis Cao
#  Email        : daviscao@zhaoxin.com
#  Create Date  : 2016-07-06 17:40
##########################################################################
use strict;
use Getopt::Long;
use File::Basename;
#### parse options
my $arg_top;
my @arg_l;
my $arg_all;
my $arg_h;
    
my $sts = GetOptions (
    		'top=s'	=> \$arg_top,
		'l:s'	=> \@arg_l,
		'all'	=> \$arg_all,
		'h'	=> \$arg_h
	    );

if ( (!$sts) || (defined($arg_h) || (!defined($arg_top)) ||
     (!defined($arg_all) && !scalar @arg_l )) ) { 
    print <<EOF; 

Usage : get not-mapped dff in the modules. constraint the not-mapped dff to constant 0

	FV_get_notmap_dff.pl [-l module] ... # module name list
			      -all           # all modules
			      -h             # Print Out Help Brief

EOF

    exit (-1);
}
####
my $workspace   = "$ENV{'PWD'}/../$arg_top.cfm";
my $map_rpt_dir = "$workspace/reports";

my $area_file = "$workspace/../dc_log/$arg_top/$arg_top.subcell_area";
my %module2instance_hash = &get_module2instance_hash($area_file);

my @unmap_module_filelist = defined($arg_all)? 
				glob "$map_rpt_dir/*.notmapped_golden":
				map {"$map_rpt_dir/$_.notmapped_golden"} @arg_l;

open(my $CON_fh,">$arg_top.con");
foreach my $each_module_file (@unmap_module_filelist){
    if (-f $each_module_file) {
	&get_notmap_dff($each_module_file,$CON_fh,\%module2instance_hash);
    }else{
	print"nono\n";
    }
}
close($CON_fh);
##############################################################
#  subroutine
##############################################################
sub get_module2instance_hash{
    my $area_file = shift;
    open(AREA,"<$area_file");
    my $flag = 0;
    my $module2instance_hash;
    while(<AREA>){
	chomp;
	if (/-------------------------------------------------------/){
	    $flag = !$flag;
	    next;
	};

	if($flag){
	    my ($instance,$module) = (split / +/)[0,1];
	    $module2instance_hash{$module}=$instance;
	}
    }
    close(AREA);
    $module2instance_hash{$arg_top} = "";
    return %module2instance_hash;
}


sub get_notmap_dff{

    my $notmap_file = shift;
    my $CON_fh      = shift;
    
    my $module2instance_hash_ptr = shift;
    my $module = basename($notmap_file);
    $module =~ s/\.notmapped_golden//;

    open(NOT,"<$notmap_file");
    while(<NOT>){
	chomp;
	if (/\(G\)/) {
	    my $dff_reg = (split(/ +\//,$_))[-1];  #  (G)   14082  DFF  /xxx/../SUM13_P3_reg_0_
	    print $CON_fh "vpx add instance constraints 0 /$module2instance_hash_ptr->{$module}/$dff_reg -golden\n";
	}
    }
    close(NOT);

#    my $unmap_file = shift;
#    my $CON_fh = shift;
#    my $module2instance_hash_ptr = shift;
#    my $module = basename($unmap_file);
#    $module =~ s/\.unmapped//;
#    my $path = dirname($unmap_file);
#
#    if (-f "$path/$module.noneq"){
#	print $CON_fh "\n\/\/$module:<noneq>\n";
#    }elsif(-f "$path/$module.abort"){
#	print $CON_fh "\n\/\/$module:<abort>\n";
#    }else{
#	print $CON_fh "\n\/\/$module\n";
#    }
#
#    open(UNMAP,"<$unmap_file");
#    while(<UNMAP>){
#	chomp;
#	if (/Unmapped point \(not-mapped\):/) {
#	    my $unmap_line = <UNMAP>;
#	    chomp($unmap_line);
#
#	    if($arg_top ne $module){
#		my $dff_reg = (split(/ +\//,$unmap_line))[-1];  #  (G)   14082  DFF  /xxx/SUM13_P3_reg_0_
#	        if ($unmap_line=~ /\(G\)/){
#		    print $CON_fh "vpx add instance constraints 0 /$module2instance_hash_ptr->{$module}/$dff_reg -golden\n";
#	        }elsif($unmap_line=~ /\(R\)/){
#		    print $CON_fh "vpx add instance constraints 0 /$module2instance_hash_ptr->{$module}/$dff_reg -revised\n";
#	        }else{
#		    print "can not find dff register in :$unmap_line\n";
#		    exit(-2);
#	        }
#	    }else{
#		my $dff_reg = (split(/ +/,$unmap_line))[-1];  #  (G)   14082  DFF  /SUM13_P3_reg_0_
#	        if ($unmap_line=~ /\(G\)/){
#		    print $CON_fh "vpx add instance constraints 0 $dff_reg -golden\n";
#	        }elsif($unmap_line=~ /\(R\)/){
#		    print $CON_fh "vpx add instance constraints 0 $dff_reg -revised\n";
#	        }else{
#		    print "can not find dff register in :$unmap_line\n";
#		    exit(-2);
#		}
#	    }
#	}
#    }
#    close(UNMAP);
}
