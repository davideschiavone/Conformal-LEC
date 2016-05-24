tclmode
vpx analyze datapath -verbose -threads 10
vpx usage
set current_module [ get_root_module ]
puts $current_module
if { [ get_unmap_points -count ] > 0 } {
    //vpx report unmapped points > $work_dir/$current_module.unmapped
    //vpx report mapped points   > $work_dir/$current_module.mapped
    //vpx report floating signals -all -undriven > $work_dir/$current_module.undrive
    vpx report unmapped points
    vpx report mapped points
    //vpx report floating signals -all -undriven
}
vpxmode