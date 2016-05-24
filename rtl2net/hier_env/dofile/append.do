
tclmode
set current_module [ get_root_module ]
if {[ get_compare_points -abort -nonequivalent -count ] > 0} {
    //vpx report compare data -class nonequivalent > $work_dir/$current_module.noneq
    //vpx report compare data -class abort         > $work_dir/$current_module.abort
    vpx report compare data -class nonequivalent
    vpx report compare data -class abort
}
vpxmode

