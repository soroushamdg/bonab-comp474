;;; ============================================================
;;; requirement-rules.clp
;;; Infers system requirements from the user fact.
;;; Rule Groups:
;;;   1. Usage -> Requirements  (8 rules)
;;;   2. Budget Constraints     (4 rules)
;;;   3. Portability Rules      (4 rules)
;;; ============================================================
;;; ============================================================
;;; GROUP 1 — Usage -> Requirement Inference
;;; ============================================================
;;; Rule R1: Gaming requires a discrete GPU
(defrule req-gaming-needs-discrete-gpu
(user (primary-use gaming))
(not (requirement (attribute gpu-type) (value discrete)))
=>
(assert (requirement (attribute gpu-type) (value discrete)))
(printout t "REQUIREMENT: Gaming use requires a discrete GPU." crlf))
;;; Rule R2: Gaming requires a high-tier CPU
(defrule req-gaming-needs-high-cpu
(user (primary-use gaming))
(not (requirement (attribute cpu-tier) (value high)))
=>
(assert (requirement (attribute cpu-tier) (value high)))
(printout t "REQUIREMENT: Gaming use requires a high-tier CPU." crlf))
;;; Rule R3: Development requires at least 16 GB RAM
(defrule req-development-needs-ram
(user (primary-use development))
(not (requirement (attribute min-ram)))
=>
(assert (requirement (attribute min-ram) (value satisfied) (numeric-value 16)))
(printout t "REQUIREMENT: Development use requires at least 16 GB RAM." crlf))
;;; Rule R4: Editing requires at least 16 GB RAM
(defrule req-editing-needs-ram
(user (primary-use editing))
(not (requirement (attribute min-ram)))
=>
(assert (requirement (attribute min-ram) (value satisfied) (numeric-value 16)))
(printout t "REQUIREMENT: Editing use requires at least 16 GB RAM." crlf))
;;; Rule R5: Editing requires a high-tier CPU
(defrule req-editing-needs-high-cpu
(user (primary-use editing))
(not (requirement (attribute cpu-tier) (value high)))
=>
(assert (requirement (attribute cpu-tier) (value high)))
(printout t "REQUIREMENT: Editing use requires a high-tier CPU." crlf))
;;; Rule R6: Business use requires a webcam
(defrule req-business-needs-webcam
(user (primary-use business))
(not (requirement (attribute webcam) (value yes)))
=>
(assert (requirement (attribute webcam) (value yes)))
(printout t "REQUIREMENT: Business use requires a built-in webcam." crlf))
;;; Rule R7: Browsing and business are satisfied with 8 GB RAM minimum
(defrule req-browsing-min-ram
(user (primary-use browsing))
(not (requirement (attribute min-ram)))
=>
(assert (requirement (attribute min-ram) (value satisfied) (numeric-value 8)))
(printout t "REQUIREMENT: Browsing use requires at least 8 GB RAM." crlf))
;;; Rule R8: All uses benefit from SSD storage; assert as preferred
(defrule req-all-prefer-ssd
(user (primary-use ?u))
(test (or (eq ?u development) (eq ?u editing) (eq ?u gaming)))
(not (requirement (attribute storage-type) (value ssd)))
=>
(assert (requirement (attribute storage-type) (value ssd)))
(printout t "REQUIREMENT: Use case " ?u " requires SSD storage." crlf))
;;; ============================================================
;;; GROUP 2 — Budget Constraint Rules
;;; ============================================================
;;; Rule B1: Low budget — only low price-tier laptops allowed
(defrule budget-low-requires-low-tier
(user (budget-level low))
(not (requirement (attribute max-price-tier) (value low)))
=>
(assert (requirement (attribute max-price-tier) (value low)))
(printout t "BUDGET: Low budget — only low price-tier laptops will be considered." crlf))
;;; Rule B2: Medium budget — low and medium price-tier allowed
(defrule budget-medium-allows-medium-tier
(user (budget-level medium))
(not (requirement (attribute max-price-tier) (value medium)))
=>
(assert (requirement (attribute max-price-tier) (value medium)))
(printout t "BUDGET: Medium budget — low and medium price-tier laptops will be considered." crlf))
;;; Rule B3: High budget — all price tiers allowed (no price constraint asserted)
(defrule budget-high-no-restriction
(user (budget-level high))
(not (requirement (attribute max-price-tier) (value any)))
=>
(assert (requirement (attribute max-price-tier) (value any)))
(printout t "BUDGET: High budget — all price tiers are available." crlf))
;;; Rule B4: Gaming on low budget — issue advisory warning
(defrule budget-gaming-low-warning
(user (primary-use gaming) (budget-level low))
=>
(printout t "WARNING: Gaming on a low budget is very restrictive. Recommendations may be limited." crlf))
;;; ============================================================
;;; GROUP 3 — Portability Rules
;;; ============================================================
;;; Rule P1: Portability required — enforce weight limit of 1.6 kg
(defrule portability-requires-light-weight
(user (portability yes))
(not (requirement (attribute max-weight)))
=>
(assert (requirement (attribute max-weight) (value light) (numeric-value 1.6)))
(printout t "PORTABILITY: Portability required — laptops must weigh at most 1.6 kg." crlf))
;;; Rule P2: Portability required — prefer small or medium screen
(defrule portability-requires-small-screen
(user (portability yes))
(not (requirement (attribute max-screen-size)))
=>
(assert (requirement (attribute max-screen-size) (value compact) (numeric-value 14.1)))
(printout t "PORTABILITY: Portability required — screen size must be at most 14.1 inches." crlf))
;;; Rule P3: No portability requirement — allow large screens
(defrule no-portability-allow-large-screen
(user (portability no))
(not (requirement (attribute max-screen-size)))
=>
(assert (requirement (attribute max-screen-size) (value any) (numeric-value 99)))
(printout t "PORTABILITY: No portability constraint — large screens are acceptable." crlf))
;;; Rule P4: Gaming typically trades portability — advisory note
(defrule portability-gaming-advisory
(user (primary-use gaming) (portability yes))
=>
(printout t "ADVISORY: Gaming laptops tend to be heavy. Portability options will be limited." crlf))