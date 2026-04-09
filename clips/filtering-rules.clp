;;; ============================================================
;;; filtering-rules.clp  (UPDATED)
;;; Eliminates laptop models that fail hard constraints.
;;;
;;; Rule Groups:
;;;   GROUP 4 (F1-F11)  : Hard constraint filters (unchanged)
;;;   GROUP 5 (C1-C9)   : Justification chain rules (NEW)
;;;
;;; GROUP 5 fires AFTER each rejection to assert a justification
;;; fact that explains WHY the failed constraint exists — forming
;;; a two-step reasoning chain:
;;;   "X attribute failed" -> "because Y use case demands X"
;;;
;;; Total: 11 + 9 = 20 rules
;;; ============================================================


;;; ============================================================
;;; GROUP 4 — Hard Constraint Filters (F1-F11)
;;; ============================================================

;;; Rule F1: Reject laptops with insufficient RAM
(defrule filter-insufficient-ram
   (requirement (attribute min-ram) (numeric-value ?min))
   (laptop (model ?m) (ram ?r))
   (test (< ?r ?min))
   (not (rejected (model ?m) (reason "Insufficient RAM")))
   =>
   (assert (rejected (model ?m) (reason "Insufficient RAM")))
   (printout t "REJECTED: " ?m " -- RAM " ?r " GB is below required " ?min " GB." crlf))

;;; Rule F2: Reject laptops without a discrete GPU when required
(defrule filter-no-discrete-gpu
   (requirement (attribute gpu-type) (value discrete))
   (laptop (model ?m) (gpu-type integrated))
   (not (rejected (model ?m) (reason "No discrete GPU")))
   =>
   (assert (rejected (model ?m) (reason "No discrete GPU")))
   (printout t "REJECTED: " ?m " -- integrated GPU does not meet gaming/editing requirement." crlf))

;;; Rule F3: Reject laptops with insufficient CPU tier
(defrule filter-low-cpu-when-high-required
   (requirement (attribute cpu-tier) (value high))
   (laptop (model ?m) (cpu-tier ?c))
   (test (or (eq ?c low) (eq ?c mid)))
   (not (rejected (model ?m) (reason "CPU tier too low")))
   =>
   (assert (rejected (model ?m) (reason "CPU tier too low")))
   (printout t "REJECTED: " ?m " -- CPU tier " ?c " does not meet high-tier requirement." crlf))

;;; Rule F4: Reject laptops that exceed maximum weight for portability
(defrule filter-too-heavy
   (requirement (attribute max-weight) (numeric-value ?max))
   (laptop (model ?m) (weight ?w))
   (test (> ?w ?max))
   (not (rejected (model ?m) (reason "Too heavy for portability")))
   =>
   (assert (rejected (model ?m) (reason "Too heavy for portability")))
   (printout t "REJECTED: " ?m " -- weight " ?w " kg exceeds portability limit of " ?max " kg." crlf))

;;; Rule F5: Reject laptops that exceed maximum acceptable screen size
(defrule filter-screen-too-large
   (requirement (attribute max-screen-size) (numeric-value ?max))
   (laptop (model ?m) (screen-size ?s))
   (test (and (< ?max 99) (> ?s ?max)))
   (not (rejected (model ?m) (reason "Screen too large")))
   =>
   (assert (rejected (model ?m) (reason "Screen too large")))
   (printout t "REJECTED: " ?m " -- screen " ?s " inches exceeds limit of " ?max " inches." crlf))

;;; Rule F6: Reject laptops above price tier for low budget users
(defrule filter-price-too-high-for-low-budget
   (requirement (attribute max-price-tier) (value low))
   (laptop (model ?m) (price-tier ?p))
   (test (or (eq ?p medium) (eq ?p high)))
   (not (rejected (model ?m) (reason "Exceeds low budget")))
   =>
   (assert (rejected (model ?m) (reason "Exceeds low budget")))
   (printout t "REJECTED: " ?m " -- price tier " ?p " exceeds allowed low budget." crlf))

;;; Rule F7: Reject high-price laptops for medium budget users
(defrule filter-price-too-high-for-medium-budget
   (requirement (attribute max-price-tier) (value medium))
   (laptop (model ?m) (price-tier high))
   (not (rejected (model ?m) (reason "Exceeds medium budget")))
   =>
   (assert (rejected (model ?m) (reason "Exceeds medium budget")))
   (printout t "REJECTED: " ?m " -- price tier high exceeds allowed medium budget." crlf))

