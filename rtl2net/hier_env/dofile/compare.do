tclmode
vpx set compare option -report_bbox_input

    //// compare bbox points first 
    //set bbox_point [get_map_points -bbox]
    //if {[llength $bbox_point] > 0} {
    //   vpx delete compare points -all
    //
    //   foreach each_bbox_point $bbox_point {
    //       set bbox_key_point [get_keypoint $each_bbox_point]
    //       vpx add compare points $bbox_key_point -golden
    //   }
    //   vpx report compare points -sum
    //   vpx compare
    //   //vpx report compare data -class nonequivalent > $bbox_compare_result
    //   vpx report compare data -class nonequivalent
    //   if { [llength [get_compare_points -NON]] == 0} {
    //       vpx add compare points -all
    //   } else {
    //       vpx save session -replace $work_dir/$current_module.compare_hier.bboxnone
    //       vpx add compare points -all
    //       vpx exit -f
    //   }
    //}

//    // compare cut points then 
//     set cut_point [get_map_points -cut]
//     if {[llength $cut_point] > 0} {
//        foreach each_cut_point $cut_point {
//        set cut_key_point [get_keypoint $each_cut_point]
//        vpx add compare points $cut_key_point -golden
//        }
//     }
//    
//     vpx report compare points -sum
//     vpx compare -report_bbox_input
//     vpx report compare data -class nonequivalent > $noequ_file\_cut  
//     vpx report compare data -class abort > $abort_file\_cut
//    
//     if { [llength [get_compare_points -NON]] == 0} {
//       
//       set run_sub_list  	[list \
//       			"/i_S3VD_CORE/i_vcp_top/INST_VLD/i_vld_hevc/i_hevc_desdec/" \
//    			"/i_S3VD_CORE/i_vcp_top/INST_PRD/i_hevc_top/i_wrapper/" \
//    			"/i_S3VD_CORE/i_vcp_top/INST_ENC/I_MEE_HEVC_CTRL/i_mee_hevc_merge_table/" \
//       			]
//       //set run_sub_list  [list ]		
//       puts "$run_sub_list"
//       foreach each_run_sub $run_sub_list {
//         puts $each_run_sub
//         vpx add compare points $each_run_sub* -golden
//         vpx compare
//       }
//       vpx save session -replace $work_dir/$module.mapdone
//       //vpx exit
//       vpx set cp l 2 -d -walltime -nok
//       vpx add compare points -all
//       //dofile /project/chx001/usr/daviscao_fv/snps/FV_fsotest/FV_compbymod.do
//       //vpx add compare points -all
//     }

vpx compare -threads 10 -noneq_print -abort_print -effort high -timestamp

//if { [llength [get_compare_points -NON]] == 0} {
//    vpx add compare points -all
//    vpx compare -threads 10 -noneq_print -abort_print -effort high -timestamp
//}
vpxmode

