;;; ============================================================
;;; test-conflict-edge-case
;;; Test Case 1: University student developer
;;; Profile: gaming | Low Budget | Portability No
;;; Expected: No recommendation
;;; Run with: (batch "test-conflict-edge-case.clp")
;;; ============================================================
(load "templates.clp")
(load "laptop-facts.clp")
(load "requirement-rules.clp")
(load "filtering-rules.clp")
(load "recommendation-rules.clp")
(reset)
(assert (user (primary-use gaming)
              (budget-level low)
              (portability no)
              (screen-pref any)
              (needs-webcam no)))
(run)
