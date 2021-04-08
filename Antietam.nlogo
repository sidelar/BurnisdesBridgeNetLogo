turtles-own [energy manpower targetPatch isInRetreat isWet isInRout isAtPrep stuckCount isCreek isBridge isReserve A*path needNewTarget useA* InitalManpower priorTarget IsBridgeDefenese UnitEnergyRecovery interDestCount interDest]
breed [unions union]
breed [confeds confed]
globals [PctReserve UnionRetreatPatch ConfedRetreatPatch AreAllUnionReady IsBridgeCaptured IsBattleWon waitAtPrepCount IsUnionWin IsConfedWin
p-valids   ;
 p-valids-water; Valid Patches for moving not wall)
  Start      ; Starting patch
  Final-Cost ; The final cost of the path given by A*

]

patches-own [UnionPreperationPatch IsWater IsBridgePatch
 father     ; Previous patch in this partial path
  Cost-path  ; Stores the cost of the path to the current patch
  visited?   ; has the path been visited previously? That is,
             ; at least one path has been calculated going through this patch
  active?    ; is the patch active? That is, we have reached it, but
             ; we must consider it because its children have not been explored
]

;add boolean for both land and water
;patches-own [UnionPreperationPatch IsWater isLand]


to setup
  clear-all



  set isBattleWon false
   set IsUnionWin false
   set IsConfedWin false

  setup-patches
  setup-turtles
  reset-ticks

end

to setup-patches

  set-patch-size 8
  ;if we want to use a slider to adjust the map size
  ;resize-world (mapSize * -1)  mapSize (mapSize * -1) mapSize
  ;if we want a fized size for the map size
  resize-world -45 45 -35 35 ;

  set waitAtPrepCount 0



; code to create a creek and bridge
;  ask patches[
;    set pcolor green
;    set IsWater false
;    set isLand true
;
;    if ((pxcor > -3) and (pxcor < 1)and (pycor < 17))
;    [
;      set pcolor blue
;      set IsWater true
;       set isLand false
;    ]
;    if ((pxcor > -3) and (pxcor < 1)and (pycor < 0) and (pycor > -4))
;    [
;      set pcolor brown
;      set IsWater false
;       set isLand true
;    ]
;  ]

let creekPoints patches at-points [
      [9 35] [10 34] [10 33] [10 32]
     [10 31] [10 30] [10 29]
     [10 28] [10 27] [10 26] [10 25]
     [10 24] [10 23] [10 22] [10 21]
     [10 20] [10 19] [10 18] [10 17]
     [10 16] [10 15] [10 14]
    [10 12] [11 12]   [11 11] [12 10] [12 9]
    [12 8] [13 8] [12 7] [12 6] [11 5] [12 5] [11 4]
     [10 4] [10 3] [10 1] [10 2] [10 0]

    [3 -35] [3 -34] [4 -33] [4 -32]
     [5 -31] [5 -30] [6 -29]
     [6 -28] [7 -27] [8 -26] [9 -25]
     [10 -24] [10 -23] [10 -22] [10 -21]
     [10 -20] [10 -19] [10 -18] [10 -17]
    [11 -19] [12 -19] [13 -19] [14 -19]
    [15 -19] [16 -19] [17 -19] [18 -19]
    [19 -19]  [20 -19]   [21 -19]  [22 -19]
    [23 -19]  [24 -19]   [25 -19]  [26 -19]
    [27 -19]  [28 -19]   [29 -19]  [30 -19]
     [31 -18]  [32 -18]   [33 -18]  [34 -18]
      [35 -18]  [36 -18]   [37 -18]  [38 -18]
      [39 -18]  [40 -18]   [41 -18]  [42 -18]
      [43 -18]  [44 -18]   [45 -18]
     [10 -16] [10 -15] [10 -14] [10 -13]
     [10 -12] [10 -11] [10 -10] [10 -9]
    [10 -8] [10 -7] [9 -6] [9 -5]
     [9 -4] [9 -3] [9 -2] [9 -1]

    ]

  let bridgePoints patches at-points [ [11 13] [10 13] [12 13] [9 13]]
   let UnionPreperationPatches patches at-points [
    [2 15] [2 17] [2 19]
    [2 21] [2 23] [2 25]
    [2 13] [2 11] [2 9]
    [2 27] [2 29] [2 31]
    [2 7] [2 5] [2 3]
  ]




  set UnionRetreatPatch patch (max-pxcor - 1) (max-pycor - 1)
  set ConfedRetreatPatch patch (min-pxcor + 1) (max-pycor - 1)
  ask patches  [ set pcolor green - 2
    set IsWater 0

  ]
  ask UnionPreperationPatches
  [

      set UnionPreperationPatch  1
     set pcolor black
    ]


     ask bridgePoints
    [
      set IsWater 0
     set pcolor grey + 2
      set IsBridgePatch 1
    ]



    ask creekPoints [
    set pcolor blue + 1
    set IsWater 1]



