class_name WaveService

#placeholder enemies
var enemy_a = "res://scenes/enemies/placeholders/EnemyA.tscn"
var enemy_b = "res://scenes/enemies/placeholders/EnemyB.tscn"
var enemy_c = "res://scenes/enemies/placeholders/EnemyC.tscn"
var enemy_d = "res://scenes/enemies/placeholders/EnemyD.tscn"
var enemy_e = "res://scenes/enemies/placeholders/EnemyE.tscn"
var enemy_f = "res://scenes/enemies/placeholders/EnemyF.tscn"
var enemy_g = "res://scenes/enemies/placeholders/EnemyG.tscn"
var enemy_h = "res://scenes/enemies/placeholders/EnemyH.tscn"
var enemy_i = "res://scenes/enemies/placeholders/EnemyI.tscn"
var enemy_j = "res://scenes/enemies/placeholders/EnemyJ.tscn"
var enemy_k = "res://scenes/enemies/placeholders/EnemyK.tscn"
var enemy_l = "res://scenes/enemies/placeholders/EnemyL.tscn"
var enemy_m = "res://scenes/enemies/placeholders/EnemyM.tscn"
var enemy_n = "res://scenes/enemies/placeholders/EnemyN.tscn"
var enemy_o = "res://scenes/enemies/placeholders/EnemyO.tscn"
var enemy_p = "res://scenes/enemies/placeholders/EnemyP.tscn"
var enemy_q = "res://scenes/enemies/placeholders/EnemyQ.tscn"
var enemy_r = "res://scenes/enemies/placeholders/EnemyR.tscn"
var enemy_s = "res://scenes/enemies/placeholders/EnemyS.tscn"
var enemy_t = "res://scenes/enemies/placeholders/EnemyT.tscn"
var enemy_u = "res://scenes/enemies/placeholders/EnemyU.tscn"
var enemy_v = "res://scenes/enemies/placeholders/EnemyV.tscn"
var enemy_w = "res://scenes/enemies/placeholders/EnemyW.tscn"
var enemy_x = "res://scenes/enemies/placeholders/EnemyX.tscn"
var enemy_y = "res://scenes/enemies/placeholders/EnemyY.tscn"
var enemy_z = "res://scenes/enemies/placeholders/EnemyZ.tscn"

var swarmer_a = "res://scenes/enemies/placeholders/SwarmerA.tscn"

#placeholder bosses
var boss_a = "res://scenes/enemies/placeholders/BossA.tscn"
var boss_b = "res://scenes/enemies/placeholders/BossB.tscn"

#regular enemies
var fly = "res://scenes/enemies/Fly.tscn"
var birb = "res://scenes/enemies/Birb.tscn"
var blob = "res://scenes/enemies/Blob.tscn"
var dummy = "res://scenes/enemies/Dummy.tscn"
var yume = "res://scenes/enemies/Yume.tscn"
var melting_heart = "res://scenes/enemies/MeltingHeart.tscn"

#bosses
var mr_sunday = "res://scenes/enemies/MrSunday.tscn"
var it = "res://scenes/enemies/It.tscn"

var waves : Array = []


func get_current_wave(time : float):
	for wave in waves:
		if time >= wave.start_time and time < wave.end_time:
			return wave
			
			
func randomise_wave(wave : int):
#	rng.randomize()
	pass
	

func intialise_waves():
	waves = [
	wave_01,
	wave_02,
	wave_03,
	wave_04,
	wave_05,
	wave_06,
	wave_07,
	wave_08,
	wave_09,
	wave_10,
	wave_11,
	wave_12,
	wave_13,
	wave_14,
	wave_15,
	wave_16,
	wave_17,
	wave_18,
	wave_19,
	wave_20
]


var wave_01 = Wave.new(
	1, #wave
	0.0, #start_time
	60.0, #end_time
	6, #trickle_max
	{
		enemy_a : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ enemy_b : 1.0 }
	] #bosses
)

#var wave_01 = Wave.new(
#	1, #wave
#	0.0, #start_time
#	60.0, #end_time
#	40, #trickle_max
#	{
#		enemy_a : 50,
#		enemy_b : 50
#	}, #enemy_weightings
#	[], #enemy_patterns
#	[] #bosses
#)

var wave_02 = Wave.new(
	2, #wave
	60.0, #start_time
	120.0, #end_time
	25, #trickle_max
	{
		enemy_b : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ enemy_c : 1.0 }
	] #bosses
)

var wave_03 = Wave.new(
	3, #wave
	120.0, #start_time
	180.0, #end_time
	30, #trickle_max
	{
		enemy_c : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ boss_a : 1.0 }
	] #bosses
)

