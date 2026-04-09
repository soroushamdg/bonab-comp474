;;; ============================================================
;;; templates.clp
;;; Defines all deftemplates used by the laptop expert system.
;;;
;;; Templates:
;;;   user                 -- user input profile
;;;   laptop               -- laptop model fact
;;;   requirement          -- derived hardware requirement
;;;   rejected             -- hard-constraint elimination record
;;;   recommended          -- candidate that passed all hard filters
;;;   justification        -- explanation chain for each rejection
;;;   score                -- individual soft-constraint point award
;;;   total-score          -- aggregated soft score per model
;;;   ranked-recommendation -- final ranked output label
;;; ============================================================


;;; ----------------------------------------------------------
;;; User profile — collected before inference begins
;;; ----------------------------------------------------------
(deftemplate user
   (slot primary-use   (type SYMBOL) (allowed-values browsing business development gaming editing))
   (slot budget-level  (type SYMBOL) (allowed-values low medium high))
   (slot portability   (type SYMBOL) (allowed-values yes no))
   (slot screen-pref   (type SYMBOL) (allowed-values small medium large any))
   (slot needs-webcam  (type SYMBOL) (allowed-values yes no)))


;;; ----------------------------------------------------------
;;; Laptop model — one fact per model in the knowledge base
;;; ----------------------------------------------------------
(deftemplate laptop
   (slot model         (type STRING))
   (slot year          (type INTEGER))
   (slot cpu-tier      (type SYMBOL) (allowed-values low mid high))
   (slot ram           (type NUMBER))
   (slot storage-type  (type SYMBOL) (allowed-values ssd hdd))
   (slot gpu-type      (type SYMBOL) (allowed-values integrated discrete))
   (slot screen-size   (type NUMBER))
   (slot weight        (type NUMBER))
   (slot webcam        (type SYMBOL) (allowed-values yes no))
   (slot price-tier    (type SYMBOL) (allowed-values low medium high))
   (slot category      (type SYMBOL) (allowed-values business gaming ultrabook creator)))


;;; ----------------------------------------------------------
;;; Requirement — derived constraint inferred from user profile
;;; numeric-value carries thresholds for range-based filters
;;; ----------------------------------------------------------
(deftemplate requirement
   (slot attribute     (type SYMBOL))
   (slot value         (type SYMBOL))
   (slot numeric-value (type NUMBER) (default 0)))


;;; ----------------------------------------------------------
;;; Rejected — hard-constraint elimination record
;;; model + reason uniquely identify each rejection event
;;; ----------------------------------------------------------
(deftemplate rejected
   (slot model  (type STRING))
   (slot reason (type STRING)))


;;; ----------------------------------------------------------
;;; Recommended — model that survived all hard filters
;;; ----------------------------------------------------------
(deftemplate recommended
   (slot model  (type STRING))
   (slot reason (type STRING)))


;;; ----------------------------------------------------------
;;; Justification — explanation chain for a rejection event
;;;
;;; constraint : short symbolic label for what failed
;;;              e.g. ram-below-minimum, no-discrete-gpu
;;; caused-by  : string explaining WHY that constraint exists
;;;              e.g. "gaming use case requires discrete GPU"
;;;
;;; Together these form a two-step chain:
;;;   "X failed" -> "because Y use case demands X"
;;; ----------------------------------------------------------
(deftemplate justification
   (slot model      (type STRING))
   (slot constraint (type SYMBOL))
   (slot caused-by  (type STRING)))


;;; ----------------------------------------------------------
;;; Score — individual soft-constraint award for a model
;;;
;;; Soft constraints do not eliminate models but influence
;;; ranking. Each satisfied soft criterion asserts one score
;;; fact, making the reasoning for ranking fully traceable.
;;;
;;; points : positive integer awarded for this criterion
;;; reason : human-readable description of why points awarded
;;; ----------------------------------------------------------
(deftemplate score
   (slot model   (type STRING))
   (slot points  (type NUMBER))
   (slot reason  (type STRING)))


;;; ----------------------------------------------------------
;;; Total-score — aggregated soft score per recommended model
;;;
;;; Computed in a single rule from laptop attributes to avoid
;;; dependency on the ordering of individual score rules.
;;; Used by ranking rules to determine best/second/other.
;;; ----------------------------------------------------------
(deftemplate total-score
   (slot model  (type STRING))
   (slot value  (type NUMBER) (default 0)))


;;; ----------------------------------------------------------
;;; Ranked-recommendation — final output classification
;;;
;;; rank values:
;;;   best   -- highest total soft score among survivors
;;;   second -- second-highest total soft score
;;;   other  -- all remaining recommendations
;;; ----------------------------------------------------------
(deftemplate ranked-recommendation
   (slot model (type STRING))
   (slot rank  (type SYMBOL) (allowed-values best second other)))
