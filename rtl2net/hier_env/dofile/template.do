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
vpx set Undefined Cell black_box -both
vpx set undriven signal 0 -golden
vpx set naming style DC
vpx set Naming Rule "/" -Hierarchical_separator -Both
vpx set naming rule "_" "_" -array -golden
vpx set naming rule _BAR -inverted_pin_extension -golden
//**************************************************************************
//* Sets up the log file and instructs the tool to display usage information
//**************************************************************************

vpx set log file lec.hier.log.$LEC_VERSION -replace 
usage -auto -elapse

//**************************************************************************
//* Specifies the LEC project that will collect and consolidate
//* information from multiple LEC runs
//**************************************************************************

vpx set project name $top_module
//**************************************************************************
//* Reads in the library and design files
//**************************************************************************

// * For Verilog library files
// *read library -verilog -replace -both \
// *     <libfile1>.v \
// *     <libfile2>.v
vpx read library -verilog -replace -both \
    -file $vlgmodule_file
// * For Liberty library files
//read library -liberty -replace -both \
//   <libfile1>.lib \
//   <libfile2>.lib

//read design -verilog -replace -golden -noelaborate \
//    <designfile1>.v \
//    <designfile2>.v
//// * Use the following to specify a command file

vpx read design -verilog -replace -golden -noelaborate \
    -file $rtl_list

vpx elaborate design  -golden
vpx set root module $run_module -golden
vpx read design -verilog -replace -revised -noelaborate \
    $netlist 

vpx elaborate design  -revised
vpx set root module $run_module -revised

vpx report design data
//vpx report black box -detailtemplate
//uniquify -all -nolibrary
vpx uniquify -all -use_renaming_rules

//vpx dofile $bbox_user_file
vpx report black box -detail    
//**************************************************************************
//* Specifies renaming rules
//**************************************************************************                                                                                               
//add renaming rule <rulename> <string><string> [-Golden |-Revised |-BOth]
//davis add for bbox match "/DIV_QUANT/DIVIDER0 <=> /DIV_QUANT_DIVIDER0"
vpx set mapping method -nobbox_name_match
//**************************************************************************
//* Specifies user constraints for test/dft/etc.
//**************************************************************************                                                                                               
//add pin constraint 0 scan_en  -golden/revised 
//add ignore output  scan_out -golden/revised

vpx add pin constraints 0 SCAN_EN -both // clark confirm
//0617vpx add pin constraints 0 SCAN_ENa -both -all
//0617vpx add pin constraints 0 test_si* -both -all
vpx add pin constraints 0 TEST_CG -both // clark confirm

vpx add pin constraint 0 LV_WRSTN -both	// mbist input
vpx add pin constraint 0 LV_TM    -both // mbist input

vpx add ig o *PWRON_*_BE -both 		// power output in revised for BCI_PWM_S3VD_PWRON_1_BE,BCI_PWM_S3VD_PWRON_0_BE

vpx add ig o SCAN_OUT* -both		// clark confirm
vpx add ig o LV_AuxEn  -both		// mbist output is floating
vpx add ig o LV_WSO    -both		// mbist output is floating
vpx add ig o LV_AuxOut -both		// mbist output is floating

vpx report pin constraints -all -both


// user define constraints 
if {[file exists $condef_file]} {
    vpx dofile $condef_file
}
//vpx dofile $con_mega_file
//vpx dofile $bbox_user_file
switch $top_module {
    "S3VDV" {
        vpx add black box -module *DW02_tree_wrap* -both
	vpx dofile $con_mega_file
    }
    "S3VDQ" {
        vpx add black box -module *DW02_multp* -both
        vpx add black box -module *DW_div_pipe* -both

        vpx add ig i Internal_scan* -module *DW_div_pipe* -revised 
        vpx add ig i ScanCo*        -module *DW_div_pipe* -revised
        vpx add ig i test*          -module *DW_div_pipe* -revised
        vpx add ig i SCAN_EN        -module *DW_div_pipe* -revised //davis add for S3VDQ
        vpx add ig i SCAN_ENa       -module *DW_div_pipe* -revised //davis add for S3VDQ
    }
}

vpx report black box -detail
//**************************************************************************
//* Specifies the modeling directives for constant optimization 
//* or clock gating
//**************************************************************************                                                                                               
vpx set flatten model  -seq_constant
vpx set flatten model  -gated_clock
vpx set flatten model  -all_seq_merge		//davis
vpx set flatten model  -latch_fold		//davis
vpx set flatten model  -nodff_to_dlat_feedback	//davis
vpx set flatten model  -ENABLE_ANALYZE_HIER_COMPARE //davis
//**************************************************************************
//* Enables auto analysis to help resolve issues from sequential 
//* redundancy, sequential constants, clock gating, or sequential merging
//* This option automatically enables 'analyze abort -compare' if there 
//* are any aborts to solve the aborts. 
//**************************************************************************

vpx set analyze option -auto -noanalyze_abort

//**************************************************************************
//* Specifies the number of threads to enable multithreading
//**************************************************************************
vpx set parallel option -threads 10 -norelease_license

//**************************************************************************
//* Generates the hierarchical dofile script for hierarchical comparison
//**************************************************************************
//[get_root_module] [get_root_module]
//set_current_module -golden $run_module
//set_current_module -revised $run_module

//set root module can report map result of root module 
//vpx set root module $run_module -both  -->new try


// add -ignore_mismatch_ports option to write more module to hier.do  -->new try

vpxmode 
write hier_compare dofile hier.do -replace -usage \
	-module S3VDQ S3VDQ \
	-constraint  -input_output_pin_equivalence \
	-noexact_pin_match -verbose \
	-balanced_extraction  \
	-function_pin_mapping \
	-keep_top_level_constraints \
	-prepend_string "dofile dofile/prepend.do" \
	-compare_string "dofile dofile/compare.do" \
	-APPEND_String "dofile dofile/append.do" 
		// -ignore_mismatch_ports  useless options
tclmode
//************************************************************************
// Executes the hier.do script
//**************************************************************************

vpx run hier_compare hier.do  -verbose 

//**************************************************************************
//* Generates the reports for all compared hierarchical modules
//**************************************************************************

vpx report hier result -all -usage
vpx report hier result -abort -usage
vpx report hier result -noneq -usage 

vpx save session -replace $work_dir/$run_module.compare_hier
vpx usage