;;; Rule F8: Reject laptops without webcam when webcam is required
(defrule filter-no-webcam
   (requirement (attribute webcam) (value yes))
   (laptop (model ?m) (webcam no))
   (not (rejected (model ?m) (reason "No webcam")))
   =>
   (assert (rejected (model ?m) (reason "No webcam")))
   (printout t "REJECTED: " ?m " -- webcam required but not present on this model." crlf))

;;; Rule F9: Reject HDD laptops when SSD is required
(defrule filter-no-ssd
   (requirement (attribute storage-type) (value ssd))
   (laptop (model ?m) (storage-type hdd))
   (not (rejected (model ?m) (reason "No SSD storage")))
   =>
   (assert (rejected (model ?m) (reason "No SSD storage")))
   (printout t "REJECTED: " ?m " -- SSD required but this model uses HDD." crlf))

;;; Rule F10: Reject discrete GPU laptops for use cases that do not need one
(defrule filter-unnecessary-discrete-gpu
   (requirement (attribute no-discrete-gpu) (value yes))
   (laptop (model ?m) (gpu-type discrete))
   (not (rejected (model ?m) (reason "Discrete GPU unnecessary for this use case")))
   =>
   (assert (rejected (model ?m) (reason "Discrete GPU unnecessary for this use case")))
   (printout t "REJECTED: " ?m " -- discrete GPU is unnecessary and adds cost/weight for this use case." crlf))

;;; Rule F11: Reject gaming-category laptops for non-gaming users
(defrule filter-gaming-category-for-non-gaming-user
   (user (primary-use ?u))
   (test (not (eq ?u gaming)))
   (laptop (model ?m) (category gaming))
   (not (rejected (model ?m) (reason "Gaming category unsuitable for this use case")))
   =>
   (assert (rejected (model ?m) (reason "Gaming category unsuitable for this use case")))
   (printout t "REJECTED: " ?m " -- gaming-category laptop is unsuitable for " ?u " use." crlf))


;;; ============================================================
;;; GROUP 5 — Justification Chain Rules (C1-C9)
;;;
;;; Each rule fires when a specific rejection reason exists in
;;; working memory and the relevant user/requirement context is
;;; available. It asserts a justification fact and prints a
;;; two-step explanation chain:
;;;
;;;   "CHAIN [model]: <what failed> -> <why that was required>"
;;;
;;; The 'not (justification ...)' guard prevents duplicate chains
;;; for the same model and constraint combination.
;;; ============================================================

;;; Rule C1: Explain RAM rejection
;;; Chain: actual RAM < minimum -> use case demands that minimum
(defrule chain-ram-rejection
   (rejected (model ?m) (reason "Insufficient RAM"))
   (requirement (attribute min-ram) (numeric-value ?min))
   (laptop (model ?m) (ram ?actual))
   (user (primary-use ?use))
   (not (justification (model ?m) (constraint ram-below-minimum)))
   =>
   (assert (justification
      (model ?m)
      (constraint ram-below-minimum)
      (caused-by (str-cat ?use " use case demands minimum RAM threshold"))))
   (printout t "  CHAIN [" ?m "]: RAM " ?actual " GB < " ?min " GB minimum"
             " -> " ?use " workload requires >= " ?min " GB." crlf))

;;; Rule C2: Explain discrete GPU rejection (hardware requirement)
;;; Chain: has integrated GPU -> gaming/editing requires discrete
(defrule chain-gpu-requirement-rejection
   (rejected (model ?m) (reason "No discrete GPU"))
   (user (primary-use ?use))
   (not (justification (model ?m) (constraint no-discrete-gpu-present)))
   =>
   (assert (justification
      (model ?m)
      (constraint no-discrete-gpu-present)
      (caused-by (str-cat ?use " use case requires discrete GPU for performance"))))
   (printout t "  CHAIN [" ?m "]: integrated GPU present"
             " -> " ?use " use case requires discrete GPU." crlf))

;;; Rule C3: Explain CPU tier rejection
;;; Chain: CPU tier too low -> gaming/editing requires high-tier CPU
(defrule chain-cpu-rejection
   (rejected (model ?m) (reason "CPU tier too low"))
   (laptop (model ?m) (cpu-tier ?actual-cpu))
   (user (primary-use ?use))
   (not (justification (model ?m) (constraint cpu-tier-insufficient)))
   =>
   (assert (justification
      (model ?m)
      (constraint cpu-tier-insufficient)
      (caused-by (str-cat ?use " use case requires high-tier CPU"))))
   (printout t "  CHAIN [" ?m "]: CPU tier " ?actual-cpu
             " -> " ?use " use case requires high-tier CPU." crlf))

