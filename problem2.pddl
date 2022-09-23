(define (problem problem2)
    (:domain assignment)
    (:objects

        mover1 mover2 - mover
        crate1 crate2 crate3 crate4 - crate
        loader_expensive  - expensive 
        loader_cheap - cheap
    )

    (:init

        (wait_first_crate)

        (= (max_light_weight) 50)
        (= (max_charge) 20)


        (free mover1)
        (free mover2)
        (free_bay)

        (= (distance mover1) 0)
        (= (distance mover2) 0)
        (mover_at_bay mover1)
        (mover_at_bay mover2)
        (= (charge mover1) 20)
        (= (charge mover2) 20)

        


        (= (distance crate1) 10)
        (= (weight crate1) 70)
        (crate_at_warehouse crate1)

        (= (distance crate2) 20)
        (= (weight crate2) 80)
        (crate_fragile crate2)
        (crate_at_warehouse crate2)


        (= (distance crate3) 20)
        (= (weight crate3) 20)
        (crate_at_warehouse crate3)

        (= (distance crate4) 10)
        (= (weight crate4) 30)
        (crate_at_warehouse crate4)





        


    )

    (:goal
        (and
            (crate_on_conveyor crate1)
            (crate_on_conveyor crate2)
            (crate_on_conveyor crate3)
            (crate_on_conveyor crate4)
            
            (subsequent_crates crate1 crate2)
            (subsequent_crates crate3 crate4)
        )
    )

    (:metric minimize(total-time))
)
