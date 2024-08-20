pendown
if :x > 0 [
    if :y > 0 [
        if :z > 0 [
            forward 10
        ]
        else [
            backward 10
        ]
    ]
    else [
        if :w > 0 [
            forward 5
        ]
        else [
            backward 5
        ]
    ]
]
else [
    if :u > 0 [
        forward 3
    ]
    else [
        backward 3
    ]
]