ask patches
  [
    set father nobody
    set Cost-path 0
    set visited? false
    set active? false
  ]
  ; Generation of random obstacles

  ; Se the valid patches (not wall)
  set p-valids patches with [IsWater = 0 and pxcor !=  max-pxcor and pxcor !=  min-pxcor and  pycor !=  max-pycor and pycor !=  min-pycor ]
   set p-valids-water patches with [ pxcor !=  max-pxcor and pxcor !=  min-pxcor and  pycor !=  max-pycor and pycor !=  min-pycor ]

  ; Create a random start






end





to setup-turtles
  let tot 0
  set tot  (PctBridge + PctCreek)
  set PctReserve  100 -(PctBridge + PctCreek)
  if tot > 100
  [
    show "Totals must be less then 100!!!!"
    error e
  ]

  let init-confed-y (list 10 9 8 7 6 10 11)
  let init-confed-x (list -7 -6 -4 -3 -2 -5 -4)
  let init-union-y (list -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -10 -9)
  let init-union-x (list 0 2 3 4 5 6 7 8 9 10 10)


  let initalUnionPoints patches at-points [
    [39 25] [39 23] [39 21] [39 19]
    [39 17] [39 15] [39 13] [39 11]
    [39 9] [39 7]
  ]

   let initalConfedPoints patches at-points [
    [-34 26] [-34 22] [-34 18] [-34 14]
    [-34 10]  [-34 6]
  ]


  set-default-shape unions "person union"
  set-default-shape confeds "person confederate"

  let TotalUnion 10
  let totCreek (PctCreek * TotalUnion / 100)
  let totBridge (PctBridge * TotalUnion / 100)
  let totReserve (PctReserve * TotalUnion / 100)
  create-unions totBridge  [
    set color blue
    set energy 100
    set manpower 1000
    set InitalManpower manpower
    set isCreek 0
    set UnitEnergyRecovery EnergyRecovery
    move-to one-of initalUnionPoints
    set InterDest nobody
    set InterDestCount 0

    ;;let remove-index random length initalUnionPoints
    ;;set ycor item remove-index init-union-y
    ;;set init-union-y remove-item remove-index init-union-y
    ;;let remove-indexx random length init-union-x
    ;;set xcor item remove-indexx init-union-x
    ;;set init-union-x remove-item remove-indexx init-union-x

    ;;let target-index random length init-confed-y
    ;;let target-y item target-index init-confed-y
    ;;let target-x item target-index init-confed-x
    ;;let tarpatch patch target-x target-y
    ;;set targetPatch tarpatch

     set targetPatch  min-one-of (patches with [UnionPreperationPatch = 1]) [distance myself]


  ]

   create-unions totCreek  [
    set color blue
    set energy 100
    set manpower 1000
     set InitalManpower manpower
    set isCreek 1
     set UnitEnergyRecovery EnergyRecovery
 set InterDest nobody
    set InterDestCount 0


    move-to one-of initalUnionPoints with [not any? turtles-here]
    ;;set ycor item remove-index init-union-y
    ;;set init-union-y remove-item remove-index init-union-y
    ;;let remove-indexx random length init-union-x
    ;;set xcor item remove-indexx init-union-x
    ;;set init-union-x remove-item remove-indexx init-union-x

    ;;let target-index random length init-confed-y
    ;;let target-y item target-index init-confed-y
    ;;let target-x item target-index init-confed-x
    ;;let tarpatch patch target-x target-y
    ;;set targetPatch tarpatch

     set targetPatch  min-one-of (patches with [UnionPreperationPatch = 1]) [distance myself]



  ]



  create-unions totReserve  [
    set color blue
    set energy 100
    set manpower 1000
     set InitalManpower manpower
    set isCreek 0
     set UnitEnergyRecovery EnergyRecovery
 set InterDest nobody
    set InterDestCount 0
    move-to one-of initalUnionPoints with [not any? turtles-here]
    ;;let remove-index random length init-union-y
    ;;set ycor item remove-index init-union-y
    ;;set init-union-y remove-item remove-index init-union-y
    ;;let remove-indexx random length init-union-x
    ;;set xcor item remove-indexx init-union-x
    ;;set init-union-x remove-item remove-indexx init-union-x

    ;;let target-index random length init-confed-y
    ;;let target-y item target-index init-confed-y
    ;;let target-x item target-index init-confed-x
    ;;let tarpatch patch target-x target-y
    ;;set targetPatch tarpatch

    set targetPatch patch-here



  ]




  create-confeds 6 [
    set color red
    set energy 100
    set manpower 500
     set InitalManpower manpower
      set IsBridgeDefenese false
    move-to one-of initalConfedPoints with [not any? turtles-here]
    set UnitEnergyRecovery EnergyRecovery
 set InterDest nobody
    set InterDestCount 0
    let tarpatch patch-here
    set targetPatch tarpatch
  ]


  create-confeds 1 [
    set color red
    set energy 100
    set manpower 500
     set InitalManpower manpower
    move-to patch 8 13
    set IsBridgeDefenese true
    set UnitEnergyRecovery EnergyRecovery
    let tarpatch patch-here
    set targetPatch tarpatch
     set InterDest nobody
    set InterDestCount 0
  ]

  ask turtles
  [set A*path false
  set size 3]



