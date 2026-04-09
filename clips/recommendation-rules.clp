;;; ============================================================
;;; recommendation-rules.clp  (UPGRADED)
;;;
;;; Three major upgrades over the original:
;;;
;;; 1. EXPLANATION CHAINS
;;;    Justification facts are asserted in filtering-rules.clp.
;;;    This file uses them to produce traceable reasoning output.
;;;
;;; 2. SOFT CONSTRAINTS + SCORING
;;;    Hard filters eliminate models (reject or pass).
;;;    Soft rules award points to surviving models for preferred
;;;    but non-mandatory attributes: screen size match, RAM
;;;    headroom, weight, and CPU tier. Each criterion asserts an
;;;    individual (score ...) fact for full traceability.
;;;    A total-score is computed per model from laptop attributes.
;;;
;;; 3. RANKED RECOMMENDATIONS
;;;    Surviving models are ranked best / second / other based on
;;;    their total soft score. Output is labelled accordingly.
;;;
;;; Rule Groups:
;;;   REC1, REC3, REC5, REC6  : Core recommendation logic (4)
;;;   SC1-SC8                  : Soft constraint scoring    (8)
;;;   TS1                      : Total score computation    (1)
;;;   RK1-RK3                  : Ranking rules              (3)
;;;   PR1-PR4                  : Ranked print rules         (4)
;;;                     Total: 20 rules
;;; ============================================================


;;; ============================================================
;;; CORE RECOMMENDATION LOGIC
;;; ============================================================

;;; Rule REC6: Print user profile at the start of every session
;;; Fires first due to high salience.
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

;;; Rule REC1: Any laptop not in the rejected set passes hard filters
(defrule recommend-valid-laptop
   (laptop (model ?m))
   (not (rejected (model ?m) (reason ?)))
   (not (recommended (model ?m)))
   =>
   (assert (recommended (model ?m) (reason "Meets all hard constraints")))
   (printout t "PASSED FILTERS: " ?m crlf))

;;; Rule REC3: Fallback when no laptop survives all hard filters
(defrule no-recommendation-fallback
   (not (recommended (model ?)))
   (not (requirement (attribute min-ram)))
   =>
   (printout t "============================================" crlf)
   (printout t "NO LAPTOP MATCHES ALL YOUR REQUIREMENTS." crlf)
   (printout t "Consider relaxing budget or portability constraints." crlf)
   (printout t "============================================" crlf))

;;; Rule REC5: Advise user to review rejection chain when no result
(defrule print-rejection-summary
   (declare (salience -10))
   (not (recommended (model ?)))
   =>
   (printout t "INFO: Review CHAIN lines above for full reasoning." crlf))


;;; ============================================================
;;; SOFT CONSTRAINT SCORING  (SC1-SC8, salience -5)
;;;
;;; These rules fire only for RECOMMENDED (surviving) models.
;;; Each rule evaluates one soft criterion and, if satisfied,
;;; asserts a (score ...) fact with a point value and reason.
;;; Scores do NOT eliminate models -- they influence ranking only.
;;; ============================================================

;;; Rule SC1: Reward large-screen models for large-screen preference
(defrule score-screen-match-large
   (declare (salience -5))
   (recommended (model ?m))
   (user (screen-pref large))
   (laptop (model ?m) (screen-size ?s))
   (test (> ?s 15.6))
   (not (score (model ?m) (reason "Screen size matches large preference")))
   =>
   (assert (score (model ?m) (points 2) (reason "Screen size matches large preference"))))

;;; Rule SC2: Reward medium-screen models for medium-screen preference
(defrule score-screen-match-medium
   (declare (salience -5))
   (recommended (model ?m))
   (user (screen-pref medium))
   (laptop (model ?m) (screen-size ?s))
   (test (and (>= ?s 14) (<= ?s 15.6)))
   (not (score (model ?m) (reason "Screen size matches medium preference")))
   =>
   (assert (score (model ?m) (points 2) (reason "Screen size matches medium preference"))))

