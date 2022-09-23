(define (problem problem4)
    (:domain assignment)
    (:objects

        mover1 mover2 - mover
        crate1 crate2 crate3 crate4 crate5 crate6 - crate
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

        


        (= (distance crate1) 20)
        (= (weight crate1) 30)
        (crate_at_warehouse crate1)

        (= (distance crate2) 20)
        (= (weight crate2) 20)
        (crate_fragile crate2)
        (crate_at_warehouse crate2)


        (= (distance crate3) 10)
        (= (weight crate3) 30)
        (crate_fragile crate3)
        (crate_at_warehouse crate3)

        (= (distance crate4) 20)
        (= (weight crate4) 20)
        (crate_at_warehouse crate4)

        (= (distance crate5) 30)
        (= (weight crate5) 30)
        (crate_fragile crate5)
        (crate_at_warehouse crate5)

        (= (distance crate6) 10)
        (= (weight crate6) 20)
        (crate_at_warehouse crate6)

    )

    (:goal
        (and
            (crate_on_conveyor crate1)
            (crate_on_conveyor crate2)
            (crate_on_conveyor crate3)
            (crate_on_conveyor crate4)
            (crate_on_conveyor crate5)
            (crate_on_conveyor crate6)

            (subsequent_crates crate1 crate2)
            
            (or
                (and
                    (subsequent_crates crate3 crate4)
                    (subsequent_crates crate4 crate5)
                )
                (and
                    (subsequent_crates crate3 crate5)
                    (subsequent_crates crate4 crate5)
                )
                (and
                    (subsequent_crates crate3 crate4)
                    (subsequent_crates crate3 crate5)
                )
            
            )
            
        )
    )

    (:metric minimize(total-time))
)