end

to create-reinforcements
  print "Ap Hill Arrives!"
  let initalConfedPoints patches at-points [
    [-34 26] [-34 22] [-34 18] [-34 14]
    [-34 10]  [-34 6]
  ]
   create-confeds 3 [
    set energy 50
    set manpower 500
     set InitalManpower manpower
      set IsBridgeDefenese false
     set UnitEnergyRecovery EnergyRecovery / 2

    move-to ConfedRetreatPatch
     set InterDest nobody
    set InterDestCount 0


    let tarpatch one-of initalConfedPoints
    set targetPatch tarpatch
    set size 2
  ]


end


to check-win
  if not any?  confeds with [IsInRout = 0]
[
   set IsUnionWin  true
  set  IsBattleWon true
  ]

 if not any? unions with [IsInRout = 0] or ticks = 500
[
  set IsConfedWin  true
  set  IsBattleWon true
  ]




end



to go
  if ticks >= 500 [ stop ]
  if IsBattleWon [ stop]
  check-turtle-status
  move-turtles
  check-after-move
  fight-turtles
  recover-turtles
  check-win
  if ticks = 330 [
    create-reinforcements
  ]
  ;;test retreat


  tick
end

to check-after-move
  if AreAllUnionReady != 1
  [
  ask unions [
   let prep [UnionPreperationPatch] of patch-here
        if (prep = 1 and isAtPrep = 0 )
        [
          set isAtPrep  1
          ;;set targetPatch patch-here
        ]

      if needNewTarget = 1
      [
        if(AreAllUnionReady = 0)
        [
          set needNewTarget 0
          set A*Path false
          set targetPatch  one-of (patches with [UnionPreperationPatch = 1 and not any? turtles-here])
         ;; print "retargeting blocked turtle"
          ;;print who
        ]
      ]







    ]
  ]

  ifelse IsBridgeCaptured != 1
  [
    if any? unions with [isAtPrep = 1]
    [
      set IsBridgeCaptured 1
    ]

  ]

  [
    ask unions
    [
      if targetPatch = patch-here
      [
          set targetPatch  min-one-of (patches with [UnionPreperationPatch = 1]) [distance myself]
      ]

    ]
  ]



   if all? unions [(isAtPrep = 1) or (IsInRetreat = 1) or (targetPatch = nobody) or (IsInRout = 1) ]
  [
    set AreAllUnionReady 1
    ask unions
    [
      set targetPatch  min-one-of (patches with [any? confeds-here with [IsInRout = 0] ]) [distance myself]
          set needNewTarget 0
          set A*Path false
    ]
  ]