;;; Rule SC3: Reward small-screen models for small-screen preference
(defrule score-screen-match-small
   (declare (salience -5))
   (recommended (model ?m))
   (user (screen-pref small))
   (laptop (model ?m) (screen-size ?s))
   (test (<= ?s 13.5))
   (not (score (model ?m) (reason "Screen size matches small preference")))
   =>
   (assert (score (model ?m) (points 2) (reason "Screen size matches small preference"))))

;;; Rule SC4: Reward high RAM (32+ GB) — strong headroom for any workload
(defrule score-ram-high
   (declare (salience -5))
   (recommended (model ?m))
   (laptop (model ?m) (ram ?r))
   (test (>= ?r 32))
   (not (score (model ?m) (reason "High RAM: 32+ GB")))
   =>
   (assert (score (model ?m) (points 2) (reason "High RAM: 32+ GB"))))

;;; Rule SC5: Reward adequate RAM (16-31 GB)
(defrule score-ram-adequate
   (declare (salience -5))
   (recommended (model ?m))
   (laptop (model ?m) (ram ?r))
   (test (and (>= ?r 16) (< ?r 32)))
   (not (score (model ?m) (reason "Adequate RAM: 16-31 GB")))
   =>
   (assert (score (model ?m) (points 1) (reason "Adequate RAM: 16-31 GB"))))

;;; Rule SC6: Reward very lightweight models (under 1.4 kg)
(defrule score-very-lightweight
   (declare (salience -5))
   (recommended (model ?m))
   (laptop (model ?m) (weight ?w))
   (test (< ?w 1.4))
   (not (score (model ?m) (reason "Very lightweight: under 1.4 kg")))
   =>
   (assert (score (model ?m) (points 2) (reason "Very lightweight: under 1.4 kg"))))

;;; Rule SC7: Reward lightweight models (1.4 kg to under 1.6 kg)
(defrule score-lightweight
   (declare (salience -5))
   (recommended (model ?m))
   (laptop (model ?m) (weight ?w))
   (test (and (>= ?w 1.4) (< ?w 1.6)))
   (not (score (model ?m) (reason "Lightweight: 1.4-1.6 kg")))
   =>
   (assert (score (model ?m) (points 1) (reason "Lightweight: 1.4-1.6 kg"))))

;;; Rule SC8: Reward high-tier CPU — best processing headroom
(defrule score-high-cpu
   (declare (salience -5))
   (recommended (model ?m))
   (laptop (model ?m) (cpu-tier high))
   (not (score (model ?m) (reason "High-tier CPU")))
   =>
   (assert (score (model ?m) (points 1) (reason "High-tier CPU"))))


;;; ============================================================
;;; TOTAL SCORE COMPUTATION  (TS1, salience -10)
;;;
;;; Computes a single aggregate score per recommended model by
;;; evaluating all soft criteria directly from laptop attributes.
;;; This is independent of the individual score facts (which are
;;; used for display only). Uses bind + if-then on the RHS,
;;; which is valid in CLIPS 6.x.
;;;
;;; Maximum possible score: 8 points
;;;   screen match:    2
;;;   RAM headroom:    2
;;;   weight:          2
;;;   CPU tier high:   1
;;;   portability bonus (weight < 1.4): already covered above
;;; ============================================================

