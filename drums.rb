#12 bar blues drums
# Standard 12 bar blues
# I7  | IV7  | I7 | I7
# IV7 | IV7 | I7 | I7
# V7  | IV7 | I7 | I7

# Choose a root note (one) and everything else will fall into place.
one = :G2
four = one + 5
five = one + 7

# Groove: quarter note triplets (trip-uh-let, trip-uh-let, ...)
trip_uh = 0.6666
let = 0.3333

chord_progression = [
one, four, one, one,
four, four, one, one,
five, four, one, one
]

in_thread(name: :bass) do
    chord_progression.each do |note|
        bass_line note
    end
end

in_thread(name: :comp) do
    chord_progression.each do |note|
        comp_line note
    end
end

define :bass_line do |root|
    cue :tick
    [root, root + 9, root + 10, root + 9].each do |note|
        play note, release: trip_uh
        sleep trip_uh
        play root + 7, amp: 0.5, release: let, amp: 2
        sleep let
    end
end

define :comp_line do |root|
    sync :tick
    root_8va = root + 12
    play chord(root_8va, :dom7), release: trip_uh, amp: 12
    sleep trip_uh
    play chord(root_8va, :dom7), release: let, amp: 8
    sleep let + 3
end


# Drum loop three, quarter notes
live_loop :drums do
    sync :tick
    beat_length = 0.5
    
    # add drum pedal to keep time
    in_thread(name: :drumPedal) do
        16.times do
            sample :drum_cymbal_pedal, amp: 2
            sleep beat_length
        end
    end
    
    #add a drum splash on the one of the measure
    in_thread(name: :drumSplash) do
        4.times do
            sample :drum_splash_soft, amp: 2
            sleep 4
        end
    end
    
    #add a hi_hat
    in_thread(name: :drumHiHat) do
        4.times do
            sample :drum_cymbal_closed, amp: 1
            sleep beat_length
        end
    end
    
    #add a drum beat
    in_thread(name: :bassDrum) do
        #3 measures of traditional blues beat
        3.times do
            sample :drum_bass_hard, amp: 2
            sleep 2
        end
        
        # 1 meausre of bass off beat
        2.times do
            sample :drum_bass_hard, amp: 2
            sleep beat_length
        end
        sleep 0.5
    end
    
    #snare drum on the 2 and 4
    in_thread(name: :snareDrum) do
        2.times do
            sleep 1
            sample :drum_snare_soft, amp: 3
            sleep 1
        end
    end
    sleep 1
end