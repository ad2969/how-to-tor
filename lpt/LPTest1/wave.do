onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider input
add wave -noupdate /detect_tb/inn
add wave -noupdate /detect_tb/dut/ain
add wave -noupdate -divider out
add wave -noupdate /detect_tb/inn2
add wave -noupdate /detect_tb/dut/bin
add wave -noupdate -divider final
add wave -noupdate /detect_tb/dut/checkain
add wave -noupdate /detect_tb/dut/checkall
add wave -noupdate /detect_tb/dut/fdraft
add wave -noupdate /detect_tb/final
add wave -noupdate /detect_tb/dut/f
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 185
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {972 ps}