(defrule compute-total-score
   (declare (salience -10))
   (recommended (model ?m))
   (laptop (model ?m) (ram ?ram) (cpu-tier ?cpu) (weight ?w) (screen-size ?s))
   (user (screen-pref ?pref))
   (not (total-score (model ?m)))
   =>
   (bind ?pts 0)
   ;;; Screen preference match (+2)
   (if (and (eq ?pref large) (> ?s 15.6))   then (bind ?pts (+ ?pts 2)))
   (if (and (eq ?pref medium) (and (>= ?s 14) (<= ?s 15.6))) then (bind ?pts (+ ?pts 2)))
   (if (and (eq ?pref small) (<= ?s 13.5))  then (bind ?pts (+ ?pts 2)))
   ;;; RAM headroom (+2 for 32+ GB, +1 for 16-31 GB)
   (if (>= ?ram 32) then (bind ?pts (+ ?pts 2))
    else (if (>= ?ram 16) then (bind ?pts (+ ?pts 1))))
   ;;; Weight bonus (+2 for < 1.4 kg, +1 for 1.4-1.6 kg)
   (if (< ?w 1.4) then (bind ?pts (+ ?pts 2))
    else (if (< ?w 1.6) then (bind ?pts (+ ?pts 1))))
   ;;; CPU tier bonus (+1 for high)
   (if (eq ?cpu high) then (bind ?pts (+ ?pts 1)))
   (assert (total-score (model ?m) (value ?pts))))


;;; ============================================================
;;; RANKING RULES  (RK1-RK3, salience -20 to -30)
;;;
;;; RK1 fires first and marks the model with the highest total
;;; score as best. The not-pattern "no other model has a higher
;;; score" uniquely identifies the top model.
;;;
;;; RK2 finds the model with the second-highest score among all
;;; non-best models by checking that no other non-best model
;;; scores higher.
;;;
;;; RK3 marks all remaining recommended models as other.
;;; ============================================================

;;; Rule RK1: Best match — highest total soft score
(defrule rank-best-match
   (declare (salience -20))
   (total-score (model ?m) (value ?s))
   (not (total-score (model ?other&~?m) (value ?s2&:(> ?s2 ?s))))
   (not (ranked-recommendation (model ?m)))
   =>
   (assert (ranked-recommendation (model ?m) (rank best))))

;;; Rule RK2: Second best — highest score among non-best survivors
(defrule rank-second-match
   (declare (salience -25))
   (ranked-recommendation (model ?best) (rank best))
   (total-score (model ?m) (value ?s))
   (test (neq ?m ?best))
   (not (ranked-recommendation (model ?m)))
   (not (and (total-score (model ?other) (value ?s2))
             (test (and (neq ?other ?best) (neq ?other ?m) (> ?s2 ?s)))))
   =>
   (assert (ranked-recommendation (model ?m) (rank second))))

;;; Rule RK3: All other survivors receive the other rank
(defrule rank-other-match
   (declare (salience -30))
   (recommended (model ?m))
   (total-score (model ?m) (value ?))
   (not (ranked-recommendation (model ?m)))
   =>
   (assert (ranked-recommendation (model ?m) (rank other))))


;;; ============================================================
;;; RANKED PRINT RULES  (PR1-PR4, salience -40 to -55)
;;;
;;; Print rules fire after all ranking is complete.
;;; A single header fires once (PR-HDR).
;;; PR1 prints the BEST MATCH block (fires once).
;;; PR2 prints the SECOND BEST block (fires once).
;;; PR3 prints any OTHER recommendations (fires once per model).
;;; Each block includes the hardware profile AND the soft score
;;; criteria that were satisfied, using do-for-all-facts to
;;; iterate over the individual score facts for that model.
;;; ============================================================

;;; Rule PR-HDR: Print recommendation section header once
(defrule print-results-header
   (declare (salience -35))
   (ranked-recommendation (model ?) (rank best))
   =>
   (printout t crlf)
   (printout t "============================================" crlf)
   (printout t "   LAPTOP RECOMMENDATION RESULTS           " crlf)
   (printout t "============================================" crlf))

