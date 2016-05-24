//**************************************************************************
//*
//* Copyright (C) 2012-2015 Cadence Design Systems, Inc.
//* All rights reserved.
//*
//**************************************************************************                                                                                               
//**************************************************************************
//* The following illustrates a sample dofile for running
//* RTL vs gate netlist with hierarchical comparison flow.
//**************************************************************************

//**************************************************************************
//* Note: For more information on the commands/options used in
//* this sample dofile, launch the specific product and use the "MAN"
//* command or refer to that product's reference manual.
//**************************************************************************

//**************************************************************************
//* Optional lines of code are commented out.  Uncomment if needed.
//**************************************************************************

//**************************************************************************
//* Sets up the log file and instructs the tool to display usage information
//**************************************************************************

set log file lec.hier.log.$LEC_VERSION -replace 
usage -auto -elapse

//**************************************************************************
//* Specifies the LEC project that will collect and consolidate
//* information from multiple LEC runs
//**************************************************************************

set project name <project name>

//**************************************************************************
//* Reads in the library and design files
//**************************************************************************

// * For Verilog library files
read library -verilog -replace -both \
     <libfile1>.v \
     <libfile2>.v

// * For Liberty library files
//read library -liberty -replace -both \
//   <libfile1>.lib \
//   <libfile2>.lib

read design -verilog -replace -golden -noelaborate \
    <designfile1>.v \
    <designfile2>.v
// * Use the following to specify a command file

//read design -verilog -replace -golden -noelaborate \
    -file <commandfile>

elaborate design  -golden

read design -verilog -replace -revised -noelaborate \
    <designnetlist>.v 

elaborate design  -revised
report design data
report black box -detail
uniquify -all -nolibrary

//**************************************************************************
//* Specifies renaming rules
//**************************************************************************                                                                                               
//add renaming rule <rulename> <string><string> [-Golden |-Revised |-BOth]

//**************************************************************************
//* Specifies user constraints for test/dft/etc.
//**************************************************************************                                                                                               
//add pin constraint 0 scan_en  -golden/revised 
//add ignore output  scan_out -golden/revised

//**************************************************************************
//* Specifies the modeling directives for constant optimization 
//* or clock gating
//**************************************************************************                                                                                               
set flatten model  -seq_constant
set flatten model  -gated_clock

//**************************************************************************
//* Enables auto analysis to help resolve issues from sequential 
//* redundancy, sequential constants, clock gating, or sequential merging
//* This option automatically enables 'analyze abort -compare' if there 
//* are any aborts to solve the aborts. 
//**************************************************************************

set analyze option -auto 

//**************************************************************************
//* Specifies the number of threads to enable multithreading
//**************************************************************************
set parallel option -threads 4 -norelease_license

//**************************************************************************
//* Generates the hierarchical dofile script for hierarchical comparison
//**************************************************************************
write hier_compare dofile hier.do -replace -usage \
-constraint -noexact_pin_match -verbose \
-prepend_string "report design data; usage; \
analyze datapath -module -resourcefile <file> -verbose; usage; \
analyze datapath -verbose; usage " \
-balanced_extraction -input_output_pin_equivalence \
-function_pin_mapping

//************************************************************************
// Executes the hier.do script
//**************************************************************************

run hier_compare hier.do  -verbose 

//**************************************************************************
//* Generates the reports for all compared hierarchical modules
//**************************************************************************

report hier result -all -usage
report hier result -abort -usage
report hier result -noneq -usage 

