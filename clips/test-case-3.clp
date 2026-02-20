;;; ============================================================
;;; test-case-3.clp
;;; Test Case 3: Early-career business professional
;;; Profile: Business | Low Budget | Portability NO
;;; Expected: Webcam required, low price-tier only, no GPU constraint
;;; Run with: (batch "test-case-3.clp")
;;; ============================================================
(load "templates.clp")
(load "laptop-facts.clp")
(load "requirement-rules.clp")
(load "filtering-rules.clp")
(load "recommendation-rules.clp")
(reset)
(assert (user (primary-use    business)
(budget-level   low)
(portability    no)
(screen-pref    any)
(needs-webcam   yes)))
(run)