end


to check-turtle-status
  ask unions [
    ifelse manpower < ( RoutLimit / 100 * InitalManpower ) [
      set IsInRout  1
      set targetPatch UnionRetreatPatch
      set A*Path false
  ]
    [
      ifelse energy < RetreatEnergyLimit and IsInRetreat = 0 [
        set IsInRetreat 1

        set priorTarget targetPatch
       set targetPatch UnionRetreatPatch
        set A*Path false
      ]
      [
        if IsInRetreat  = 1 and energy > 2 * RetreatEnergyLimit
        [
          set IsInRetreat  0
          set targetPatch priorTarget
          set A*Path false
        ]



      ]
    ]
  ]

    ask confeds [
    if IsBridgeCaptured = 1 and IsBridgeDefenese = 1
    [
          set IsInRetreat 1
          set targetPatch ConfedRetreatPatch
          set A*Path false
    ]
    ifelse manpower < ( RoutLimit / 100 * InitalManpower ) [
      ifelse IsBridgeDefenese = 1
      [
        if manpower < ( RoutLimit / 100 * InitalManpower / 2 )
        [
          set IsInRout  1
          set targetPatch ConfedRetreatPatch
          set A*Path false
        ]
      ]
      [
      set IsInRout  1
      set targetPatch ConfedRetreatPatch
        set A*Path false
      ]
  ]
    [
      ifelse energy < RetreatEnergyLimit and IsInRetreat = 0 [
        set IsInRetreat 1
         set priorTarget targetPatch
       set targetPatch ConfedRetreatPatch
         set A*Path false
      ]
      [
        if IsInRetreat  = 1 and energy > 2 * RetreatEnergyLimit
        [
          set IsInRetreat  0
          set targetPatch priorTarget
           set A*Path false

          if IsBridgeDefenese and IsBridgeCaptured = 1
          [
            set  targetPatch patch -34 18
          ]

        ]



      ]
    ]

  ]


end

to recover-turtles
  ask turtles [
    ifelse isInRout = 1
    []
    [
      ifelse isWet = 1
      [
        set energy energy + WetEnergyRecovery
      ]
      [

        set energy energy + EnergyRecovery
      ]

    ]
    if energy > 100
    [
      set energy 100
    ]
    if energy < 0
    [
      set energy 0
    ]
    if manpower < 0
    [
      set manpower 0
    ]

  ]
end


;; based on code from paths example model in model library
to move-turtles
  ask turtles [
    ifelse patch-here = targetPatch [
    ;;set targetPatch one-of patches
      ;; walk random for now
    ]
     [
      walk-towards-goal
    ]

  ]

end

to fight-turtles
  manpower-damage
 ;; enemy-target
 ;; enemy-target-distance
end

