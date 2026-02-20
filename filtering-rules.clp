;;; ============================================================
;;; filtering-rules.clp
;;; Eliminates laptop models that fail to meet derived requirements.
;;; Each rule asserts a (rejected) fact with a reason string.
;;; ============================================================
;;; ============================================================
;;; GROUP 4 — Filtering and Elimination Rules
;;; ============================================================
;;; Rule F1: Reject laptops with insufficient RAM
(defrule filter-insufficient-ram
(requirement (attribute min-ram) (numeric-value ?min))
(laptop (model ?m) (ram ?r))
(test (< ?r ?min))
(not (rejected (model ?m) (reason "Insufficient RAM")))
=>
(assert (rejected (model ?m) (reason "Insufficient RAM")))
(printout t "REJECTED: " ?m " — RAM " ?r " GB is below required " ?min " GB." crlf))
;;; Rule F2: Reject laptops without a discrete GPU when required
(defrule filter-no-discrete-gpu
(requirement (attribute gpu-type) (value discrete))
(laptop (model ?m) (gpu-type integrated))
(not (rejected (model ?m) (reason "No discrete GPU")))
=>
(assert (rejected (model ?m) (reason "No discrete GPU")))
(printout t "REJECTED: " ?m " — integrated GPU does not meet gaming/editing requirement." crlf))
;;; Rule F3: Reject laptops with low CPU tier when high tier required
(defrule filter-low-cpu-when-high-required
(requirement (attribute cpu-tier) (value high))
(laptop (model ?m) (cpu-tier ?c))
(test (or (eq ?c low) (eq ?c mid)))
(not (rejected (model ?m) (reason "CPU tier too low")))
=>
(assert (rejected (model ?m) (reason "CPU tier too low")))
(printout t "REJECTED: " ?m " — CPU tier " ?c " does not meet high-tier requirement." crlf))
;;; Rule F4: Reject laptops that exceed the maximum weight for portability
(defrule filter-too-heavy
(requirement (attribute max-weight) (numeric-value ?max))
(laptop (model ?m) (weight ?w))
(test (> ?w ?max))
(not (rejected (model ?m) (reason "Too heavy for portability")))
=>
(assert (rejected (model ?m) (reason "Too heavy for portability")))
(printout t "REJECTED: " ?m " — weight " ?w " kg exceeds portability limit of " ?max " kg." crlf))
;;; Rule F5: Reject laptops that exceed the maximum acceptable screen size
(defrule filter-screen-too-large
(requirement (attribute max-screen-size) (numeric-value ?max))
(laptop (model ?m) (screen-size ?s))
(test (and (< ?max 99) (> ?s ?max)))
(not (rejected (model ?m) (reason "Screen too large for portability")))
=>
(assert (rejected (model ?m) (reason "Screen too large for portability")))
(printout t "REJECTED: " ?m " — screen " ?s " inches exceeds compact limit of " ?max " inches." crlf))
;;; Rule F6: Reject low price-tier laptops when budget is medium and higher-tier available
;;;          (Only reject laptops above the allowed price tier)
(defrule filter-price-too-high-for-low-budget
(requirement (attribute max-price-tier) (value low))
(laptop (model ?m) (price-tier ?p))
(test (or (eq ?p medium) (eq ?p high)))
(not (rejected (model ?m) (reason "Exceeds low budget")))
=>
(assert (rejected (model ?m) (reason "Exceeds low budget")))
(printout t "REJECTED: " ?m " — price tier " ?p " exceeds allowed low budget." crlf))
;;; Rule F7: Reject high-price laptops when budget is medium
(defrule filter-price-too-high-for-medium-budget
(requirement (attribute max-price-tier) (value medium))
(laptop (model ?m) (price-tier high))
(not (rejected (model ?m) (reason "Exceeds medium budget")))
=>
(assert (rejected (model ?m) (reason "Exceeds medium budget")))
(printout t "REJECTED: " ?m " — price tier high exceeds allowed medium budget." crlf))
;;; Rule F8: Reject laptops without webcam when webcam is required
(defrule filter-no-webcam
(requirement (attribute webcam) (value yes))
(laptop (model ?m) (webcam no))
(not (rejected (model ?m) (reason "No webcam")))
=>
(assert (rejected (model ?m) (reason "No webcam")))
(printout t "REJECTED: " ?m " — webcam required but not available on this model." crlf))
;;; Rule F9: Reject HDD laptops when SSD is required
(defrule filter-no-ssd
(requirement (attribute storage-type) (value ssd))
(laptop (model ?m) (storage-type hdd))
(not (rejected (model ?m) (reason "No SSD storage")))
=>
(assert (rejected (model ?m) (reason "No SSD storage")))
(printout t "REJECTED: " ?m " — SSD required but this model uses HDD." crlf))