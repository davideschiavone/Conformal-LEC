
tclmode
set current_module [ get_root_module ]
if {[ get_compare_points -abort -nonequivalent -count ] > 0} {
    //file mkdir "$work_dir/reports/un.map"
    vpx report compare data -class nonequivalent > $work_dir/reports/$current_module.noneq
    vpx report compare data -class abort         > $work_dir/reports/$current_module.abort

    vpx report unmapped points > $work_dir/reports/$current_module.unmapped
    vpx report mapped points   > $work_dir/reports/$current_module.mapped
    vpx report floating signals -all -undriven > $work_dir/reports/$current_module.undrive
    //vpx report compare data -class nonequivalent
    //vpx report compare data -class abort

    if {$current_module eq $top_module} {
    vpx save session -replace $work_dir/$current_module.compare_hier.bboxnone
    vpx exit -f 
    }
}

vpxmode

