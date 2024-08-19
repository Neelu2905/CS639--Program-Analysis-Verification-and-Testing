penup
if (:x > :y)[
    forward 100
    if(:y < :z)[
        goto(50 , 50)
        right 45
        if(:z > :y)[
            goto(43,80)
            right 70
        ]
        else[
            goto(0,0)
            left 80
        ]
    ]
    else[
        goto(200 , 20)
        right 120
        if(:x > 30)[
            forward -30
            right 33
        ]
        else[
            backward 120
            left 45
        ]
    ]
]
else[
    backward 100
    if(:w < :y)[
        goto(30,48)
    ]
    else[
        forward 157
        if(:y < :z)[
            repeat 4 [
                forward 80
                left 45
                :y = :y + :z
                backward 40
            ]
        ]
    ]
]