;;; Rule C4: Explain weight rejection
;;; Chain: weight over limit -> user requires portability
(defrule chain-weight-rejection
   (rejected (model ?m) (reason "Too heavy for portability"))
   (laptop (model ?m) (weight ?w))
   (requirement (attribute max-weight) (numeric-value ?max))
   (not (justification (model ?m) (constraint weight-exceeds-portability-limit)))
   =>
   (assert (justification
      (model ?m)
      (constraint weight-exceeds-portability-limit)
      (caused-by "user requires portability (weight <= 1.6 kg)")))
   (printout t "  CHAIN [" ?m "]: weight " ?w " kg > " ?max " kg limit"
             " -> user requires portability." crlf))

;;; Rule C5: Explain screen size rejection
;;; Chain: screen too large -> portability or screen preference constraint
(defrule chain-screen-rejection
   (rejected (model ?m) (reason "Screen too large"))
   (laptop (model ?m) (screen-size ?s))
   (requirement (attribute max-screen-size) (numeric-value ?max))
   (user (portability ?port) (screen-pref ?pref))
   (not (justification (model ?m) (constraint screen-exceeds-size-limit)))
   =>
   (assert (justification
      (model ?m)
      (constraint screen-exceeds-size-limit)
      (caused-by (str-cat "portability=" ?port " screen-pref=" ?pref " limits screen to " ?max " inches"))))
   (printout t "  CHAIN [" ?m "]: screen " ?s "\" > " ?max "\" limit"
             " -> portability=" ?port " / screen-pref=" ?pref "." crlf))

;;; Rule C6: Explain low-budget rejection
;;; Chain: price tier too high -> user declared low budget
(defrule chain-budget-low-rejection
   (rejected (model ?m) (reason "Exceeds low budget"))
   (laptop (model ?m) (price-tier ?p))
   (not (justification (model ?m) (constraint price-exceeds-low-budget)))
   =>
   (assert (justification
      (model ?m)
      (constraint price-exceeds-low-budget)
      (caused-by "user declared low budget -- only low price-tier permitted")))
   (printout t "  CHAIN [" ?m "]: price tier " ?p
             " -> user budget is low, only low-tier models allowed." crlf))

;;; Rule C7: Explain medium-budget rejection
;;; Chain: high price tier -> user declared medium budget
(defrule chain-budget-medium-rejection
   (rejected (model ?m) (reason "Exceeds medium budget"))
   (not (justification (model ?m) (constraint price-exceeds-medium-budget)))
   =>
   (assert (justification
      (model ?m)
      (constraint price-exceeds-medium-budget)
      (caused-by "user declared medium budget -- high price-tier excluded")))
   (printout t "  CHAIN [" ?m "]: price tier high"
             " -> user budget is medium, high-tier models excluded." crlf))

;;; Rule C8: Explain unnecessary discrete GPU rejection
;;; Chain: has discrete GPU -> browsing/business does not need it
(defrule chain-unnecessary-gpu-rejection
   (rejected (model ?m) (reason "Discrete GPU unnecessary for this use case"))
   (user (primary-use ?use))
   (not (justification (model ?m) (constraint discrete-gpu-not-needed)))
   =>
   (assert (justification
      (model ?m)
      (constraint discrete-gpu-not-needed)
      (caused-by (str-cat ?use " use case gains no benefit from discrete GPU"))))
   (printout t "  CHAIN [" ?m "]: has discrete GPU"
             " -> " ?use " use case does not require GPU acceleration." crlf))

;;; Rule C9: Explain gaming-category rejection
;;; Chain: gaming category -> non-gaming user does not benefit
(defrule chain-gaming-category-rejection
   (rejected (model ?m) (reason "Gaming category unsuitable for this use case"))
   (user (primary-use ?use))
   (not (justification (model ?m) (constraint gaming-category-mismatch)))
   =>
   (assert (justification
      (model ?m)
      (constraint gaming-category-mismatch)
      (caused-by (str-cat ?use " use case does not benefit from gaming-optimised design"))))
   (printout t "  CHAIN [" ?m "]: gaming category"
             " -> " ?use " user does not need gaming thermal/noise trade-offs." crlf))
