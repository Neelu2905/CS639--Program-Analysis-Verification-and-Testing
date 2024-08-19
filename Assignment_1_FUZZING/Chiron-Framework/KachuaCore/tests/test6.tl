pendown
if (:w > :x)[
     forward 200
     if(:w < :z)[
          goto(100 , 100)
          right 45
          if(:z>:y)[
               goto(43,80)
               right 70
          ]
          else[
               goto(0,0)
               left 80
          ]
     ]
     else[
          goto(300 , 10)
          right 100
          if(:x > 20)[
               forward -30
               right 33
          ]
          else[
               backward 220
               left 45
          ]
     ]
]
else[

     backward 200
     if(:x<:y)[
        goto(30,48)
     ]
     else[
        forward 157
        if(:y<:z)[
          repeat 4 [
			forward 100
			left 45
               :y = :y + :z
               backward 40
		]
        ]
     ]
]