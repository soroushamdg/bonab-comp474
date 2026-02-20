;;; ============================================================
;;; recommendation-rules.clp
;;; Generates final recommendations from laptops not rejected.
;;; Also provides explanation output for each result.
;;; ============================================================
;;; ============================================================
;;; GROUP 5 — Final Recommendation Rules
;;; ============================================================
;;; Rule REC1: Any laptop not in the rejected set is recommended
(defrule recommend-valid-laptop
(laptop (model ?m))
(not (rejected (model ?m) (reason ?)))
(not (recommended (model ?m)))
=>
(assert (recommended (model ?m) (reason "Meets all derived requirements")))
(printout t "RECOMMENDED: " ?m " passes all requirement filters." crlf))
;;; Rule REC2: Print detailed summary for each recommended laptop
(defrule explain-recommended-laptop
(recommended (model ?m))
(laptop (model ?m)
(cpu-tier ?cpu)
(ram ?ram)
(storage-type ?storage)
(gpu-type ?gpu)
(screen-size ?screen)
(weight ?weight)
(price-tier ?price)
(category ?cat))
=>
(printout t "----------------------------------------------------" crlf)
(printout t "MODEL:    " ?m crlf)
(printout t "Category: " ?cat crlf)
(printout t "CPU Tier: " ?cpu crlf)
(printout t "RAM:      " ?ram " GB" crlf)
(printout t "Storage:  " ?storage crlf)
(printout t "GPU:      " ?gpu crlf)
(printout t "Screen:   " ?screen " inches" crlf)
(printout t "Weight:   " ?weight " kg" crlf)
(printout t "Price:    " ?price crlf)
(printout t "----------------------------------------------------" crlf))
;;; Rule REC3: Fallback — notify user if no laptop was recommended
(defrule no-recommendation-fallback
(not (recommended (model ?)))
(not (requirement (attribute min-ram)))   ; ensure requirements were processed
=>
(printout t "============================================" crlf)
(printout t "NO LAPTOP MATCHES ALL YOUR REQUIREMENTS." crlf)
(printout t "Consider relaxing your budget or portability constraints." crlf)
(printout t "============================================" crlf))
;;; Rule REC4: Print header before recommendations
(defrule print-recommendation-header
(declare (salience 10))
(recommended (model ?))
=>
(printout t "============================================" crlf)
(printout t "   LAPTOP RECOMMENDATION RESULTS           " crlf)
(printout t "============================================" crlf))
;;; Rule REC5: Print summary of rejected laptops count for transparency
(defrule print-rejection-summary
(declare (salience -10))
(not (recommended (model ?)))
=>
(printout t "INFO: Review the REJECTED lines above to understand why models were eliminated." crlf))
;;; Rule REC6: Explain user's primary use context at inference start
(defrule explain-user-context
(declare (salience 100))
(user (primary-use ?use) (budget-level ?budget) (portability ?port))
=>
(printout t "============================================" crlf)
(printout t "USER PROFILE" crlf)
(printout t "  Primary Use:  " ?use crlf)
(printout t "  Budget Level: " ?budget crlf)
(printout t "  Portability:  " ?port crlf)
(printout t "============================================" crlf)
(printout t "Beginning requirement inference..." crlf))