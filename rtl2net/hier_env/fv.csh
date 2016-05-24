#!/bin/csh -f
##########################################################################
#  File Name    : fv.csh
#  Description  : 
#               : 
#  Author Name  : Davis Cao
#  Email        : daviscao@**.com
#  Create Date  : 2016-05-19 11:04
##########################################################################
set LEC_VERSION		= "14.20-s260"
set top_module		= "root"
set run_module		= "root_enc_top_0"
set LEC_dir		= "$cwd"

set work_dir		= "$LEC_dir/$top_module.cfm"
set rtllist_dir		= "$LEC_dir/rtl_list"
set bbox_dir		= "$LEC_dir/bbox"
set setup_dir		= "$LEC_dir/setup"
set condef_dir		= "$LEC_dir/con_def"
set net_dir		= "$LEC_dir/net"
set dofile_dir		= "$LEC_dir/dofile"

set bbox_user_file	= "$bbox_dir/$top_module.bbox"
set condef_file		= "$condef_dir/$top_module.con"
set con_mega_file	= "$condef_dir/$top_module.con.mega"
set netlist		= "$net_dir/$top_module.vlg"
set dofile		= "$dofile_dir/$top_module.do"
set vlgmodule_file	= "$rtllist_dir/vlgmodule.f"
set rtl_list		= "$rtllist_dir/$top_module.list"
set reset_pin_list	= "*TEST_CG* *DFT_ON* *BIST_ON *SCAN_EN* SE *LV_TM* *ELOCEN *CPRSEN*"

####
echo "tclmode"							>$dofile
echo "vpx reset"						>>$dofile
echo "vpx set dofile abort exit"				>>$dofile

echo "set LEC_VERSION			$LEC_VERSION"		>>$dofile
echo "set top_module 			$top_module"		>>$dofile
echo "set run_module			$run_module"		>>$dofile
echo "set LEC_dir 			$LEC_dir"		>>$dofile
#echo "set reset_pin_list 		$reset_pin_list"	>>$dofile
echo "set work_dir 			$work_dir"		>>$dofile
echo "set rtllist_dir 			$rtllist_dir"		>>$dofile
echo "set bbox_dir 			$bbox_dir"		>>$dofile
echo "set setup_dir 			$setup_dir"		>>$dofile
echo "set condef_dir 			$condef_dir"		>>$dofile
echo "set net_dir 			$net_dir"		>>$dofile
echo "set dofile_dir 			$dofile_dir"		>>$dofile
echo "set bbox_user_file 		$bbox_user_file"	>>$dofile
echo "set condef_file 			$condef_file"		>>$dofile
echo "set con_mega_file 		$con_mega_file"		>>$dofile
echo "set netlist 			$netlist"		>>$dofile
echo "set vlgmodule_file		$vlgmodule_file"	>>$dofile
echo "set rtl_list			$rtl_list"		>>$dofile


echo "dofile $dofile_dir/template" 				>>$dofile
echo "exit"							>> $dofile


source $setup_dir/setup.lec
lec -nogui -xl -64 -dofile $dofile

cp lec.hier.log.$LEC_VERSION $work_dir/$run_module.lec.hier.log.$LEC_VERSION