;;; Rule PR1: Print BEST MATCH recommendation
(defrule print-best-recommendation
   (declare (salience -40))
   (ranked-recommendation (model ?m) (rank best))
   (laptop (model ?m) (cpu-tier ?cpu) (ram ?ram) (storage-type ?storage)
           (gpu-type ?gpu) (screen-size ?screen) (weight ?weight)
           (price-tier ?price) (category ?cat))
   (total-score (model ?m) (value ?pts))
   =>
   (printout t crlf)
   (printout t "  BEST MATCH  [Soft Score: " ?pts "/8 pts]" crlf)
   (printout t "----------------------------------------------------" crlf)
   (printout t "  MODEL:    " ?m crlf)
   (printout t "  Category: " ?cat crlf)
   (printout t "  CPU Tier: " ?cpu crlf)
   (printout t "  RAM:      " ?ram " GB" crlf)
   (printout t "  Storage:  " ?storage crlf)
   (printout t "  GPU:      " ?gpu crlf)
   (printout t "  Screen:   " ?screen " inches" crlf)
   (printout t "  Weight:   " ?weight " kg" crlf)
   (printout t "  Price:    " ?price crlf)
   (printout t "  SOFT CRITERIA MET:" crlf)
   (do-for-all-facts ((?sc score)) (eq ?sc:model ?m)
      (printout t "    + " ?sc:reason " (+" ?sc:points " pts)" crlf))
   (printout t "----------------------------------------------------" crlf))

;;; Rule PR2: Print SECOND BEST recommendation
(defrule print-second-recommendation
   (declare (salience -45))
   (ranked-recommendation (model ?m) (rank second))
   (laptop (model ?m) (cpu-tier ?cpu) (ram ?ram) (storage-type ?storage)
           (gpu-type ?gpu) (screen-size ?screen) (weight ?weight)
           (price-tier ?price) (category ?cat))
   (total-score (model ?m) (value ?pts))
   =>
   (printout t crlf)
   (printout t "  SECOND BEST  [Soft Score: " ?pts "/8 pts]" crlf)
   (printout t "----------------------------------------------------" crlf)
   (printout t "  MODEL:    " ?m crlf)
   (printout t "  Category: " ?cat crlf)
   (printout t "  CPU Tier: " ?cpu crlf)
   (printout t "  RAM:      " ?ram " GB" crlf)
   (printout t "  Storage:  " ?storage crlf)
   (printout t "  GPU:      " ?gpu crlf)
   (printout t "  Screen:   " ?screen " inches" crlf)
   (printout t "  Weight:   " ?weight " kg" crlf)
   (printout t "  Price:    " ?price crlf)
   (printout t "  SOFT CRITERIA MET:" crlf)
   (do-for-all-facts ((?sc score)) (eq ?sc:model ?m)
      (printout t "    + " ?sc:reason " (+" ?sc:points " pts)" crlf))
   (printout t "----------------------------------------------------" crlf))

;;; Rule PR3: Print OTHER recommendations (fires once per remaining model)
(defrule print-other-recommendation
   (declare (salience -50))
   (ranked-recommendation (model ?m) (rank other))
   (laptop (model ?m) (cpu-tier ?cpu) (ram ?ram) (storage-type ?storage)
           (gpu-type ?gpu) (screen-size ?screen) (weight ?weight)
           (price-tier ?price) (category ?cat))
   (total-score (model ?m) (value ?pts))
   =>
   (printout t crlf)
   (printout t "  ALSO RECOMMENDED  [Soft Score: " ?pts "/8 pts]" crlf)
   (printout t "----------------------------------------------------" crlf)
   (printout t "  MODEL:    " ?m crlf)
   (printout t "  Category: " ?cat crlf)
   (printout t "  CPU Tier: " ?cpu crlf)
   (printout t "  RAM:      " ?ram " GB" crlf)
   (printout t "  Storage:  " ?storage crlf)
   (printout t "  GPU:      " ?gpu crlf)
   (printout t "  Screen:   " ?screen " inches" crlf)
   (printout t "  Weight:   " ?weight " kg" crlf)
   (printout t "  Price:    " ?price crlf)
   (printout t "  SOFT CRITERIA MET:" crlf)
   (do-for-all-facts ((?sc score)) (eq ?sc:model ?m)
      (printout t "    + " ?sc:reason " (+" ?sc:points " pts)" crlf))
   (printout t "----------------------------------------------------" crlf))
