pendown
:e = 25
if(:z <= 80)[
    backward :x
    if(:y > -100)[
        right 45
        forward 30
        left 45
        :e = 10
    ]
]
if(:x > 100 && :y <= -160)[
    forward :x - :y
    :e = 0
    right 50
    goto(20, -99)
    backward :x/10
    right 90
    forward :y
    if(:z > 50)[
        left 30
        forward 20
        right 30
    ]
]
if(:e >= 0 && :a > 90)[
    backward 15
    right 90
    forward :z
    forward :e
    left 134
    goto(100, 99)
    if(:y < 0)[
        right 45
        backward 20
        left 45
    ]
]
else[
    backward :e
    :e = :e * 2  
    right 90
    forward 70
    left 134
    goto(50, 59)
    backward 89
    right 90
    forward 100
    left 134
    goto(-10, 88)
    if(:z < 60)[
        left 45
        forward 30
        right 45
    ]
]
backward :z
right 90
forward :z - :y
left 134
if(:x >= 0)[
    left 60
    backward :z
    if(:y >= 50)[
        right 30
        forward 10
        left 30
    ]
]