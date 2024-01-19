(deftemplate task
    (slot id)
    (slot activated)
    (slot outcome (default none))
)

(deftemplate cycle
    (slot task_id)
    (slot until_outcome)
)

(deftemplate command
    (multislot action)
)

(deftemplate clock
    (slot time)
)