to manpower-damage
;; Do we need a staggered start like this? Give it a tick or two to get set up before we start "firing"?
  if ticks >= 2 [
    ask unions [
        ;; Insert the check-creek logic here to see if it can identify the closest enemy and fire

      let enemy-target-distance2 1000
      let enemy-target-distance 1000

       let enemy-target min-one-of confeds with [IsInRout = 0 and IsInRetreat = 0] [distance myself]
      let enemy-target2 min-one-of confeds with [IsInRout = 0 ] [distance myself]

  if enemy-target != nobody
            [set enemy-target-distance distance enemy-target]
      if enemy-target2 != nobody
      [ set enemy-target-distance2 distance enemy-target2]

      if enemy-target-distance > 10
      [
        set enemy-target enemy-target2
        set enemy-target-distance enemy-target-distance2
      ]




      if enemy-target-distance <= 10 and IsInRetreat != 1 and isInRout != 1 and [IsWater] of patch-here != 1
      [




        let manpower-reduction ( 4 / abs enemy-target-distance)



        ask enemy-target [
           set manpower (manpower - (manpower-reduction ))



           set energy (energy - ((manpower-reduction ) * 3 ) - 20 * (1 - manpower / initalManpower))


        ]



      ]




        ]



    ask confeds [
        ;; Insert the check-creek logic here to see if it can identify the closest enemy and fire

       let enemy-target-distance2 1000
      let enemy-target-distance 1000


      let enemy-target min-one-of unions with [IsInRout = 0 and IsInRetreat = 0] [distance myself]
      let enemy-target2 min-one-of unions with [IsInRout = 0 ] [distance myself]

      if enemy-target != nobody
            [set enemy-target-distance distance enemy-target]
      if enemy-target2 != nobody
            [ set enemy-target-distance2 distance enemy-target2]



      if enemy-target-distance > 13
      [
        set enemy-target enemy-target2
        set enemy-target-distance enemy-target-distance2
      ]

if enemy-target-distance <= 13 and IsInRetreat != 1 and isInRout != 1
      [




        ;;Struggling here to apply the damage to the enemy-target turtle...
        let manpower-reduction ( 7 / abs enemy-target-distance)
        if IsBridgeDefenese
        [set manpower-reduction manpower-reduction * 3  ]


        ask enemy-target [
           set manpower (manpower - (manpower-reduction ))



           set energy (energy - ((manpower-reduction ) * 5 ) - 15 * (1 - manpower / initalManpower))
        ]



      ]




        ]
  ]
end

to walk-towards-goal
 let intermedDest targetPatch
  ifelse InterDest = nobody
[

  if targetPatch != nobody
  [
    ifelse  AreAllUnionReady = 1 or IsInRout = 1  ;; if going through creek just run in a straight line
    [
      set intermedDest best-way-to targetPatch
    ]

    [

      ifelse A*path = false
      [
        let here patch-here

        let valid p-valids with [(not any? turtles-here)]

        if IsCreek = 1
          [
          set valid p-valids-water with [(not any? turtles-here)]
          ]


        set valid (patch-set here valid)
        carefully [

          let path  A* patch-here targetPatch valid ;
          ifelse path = false
          [
            set needNewTarget 1
          ]
          [
            set  path remove-item  0 path
            set intermedDest first path
            set A*path path
          ]
        ] [
          print error-message ;
          set needNewTarget 1;
          ;; or do something else instead...

        ]


      ]
      [
         carefully [
        ifelse length A*path  > 1
        [

          set intermedDest item 1 A*path
          ifelse not any? turtles-on intermedDest and  (( IsInRetreat = 1) or (  is-union? myself and  not any? confeds in-radius 5) or  ( is-confed? myself and  not any? unions in-radius 5))
          [
            set  A*path remove-item  0 A*path


          ]
          [ set stuckCount stuckCount + 1
            set intermedDest nobody

            if stuckCount > 10 and IsBridgeCaptured
            [set isAtPrep 1]
          ]
        ]
          [
          ]
        ]
        [

            set needNewTarget 1;
        ]


      ]


      ;;print path
      ;;print patch-here


    ]
   ]
  ]
    [
       set intermedDest InterDest
    ]


    ifelse intermedDest = nobody
    [

    ]
    [
      ;;print intermedDest
      ;;face intermedDest

     ;; move-to patch-ahead 1

      set stuckCount 0
      ifelse [IsWater] of  intermedDest = 1 or [IsWater] of patch-here = 1
      [
       set InterDest intermedDest

       ifelse interdestcount > 3
       [
        print "here"
        set energy energy - WetPatchCost
        set isWet 1
        fd .25
        set InterDest nobody
           set interDestCount 0
      ]
        [
          set interdestcount interdestcount + 1
          print interdestcount
        ]

      ]
      [
        set energy energy - DryPatchCost
         ;;fd 1
        move-to intermedDest
      ]


    ]








