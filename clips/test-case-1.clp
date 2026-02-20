;;; ============================================================
;;; test-case-1.clp
;;; Test Case 1: University student developer
;;; Profile: Development | Medium Budget | Portability YES
;;; Expected: Lightweight laptops with >=16GB RAM, SSD, medium price
;;; Run with: (batch "test-case-1.clp")
;;; ============================================================
(load "templates.clp")
(load "laptop-facts.clp")
(load "requirement-rules.clp")
(load "filtering-rules.clp")
(load "recommendation-rules.clp")
(reset)
(assert (user (primary-use    development)
(budget-level   medium)
(portability    yes)
(screen-pref    medium)
(needs-webcam   yes)))
(run)