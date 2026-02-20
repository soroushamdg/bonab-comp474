;;; ============================================================
;;; test-case-2.clp
;;; Test Case 2: Enthusiast gamer
;;; Profile: Gaming | High Budget | Portability NO
;;; Expected: Discrete GPU, high CPU, any price, large screen allowed
;;; Run with: (batch "test-case-2.clp")
;;; ============================================================
(load "templates.clp")
(load "laptop-facts.clp")
(load "requirement-rules.clp")
(load "filtering-rules.clp")
(load "recommendation-rules.clp")
(reset)
(assert (user (primary-use    gaming)
(budget-level   high)
(portability    no)
(screen-pref    large)
(needs-webcam   no)))
(run)