end

to-report best-way-to [ destination ]

  ; of all the visible route patches, select the ones
  ; that would take me closer to my destination
  let visible-patches patches in-radius 10


    let visible-routes visible-patches with [(not any? turtles-here)]
    let routes-that-take-me-closer visible-routes with [
    distance destination < [ distance destination + 1 ] of myself
  ]



  ifelse any? routes-that-take-me-closer [
    ; from those route patches, choose the one that is the closest to me
    report min-one-of routes-that-take-me-closer [ distance self ]
  ] [
    ; if there are no nearby routes to my destination
    report nobody
  ]







end

 ;;Patch report to estimate the total expected cost of the path starting from
; in Start, passing through it, and reaching the #Goal
to-report Total-expected-cost [#Goal]
  report Cost-path + Heuristic #Goal
end

; Patch report to reurtn the heuristic (expected length) from the current patch
; to the #Goal
to-report Heuristic [#Goal]
  report  distance #Goal

end

; A* algorithm. Inputs:
;   - #Start     : starting point of the search.
;   - #Goal      : the goal to reach.
;   - #valid-map : set of agents (patches) valid to visit.
; Returns:
;   - If there is a path : list of the agents of the path.
;   - Otherwise          : false

to-report A* [#Start #Goal #valid-map]
  ; clear all the information in the agents
  ask #valid-map with [visited?]
  [
    set father nobody
    set Cost-path 0
    set visited? false
    set active? false
  ]
  ; Active the staring point to begin the searching loop
  ask #Start
  [
    set father self
    set visited? true
    set active? true
  ]
  ; exists? indicates if in some instant of the search there are no options to
  ; continue. In this case, there is no path connecting #Start and #Goal
  let exists? true
  ; The searching loop is executed while we don't reach the #Goal and we think
  ; a path exists
  while [not [visited?] of #Goal and exists?]
  [
    ; We only work on the valid pacthes that are active
    let options #valid-map with [active?]
    ; If any
    ifelse any? options
    [
      ; Take one of the active patches with minimal expected cost
      ask min-one-of options [Total-expected-cost #Goal]
      [
        ; Store its real cost (to reach it) to compute the real cost
        ; of its children
        let Cost-path-father Cost-path
        ; and deactivate it, because its children will be computed right now
        set active? false
        ; Compute its valid neighbors
        let valid-neighbors neighbors with [member? self #valid-map]
        ask valid-neighbors
        [
          ; There are 2 types of valid neighbors:
          ;   - Those that have never been visited (therefore, the
          ;       path we are building is the best for them right now)
          ;   - Those that have been visited previously (therefore we
          ;       must check if the path we are building is better or not,
          ;       by comparing its expected length with the one stored in
          ;       the patch)
          ; One trick to work with both type uniformly is to give for the
          ; first case an upper bound big enough to be sure that the new path
          ; will always be smaller.
          let t ifelse-value visited? [ Total-expected-cost #Goal] [2 ^ 20]
          ; If this temporal cost is worse than the new one, we substitute the
          ; information in the patch to store the new one (with the neighbors
          ; of the first case, it will be always the case)
          if t > (Cost-path-father + distance myself + Heuristic #Goal)
          [
            ; The current patch becomes the father of its neighbor in the new path
            set father myself
            set visited? true
            set active? true
            ; and store the real cost in the neighbor from the real cost of its father
            set Cost-path Cost-path-father + distance father
            set Final-Cost precision Cost-path 3
          ]
        ]
      ]
    ]
    ; If there are no more options, there is no path between #Start and #Goal
    [
      set exists? false
    ]
  ]
  ; After the searching loop, if there exists a path
  ifelse exists?
  [
    ; We extract the list of patches in the path, form #Start to #Goal
    ; by jumping back from #Goal to #Start by using the fathers of every patch
    let current #Goal
    set Final-Cost (precision [Cost-path] of #Goal 3)
    let rep (list current)
    While [current != #Start]
    [
      set current [father] of current
      set rep fput current rep
    ]
    report rep
  ]
  [
    ; Otherwise, there is no path, and we return False
    report false
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
195
11
931
588
-1
-1
8.0
1
10
1
1
1
0
0
0
1
-45
45
-35
35
0
0
1
ticks
30.0

TEXTBOX
14
36
164
64
Batle Of Antietam - Burnsides Bridge\n
11
0.0
1

BUTTON
17
70
80
103
NIL
go\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
106
71
169
104
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
11
309
183
342
PctBridge
PctBridge
0
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
13
363
185
396
PctCreek
PctCreek
0
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
12
405
184
438
WetEnergyRecovery
WetEnergyRecovery
0
100
15.0
1
1
NIL
HORIZONTAL

SLIDER
17
455
189
488
EnergyRecovery
EnergyRecovery
0
100
20.0
1
1
NIL
HORIZONTAL

SLIDER
13
504
185
537
RoutLimit
RoutLimit
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
15
552
187
585
RetreatEnergyLimit
RetreatEnergyLimit
0
100
30.0
1
1
NIL
HORIZONTAL

SLIDER
22
603
194
636
DryPatchCost
DryPatchCost
0
100
5.0
1
1
NIL
HORIZONTAL

SLIDER
21
646
193
679
WetPatchCost
WetPatchCost
0
100
20.0
1
1
NIL
HORIZONTAL

PLOT
1295
193
1648
405
Average Energy
ticks
Energy
0.0
500.0
0.0
100.0
false
true
"" ""
PENS
"Union" 1.0 0 -14730904 true "" "if any? unions\n[ plot mean [energy] of unions ]"
"Confederacy" 1.0 0 -2674135 true "" "if any? confeds\n[ plot mean [energy] of confeds ]"

PLOT
1295
409
1652
625
Total  Manpower
NIL
NIL
0.0
500.0
0.0
10000.0
false
true
"" ""
PENS
"Union" 1.0 0 -14730904 true "" "if any? unions\n[ plot sum [Manpower] of unions ]"
"Confederacy" 1.0 0 -2674135 true "" "if any? confeds\n[ plot sum [Manpower] of confeds ]"

MONITOR
979
578
1131
623
Num Union Troops Ready
Sum  [isAtPrep] of unions
17
1
11

MONITOR
981
55
1114
100
IsBridgeCaptured
IsBridgeCaptured = 1
17
1
11

MONITOR
982
101
1063
146
NIL
IsBattleWon
17
1
11

MONITOR
981
147
1056
192
NIL
IsUnionWin
17
1
11

MONITOR
979
194
1064
239
NIL
IsConfedWin
17
1
11

MONITOR
981
252
1124
297
Union Manpower 
sum [Manpower] of unions
0
1
11

MONITOR
982
318
1126
363
Confederate Manpower
sum [Manpower] of confeds
0
1
11

MONITOR
1138
252
1290
297
Union Casualties
sum [InitalManpower - Manpower] of unions
0
1
11

MONITOR
1142
317
1285
362
Confederate Casualties
sum [InitalManpower - Manpower] of confeds
0
1
11

MONITOR
977
531
1129
576
Num Union Troops Wet
sum [IsWet] of unions
17
1
11

MONITOR
977
481
1136
526
Num Union Troops Routing
sum [IsInRout] of unions
17
1
11

MONITOR
981
10
1087
55
Curent Time
ticks  + 1000
17
1
11

MONITOR
1137
479
1293
524
Num Confeds Troops Routing
sum [IsInRout] of Confeds
17
1
11

MONITOR
978
432
1134
477
Num Union Troops Retreating
sum [IsInRetreat] of unions
17
1
11

MONITOR
1140
430
1289
475
Num Confeds Retreating
Sum [IsInRetreat] of Confeds
17
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

nato enemy
false
14
Rectangle -1 true false 15 15 285 285
Line -16777216 true 210 90 90 210
Line -16777216 true 90 90 210 210
Polygon -2674135 false false 150 30 30 150 150 270 270 150 150 30
Line -16777216 true 150 30 150 0

nato freindly
false
14
Rectangle -1 true false 0 45 315 255
Line -16777216 true 285 60 15 240
Line -16777216 true 15 60 285 240
Rectangle -13345367 false false 15 60 285 240
Line -16777216 true 135 60 135 45
Line -16777216 true 165 60 165 45

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person confederate
false
0
Rectangle -955883 true false 127 79 172 94
Polygon -1 true false 105 90 60 195 90 210 135 105
Polygon -1 true false 195 90 240 195 210 210 165 105
Circle -1184463 true false 110 5 80
Polygon -1 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -7500403 true true 120 90 105 90 180 195 180 165
Line -6459832 false 109 105 139 105
Line -6459832 false 122 125 151 117
Line -5825686 false 137 143 159 134
Line -6459832 false 158 179 181 158
Line -6459832 false 146 160 169 146
Rectangle -7500403 true true 120 193 180 201
Polygon -1 true false 122 4 107 16 102 39 105 53 148 34 192 27 189 17 172 2 145 0
Polygon -16777216 true false 183 90 240 15 247 22 193 90
Rectangle -7500403 true true 114 187 128 208
Rectangle -7500403 true true 177 187 191 208

person soldier
false
0
Rectangle -7500403 true true 127 79 172 94
Polygon -10899396 true false 105 90 60 195 90 210 135 105
Polygon -10899396 true false 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Polygon -10899396 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -6459832 true false 120 90 105 90 180 195 180 165
Line -6459832 false 109 105 139 105
Line -6459832 false 122 125 151 117
Line -6459832 false 137 143 159 134
Line -6459832 false 158 179 181 158
Line -6459832 false 146 160 169 146
Rectangle -6459832 true false 120 193 180 201
Polygon -6459832 true false 122 4 107 16 102 39 105 53 148 34 192 27 189 17 172 2 145 0
Polygon -16777216 true false 183 90 240 15 247 22 193 90
Rectangle -6459832 true false 114 187 128 208
Rectangle -6459832 true false 177 187 191 208

person union
false
0
Rectangle -955883 true false 127 79 172 94
Polygon -13345367 true false 105 90 60 195 90 210 135 105
Polygon -13345367 true false 195 90 240 195 210 210 165 105
Circle -1184463 true false 110 5 80
Polygon -13345367 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -7500403 true true 120 90 105 90 180 195 180 165
Line -6459832 false 109 105 139 105
Line -6459832 false 122 125 151 117
Line -5825686 false 137 143 159 134
Line -6459832 false 158 179 181 158
Line -6459832 false 146 160 169 146
Rectangle -7500403 true true 120 193 180 201
Polygon -13345367 true false 122 4 107 16 102 39 105 53 148 34 192 27 189 17 172 2 145 0
Polygon -1184463 true false 183 90 240 15 247 22 193 90
Rectangle -7500403 true true 114 187 128 208
Rectangle -7500403 true true 177 187 191 208

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
