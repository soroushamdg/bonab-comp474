;;; ============================================================
;;; requirement-rules.clp  (UPDATED)
;;; Infers system requirements from the user fact.
;;;
;;; Rule Groups:
;;;   1. Usage -> Requirements        (8 rules)
;;;   2. Budget Constraints           (4 rules)
;;;   3. Portability Rules            (4 rules)
;;;   4. Screen Preference Rules      (4 rules)
;;;   5. Webcam Rule                  (1 rule)
;;;   6. GPU Suitability Rules        (3 rules)
;;;                            Total: 24 rules
;;; ============================================================


;;; ============================================================
;;; GROUP 1 — Usage -> Requirement Inference (8 rules)
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

;;; Rule R4: Editing requires at least 32 GB RAM
;;; Video and photo editing workloads are RAM-intensive.
;;; 16 GB is insufficient for professional creative workflows.
(defrule req-editing-needs-ram
   (user (primary-use editing))
   (not (requirement (attribute min-ram)))
   =>
   (assert (requirement (attribute min-ram) (value satisfied) (numeric-value 32)))
   (printout t "REQUIREMENT: Editing use requires at least 32 GB RAM." crlf))

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

;;; Rule R7: Browsing requires minimum 8 GB RAM
(defrule req-browsing-min-ram
   (user (primary-use browsing))
   (not (requirement (attribute min-ram)))
   =>
   (assert (requirement (attribute min-ram) (value satisfied) (numeric-value 8)))
   (printout t "REQUIREMENT: Browsing use requires at least 8 GB RAM." crlf))

;;; Rule R8: Development, editing, and gaming require SSD storage
(defrule req-intensive-use-needs-ssd
   (user (primary-use ?u))
   (test (or (eq ?u development) (eq ?u editing) (eq ?u gaming)))
   (not (requirement (attribute storage-type) (value ssd)))
   =>
   (assert (requirement (attribute storage-type) (value ssd)))
   (printout t "REQUIREMENT: Use case " ?u " requires SSD storage." crlf))


;;; ============================================================
;;; GROUP 2 — Budget Constraint Rules (4 rules)
;;; ============================================================

;;; Rule B1: Low budget — only low price-tier laptops allowed
(defrule budget-low-requires-low-tier
   (user (budget-level low))
   (not (requirement (attribute max-price-tier) (value low)))
   =>
   (assert (requirement (attribute max-price-tier) (value low)))
   (printout t "BUDGET: Low budget -- only low price-tier laptops will be considered." crlf))

;;; Rule B2: Medium budget — low and medium price-tier allowed
(defrule budget-medium-allows-medium-tier
   (user (budget-level medium))
   (not (requirement (attribute max-price-tier) (value medium)))
   =>
   (assert (requirement (attribute max-price-tier) (value medium)))
   (printout t "BUDGET: Medium budget -- low and medium price-tier laptops will be considered." crlf))

;;; Rule B3: High budget — all price tiers allowed
(defrule budget-high-no-restriction
   (user (budget-level high))
   (not (requirement (attribute max-price-tier) (value any)))
   =>
   (assert (requirement (attribute max-price-tier) (value any)))
   (printout t "BUDGET: High budget -- all price tiers are available." crlf))

;;; Rule B4: Gaming on low budget — advisory warning
(defrule budget-gaming-low-warning
   (user (primary-use gaming) (budget-level low))
   =>
   (printout t "WARNING: Gaming on a low budget is very restrictive. Recommendations may be limited." crlf))


;;; ============================================================
;;; GROUP 3 — Portability Rules (4 rules)
;;; Portability rules handle screen size ONLY when portability=yes.
;;; When portability=no, screen-pref rules (Group 4) apply.
;;; ============================================================

;;; Rule P1: Portability required — enforce weight limit of 1.6 kg
(defrule portability-requires-light-weight
   (user (portability yes))
   (not (requirement (attribute max-weight)))
   =>
   (assert (requirement (attribute max-weight) (value light) (numeric-value 1.6)))
   (printout t "PORTABILITY: Portability required -- laptops must weigh at most 1.6 kg." crlf))

;;; Rule P2: Portability required — enforce compact screen limit
(defrule portability-requires-small-screen
   (user (portability yes))
   (not (requirement (attribute max-screen-size)))
   =>
   (assert (requirement (attribute max-screen-size) (value compact) (numeric-value 14.1)))
   (printout t "PORTABILITY: Portability required -- screen size must be at most 14.1 inches." crlf))

;;; Rule P3: No portability constraint — print advisory only
;;;          Screen size is handled by Group 4 (screen-pref rules)
(defrule no-portability-advisory
   (user (portability no))
   =>
   (printout t "PORTABILITY: No portability constraint -- weight and screen size unrestricted by portability." crlf))

