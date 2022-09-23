(define (domain assignment)
    (:requirements :strips :adl :typing)
    (:types
        loader mover - robot
        crate
        cheap expensive - loader
    )

    (:predicates

        (free ?r - robot)

        (mover_at_bay ?m - mover)
        (crate_at_bay ?c - crate)
        (free_bay)

        (crate_fragile ?c - crate)

        (mover_at_crate ?m - mover ?c - crate)
        (going_to_crate ?m - mover ?c - crate)
        
        (going_to_bay ?m - mover)
        (going_to_bay_fast ?m - mover)
        
        (crate_on_mover ?m - mover ?c - crate)
        (crate_on_loader ?l - loader ?c - crate)
        
        (mover_together ?m - mover)
        
        (wait_for_free_bay ?m - mover)
        
        (loading_crate ?l - loader)
        
        (crate_on_conveyor ?c - crate)
        (crate_at_warehouse ?c - crate)

        (last_crate_loaded ?c - crate)
        (subsequent_crates ?c1 - crate ?c2 - crate)
        (wait_first_crate)
        (crate_need_sequence ?c - crate)
        
        (going_to_recharge ?m - mover)
        (recharging ?m)
    )

    (:functions
        (weight ?c - crate)
        (distance ?o)
        (charge ?m - mover)
        (loading_time ?l - loader)

        (max_charge)
        (max_light_weight)
    )

    (:action go_to_crate
        :parameters (?m - mover ?c -crate)
        :precondition (and 
            (crate_at_warehouse ?c)
            (mover_at_bay ?m)
            (free ?m))
        :effect (and
            (going_to_crate ?m ?c)
            (not (free ?m))
            (not (mover_at_bay ?m))
        )
    
    )

    (:process move_to_crate
        :parameters (?m - mover ?c -crate)
        :precondition (and 
            (> (charge ?m) 0)
            (going_to_crate ?m ?c))
        :effect (and
            (decrease (charge ?m) #t)
            (increase (distance ?m) (* #t 10))
        )
    )

    (:event robot_at_crate
        :parameters (?m - mover ?c -crate)
        
        :precondition (and
            (going_to_crate ?m ?c)
            (= (distance ?m) (distance ?c))
        )
        :effect (and
            (not (going_to_crate ?m ?c))
            (mover_at_crate ?m ?c)
            (free ?m)
        )
    
    
    )

    (:action grab_one_mover
        :parameters (?m - mover ?c - crate)
        :precondition (and 
            (<= (weight ?c) (max_light_weight)) 
            (not (crate_fragile ?c))
            (crate_at_warehouse ?c)
            (free ?m)
            (mover_at_crate ?m ?c))
        :effect (and
            (not (crate_at_warehouse ?c))
            (not (mover_at_crate ?m ?c))
            (going_to_bay ?m) 
            (crate_on_mover ?m ?c)
            (not (free ?m)))
    )

    (:action grab_two_movers
        :parameters (?m1 ?m2 - mover ?c - crate)
        :precondition (and 
            (free ?m1)
            (free ?m2)
            (or
                (> (weight ?c) (max_light_weight))
                (crate_fragile ?c)
            )
            (crate_at_warehouse ?c)
            (mover_at_crate ?m1 ?c)
            (mover_at_crate ?m2 ?c)
            (not (= ?m1 ?m2)))
        :effect (and
            (not (crate_at_warehouse ?c))
            (not (mover_at_crate ?m1 ?c))
            (not (mover_at_crate ?m2 ?c))
            (mover_together ?m1)
            (mover_together ?m2)
            (going_to_bay ?m1) 
            (going_to_bay ?m2) 
            (crate_on_mover ?m1 ?c)
            (crate_on_mover ?m2 ?c)
            (not (free ?m1))
            (not (free ?m2)))
    )


    (:action grab_two_movers_fast
    :parameters (?m1 ?m2 - mover ?c - crate)
    :precondition (and 
        (free ?m1)
        (free ?m2)
        (<= (weight ?c) (max_light_weight))
        (crate_at_warehouse ?c)
        (not (crate_fragile ?c))
        (mover_at_crate ?m1 ?c)
        (mover_at_crate ?m2 ?c)
        (not (= ?m1 ?m2)))
    :effect (and
        (not (crate_at_warehouse ?c))
        (not (mover_at_crate ?m1 ?c))
        (not (mover_at_crate ?m2 ?c))
        (mover_together ?m1)
        (mover_together ?m2)
        (going_to_bay_fast ?m1) 
        (going_to_bay_fast ?m2) 
        (crate_on_mover ?m1 ?c)
        (crate_on_mover ?m2 ?c)
        (not (free ?m1))
        (not (free ?m2)))
    )

    (:process move_to_bay_normal_speed
        :parameters (?m - mover ?c - crate)
        :precondition (and 
            (> (charge ?m) 0)
            (crate_on_mover ?m ?c)
            (going_to_bay ?m))
        :effect (and
            (decrease (charge ?m) #t)
            (decrease (distance ?m) (* #t (/ 100 (weight ?c))))
        )
    )

    (:process move_to_bay_fast_speed
        :parameters (?m - mover ?c - crate)
        :precondition (and 
            (> (charge ?m) 0)
            (crate_on_mover ?m ?c)
            (going_to_bay_fast ?m))
        :effect (and
            (decrease (charge ?m) #t)
            (decrease (distance ?m) (* #t (/ 150 (weight ?c))))
        )
    )

    (:event arrived_to_bay
        :parameters (?m - mover ?c -crate)
        
        :precondition (and
            (free_bay)
            (crate_on_mover ?m ?c)
            (or
                (going_to_bay ?m)
                (going_to_bay_fast ?m)
            )
            (<= (distance ?m) 0))
        :effect (and
            (assign (distance ?m) 0)
            (not (going_to_bay ?m))
            (not (going_to_bay_fast ?m)))
    )    
    
    (:event arrived_to_busy_bay
        :parameters (?m - mover ?c -crate)
        :precondition (and
            (not (free_bay))
            (crate_on_mover ?m ?c)
            (or
                (going_to_bay ?m)
                (going_to_bay_fast ?m)
            )
            (<= (distance ?m) 0))
        :effect (and
            (assign (distance ?m) 0)
            (not (going_to_bay ?m))
            (not (going_to_bay_fast ?m))
            (wait_for_free_bay ?m))
    )

    (:process wait_bay_free
        :parameters (?m - mover)
        :precondition (wait_for_free_bay ?m)
        :effect ()
    )

    (:event stop_waiting_for_free_bay
        :parameters (?m - mover ?c -crate)
        :precondition (and
            (free_bay)
            (wait_for_free_bay ?m))
        :effect (not (wait_for_free_bay ?m))
    )

    (:action release_one_mover
        :parameters (?m - mover ?c - crate)
        :precondition (and 
            (<= (weight ?c) (max_light_weight)) 
            (not (crate_fragile ?c))
            (not (wait_for_free_bay ?m))
            (not (mover_together ?m))
            (crate_on_mover ?m ?c)
            (= (distance ?m) 0))
        :effect (and
            (mover_at_bay ?m)
            (not (free_bay))
            (crate_at_bay ?c)
            (not (crate_on_mover ?m ?c))
            (free ?m))
    )

    (:action release_two_movers
        :parameters (?m1 ?m2 - mover ?c - crate)
        :precondition (and 
            (not (wait_for_free_bay ?m1))
            (not (wait_for_free_bay ?m2))
            (crate_on_mover ?m1 ?c)
            (crate_on_mover ?m2 ?c)
            (= (distance ?m1) 0)
            (= (distance ?m2) 0)
            (mover_together ?m1)
            (mover_together ?m2)
            (not (= ?m1 ?m2)))
        :effect (and
            (mover_at_bay ?m1)
            (mover_at_bay ?m2)
            (not (free_bay))
            (crate_at_bay ?c)
            (not (crate_on_mover ?m1 ?c))
            (not (crate_on_mover ?m2 ?c))
            (free ?m1)
            (free ?m2))
    )

    (:action start_charging
        :parameters (?m - mover)
        :precondition (and
            (mover_at_bay ?m)
            (< (charge ?m) (max_charge))
        )
        :effect (and
            (not (free ?m))
            (recharging ?m))
    )

    (:process recharge_battery
        :parameters (?m - mover)
        :precondition (and
            (recharging ?m)
        )
        :effect (increase (charge ?m) #t)
    )

    (:event charge_complete
        :parameters (?m - mover)
        :precondition (and
            (recharging ?m)
            (= (charge ?m) (max_charge))
        )
        :effect (and
            (free ?m)
            (not (recharging ?m)))
    )

    (:action load_crate_expensive
        :parameters (?l - expensive ?c - crate)
        :precondition (and 
            (crate_at_bay ?c)
            (not (loading_crate ?l))
            )
        :effect (and
            (assign (loading_time ?l) 0)
            (free_bay)
            (not (crate_at_bay ?c))
            (loading_crate ?l) 
            (crate_on_loader ?l ?c))
    )

    (:action load_crate_cheap
        :parameters (?l - cheap ?c - crate)
        :precondition (and 
            (<= (weight ?c) (max_light_weight))
            (crate_at_bay ?c)
            (not (loading_crate ?l)))
        :effect (and
            (assign (loading_time ?l) 0)
            (free_bay)
            (not (crate_at_bay ?c))
            (loading_crate ?l) 
            (crate_on_loader ?l ?c))
    )

    (:process load_to_conveyor
        :parameters (?l - loader)
        :precondition (and 
            (loading_crate ?l))
        :effect (and
            (increase (loading_time ?l) #t)
        )
    )

    (:event release_on_conveyor
        :parameters (?l - loader ?c -crate)
        :precondition (and
            (loading_crate ?l)
            (crate_on_loader ?l ?c)
            (not (crate_fragile ?c))
            (>= (loading_time ?l) 4))
        :effect (and
            (not (loading_crate ?l))
            (not (crate_on_loader ?l ?c))
            (crate_on_conveyor ?c)
            (crate_need_sequence ?c)
        )
    )

    (:event release_on_conveyor_fragile
        :parameters (?l - loader ?c -crate)
        :precondition (and
            (loading_crate ?l)
            (crate_on_loader ?l ?c)
            (crate_fragile ?c)
            (>= (loading_time ?l) 6))
        :effect (and
            (not (loading_crate ?l))
            (not (crate_on_loader ?l ?c))
            (crate_on_conveyor ?c)
            (crate_need_sequence ?c)
        )
    )

    (:event create_sequence
        :parameters (?c - crate)
        :precondition (and
            (wait_first_crate)
            (crate_on_conveyor ?c))
        :effect (and
            (not (wait_first_crate))
            (last_crate_loaded ?c)
            (not (crate_need_sequence ?c))
        )
    )    

    (:event manage_sequence
        :parameters (?c1 ?c2 - crate)
        :precondition (and
            (crate_need_sequence ?c2)
            (last_crate_loaded ?c1)
            )
        :effect (and
            (not (crate_need_sequence ?c2))
            (subsequent_crates ?c1 ?c2)
            (subsequent_crates ?c2 ?c1)
            (last_crate_loaded ?c2)
            (not (last_crate_loaded ?c1))
        )
    )   

    (:action need_recharge_one_mover
        :parameters (?m - mover ?c -crate)
        :precondition (and 
            (not (mover_together ?m))
            (> (distance ?m) (/ 100 (weight ?c)))
            (= (charge ?m) 1)
            (going_to_bay ?m)
            (crate_on_mover ?m ?c))
        :effect (and
            (assign (distance ?c) (distance ?m))
            (not (crate_on_mover ?m ?c))
            (going_to_recharge ?m)
            (crate_at_warehouse ?c)
        )
    
    )

    (:action need_recharge_two_movers
        :parameters (?m1 ?m2 - mover ?c -crate)
        :precondition (and 
            (> (distance ?m1) (/ 100 (weight ?c)))
            (or
                
                (= (charge ?m1) 1)
                (= (charge ?m2) 1)
            )
            (crate_on_mover ?m1 ?c)
            (crate_on_mover ?m2 ?c)
            (mover_together ?m1)
            (mover_together ?m2)
            (going_to_bay ?m1)
            (going_to_bay ?m2)
            (not (= ?m1 ?m2)))
        :effect (and
            (assign (distance ?c) (distance ?m1))
            (not (crate_on_mover ?m1 ?c))
            (not (crate_on_mover ?m2 ?c))
            (not (mover_together ?m1)) 
            (not (mover_together ?m2))
            (going_to_recharge ?m1)
            (going_to_recharge ?m2)
            (crate_at_warehouse ?c)
        )
    
    )

    (:process move_to_charge
        :parameters (?m - mover)
        :precondition (and 
            (>  (charge ?m) 0)
            (going_to_recharge ?m))
        :effect (and
            (decrease (charge ?m) #t)
            (decrease (distance ?m) (* #t 10))
        )
    )

    (:event mover_at_charge
        :parameters (?m - mover)
        
        :precondition (and
            (going_to_recharge ?m)
            (<= (distance ?m) 0)
        )
        :effect (and
            (not (going_to_recharge ?m))
            (mover_at_bay ?m)
        )
    
    )

)