var wave_04 = Wave.new(
	4, #wave
	180.0, #start_time
	240.0, #end_time
	50, #trickle_max
	{
		enemy_b : 100
	}, #enemy_weightings
	[
		{ "Swarm" : [3.0, swarmer_a] },
		{ "Swarm" : [13.0, swarmer_a] },
		{ "Swarm" : [23.0, swarmer_a] },
		{ "Swarm" : [33.0, swarmer_a] }
	], #enemy_patterns
	[
		{ boss_a : 1.0 }
	] #bosses
)

var wave_05 = Wave.new(
	5, #wave
	240.0, #start_time
	300.0, #end_time
	40, #trickle_max
	{
		enemy_e : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ boss_a : 1.0 }
	] #bosses
)

var wave_06 = Wave.new(
	6, #wave
	300.0, #start_time
	360.0, #end_time
	10, #trickle_max
	{
		enemy_d : 100
	}, #enemy_weightings
	[	
		{ "Box" : [1.0, enemy_d] },
		{ "Box" : [31.0, enemy_d] }
	], #enemy_patterns
	[
		{ boss_b : 10.0 }
	] #bosses
)

var wave_07 = Wave.new(
	7, #wave
	360.0, #start_time
	420.0, #end_time
	50, #trickle_max
	{
		enemy_f : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ boss_b : 10.0 }
	] #bosses
)

var wave_08 = Wave.new(
	8, #wave
	420.0, #start_time
	480.0, #end_time
	50, #trickle_max
	{
		enemy_g : 100
	}, #enemy_weightings
	[
		{ "WideSweep" : [3.0, swarmer_a] },
		{ "WideSweep" : [13.0, swarmer_a] },
		{ "WideSweep" : [23.0, swarmer_a] },
		{ "WideSweep" : [33.0, swarmer_a] }	
	], #enemy_patterns
	[
		{ boss_b : 10.0 }
	] #bosses
)

var wave_09 = Wave.new(
	9, #wave
	480.0, #start_time
	540.0, #end_time
	50, #trickle_max
	{
		enemy_h : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ boss_b : 10.0 }
	] #bosses
)

var wave_10 = Wave.new(
	10, #wave
	540.0, #start_time
	600.0, #end_time
	50, #trickle_max
	{
		enemy_i : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ boss_b : 10.0 }
	] #bosses
)

var wave_11 = Wave.new(
	11, #wave
	600.0, #start_time
	660.0, #end_time
	50, #trickle_max
	{
		enemy_j : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ boss_b : 10.0 }
	] #bosses
)

var wave_12 = Wave.new(
	12, #wave
	660.0, #start_time
	720.0, #end_time
	50, #trickle_max
	{
		enemy_k : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ boss_b : 10.0 }
	] #bosses
)

var wave_13 = Wave.new(
	13, #wave
	720.0, #start_time
	780.0, #end_time
	50, #trickle_max
	{
		enemy_l : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ boss_b : 10.0 }
	] #bosses
)

var wave_14 = Wave.new(
	14, #wave
	780.0, #start_time
	840.0, #end_time
	50, #trickle_max
	{
		enemy_m : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ boss_b : 10.0 }
	] #bosses
)

var wave_15 = Wave.new(
	15, #wave
	840.0, #start_time
	900.0, #end_time
	50, #trickle_max
	{
		enemy_n : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ boss_b : 10.0 }
	] #bosses
)

var wave_16 = Wave.new(
	16, #wave
	900.0, #start_time
	960.0, #end_time
	50, #trickle_max
	{
		enemy_o : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ boss_b : 10.0 }
	] #bosses
)

var wave_17 = Wave.new(
	17, #wave
	960.0, #start_time
	1020.0, #end_time
	50, #trickle_max
	{
		enemy_p : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ boss_b : 10.0 }
	] #bosses
)

var wave_18 = Wave.new(
	18, #wave
	1020.0, #start_time
	1080.0, #end_time
	50, #trickle_max
	{
		enemy_q : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ boss_b : 10.0 }
	] #bosses
)

var wave_19 = Wave.new(
	19, #wave
	1080.0, #start_time
	1140.0, #end_time
	50, #trickle_max
	{
		enemy_r : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ boss_b : 10.0 }
	] #bosses
)

var wave_20 = Wave.new(
	20, #wave
	1140.0, #start_time
	1900.0, #end_time
	50, #trickle_max
	{
		enemy_s : 100
	}, #enemy_weightings
	[], #enemy_patterns
	[
		{ boss_b : 10.0 }
	] #bosses
)