;;; Rule P4: Gaming + portability advisory
(defrule portability-gaming-advisory
   (user (primary-use gaming) (portability yes))
   =>
   (printout t "ADVISORY: Gaming laptops tend to be heavy. Portability options will be limited." crlf))


;;; ============================================================
;;; GROUP 4 — Screen Preference Rules (4 rules)
;;; Active ONLY when portability=no (portability rules cover yes).
;;; Maps symbolic screen-pref to a numeric max-screen-size.
;;;   small  ->  <= 13.5 inches
;;;   medium ->  <= 15.6 inches
;;;   large  ->  unrestricted (99 sentinel)
;;;   any    ->  unrestricted (99 sentinel)
;;; ============================================================

;;; Rule S1: No portability + small screen preference
(defrule screen-pref-small
   (user (portability no) (screen-pref small))
   (not (requirement (attribute max-screen-size)))
   =>
   (assert (requirement (attribute max-screen-size) (value small) (numeric-value 13.5)))
   (printout t "SCREEN: Small screen preference -- laptops must have screen <= 13.5 inches." crlf))

;;; Rule S2: No portability + medium screen preference
(defrule screen-pref-medium
   (user (portability no) (screen-pref medium))
   (not (requirement (attribute max-screen-size)))
   =>
   (assert (requirement (attribute max-screen-size) (value medium) (numeric-value 15.6)))
   (printout t "SCREEN: Medium screen preference -- laptops must have screen <= 15.6 inches." crlf))

;;; Rule S3: No portability + large screen preference (no restriction)
(defrule screen-pref-large
   (user (portability no) (screen-pref large))
   (not (requirement (attribute max-screen-size)))
   =>
   (assert (requirement (attribute max-screen-size) (value any) (numeric-value 99)))
   (printout t "SCREEN: Large screen preference -- no screen size restriction applied." crlf))

;;; Rule S4: No portability + any screen preference (no restriction)
(defrule screen-pref-any
   (user (portability no) (screen-pref any))
   (not (requirement (attribute max-screen-size)))
   =>
   (assert (requirement (attribute max-screen-size) (value any) (numeric-value 99)))
   (printout t "SCREEN: No screen size preference -- no screen size restriction applied." crlf))


;;; ============================================================
;;; GROUP 5 — Webcam Rule (1 rule)
;;; Activates for ANY use case where user explicitly requires webcam.
;;; (Business use already asserts this via R6 -- the 'not' guard
;;;  prevents a duplicate requirement fact.)
;;; ============================================================

;;; Rule W1: User explicitly requires a built-in webcam
(defrule req-user-needs-webcam
   (user (needs-webcam yes))
   (not (requirement (attribute webcam) (value yes)))
   =>
   (assert (requirement (attribute webcam) (value yes)))
   (printout t "REQUIREMENT: User requires a built-in webcam." crlf))


;;; ============================================================
;;; GROUP 6 — GPU Suitability Rules (3 rules)
;;; Browsing and business use cases have no need for a discrete GPU.
;;; A discrete GPU adds cost, heat, and weight without benefit for
;;; these workloads. Asserting no-discrete-gpu triggers filtering.
;;; Development is excluded: some developers run local ML workloads
;;; or GPU-accelerated tools and may benefit from discrete graphics.
;;; ============================================================

;;; Rule G1: Browsing users do not need a discrete GPU
(defrule req-browsing-no-discrete-gpu
   (user (primary-use browsing))
   (not (requirement (attribute no-discrete-gpu) (value yes)))
   =>
   (assert (requirement (attribute no-discrete-gpu) (value yes)))
   (printout t "REQUIREMENT: Browsing use does not require a discrete GPU -- excluding gaming-tier machines." crlf))

;;; Rule G2: Business users do not need a discrete GPU
(defrule req-business-no-discrete-gpu
   (user (primary-use business))
   (not (requirement (attribute no-discrete-gpu) (value yes)))
   =>
   (assert (requirement (attribute no-discrete-gpu) (value yes)))
   (printout t "REQUIREMENT: Business use does not require a discrete GPU -- excluding gaming-tier machines." crlf))

;;; Rule G3: Editing users require a discrete GPU
;;; GPU acceleration is essential for timeline rendering, effects
;;; processing, and export in professional editing applications.
(defrule req-editing-needs-discrete-gpu
   (user (primary-use editing))
   (not (requirement (attribute gpu-type) (value discrete)))
   =>
   (assert (requirement (attribute gpu-type) (value discrete)))
   (printout t "REQUIREMENT: Editing use requires a discrete GPU for accelerated rendering." crlf))
