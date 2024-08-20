goto(20, 20)

repeat 4 [
    if (:x > :y)[
        repeat 3 [
            forward 20
            right 45
            if (:y > :z)[
                repeat 2 [
                    forward 15
                    left 30
                    if (:z < 10)[
                        goto(100, 100)
                    ]
                ]
            ]
        ]
    ]
    else[
        repeat 4 [
            forward 10
            left 45
        ]
 if (:y > :z)[
                repeat 2 [
                    forward 15
                    left 30
                    if (:z < 10)[
                        goto(:w, :y)
                    ]
                ]
            ]
    ]
]
