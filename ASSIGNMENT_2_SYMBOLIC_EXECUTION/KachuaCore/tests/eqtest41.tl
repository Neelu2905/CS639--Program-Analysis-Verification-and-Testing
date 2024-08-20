:k = 0
if(:x > 10)[
    :k = :k + :c1
]
else[
    if(:x>20)[
        :k = :x + :y + :c1
        :x = :y
    ]
    :k = :k + :c2
]w