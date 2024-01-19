(defrule activate_t2
    (task
        (id t1)
        (outcome yolo)
    )
    ?t <- (task (id t2))
    =>
    (modify ?t (activated yes))
    (println "t2 activated!")
)

(defrule activate_t3
    (task
        (id t1)
        (outcome omg)
    )
    ?t <- (task (id t3))
    =>
    (modify ?t (activated yes))
    (println "t3 activated!")
)


; Kernal
(defrule what_next
    (declare (salience -10))
    (not (command))
    =>
    (println "What task do you want to do?")
    (do-for-all-facts ((?t task))
        (and
            (eq ?t:activated yes)
            (eq ?t:outcome none)
        )
       (println " - " ?t:id)
    )
    (print "> ")
    (bind ?rsp (explode$ (lowcase (readline))))
    (assert (command (action ?rsp)))
)


; Process commands
(defrule do_task
    ?c <- (command (action ?task))
    ?t <- (task 
        (id ?task)
        (activated yes)
        (outcome none)
    )
    =>
    (println "What was the outcome of this task?")
    (print "> ")
    (bind ?outcome (lowcase (readline)))
    (modify ?t
        (outcome ?outcome)
    )
    (retract ?c)
)

(defrule task_already_done
    ?c <- (command (action ?task))
    ?t <- (task 
        (id ?task)
        (outcome ~none)
    )
    =>
    (retract ?c)
    (println "That task is already done!")
)

(defrule invalid_task
    ?c <- (command (action ?task))
    ?t <- (task 
        (id ~?task)
    )
    =>
    (retract ?c)
    (println "You cannot do this task.")
)

(defrule invalid_command
    (declare (salience -5))
    ?c <- (command)
    =>
    (retract ?c)
    (println "Invalid command")
)

(defrule quit
    (declare (salience 10))
    ?c <- (command (action q))
    =>
    (retract ?c)
    (println "Bye!")
    (halt)
)