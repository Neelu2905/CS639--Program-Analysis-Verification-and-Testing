:k = 0
if(:x > 10)[
    :k = :k + 2
]
else[
    if(:x>20)[
        :k = :x + :y
        :x = :y
    ]
    :k = :k + 10
]