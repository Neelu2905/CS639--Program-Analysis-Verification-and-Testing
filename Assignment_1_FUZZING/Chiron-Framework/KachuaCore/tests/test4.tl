goto(20, 20)

repeat 3 [
    if (:x > :y)[
        repeat 2 [
            forward 20
            right 45
            :x = :x - 5
        ]
        if (:y < :z)[
            repeat 2 [
                forward 15
                left 30
                :y = :y + 10
            ]
        ]
        else[
            repeat 3 [
                forward 25
                right 60
                :z = :z - 5
            ]
        ]
    ]
    else[
        repeat 4 [
            forward 10
            left 45
        ]
    ]
]
